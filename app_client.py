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
def example_query():
    param1 = ''
    cursor = conn.cursor()
    # Remember to pass arguments as a tuple like so to prevent SQL
    # injection.
    sql = 'SELECT col1 FROM table WHERE col2 = \'%s\';' % (param1, )
    try:
        cursor.execute(sql)
        # row = cursor.fetchone()
        rows = cursor.fetchall()
        for row in rows:
            (col1val) = (row) # tuple unpacking!
            # do stuff with row data
    except mysql.connector.Error as err:
        # If you're testing, it's helpful to see more details printed.
        if DEBUG:
            sys.stderr.write((err))
            sys.exit(1)
        else:
            # TODO: Please actually replace this :) 
            sys.stderr.write(('An error occurred, give something useful for clients...'))

"""
Executes the queries required for a user to view all of the Pokemon contained
within a particular box. Returns information of Pokemon contained in the box
to the user.
"""
def view_box():
    print("What box would you like to view?")
    box_num = int(input("Box (1-16): "))
    cursor = conn.cursor()
    sql = "SELECT pkmn_name, pokedex_number, pkmn_id, pkmn_nickname FROM box_owner NATURAL JOIN has_box NATURAL JOIN collected NATURAL JOIN has_species NATURAL JOIN pokedex WHERE user_id = '%s' AND (MOD(box_id - 1, 16) + 1) = %d;" % (session_username, box_num)
    try:
        print(session_username)
        print(box_num)
        cursor.execute(sql)
        rows = cursor.fetchall()
        print(rows)
        show_options()
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
    pass

"""
Executes the queries required for a user to delete a Pokemon from their box.
Alternatively, enables a user to delete ALL of the Pokemon within a particular
box. 
"""
def delete_pokemon():
    pass

"""
Executes the queries required for a user to search across all their boxes for
all Pokemon they possess which are of a certain type (for dual-typed Pokemon,
if either of their types is the specified type). Returns key information
about all Pokemon which match the specified type.
"""
def search_by_type():
    pass

"""
Executes the queries required for a user to determine which of their Pokemon
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
        sql = "CALL sp_add_client('%s', '%s');" % (username, password)
        try:
            cursor.execute(sql)
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
    print('What would you like to do?')
    print('  (v) - view a box')
    print('  (a) - add a Pokemon to a box')
    print('  (d) - delete Pokemon from a box')
    print('  (s) - search for Pokemon of a certain type')
    print('  (t) - analyze type advantages')
    print('  (q) - quit')
    print()
    ans = input('Enter an option: ').lower()
    if ans == 'v':
        view_box()
    elif ans == 'a':
        add_pokemon()
    elif ans == 'd':
        delete_pokemon()
    elif ans == 's':
        search_by_type()
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