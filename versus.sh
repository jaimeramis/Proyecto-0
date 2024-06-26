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

# FUNCTION HEALTH AND RAGE BARS:
display_bars() {
    local health=$1
    echo "\e[1;42mHealth:\e[0m $health"
}

# FUNCTION TO SELECT A RANDOM MOVEMENT
random_movement() {
    local character_id=$1
    QUERY="SELECT name FROM movements WHERE character_id=$character_id ORDER BY RAND() LIMIT 1;"
    movement=$(mysql -h "$HOST" -P "$PORT" -u "$USER" -s -N -D "$DATABASE" -e "$QUERY")
    echo "$movement"
}

# FUNCTION TO DEAL DAMAGE
deal_damage() {
    echo $(( RANDOM % 20 + 1 ))  # Damage range between 1 and 20
}

# FUNCTION CHARACTER INFO
display_character_info() {
    local id=$1
    local image=$2
    local health=$3
    local rage=$4
    info=$(jp2a --width=20px --colors "$image" 2>/dev/null)
    echo "$info"
    QUERY="SELECT name FROM characters WHERE character_id=$id;"
    character_name=$(mysql -h "$HOST" -P "$PORT" -u "$USER" -s -N -D "$DATABASE" -e "$QUERY")
    echo "$character_name"
    echo "$(display_bars $health)"
}

# FUNCTION TO SELECT PLAYER BY J1 AND J2:
select_character() {
    local player=$1
    echo ""
    echo -e "\e[44m $player, SELECT A CHARACTER:\e[0m\e[0m"
    echo ""
    echo "1) Monty Brooks"
    echo "2) Akira Sushi"
    echo "3) Clara Hitt"
    echo "4) Jason McKing"
    echo "b) Back to Game Menu"
    echo " "
    read -p "SELECT AN OPTION: " choice
    echo " "
    case $choice in
        1)
            echo "1" > "/tmp/${player}_id"
            echo "$ch1" > "/tmp/${player}_image"
            ;;
        2)
            echo "2" > "/tmp/${player}_id"
            echo "$ch2" > "/tmp/${player}_image"
            ;;
        3)
            echo "3" > "/tmp/${player}_id"
            echo "$ch3" > "/tmp/${player}_image"
            ;;
        4)
            echo "4" > "/tmp/${player}_id"
            echo "$ch4" > "/tmp/${player}_image"
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
            select_character $player
            ;;
    esac
}

# Prompt players for their selections
select_character "J1"
select_character "J2"

# Assuming default health values for demonstration
default_health=100

# Initialize round and win counters
round=1
j1_wins=0
j2_wins=0


# Function to handle a single round of fighting
fight_round() {
    local j1_health=$default_health
    local j2_health=$default_health

    while [ $j1_health -gt 0 ] && [ $j2_health -gt 0 ]; do
        clear
        echo -e "\e[1;44m ROUND $round \e[0m"
        echo " "
        # Display characters information side by side
        j1_info=$(display_character_info $(cat /tmp/J1_id) $(cat /tmp/J1_image) $j1_health)
        j2_info=$(display_character_info $(cat /tmp/J2_id) $(cat /tmp/J2_image) $j2_health)

        # Random movements and damage
        j1_movement=$(random_movement $(cat /tmp/J1_id))
        j2_movement=$(random_movement $(cat /tmp/J2_id))
        j1_damage=$(deal_damage)
        j2_damage=$(deal_damage)

        # Create movement and damage info
        j1_action_info="$j1_movement deals $j1_damage damage"
        j2_action_info="$j2_movement deals $j2_damage damage"

        # Display combined info with potential Rage Mode activation
        j1_combined="$j1_info\n$j1_action_info\n"
        j2_combined="$j2_info\n$j2_action_info\n"

        # Display combined info side by side
        paste <(echo -e "$j1_combined") <(echo -e "$j2_combined") | column -s $'\t' -t

        # Update health
        j1_health=$((j1_health - j2_damage))
        j2_health=$((j2_health - j1_damage))

        # Health cannot be below 0
        if [ $j1_health -lt 0 ]; then
            j1_health=0
        fi
        if [ $j2_health -lt 0 ]; then
            j2_health=0
        fi

        # Delay before next movement
        sleep 1
    done

    # Final values of health
    clear
    j1_final_info=$(display_character_info $(cat /tmp/J1_id) $(cat /tmp/J1_image) $j1_health)
    j2_final_info=$(display_character_info $(cat /tmp/J2_id) $(cat /tmp/J2_image) $j2_health)
    paste <(echo -e "$j1_final_info") <(echo -e "$j2_final_info") | column -s $'\t' -t

    # Declare the winner of the round
    if [ $j1_health -le 0 ]; then
        echo " "
        echo -e "\e[1;42m J2 WINS ROUND $round! \e[0m"
        j2_wins=$((j2_wins + 1))
    elif [ $j2_health -le 0 ]; then
        echo " "
        echo -e "\e[1;42m J1 WINS ROUND $round! \e[0m"
        j1_wins=$((j1_wins + 1))
    fi

    # Increment round counter
    round=$((round + 1))

    # Pause before the next round
    echo " "
    read -p "Press [Enter] to continue to the next round..."
}

# Function to display the end game menu
end_game_menu() {
    echo ""
    echo -e "\e[44m END OF THE GAME MENU:\e[0m\e[0m"
    echo ""
    echo "b) BACK TO MAIN MENU"
    echo " "
    read -p "SELECT AN OPTION: " end_choice
    echo " "
    case $end_choice in
        b)
            source main.sh
            break
            ;;
        *)
            echo " "
            echo -e "\e[41mInvalid option. Select a correct one\e[0m"
            echo " "
            end_game_menu
            ;;
    esac
}

# Main loop for handling rounds
while [ $j1_wins -lt 2 ] && [ $j2_wins -lt 2 ]; do
    fight_round
done

# Declare the final winner
if [ $j1_wins -eq 2 ]; then
    echo " "
    echo -e "\e[1;42m J1 IS THE FINAL WINNER! \e[0m"
elif [ $j2_wins -eq 2 ]; then
    echo " "
    echo -e "\e[1;42m J2 IS THE FINAL WINNER! \e[0m"
fi

 end_game_menu

# Clean the export variable of the password
unset MYSQL_PWD
