"""
Student name(s): Kaushik Tota, Avi Sundaresan
Student email(s): ktota@caltech.edu, asundare@caltech.edu

This is a SQL implementation of the Pokemon Storage System from the main-series
Pokemon video games. It contains functionality for storing Pokemon in various
boxes, as well as some neat additional functionality (detecting whether a
Pokemon is hacked, analyzing type advantages, etc.). 
"""

import sys  # to print error messages to sys.stderr
import mysql.connector
# To get error codes from the connector, useful for user-friendly
# error-handling
import mysql.connector.errorcode as errorcode
import prettytable

# Debugging flag to print errors when debugging that shouldn't be visible
# to an actual client. ***Set to False when done testing.***
DEBUG = True

session_username = ""

# ----------------------------------------------------------------------
# SQL Utility Functions
# ----------------------------------------------------------------------
def get_conn():
    """"
    Returns a connected MySQL connector instance, if connection is successful.
    If unsuccessful, exits.
    """
    try:
        conn = mysql.connector.connect(
          host='localhost',
          user='pssclient',
          # Find port in MAMP or MySQL Workbench GUI or with
          # SHOW VARIABLES WHERE variable_name LIKE 'port';
          port='3306',  # this may change!
          password='ClientPW2024!',
          database='final_db_v5'
        )
        print('Successfully connected.')
        return conn
    except mysql.connector.Error as err:
        # Remember that this is specific to _database_ users, not
        # application users. So is probably irrelevant to a client in your
        # simulated program. Their user information would be in a users table
        # specific to your database; hence the DEBUG use.
        if err.errno == errorcode.ER_ACCESS_DENIED_ERROR and DEBUG:
            sys.stderr.write(('Incorrect username or password when connecting to DB.'))
        elif err.errno == errorcode.ER_BAD_DB_ERROR and DEBUG:
            sys.stderr.write(('Database does not exist.'))
        elif DEBUG:
            sys.stderr.write((err))
        else:
            # A fine catchall client-facing message.
            sys.stderr.write(('An error occurred, please contact the administrator.'))
        sys.exit(1)

# ----------------------------------------------------------------------
# Functions for Command-Line Options/Query Execution
# ----------------------------------------------------------------------
"""
Executes the queries required for a user to view all of the Pokemon contained
within a particular box. Returns information of Pokemon contained in the box
to the user.
"""
def view_box():
    print("What box number would you like to view?")
    bn = input("Box number (1-16): ")
    while bn not in [str(num) for num in range(1, 17)]:
        bn = input("Please enter a valid box number (1-16): ")
    bn = int(bn)
    cursor = conn.cursor()
    sql = "SELECT pkmn_name, pokedex_number, pkmn_id, pkmn_nickname, hp, attack, special_attack, defense, " + \
          "special_defense, speed, lvl, is_hacked FROM box_owner NATURAL JOIN has_box NATURAL JOIN collected " + \
          "NATURAL JOIN has_species NATURAL JOIN pokedex NATURAL JOIN hack_checks WHERE " + \
          "user_id = '%s' AND (MOD(box_id - 1, 16) + 1) = %d;" % (session_username, bn)
    try:
        print("Box " + str(bn))
        cursor.execute(sql)
        rows = cursor.fetchall()
        column_names = [i[0] for i in cursor.description]
        table = prettytable.PrettyTable(column_names)
        for row in rows:
            table.add_row(row)
        print(table)
    except mysql.connector.Error as err:
        if DEBUG:
            sys.stderr.write((err))
            sys.exit(1)
        else:
            sys.stderr.write(('An error occurred, and the box could not be accessed.'))

