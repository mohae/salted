#
# name: pillar/mysql_dbs.sls
# purpose: Define the database and user for various DBs that aren't
#          directly part of an application install. The application
#          is responsible for its own db and user creation stuff
# Notes: The testDBO is the database owner. This user has all privileges
#        to only this database. Normal users of the database should be 
#        added via as a db user.  The testDBO password is the same as the
#        username.  Do not do this in a real deployment!
#
qa_mysql_dbs:
  qa_db:
    db_name: qaDB
    db_user: qaDBDBO
    db_pass_hash: "*7281996ED068E0E4D939D27AECD9D7447C1EA3DC"
    db_host: localhost
    db_grants: all privileges
