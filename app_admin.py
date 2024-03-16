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
client of the Pokemon Storage Service (admin-only functionality). Returns 
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
    box_num = int(input("Box (1-16): "))
    cursor = conn.cursor()
    sql = "SELECT pkmn_name, pokedex_number, pkmn_id, pkmn_nickname, hp, attack, special_attack, defense, special_defense, speed, lvl, is_hacked FROM box_owner NATURAL JOIN has_box NATURAL JOIN collected NATURAL JOIN has_species NATURAL JOIN pokedex NATURAL JOIN hack_checks WHERE user_id = '%s' AND (MOD(box_id - 1, 16) + 1) = %d;" % (username, box_num)
    try:
        print(session_username)
        print(box_num)
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
Executes the queries required for an admin to add a Pokemon to a box of their
choosing. This box can be one of their own boxes, OR a box of any client of
the Pokemon Storage Service (admin-only functionality). Returns whether 
the addition was successful, and if successful, whether the stored Pokemon 
was detected to be hacked or not.
"""
def add_pokemon():
    pass

"""
Executes the queries required for an admin to delete a Pokemon from a 
particular box. This box can be one of their own boxes, OR a box of any 
client of the Pokemon Storage Service (admin-only functionality).
"""
def delete_pokemon():
    pass

"""
Executes the queries required for an admin to view, at a glance, ALL Pokemon
currently in the Pokemon Storage System which have been detected to be hacked,
as well as the users who own those Pokemon.
"""
def view_hacked_pokemon():
    pass

"""
Executes the queries required for an admin to determine which of their Pokemon
are weak to a move of a given type. Returns a list of all Pokemon owned by that
user who are weak to the specified type.
"""
def analyze_type_advantages():
    pass

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
        sql = "CALL sp_add_admin('%s', '%s');" % (username, password)
        try:
            cursor.execute(sql)
            conn.commit()
            print("Your account has successfully been created! Please restart the application and try logging in with your newly-created credentials.")
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
        print('What would you like to do?')
        print('  (v) - view a box')
        print('  (a) - add a Pokemon to a box')
        print('  (d) - delete Pokemon from a box')
        print('  (m) - Move a Pokemon from one box to another box')
        print('  (c) - display counts of stored Pokemon for all users')
        print('  (h) - view hacked Pokemon currently in storage')
        print('  (t) - analyze type advantages')
        print('  (n) - add a NEW species of Pokemon to the Pokedex')
        print('  (q) - quit')
        print()
        ans = input('Enter an option: ').lower()
        while ans not in ['v', 'a', 'd', 'm', 'c', 'h', 't', 'n', 'q']:
            ans = input('Sorry, that option is not recognized. Enter an option again: ').lower()
        if ans == 'v':
            view_box()
        elif ans == 'a':
            add_pokemon()
        elif ans == 'd':
            delete_pokemon()
        elif ans == 'm':
            pass
        elif ans == 'c':
            pass
        elif ans == 'h':
            view_hacked_pokemon()
        elif ans == 't':
            analyze_type_advantages()
        elif ans == 'n':
            pass
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