"""
Executes the queries required for a user to add a Pokemon to a box of their
choosing. Returns whether the addition was successful, and if successful,
whether the stored Pokemon was detected to be hacked or not.
"""
def add_pokemon():
    cursor = conn.cursor()
    print("Which box would you like to add a Pokemon to?")
    bn = input("Box number (1-16): ")
    while bn not in [str(num) for num in range(1, 17)]:
        bn = input("Please enter a valid box number (1-16): ")
    bn = int(bn)
    sql = "SELECT num_pokemon FROM boxes NATURAL JOIN box_owner WHERE " + \
          "user_id = '%s' AND (MOD(box_id - 1, 16) + 1) = %d;" % (session_username, bn)
    try:
        cursor.execute(sql)
        result = cursor.fetchone()[0]
        if result >= 30:
            print("Sorry, this box is full. Try again with a different box!")
            return
    except mysql.connector.Error as err:
        if DEBUG:
            sys.stderr.write((err))
            sys.exit(1)
        else:
            sys.stderr.write(('An error occurred, and the addition process cannot be completed.'))
    print("Enter the species of the Pokemon you'd like to add.")
    p_name = input("Pokemon species name: ")
    print("What is this Pokemon's nickname? (30 character max, will default to Pokemon species name if left blank)")
    nickname = input("Pokemon's nickname: ")
    if nickname == "":
        nickname = p_name
    try:
        h = int(input("Enter the Pokemon's HP stat: "))
    except ValueError:
        print("Sorry, this is not an integer value. Please try again.")
        return
    try:
        atk = int(input("Enter the Pokemon's Attack stat: "))
    except ValueError:
        print("Sorry, this is not an integer value. Please try again.")
        return
    try:
        spa = int(input("Enter the Pokemon's Special Attack stat: "))
    except ValueError:
        print("Sorry, this is not an integer value. Please try again.")
        return
    try:
        defn = int(input("Enter the Pokemon's Defense stat: "))
    except ValueError:
        print("Sorry, this is not an integer value. Please try again.")
        return
    try:
        spd = int(input("Enter the Pokemon's Special Defense stat: "))
    except ValueError:
        print("Sorry, this is not an integer value. Please try again.")
        return
    try:
        spe = int(input("Enter the Pokemon's Speed stat: "))
    except ValueError:
        print("Sorry, this is not an integer value. Please try again.")
        return
    try:
        lv = int(input("Enter the Pokemon's level: "))
    except ValueError:
        print("Sorry, this is not an integer value. Please try again.")
        return
    nt = input("Enter the Pokemon's nature: ")
    try:
        cursor.callproc('sp_add_to_box', args=(session_username, p_name, nickname, bn, h, atk, spa, defn, spd, spe, lv, nt))
        conn.commit()
        print("Pokemon successfully added!")
    except mysql.connector.Error as err:
        if DEBUG:
            sys.stderr.write((err))
            sys.exit(1)
        else:
            sys.stderr.write(('An error occurred, and the addition process cannot be completed.'))

"""
Executes the queries required for a user to delete a Pokemon from their box.
"""
def delete_pokemon():
    cursor = conn.cursor()
    print("What is the ID of the Pokemon you would like to release?")
    try:
        pid = int(input("Pokemon ID: "))
    except ValueError:
        print("Sorry, this is not a valid Pokemon ID value. Please try again.")
        return
    sql = "SELECT user_id FROM has_box NATURAL JOIN box_owner WHERE pkmn_id = %d;" % (pid, )
    try:
        cursor.execute(sql)
        result = cursor.fetchone()
        if result == None:
            print("Sorry, no Pokemon with this ID exists.")
            return
        if result[0] != session_username:
            print("This is not your Pokemon, so you cannot release it. Please try again.")
            return
    except mysql.connector.Error as err:
        if DEBUG:
            sys.stderr.write((err))
            sys.exit(1)
        else:
            sys.stderr.write(('An error occurred, and the Pokemon could not be released.'))
    sql = "SELECT box_id FROM has_box WHERE pkmn_id = %d;" % (pid, )
    bn = None
    try:
        cursor.execute(sql)
        bn = cursor.fetchone()[0]
    except mysql.connector.Error as err:
        if DEBUG:
            sys.stderr.write((err))
            sys.exit(1)
        else:
            sys.stderr.write(('An error occurred, and the Pokemon could not be released.'))
    sql = "DELETE FROM collected WHERE pkmn_id = %d;" % (pid, )
    try:
        cursor.execute(sql)
        conn.commit()
        print("The Pokemon was successfully released!")
    except mysql.connector.Error as err:
        if DEBUG:
            sys.stderr.write((err))
            sys.exit(1)
        else:
            sys.stderr.write(('An error occurred, and the Pokemon could not be released.'))
    try:
        cursor.callproc('sp_update_box_count_del', args=(bn, ))
        conn.commit()
    except mysql.connector.Error as err:
        if DEBUG:
            sys.stderr.write((err))
            sys.exit(1)
        else:
            sys.stderr.write(('An error occurred, and the Pokemon could not be released.'))

