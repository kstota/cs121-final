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
          user='pssadmin',
          # Find port in MAMP or MySQL Workbench GUI or with
          # SHOW VARIABLES WHERE variable_name LIKE 'port';
          port='3306',  # this may change!
          password='AdminPW2024!',
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
Executes the queries required for an admin to view all of the Pokemon contained
within a particular box. This box can be one of their own boxes, OR a box of any 
user of the Pokemon Storage Service (admin-only functionality). Returns 
information of Pokemon contained in the box to the user.
"""
def view_box():
    print("Whose boxes would you like to view?")
    print("  (s) - your own boxes")
    print("  (u) - a different user's boxes")
    ans = input('Enter an option: ').lower()
    while ans not in ['s', 'u']:
        ans = input('Sorry, that option is not recognized. Enter an option again: ').lower()
    username = session_username
    if ans == 'u':
        print("Enter the user_id of the user whose boxes you would like to view.")
        username = input("user_id: ")
    print("What box number would you like to view?")
    bn = input("Box number (1-16): ")
    while bn not in [str(num) for num in range(1, 17)]:
        bn = input("Please enter a valid box number (1-16): ")
    bn = int(bn)
    cursor = conn.cursor()
    sql = "SELECT pkmn_name, pokedex_number, pkmn_id, pkmn_nickname, hp, attack, special_attack, defense, " + \
          "special_defense, speed, lvl, is_hacked FROM box_owner NATURAL JOIN has_box NATURAL JOIN collected " + \
          "NATURAL JOIN has_species NATURAL JOIN pokedex NATURAL JOIN hack_checks WHERE " + \
          "user_id = '%s' AND (MOD(box_id - 1, 16) + 1) = %d;" % (username, bn)
    try:
        print("Box " + str(bn))
        cursor.execute(sql)
        rows = cursor.fetchall()
        column_names = [i[0] for i in cursor.description]
        table = prettytable.PrettyTable(column_names)
        for row in rows:
            table.add_row(row)
        print(table)
        input("Press the Enter key to return to the main menu.")
    except mysql.connector.Error as err:
        if DEBUG:
            sys.stderr.write((err))
            sys.exit(1)
        else:
            sys.stderr.write(('An error occurred, and the box could not be accessed.'))

"""
Executes the queries required for an admin to add a Pokemon to a box of their
choosing. This box can be one of their own boxes, OR a box of any user of
the Pokemon Storage Service (admin-only functionality). Returns whether 
the addition was successful, and if successful, whether the stored Pokemon 
was detected to be hacked or not.
"""
def add_pokemon():
    cursor = conn.cursor()
    print("Whose boxes would you like to add to?")
    print("  (s) - your own boxes")
    print("  (u) - a different user's boxes")
    ans = input('Enter an option: ').lower()
    while ans not in ['s', 'u']:
        ans = input('Sorry, that option is not recognized. Enter an option again: ').lower()
    username = session_username
    if ans == 'u':
        print("Enter the user_id of the user whose boxes you would like to add to.")
        username = input("user_id: ")
    print("Which box would you like to add a Pokemon to?")
    bn = input("Box number (1-16): ")
    while bn not in [str(num) for num in range(1, 17)]:
        bn = input("Please enter a valid box number (1-16): ")
    bn = int(bn)
    sql = "SELECT num_pokemon FROM boxes NATURAL JOIN box_owner WHERE " + \
          "user_id = '%s' AND (MOD(box_id - 1, 16) + 1) = %d;" % (username, bn)
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
    while len(nickname) > 30:
        nickname = input("This nickname is too long! Please try a different nickname: ")
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
        cursor.callproc('sp_add_to_box', args=(username, p_name, nickname, bn, h, atk, spa, defn, spd, spe, lv, nt))
        conn.commit()
        print("Pokemon successfully added!")
        input("Press the Enter key to return to the main menu.")
    except mysql.connector.Error as err:
        if DEBUG:
            sys.stderr.write((err))
            sys.exit(1)
        else:
            sys.stderr.write(('An error occurred, and the addition process cannot be completed.'))

"""
Executes the queries required for an admin to delete a Pokemon from a 
particular box. This box can be one of their own boxes, OR a box of any 
user of the Pokemon Storage Service (admin-only functionality).
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
        input("Press the Enter key to return to the main menu.")
    except mysql.connector.Error as err:
        if DEBUG:
            sys.stderr.write((err))
            sys.exit(1)
        else:
            sys.stderr.write(('An error occurred, and the Pokemon could not be released.'))

