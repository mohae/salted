#
# name: pillar/mysql_dbs.sls
# purpose: Define database users. These users usually have more restricted
#          privileges than DBAs and DBOs. The database for which they are 
#          being given permission to use should exist.
# Notes: The testUser password is the same as the username.  Do not do this
#        in a real deployment!
#

qa_db_users:
  qaUser:
    db_pass_hash: "*62037296EFDBA039E7DABB7986DDA82138F27296"
    database: qa
    db_host: localhost
    db_grants: insert,update,select,delete
