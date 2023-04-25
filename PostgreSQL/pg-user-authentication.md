# 4 types of PostgreSQL user authentication methods you must know

https://postgreshelp.com/postgresql-user-authentication-demystified/

How is the PostgreSQL user authentication done when you login to the database?
By default, when PostgreSQL server is installed, a user called Postgres and a database called Postgres is created. There will be two more databases called template0 and template1 are created by default, but we limit the post with user authentication only.
If you want to login to the Postgres database with postgres user we simply query psql.
```
[postgres@postgreshelp data]$ psql
psql (9.6.8)
Type "help" for help.
postgres=#
postgres=# select current_user;
current_user
--------------
postgres
(1 row)
 
postgres=#
```

But what is the default password for Postgres user? The answer is simple, there is not any default password for Postgres user. The first thing we need to do after the database is created is to set the password for the Postgres user.
How to Change a Password for PostgreSQL user?
Use the following command to change/set the password for your current user:
```
postgres=# \password
Enter new password:
Enter it again:
postgres=#
```
But the question is how did it login without prompting for the password or even without setting a password?

The reason why it did not ask for a password is its authentication method. The authentication method configuration will be there in **pg_hba.conf** file under the data directory. The default authentication method for PostgreSQL server is either ident or peer. There are two more authentication methods which are widely used are trust and md5.

### PostgreSQL User Authentication types:
#### Peer Authentication:
The peer authentication method works by obtaining the client's operating system username from the kernel and using it as the allowed database username (with optional username mapping). This method is only supported on local connections.
```
[postgres@postgreshelp ~]$ psql -U postgres
psql (9.6.8)
Type "help" for help.
 
postgres=#
```

Here, as the database username and the OS username are same, the peer authentication method used OS credentials and logged in successfully. If I use a database user other than Postgres it throws an error.
```
postgres=# create user testing ;
CREATE ROLE
postgres=# \q
[postgres@postgreshelp ~]$ psql -U testing
<strong>psql: Peer authentication failed for user "testing"</strong>
[postgres@asristgdb ~]$
```
Here, as testing user is not there at OS level my authentication failed. To resolve the above issue, we have to map the operating system username to a database user.

#### Username Mapping:
username mapping can be done in two steps. 
STEP 1: Add a mapping configuration in pg_ident.conf file.
STEP 2: specify map=map-name in the options field in pg_hba.conf.
STEP 1:
```
[postgres@postgreshelp data]$ cat pg_ident.conf
 
MAPNAME       SYSTEM-USERNAME         PG-USERNAME
postgres-testing        postgres        testing
``` 
STEP 2:
```
[postgres@postgreshelp data]$ cat pg_hba.conf
local   all          all        peer map=postgres-testing

Reload the Postgres server:
postgres=# select pg_reload_conf();
pg_reload_conf
----------------
t
(1 row)
 
postgres=# \q
[postgres@postgreshelp ~]$ psql -U testing -d postgres
psql (9.6.8)
Type "help" for help.
 
postgres=>
```

#### Trust Authentication
When trust authentication is specified, PostgreSQL assumes that anyone who can connect to the server is authorized to access the database with whatever database username they specify (even superuser names). Of course, restrictions made in the database and user columns still apply. This method should only be used when there is adequate operating-system-level protection on connections to the server. This method allows anyone that can connect to the PostgreSQL database server to login as any PostgreSQL user they wish, without the need for a password or any other authentication. The following is the line mentioned in pg_hba.conf for local authentication:

local  all              all                     trust
Here, irrespective of the password given, the postgres server allows the user to login.
```
[postgres@postgreshelp data]$ psql -U testing -d postgres
psql (9.6.8)
Type "help" for help.
 
postgres=>
```

#### md5 Authentication (part of Password Authentication method)
There are several password-based authentication methods. These methods operate similarly but differ in how the users' passwords are stored on the server and how the password provided by a client is sent across the connection: scram-sha-256, md2, or password.
Requires the client to supply a double-MD5-hashed password for authentication. The following is the line mentioned in pg_hba.conf for md5 authentication:

local  all              all                     md5

How does it work?
```
postgres=# create user md5user;
CREATE ROLE
postgres=# \q
[postgres@postgreshelp data]$ psql -U md5user
Password for user md5user:
<strong>psql: FATAL:  password authentication failed for user "md5user"</strong>
[postgres@asristgdb data]$
```
Here, as I have not supplied any password while creating the user, my login failed. After changing the password for the md5user I could log in to the database.
```
postgres=# alter user md5user password 'md5user';
ALTER ROLE
[postgres@postgreshelp data]$ psql -U md5user -d postgres
Password for user md5user:
psql (9.6.8)
Type "help" for help.
 
postgres=>
```

#### ident Authentication
The ident authentication method works by obtaining the client's operating system username from an ident server and using it as the allowed database username (with an optional username mapping). This is only supported on TCP/IP connections.
Obtain the operating system username of the client by contacting the ident server on the client and check if it matches the requested database username. Ident authentication can only be used on TCP/IP connections. When specified for local connections, peer authentication will be used instead. ident works similar to peer authentication.
```
[postgres@postgreshelp data]$ psql -d postgres -U md5user -h 10.10.12.143
<strong>psql: FATAL:  Ident authentication failed for user "md5user"</strong>
[postgres@postgreshelp data]$ psql -d postgres -U md5user
<strong>psql: FATAL:  Peer authentication failed for user "md5user"</strong>
[postgres@asristgdb data]$
[postgres@postgreshelp data]$ cat pg_hba.conf | grep ident
local  all              all             ident
host   all              all             ident
 
[postgres@asristgdb data]$
```

Depending on the environment needs, we either set trust or md5 as our default authentication method. Peer and ident methods are more dependent on OS usernames, so we do not use these authentication methods.
https://www.postgresql.org/docs/current/auth-methods.html