"""
Executes the queries required for a user to move a Pokemon from one box to another. This Pokemon
can belong to any user of the Pokemon Storage System (admin-only functionality).
"""
def move_pokemon():
    cursor = conn.cursor()
    print("Whose Pokemon would you like to move?")
    print("  (s) - your own Pokemon")
    print("  (u) - a different user's Pokemon")
    ans = input('Enter an option: ').lower()
    while ans not in ['s', 'u']:
        ans = input('Sorry, that option is not recognized. Enter an option again: ').lower()
    username = session_username
    if ans == 'u':
        print("Enter the user_id of the user whose Pokemon you would like to move.")
        username = input("user_id: ")
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
            sys.stderr.write(('An error occurred, and the move process cannot be completed.'))
    sql = "UPDATE has_box SET box_id = (SELECT box_id FROM box_owner WHERE " + \
          "user_id = '%s' AND (MOD(box_id - 1, 16) + 1) = %d) WHERE pkmn_id = %d;" % (username, bn, pid)
    try:
        cursor.execute(sql)
        conn.commit()
        print("The Pokemon was successfully moved!")
        input("Press the Enter key to return to the main menu.")
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
about all Pokemon which match the specified type. The Pokemon searched can be
the user's own Pokemon, or any other user's Pokemon (admin-only functionality).
"""
def search_by_type():
    cursor = conn.cursor()
    print("Whose boxes would you like to search?")
    print("  (s) - your own boxes")
    print("  (u) - a different user's boxes")
    ans = input('Enter an option: ').lower()
    while ans not in ['s', 'u']:
        ans = input('Sorry, that option is not recognized. Enter an option again: ').lower()
    username = session_username
    if ans == 'u':
        print("Enter the user_id of the user whose boxes you would like to search.")
        username = input("user_id: ")
    print("Select a type you would like to search for.")
    search_type = input("Type: ")
    sql = ("SELECT pkmn_name, pkmn_nickname, (MOD(box_id - 1, 16) + 1) as box_num, " +  
           "pkmn_id, pokedex_number FROM box_owner NATURAL JOIN has_box NATURAL JOIN collected " + 
           "NATURAL JOIN has_species NATURAL JOIN pokedex WHERE user_id = '%s' " % (username, ) + 
           "AND (type_1 = '%s' OR type_2 = '%s') ORDER BY pokedex_number;" % (search_type, search_type))
    try:
        print(username + "'s Pokemon of type: " + search_type)
        cursor.execute(sql)
        rows = cursor.fetchall()
        column_names = [i[0] for i in cursor.description]
        table = prettytable.PrettyTable(column_names)
        for row in rows:
            table.add_row(row)
        print(table)
        input("Press the Enter key to return to the main menu.")
    except mysql.connector.Error as err:
        if DEBUG:
            sys.stderr.write((err))
            sys.exit(1)
        else:
            sys.stderr.write(('An error occurred, and the Pokemon could not be accessed.'))

"""
Executes the queries required for a user to find the Pokemon IDs and levels of
all the Pokemon they own which fall within a user-defined range of levels. The Pokemon searched can be
the user's own Pokemon, or any other user's Pokemon (admin-only functionality).
"""
def search_lvl_range():
    cursor = conn.cursor()
    print("Whose boxes would you like to search?")
    print("  (s) - your own boxes")
    print("  (u) - a different user's boxes")
    ans = input('Enter an option: ').lower()
    while ans not in ['s', 'u']:
        ans = input('Sorry, that option is not recognized. Enter an option again: ').lower()
    username = session_username
    if ans == 'u':
        print("Enter the user_id of the user whose boxes you would like to search.")
        username = input("user_id: ")
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
    sql = ("SELECT pkmn_id, pkmn_nickname, (MOD(box_id - 1, 16) + 1) AS box_num, lvl " +
           "FROM collected NATURAL JOIN has_box NATURAL JOIN box_owner " +
           "WHERE user_id = '%s' AND lvl <= %d AND lvl >= %d " % (username, upper, lower) + 
           "ORDER BY lvl DESC;")
    try:
        print(username + "'s Pokemon falling between level " + str(lower) + " and level " + str(upper))
        cursor.execute(sql)
        rows = cursor.fetchall()
        column_names = [i[0] for i in cursor.description]
        table = prettytable.PrettyTable(column_names)
        for row in rows:
            table.add_row(row)
        print(table)
        input("Press the Enter key to return to the main menu.")
    except mysql.connector.Error as err:
        if DEBUG:
            sys.stderr.write((err))
            sys.exit(1)
        else:
            sys.stderr.write(('An error occurred, and the Pokemon could not be accessed.'))

"""
Executes the queries required for a user to search across all their boxes for
all Pokemon they own of a particular Pokedex number. Returns key information
about all Pokemon which match the specified Pokedex number. The Pokemon searched can be
the user's own Pokemon, or any other user's Pokemon (admin-only functionality).
"""
def search_by_dex():
    cursor = conn.cursor()
    print("Whose boxes would you like to search?")
    print("  (s) - your own boxes")
    print("  (u) - a different user's boxes")
    ans = input('Enter an option: ').lower()
    while ans not in ['s', 'u']:
        ans = input('Sorry, that option is not recognized. Enter an option again: ').lower()
    username = session_username
    if ans == 'u':
        print("Enter the user_id of the user whose boxes you would like to search.")
        username = input("user_id: ")
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
           "WHERE user_id = '%s' AND (pokedex_number = %d) " % (username, dex) +
           "ORDER BY pkmn_nickname;")
    try:
        print(username + "'s Pokemon of Pokedex number: " + str(dex))
        cursor.execute(sql)
        rows = cursor.fetchall()
        column_names = [i[0] for i in cursor.description]
        table = prettytable.PrettyTable(column_names)
        for row in rows:
            table.add_row(row)
        print(table)
        input("Press the Enter key to return to the main menu.")
    except mysql.connector.Error as err:
        if DEBUG:
            sys.stderr.write((err))
            sys.exit(1)
        else:
            sys.stderr.write(('An error occurred, and the Pokemon could not be accessed.'))

"""
Executes the queries required for an admin to view, at a glance, ALL Pokemon
currently in the Pokemon Storage System which have been detected to be hacked,
as well as the users who own those Pokemon.
"""
def view_hacked_pokemon():
    cursor = conn.cursor()
    sql = ("SELECT pkmn_id, pkmn_name, pkmn_nickname, user_id FROM collected NATURAL JOIN " +
           "has_box NATURAL JOIN box_owner NATURAL JOIN hack_checks NATURAL JOIN has_species " +
           "NATURAL JOIN pokedex WHERE is_hacked = 1;")
    try:
        print("Hacked Pokemon currently stored in the Pokemon Storage System")
        cursor.execute(sql)
        rows = cursor.fetchall()
        column_names = [i[0] for i in cursor.description]
        table = prettytable.PrettyTable(column_names)
        for row in rows:
            table.add_row(row)
        print(table)
        input("Press the Enter key to return to the main menu.")
    except mysql.connector.Error as err:
        if DEBUG:
            sys.stderr.write((err))
            sys.exit(1)
        else:
            sys.stderr.write(('An error occurred, and the Pokemon could not be accessed.'))

"""
Executes the queries required for an admin to view the total number of Pokemon possessed
by all users of the Pokemon Storage System.
"""
def count_pokemon():
    cursor = conn.cursor()
    sql = ("SELECT user_id, SUM(num_pokemon) as total_count FROM boxes NATURAL JOIN " +
           "box_owner GROUP BY user_id ORDER BY total_count DESC;")
    try:
        print("Number of Pokemon owned by all users of Pokemon Storage System")
        cursor.execute(sql)
        rows = cursor.fetchall()
        column_names = [i[0] for i in cursor.description]
        table = prettytable.PrettyTable(column_names)
        for row in rows:
            table.add_row(row)
        print(table)
        input("Press the Enter key to return to the main menu.")
    except mysql.connector.Error as err:
        if DEBUG:
            sys.stderr.write((err))
            sys.exit(1)
        else:
            sys.stderr.write(('An error occurred, and the Pokemon could not be accessed.'))

"""
Executes the stored procedure which enables an admin to add a new species of Pokemon to
the Pokedex. This will enable users to store Pokemon of that species in the Pokemon
Storage System.
"""
def add_new_pkmn_species():
    cursor = conn.cursor()
    print("Enter the name of the new species of the Pokemon you'd like to add.")
    p_name = input("Pokemon species name: ")
    try:
        dex = int(input("Enter the Pokemon's Pokedex number: "))
    except ValueError:
        print("Sorry, this is not an integer value. Please try again.")
        return
    print("Enter the first type of the new species of the Pokemon you'd like to add.")
    type_1 = input("First type: ")
    print("Enter the second type of the new species of the Pokemon you'd like to add." + 
          "Press Enter (leave empty) if the Pokemon does not have a second type.")
    type_2 = input("Second type: ")
    try:
        h = int(input("Enter the Pokemon's base HP stat: "))
    except ValueError:
        print("Sorry, this is not an integer value. Please try again.")
        return
    try:
        atk = int(input("Enter the Pokemon's base Attack stat: "))
    except ValueError:
        print("Sorry, this is not an integer value. Please try again.")
        return
    try:
        spa = int(input("Enter the Pokemon's base Special Attack stat: "))
    except ValueError:
        print("Sorry, this is not an integer value. Please try again.")
        return
    try:
        defn = int(input("Enter the Pokemon's base Defense stat: "))
    except ValueError:
        print("Sorry, this is not an integer value. Please try again.")
        return
    try:
        spd = int(input("Enter the Pokemon's base Special Defense stat: "))
    except ValueError:
        print("Sorry, this is not an integer value. Please try again.")
        return
    try:
        spe = int(input("Enter the Pokemon's base Speed stat: "))
    except ValueError:
        print("Sorry, this is not an integer value. Please try again.")
        return
    try:
        cursor.callproc('sp_insert_into_pokedex', args=(p_name, dex, type_1, type_2, h, atk, spa, defn, spd, spe))
        conn.commit()
        print(p_name + " was successfully added to the Pokedex!")
        input("Press the Enter key to return to the main menu.")
    except mysql.connector.Error as err:
        if DEBUG:
            sys.stderr.write((err))
            sys.exit(1)
        else:
            sys.stderr.write(('An error occurred, and the Pokemon could not be added.'))

"""
Executes the queries required for an admin to determine which of their Pokemon
are weak to a move of a given type. Returns a list of all Pokemon owned by that
user who are weak to the specified type.
"""
def analyze_type_advantages():
    cursor = conn.cursor()
    print("Whose boxes would you like to search?")
    print("  (s) - your own boxes")
    print("  (u) - a different user's boxes")
    ans = input('Enter an option: ').lower()
    while ans not in ['s', 'u']:
        ans = input('Sorry, that option is not recognized. Enter an option again: ').lower()
    username = session_username
    if ans == 'u':
        print("Enter the user_id of the user whose boxes you would like to search.")
        username = input("user_id: ")
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
           "WHERE user_id = '%s' AND detect_weak(pkmn_name, '%s') " % (username, attack_type) + 
           "ORDER BY pkmn_name, pkmn_nickname;")
    
    try:
        print("The Pokemon that are weak to the " + attack_type + " attack type are:")
        cursor.execute(sql)
        rows = cursor.fetchall()
        column_names = [i[0] for i in cursor.description]
        table = prettytable.PrettyTable(column_names)
        for row in rows:
            table.add_row(row)
        print(table)
        input("Press the Enter key to return to the main menu.")
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
        sql = "SELECT is_admin FROM users WHERE user_id = '%s'" % (username, )
        try:
            cursor.execute(sql)
            admin_result = cursor.fetchone()
            if admin_result == None:
                print("Sorry, this username/password pair is not recognized.")
                exit()
            if admin_result[0] == 0:
                print("Sorry, you are attempting to use a non-admin account to log into the admin app - this is not permitted.")
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
        while len(username) > 10 or username == "":
            if len(username) > 10:
                username = input("This username is too long! Please try a different one: ").lower()
            if username == "":
                username = input("Your username must be a non-empty string. Please enter one: ").lower()
        print("Please create a password. It can be up to 20 characters long.")
        password = input('Password: ').lower()
        while len(password) > 20 or password == "":
            if len(password) > 20:
                password = input("This password is too long! Please try a different one: ").lower()
            if password == "":
                password = input("Your password must be a non-empty string. Please enter one: ").lower()
        sql = "CALL sp_add_admin('%s', '%s');" % (username, password)
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
        print('  (c) - display counts of stored Pokemon for all users')
        print('  (h) - view hacked Pokemon currently in storage')
        print('  (t) - analyze type advantages')
        print('  (add) - add a NEW species of Pokemon to the Pokedex')
        print('  (q) - quit')
        print()
        ans = input('Enter an option: ').lower()
        while ans not in ['v', 'a', 'd', 'm', 's', 'r', 'n', 'c', 'h', 't', 'add', 'q']:
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
        elif ans == 'c':
            count_pokemon()
        elif ans == 'h':
            view_hacked_pokemon()
        elif ans == 't':
            analyze_type_advantages()
        elif ans == 'add':
            add_new_pkmn_species()
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