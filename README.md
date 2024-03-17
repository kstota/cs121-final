# cs121-final

## Overview

This is a SQL implementation of the Pokemon database, paired with a Python CLI
for both regular clients and admins (who have additional admin-specific
functionality). This implementation has the additional ability to detect
whether a stored Pokemon is "hacked" - that is, whether its stats are
legitimate according to in-game mechanics actually used to compute the stat
values of a particular Pokemon (see hack_check.pdf for more).

Users have the ability to view their own Pokemon, add Pokemon
to their boxes, release Pokemon from their boxes, move Pokemon between boxes,
search through their Pokemon on the basis of Pokemon name, level, or type, and
analyze type weaknesses of their Pokemon. Admins can perform all of these
operations on ANY user, as well as view all hacked Pokemon in storage and the
total number of Pokemon stored by each user of the Pokemon Storage System.

Our Pokedex data is adapted from:
https://gist.github.com/armgilles/194bcff35001e7eb53a2a8b441e8b2c6

Our nature data is adapted from:
https://bulbapedia.bulbagarden.net/wiki/Nature

Our type advantage table is adapted from:
https://www.kaggle.com/datasets/jadenbailey/pokemon-type-chart

## Packages

This application requires the following Python packages:

mysql.connector, mysql.connector.python, prettytable

Please ensure that these packages are installed (they can be installed via
pip or any other package manager) before attempting to run the application.

## Database/application setup

First, download all files in the main directory of this repository. Make sure
to also download the datasets (pokedex.csv, nature.csv, type_weaknesses.csv).

Loading the database and application requires the following files to be run
(in this exact order):

In MySQL:
mysql> source setup.sql;

mysql> source setup-routines.sql;

mysql> source setup-passwords.sql;

mysql> source load-data.sql;

mysql> source grant-permissions.sql;

mysql> source queries.sql;

mysql> exit

In terminal:
If you want to run the admin app: python3 app_admin.py

If you want to run the client app: python3 app_client.py

## Example walkthrough of application

The remainder of this guide will be from the perspective of the user 'profoak'
whose password is 'bestgrandpa'. Feel free to log into this user after
setting up the application and running through the following example
functionality!

To demonstrate some examples of things you can do in the Pokemon Storage
System, we'll run through some operations Professor Oak has to complete today.

First, let's view the number of Pokemon stored by all users. In the main menu,
enter 'c'. You should see a table containing the numbers of Pokemon owned by
all users of the system. Note that 'ashketch' (Ash Ketchum) has no Pokemon!
Today, you'll help Ash start his Pokemon journey by giving him his starter
Pokemon, a trusty Pikachu.

Press the Enter key to return to the main menu. Then, enter 'a' to add a
Pokemon to a box. Then, enter 'u' to indicate that you wish to add a new
Pokemon to ashketch's boxes. Enter the user_id 'ashketch' when prompted.
Enter box number 1 next. Enter the species name 'pikachu' next. Nickname
this Pikachu 'starter' so that we can find it later. Enter the following
stats for this Pikachu when prompted:

HP: 19

Attack: 11

Special Attack: 11

Defense: 10

Special Defense: 11

Speed: 15

Level: 5

Nature: Docile

Return to the main menu by pressing Enter. Now, let's view Ash's box to ensure
that he has his Pikachu. Enter 'v' to view a box. Then, enter 'u' to indicate
that you wish to view a different user's boxes. Once again, enter the user_id
'ashketch' to view Ash's boxes. Since we added Pikachu to box 1, enter box 1
when prompted. You should see the Pikachu we just added!

The number of Pokemon stored in Ash's boxes should also update automatically.
Return to the main menu, and enter 'c' to view the counts of Pokemon in each
user's boxes again. Now, you'll see that Ash's boxes contain 1 Pokemon. While
you're here, note that 'teamrocket' has 16 Pokemon.

You've been informed that there is some suspicious activity occurring in the
Pokemon Storage System. Return to the main menu and enter 'h' to view the
hacked Pokemon currently in storage. As you suspected, Team Rocket has been
storing a bunch of hacked Pokemon! The Pokemon with pkmn_id 46, 47, 48, 49, 
and 50 are all hacked.

You need to delete these Pokemon to ensure the integrity of the Pokemon
Storage System as an admin. Thus, return to the main menu and enter 'd'
to delete a Pokemon. When prompted for an ID, enter the pkmn_id 46. Repeat
this process for pkmn_id 47, 48, 49, and 50.

Now, let's view the number of Pokemon stored by Team Rocket. Enter 'c' in the
main menu. You'll see that 'teamrocket' now only owns 11 Pokemon! 

This concludes the example walkthrough of our application!