"""
Executes the queries required for a user to move a Pokemon from one box to another.
"""
def move_pokemon():
    cursor = conn.cursor()
    print("What is the ID of the Pokemon you would like to move?")
    try:
        pid = int(input("Pokemon ID: "))
    except ValueError:
        print("Sorry, this is not a valid Pokemon ID value. Please try again.")
        return
    sql = "SELECT user_id FROM has_box NATURAL JOIN box_owner WHERE pkmn_id = %d;" % (pid, )
    try:
        cursor.execute(sql)
        result = cursor.fetchone()
        if result == None:
            print("Sorry, no Pokemon with this ID exists.")
            return
        if result[0] != session_username:
            print("This is not your Pokemon, so you cannot move it. Please try again.")
            return
    except mysql.connector.Error as err:
        if DEBUG:
            sys.stderr.write((err))
            sys.exit(1)
        else:
            sys.stderr.write(('An error occurred, and the Pokemon could not be moved.'))
    print("Which box would you like to move this Pokemon to?")
    bn = input("Box number (1-16): ")
    while bn not in [str(num) for num in range(1, 17)]:
        bn = input("Please enter a valid box number (1-16): ")
    bn = int(bn)
    sql = "UPDATE has_box SET box_id = (SELECT box_id FROM box_owner WHERE " + \
          "user_id = '%s' AND (MOD(box_id - 1, 16) + 1) = %d) WHERE pkmn_id = %d;" % (session_username, bn, pid)
    try:
        cursor.execute(sql)
        conn.commit()
        print("The Pokemon was successfully moved!")
    except mysql.connector.Error as err:
        if DEBUG:
            sys.stderr.write((err))
            sys.exit(1)
        else:
            sys.stderr.write(('An error occurred, and the Pokemon could not be moved.'))

"""
Executes the queries required for a user to search across all their boxes for
all Pokemon they possess which are of a certain type (for dual-typed Pokemon,
if either of their types is the specified type). Returns key information
about all Pokemon which match the specified type.
"""
def search_by_type():
    cursor = conn.cursor()
    print("Select a type you would like to search for.")
    search_type = input("Type: ")
    sql = ("SELECT pkmn_name, pkmn_nickname, (MOD(box_id - 1, 16) + 1) as box_num, " +  
           "pkmn_id, pokedex_number FROM box_owner NATURAL JOIN has_box NATURAL JOIN collected " + 
           "NATURAL JOIN has_species NATURAL JOIN pokedex WHERE user_id = '%s' " % (session_username, ) + 
           "AND (type_1 = '%s' OR type_2 = '%s') ORDER BY pokedex_number;" % (search_type, search_type))
    try:
        print("Your Pokemon of type: " + search_type)
        cursor.execute(sql)
        rows = cursor.fetchall()
        column_names = [i[0] for i in cursor.description]
        table = prettytable.PrettyTable(column_names)
        for row in rows:
            table.add_row(row)
        print(table)
    except mysql.connector.Error as err:
        if DEBUG:
            sys.stderr.write((err))
            sys.exit(1)
        else:
            sys.stderr.write(('An error occurred, and your Pokemon could not be accessed.'))

