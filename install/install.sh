# kPKI One Click Installer

# Variables
BASEFOLDER="$(pwd)"
export GOROOT="$BASEFOLDER/../go/"
export PATH=$PATH:$GOROOT/bin
CFSSL="$BASEFOLDER/../client/cfssl"
MYSQL="$(which mysql)"
MYSQLHOST="localhost"
MYSQLUSER="root"
MYSQLPASS=""
MYSQLDB="cfssl"

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
}


# Main Routine
echo -e "\tkPKI Installer started"
addmysql
