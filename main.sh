#!/bin/bash

# MAIN MENU
mainImage="images/main-menu.png"

# IF IMAGE EXISTS DO:
if [ -f "$mainImage" ]; then
  # RENDERING IMAGE TO  ASCII
  jp2a --background=light  --colors "$mainImage"
else
  echo "This image $mainImage doesn't exist."
fi

# SELECT AN OPTION
# MAIN MENU:
while true; do
    echo " "
    echo -e "\e[44mSELECT AN OPTION:\e[0m\e[0m"
    echo " "
    echo "1) FIGHT MODE"
    echo "2) CHARACTERS LIST"
    echo "h) HELP"
    echo " "

    read -p "SELECT AN OPTION:" menu
    echo " "

    case $menu in

        1)  # GO TO FILE FIGHT:
            source versus.sh
	    break
            ;;

        2) # GO TO FILE CHARACTERS:
            source characters.sh
	    break
	    ;;

	h) echo "Press 1 to access FIGHT MODE"
	   echo "Press 2 to access CHARACTER LIST"
            ;;

        *)
	   echo " "            
	   echo -e "\e[41mInvalid option. Select a correct one\e[0m"
           menu=""
            ;;
    esac
done