"""
Executes the queries required for a user to find the Pokemon IDs and levels of
all the Pokemon they own which fall within a user-defined range of levels.
"""
def search_lvl_range():
    cursor = conn.cursor()
    lower = 1
    upper = 100
    print("What is the lower bound of the level range you would like to search?")
    try:
        lower = int(input("Lower level bound: "))
    except ValueError:
        print("Sorry, this is not a valid level value. Please try again.")
        return
    print("What is the upper bound of the level range you would like to search?")
    try:
        upper = int(input("Upper level bound: "))
    except ValueError:
        print("Sorry, this is not a valid level value. Please try again.")
        return
    sql = ("SELECT pkmn_id, pkmn_nickname, lvl " +
           "FROM collected NATURAL JOIN has_box NATURAL JOIN box_owner " +
           "WHERE user_id = '%s' AND lvl <= %d AND lvl >= %d " % (session_username, upper, lower) + 
           "ORDER BY lvl DESC;")
    try:
        print("Your Pokemon falling between level " + str(lower) + " and level " + str(upper))
        cursor.execute(sql)
        rows = cursor.fetchall()
        column_names = [i[0] for i in cursor.description]
        table = prettytable.PrettyTable(column_names)
        for row in rows:
            table.add_row(row)
        print(table)
    except mysql.connector.Error as err:
        if DEBUG:
            sys.stderr.write((err))
            sys.exit(1)
        else:
            sys.stderr.write(('An error occurred, and your Pokemon could not be accessed.'))

"""
Executes the queries required for a user to search across all their boxes for
all Pokemon they own of a particular Pokedex number. Returns key information
about all Pokemon which match the specified Pokedex number.
"""
def search_by_dex():
    cursor = conn.cursor()
    dex = None
    print("What is the Pokedex number you would like to search for?")
    try:
        dex = int(input("Pokedex number: "))
    except ValueError:
        print("Sorry, this is not a valid Pokedex number (must be an integer). Please try again.")
        return
    sql = ("SELECT pokedex_number, pkmn_name, pkmn_id, pkmn_nickname, " +
           "(MOD(box_id - 1, 16) + 1) AS box_num " +
           "FROM box_owner NATURAL JOIN has_box NATURAL JOIN collected " +
           "NATURAL JOIN has_species NATURAL JOIN pokedex " +
           "WHERE user_id = '%s' AND (pokedex_number = %d) " % (session_username, dex) +
           "ORDER BY pkmn_nickname;")
    try:
        print("Your Pokemon of Pokedex number: " + str(dex))
        cursor.execute(sql)
        rows = cursor.fetchall()
        column_names = [i[0] for i in cursor.description]
        table = prettytable.PrettyTable(column_names)
        for row in rows:
            table.add_row(row)
        print(table)
    except mysql.connector.Error as err:
        if DEBUG:
            sys.stderr.write((err))
            sys.exit(1)
        else:
            sys.stderr.write(('An error occurred, and your Pokemon could not be accessed.'))

"""
Executes the queries required for a user to determine which of their Pokemon
are weak to a move of a given type. Returns a list of all Pokemon owned by that
user who are weak to the specified type.
"""
def analyze_type_advantages():
    cursor = conn.cursor()
    attack_type = ''
    print("What is the type of the move you wish to analyze?")
    try:
        attack_type = input("Attack type: ")
    except ValueError:
        print("Sorry, this is not a valid type. Please try again.")
        return

    sql = ("SELECT pkmn_id, (MOD(box_id - 1, 16) + 1) as box_num, pkmn_name," +
           "pkmn_nickname, type_1, type_2 " + 
           "FROM box_owner NATURAL JOIN has_box NATURAL JOIN collected " + 
           "NATURAL JOIN has_species NATURAL JOIN pokedex " + 
           "WHERE user_id = '%s' AND detect_weak(pkmn_name, '%s') " % (session_username, attack_type) + 
           "ORDER BY type_1, type_2, pkmn_name, pkmn_nickname;")
    
    try:
        print("Your Pokemon that are weak to the " + attack_type + " attack type are:")
        cursor.execute(sql)
        rows = cursor.fetchall()
        column_names = [i[0] for i in cursor.description]
        table = prettytable.PrettyTable(column_names)
        for row in rows:
            table.add_row(row)
        print(table)
    except mysql.connector.Error as err:
        if DEBUG:
            sys.stderr.write((err))
            sys.exit(1)
        else:
            sys.stderr.write(('An error occurred, and your Pokemon could not be accessed.'))


