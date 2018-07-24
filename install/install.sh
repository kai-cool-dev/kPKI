# kPKI One Click Installer

# Variables
BASEFOLDER="$(pwd)"
# Needed programs
MYSQL="$(which mysql)"
CFSSL="$BASEFOLDER/../client/cfssl"
CAT="$(which cat)"
# Some Go Stuff (Required for the cfssl daemon)
export GOROOT="$BASEFOLDER/../go/"
export PATH=$PATH:$GOROOT/bin
# MySQL Variables
MYSQLHOST="localhost"
MYSQLUSER="root"
MYSQLPASS=""
MYSQLDB="cfssl"
# Config Files Location
CFSSL_MYSQL_EXAMPLE_CONFIG="$BASEFOLDER/../conf/mysql.config.example.json"
CFSSL_MYSQL_CONFIG="$BASEFOLDER/../conf/mysql.config.json"
HTML_MYSQL_EXAMPLE_CONFIG="$BASEFOLDER/../html/app/config/config.php.sample"
HTML_MYSQL_CONFIG="$BASEFOLDER/../html/app/config/config.php"
HTML_MYSQL_SCHEMA="$BASEFOLDER/../html/schemas/kPKI.schema.sql"

# Functions
function addmysql()
{
  echo -e "-->\tPlease Type in the MySQL Host:"
  read MYSQLHOST
  echo -e "\tWe are using '$MYSQLHOST' as the MySQL Hostname"

  echo -e "-->\tPlease Type in the MySQL Username:"
  read MYSQLUSER
  echo -e "\tWe are using '$MYSQLUSER' as the MySQL Username"

  echo -e "-->\tPlease Type in the MySQL Password:"
  read MYSQLPASS
  echo -e "\tWe are using '$MYSQLPASS' as the MySQL Password"

  echo -e "-->\tPlease Type in the MySQL Database:"
  read MYSQLDB
  echo -e "\tWe are using '$MYSQLDB' as the MySQL Database"

  echo -e "-->\tTrying to establish a MySQL Connection"
  MYSQLCONN="$MYSQL -u $MYSQLUSER -p$MYSQLPASS -h $MYSQLHOST $MYSQLDB -e QUIT"
  if $($MYSQLCONN)
  then
    echo -e "\tMySQL Connection is working"
  else
    echo -e "\tMySQL Connection is not working. Please check your input!\n$OUTPUT"
    exit 0;
  fi

  echo -e "-->\tUpdating Config Files"

  if [ -f $CFSSL_MYSQL_EXAMPLE_CONFIG ]
  then
     $CAT $CFSSL_MYSQL_EXAMPLE_CONFIG | sed "s/MYSQLHOST/$MYSQLHOST/g" | sed "s/MYSQLUSER/$MYSQLUSER/g" | sed "s/MYSQLPASS/$MYSQLPASS/g" | sed "s/MYSQLDB/$MYSQLDB/g" > $CFSSL_MYSQL_CONFIG
  else
    echo -e "\tDaemon MySQL Example Config not found. Aborting."
    exit 0;
  fi

  if [ -f $HTML_MYSQL_EXAMPLE_CONFIG ]
  then
     $CAT $HTML_MYSQL_EXAMPLE_CONFIG | sed "s/MYSQLHOST/$MYSQLHOST/g" | sed "s/MYSQLUSER/$MYSQLUSER/g" | sed "s/MYSQLPASS/$MYSQLPASS/g" | sed "s/MYSQLDB/$MYSQLDB/g" > $HTML_MYSQL_CONFIG
  else
    echo -e "\tGUI MySQL Example Config not found. Aborting."
    exit 0;
  fi

  echo -e "-->\tImport Schema"
  MYSQLCONN="$MYSQL -u $MYSQLUSER -p$MYSQLPASS -h $MYSQLHOST $MYSQLDB < $HTML_MYSQL_SCHEMA"
  if $($MYSQLCONN)
  then
    echo -e "\tMySQL Schema import successfull"
  else
    echo -e "\tMySQL Schema import is not working. Aborting!\n$OUTPUT"
    exit 0;
  fi

}


# Main Routine
echo -e "\tkPKI Installer started"
addmysql
