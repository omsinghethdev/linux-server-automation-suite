#!/usr/bin/env bash
show_menu(){
	echo "==================================="
        echo "  Linux Server Automation Suite    "
        echo "==================================="

        echo "1. User Management"
        echo "2. System Monitoring"
        echo "3. Backup Management"
        echo "4. Deployment Automation"
        echo "5. Exit"
        echo "==================================="

	}
get_valid_choice() {
	local attempt=0
        local maxattempt=3
        
        while (( attempt < maxattempt )); do
                read -p "Enter your choice: " choice 
                if [[ -z "${choice}" ]]; then
                        echo "Choice is empty"
                        echo "Choose Again"
                        ((attempt++))


                elif ! [[ "$choice" =~ ^[0-9]+$ ]]; then
                        echo "Choice must be number."
                        ((attempt++))


                elif  (( choice <1 || choice > 6 )); then
                        echo "Choice must be from 1 to 5"
                        ((attempt++))

                else 
                        echo "Valid Choice"
                        break
                fi
        
                echo "Attempt left: $((maxattempt - attempt))"
                        
        done
        if (( attempt == maxattempt )); then
                echo "Too many invalid attempt. Exiting...."
                exit 1
        fi
        
}


handle_choice() {
		local selected_choice="$1"
		case "${selected_choice}" in
                1) echo "User Management selected" 
                   read -p "Press Enter to continue..."
                   source ./modules/user_management.sh
                   ;;
                2) echo "System Monitoring selected"
                   read -p "Press Enter to continue..." 
                   ;;
                3) echo "Backup Management selected"
                   read -p "Press Enter to continue..."
                   source ./modules/backup.sh
                   ;;
                4) echo "Deployment Automation selected"
                   read -p "Press Enter to continue..."
                   source ./modules/deployment.sh
                   ;;
                5) echo "Exiting..."
                   read -p "Press Enter to continue..."
                   exit 0
                   ;;
        	esac

		}

ask_continue() {
		local confirm
		read -p  "Do you want to go to  Main menu?(yes/no):" confirm
                    if [[ "${confirm}" == 'yes' ]]; then
                        return 0
                    else 
                        echo "Exiting Script...."
                        exit 0
                    fi

		}
clear_screen(){
        clear
}


while true; do
        clear_screen
	show_menu
	
	get_valid_choice

	handle_choice "$choice"

	ask_continue	
done