# ----------------------------------------------------------------------
# Functions for Logging Users In
# ----------------------------------------------------------------------
def user_login():
    username = ""
    password = ""
    cursor = conn.cursor()
    print("Do you have an account? (Y/N)")
    ans = input('Enter an option: ').lower()
    if ans == 'y':
        print("Please enter your username.")
        username = input('Username: ').lower()
        print("Please enter your password.")
        password = input('Password: ').lower()
        sql = "SELECT is_admin FROM users WHERE user_id = '%s';" % (username, )
        try:
            cursor.execute(sql)
            admin_result = cursor.fetchone()
            if admin_result == None:
                print("Sorry, this username/password pair is not recognized.")
                exit()
            if admin_result[0] == 1:
                print("Sorry, you are attempting to log into an admin's account - this is not permitted.")
                exit()
        except mysql.connector.Error as err:
            if DEBUG:
                sys.stderr.write((err))
                sys.exit(1)
            else:
                sys.stderr.write(('An error has occurred while attempting to log in.'))
        sql = "SELECT authenticate ('%s', '%s');" % (username, password)
        try:
            cursor.execute(sql)
            auth_result = cursor.fetchone()[0]
            if auth_result == 0:
                print("Sorry, this username/password pair is not recognized. Please restart and try again.")
                exit()
            else:
                print("Welcome to the Pokemon Storage System!")
                global session_username
                session_username = username
        except mysql.connector.Error as err:
            if DEBUG:
                sys.stderr.write((err))
                sys.exit(1)
            else:
                sys.stderr.write(('An error has occurred while attempting to log in.'))
    elif ans == 'n':
        print("Let's make an account! Please enter the username you'd like. It can be up to 10 characters long.")
        username = input('Username: ').lower()
        print("Please create a password. It can be up to 20 characters long.")
        password = input('Password: ').lower()
        sql = "CALL sp_add_client('%s', '%s');" % (username, password)
        try:
            cursor.execute(sql)
            conn.commit()
            print("Your account has successfully been created! " + 
                  "Please restart the application and try logging in with your newly-created credentials.")
            exit()
        except mysql.connector.Error as err:
            if DEBUG:
                sys.stderr.write((err))
                sys.exit(1)
            else:
                sys.stderr.write(('An error has occurred while attempting to create the new account. Please try again.'))
    else:
        print("Sorry, this is not an option. Please restart the application and try again.")
        exit()


# ----------------------------------------------------------------------
# Command-Line Functionality
# ----------------------------------------------------------------------
def show_options():
    """
    Displays options users can choose in the application, such as
    viewing <x>, filtering results with a flag (e.g. -s to sort),
    sending a request to do <x>, etc.
    """
    ans = 'START'
    while ans:
        print()
        print('What would you like to do?')
        print('  (v) - view a box')
        print('  (a) - add a Pokemon to a box')
        print('  (d) - delete Pokemon from a box')
        print('  (m) - move a Pokemon from one box to another box')
        print('  (s) - search for Pokemon of a certain type')
        print('  (r) - search for Pokemon within a range of levels')
        print('  (n) - search for Pokemon by Pokedex number')
        print('  (t) - analyze type advantages')
        print('  (q) - quit')
        print()
        ans = input('Enter an option: ').lower()
        while ans not in ['v', 'a', 'd', 'm', 's', 'r', 'n', 't', 'q']:
            ans = input('Sorry, that option is not recognized. Enter an option again: ').lower()
        if ans == 'v':
            view_box()
        elif ans == 'a':
            add_pokemon()
        elif ans == 'd':
            delete_pokemon()
        elif ans == 'm':
            move_pokemon()
        elif ans == 's':
            search_by_type()
        elif ans == 'r':
            search_lvl_range()
        elif ans == 'n':
            search_by_dex()
        elif ans == 't':
            analyze_type_advantages()
        elif ans == 'q':
            quit_ui()

def quit_ui():
    """
    Quits the program, printing a goodbye message to the user.
    """
    print('Have fun catching more Pokemon!')
    exit()


def main():
    """
    Main function for starting things up.
    """
    show_options()


if __name__ == '__main__':
    # This conn is a global object that other functions can access.
    # You'll need to use cursor = conn.cursor() each time you are
    # about to execute a query with cursor.execute(<sqlquery>)
    conn = get_conn()
    user_login()
    main()