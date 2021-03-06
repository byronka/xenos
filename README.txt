If you have already set up everything, just type:

  ant run-dev




                          **===================**
                          **===================**
                          **  Getting started  **
                          **===================**
                          **===================**


*Note: Check out the dev manual in docs/dev_manual





=================
1) Dependencies
=================

OpenJdk 1.7
MariaDB 10.0.17-MariaDB

Installing OpenJdk
------------------

For CentOS:
sudo yum install java-1.7.0-openjdk-devel

For Ubuntu:
sudo apt-get install openjdk-7-jre

Installing MariaDB
----------------

Download links for Generic Linux binaries:

(Choose 32 bit or 64 bit.  By the way, I experimented - choosing
one or the other will have negligible impact on memory usage)

https://downloads.mariadb.org/f/mariadb-10.0.17/source/mariadb-10.0.17.tar.gz/from/http%3A/sfo1.mirrors.digitalocean.com/mariadb?serve

Follow the general instructions from the INSTALL-SOURCE file 
in that archive.

Once the build is done, look for INSTALL-BINARY and 
follow those instructions to the letter.

IMPORTANT: If there is a sock (socket) complaint it gives you, like
something about not finding the sock in /var/run/mysql/mysql.sock or
similar, the problem tends to be that you need to explicitly set the
value for the file location for the socket, in my.cnf.  Also, make
sure the directly and file for the socket are owned by mysql, by
typing something like the following, as root or in sudo mode:

  chown -R mysql:mysql /var/run/mysql

Now, set up a user, xenosuser and a password of password1

First, use the mysql program to connect to the server as the 
MariaDB root user:

> mysql -u root -p

If you have assigned a password to the root account, you will also
need to supply a --password or -p option, 

Second, use the mysql command to add our user:
mysql> CREATE USER 'xenosuser'@'localhost' IDENTIFIED BY 'password1';
mysql> GRANT ALL PRIVILEGES ON *.* TO 'xenosuser'@'localhost'WITH GRANT OPTION;
mysql> CREATE USER 'xenosuser'@'%' IDENTIFIED BY 'password1';
mysql> GRANT ALL PRIVILEGES ON *.* TO 'xenosuser'@'%' WITH GRANT OPTION;



========================
2) Configure Tomcat
========================
Run this command:
  cp $CATALINA_HOME/conf/server.xml.README $CATALINA_HOME/conf/server.xml

This is a mandatory Tomcat configuration file.  It's needed to do it this
way so we can leave the server.xml file unaffected by source control
on the production server.



========================
3) Environment variables
========================

There is a script, utils/set_env.sh which will try to get the
proper values for JAVA_HOME, ANT_HOME, and CATALINA_HOME.  Of these,
JAVA_HOME is the tricky one, since the other two are in this directory!

If you already know the values for JAVA_HOME, ANT_HOME, and CATALINA_HOME,
just set them.  They may be as follows:

ANT_HOME=$LOCATION_OF_XENOS_FOLDER/ant/apache-ant-1.9.4
CATALINA_HOME=$LOCATION_OF_XENOS_FOLDER/web_container/apache-tomcat-8.0.14

For Ubuntu:
JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64

For CentOS:
JAVA_HOME=/usr/lib/jvm/java-1.7.0-openjdk-1.7.0.65.x86_64

If you want to use a script to search for your JAVA_HOME, just run:

utils/set_env.sh

ANT_HOME should point to the Ant project in this folder. You need it
  to run the ant scripts that make development easy.

JAVA_HOME should point to a Java 1.7 OpenJdk directory.  Ant needs it
  to build the source.

CATALINA_HOME should point to the Tomcat directory.  The Tomcat
  scripts need this.


Optional variables
------------------

If you want Ant to only print information about targets when there is
something interesting in it (like errors or notes), you might add this
environment variable:

  set ANT_ARGS="-emacs -logger org.apache.tools.ant.NoBannerLogger"
  export ANT_ARGS

This way a lot of the unneccessary information is avoided during
builds.  You can try this out yourself from the command line:

  ant -emacs -logger org.apache.tools.ant.NoBannerLogger run

See more about this at: ./utils/ant/apache-ant-1.9.4/manual/listeners.html






========================
4) Git setup
========================

Read the information in the dev manual about setting up git client 
hooks.  You'll need that if you want to avoid getting nasty error messages
when you push to the central repository.  See Git commit standards.




====================================
5) Directories and files at the top:
====================================

build.xml - the Ant script that provides all sorts of benefits, for
  example, building the project. Note: it is very important that this
  file remain where it is, at the root of the project.  Otherwise, it
  may end up creating and deleting directories in unexpected places.

db_scripts/ - holds scripts necessary to built the database schema.

docs/ - documentation for the project.

lib/ - library files used by the project

src/ - source files of the project Compiled code will be placed in the build
  directory

utils/ - some utilities helpful for development.
  |
  \--- test_scripts/ - contains lynx scripts for integration testing.  For
    more info, see the dev manual in docs

web_container/ - contains documents and binaries for the web container,
  Tomcat.  Also contains the xenos web application and its client files.
  note that when the java files get compiled, they are placed in the 
  classes directory under webapps/Root/WEB-INF/

