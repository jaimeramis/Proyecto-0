#!/bin/bash

# DATABASE CONFIGURATION
HOST="localhost"
USER="root"
PASSWORD="admin"
PORT="3306"
DATABASE="proyecto_0"

# THIS IS FOR THE WARNING MESSAGE OF THE PASSWORD:
export MYSQL_PWD="$PASSWORD"

# CHARACTERS IMAGES
ch1="images/01.png"
ch2="images/02.png"
ch3="images/03.png"
ch4="images/04.png"

# FUNCTION CHARACTER INFO
display_character_info() {
    local id=$1
    local image=$2
    jp2a --width=20px --colors "$image"
    echo " "
    QUERY="SELECT name AS Name, gender AS Gender, origin AS Origin, style AS Style, LEFT(status, 50) AS Background FROM characters WHERE character_id=$id;"
    mysql -h "$HOST" -P "$PORT" -u "$USER" -t -D "$DATABASE" -e "$QUERY" | column -t -s $'\t'
    echo " "
}

# CHARACTER SELECTION MENU:
while true; do
    echo " "
    echo -e "\e[44mSELECT A CHARACTER TO SEE INFORMATION:\e[0m\e[0m"
    echo " "
    echo "1) Monty Brooks"
    echo "2) Akira Sushi"
    echo "3) Clara Hitt"
    echo "4) Jason McKing"
    echo "b) Back to Game Menu"
    echo " "

    read -p "SELECT AN OPTION: " menu

    case $menu in
        1)
            echo " "
            display_character_info 1 "$ch1"
            ;;
        2)
	    echo " "
            display_character_info 2 "$ch2"
            ;;

        3)
	    echo " "
            display_character_info 3 "$ch3"
            ;;

        4)
	    echo " "
            display_character_info 4 "$ch4"
            ;;
        b)
            # GO TO MAIN FILE:
            source main.sh
	    break
            ;;
        *)
	    echo " "
            echo -e "\e[41mInvalid option. Select a correct one\e[0m"
	    echo " "
            ;;
    esac
done

# CLEAN THE EXPORT VARIABLE OF THE PASSWORD:
unset MYSQL_PWD
