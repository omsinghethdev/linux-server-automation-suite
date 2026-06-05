show_user_menu(){

	echo "-----------------"
	echo "1.Creat User"
	echo "2.Delete User"
	echo "3.Lock User"
	echo "4.Unlock User"
	echo "5.Create Group"
	echo "6.Add User to Group"
	echo "7.List Users"
	echo "8.Back to main menu"
	echo  "------------------"
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


                elif  (( choice <1 || choice > 8 )); then
                        echo "Choice must be between 1 and 8"
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

handle_user_choice() {
    local selected_choice="$1"

    case "$selected_choice" in
        1) create_user ;;
        2) delete_user ;;
        3) lock_user ;;
        4) unlock_user ;;
        5) create_group ;;
        6) add_user_to_group ;;
        7) list_users ;;
        8) return 0 ;;
        *) echo "Invalid choice." ;;
    esac
}


create_user() {
        local username
        local attempt=0
        local maxattempt=3
 while (( attempt < maxattempt )) ; do 
        read -p "Enter the username:" username
        if [[ -z  "${username}" ]]; then
                echo "Username is Empty"
                ((attempt++))
        elif ! [[ "${username}" =~ ^[a-z0-9_-]+$ ]]; then
                echo "Invalid username entry."
                ((attempt++))
        
        elif getent passwd "${username}" > /dev/null; then
                echo "User already exists."
                ((attempt++))
        else
                echo "Creating User ${username}."
                        if sudo useradd "${username}"; then
                                echo "User created Succesfully."
                                break
                        else
                                echo "ERROR in Creating user"
                        fi


        fi
     done

        if (( attempt == maxattempt )); then
                echo "To many attmepts.Returning to User Management menu...."
                return 1
        fi

        
}
delete_user(){
        local username
        local attempt=0
        local maxattempt=3
        while ((attempt < maxattempt)); do
                read -p  "Enter the user to Delete:" username
                if [[ -z ${username} ]]; then
                        echo "No User Entered "
                        ((attempt++))
                elif  ! [[ ${username} =~ ^[a-z0-9\-_]+$ ]]; then
                        echo "Invalid user entry."
                        ((attempt++))
                elif getent passwd "${username}" > /dev/null; then
                        echo "User Found! "
                        read -p "Are you sure you want to delete the user '${username}'?(yes/no) " confirm

                        if [[ "$confirm" == "yes" ]]; then
                                echo "Deleting the User ${username}"
                                
                                if sudo userdel ${username}; then
                                        echo "Deleted user Successfully."
                                        break
                                else
                                        echo "ERROR in deleting user."
                                        return 1
                                fi
                        else
                                echo "Deleting operation cancelled."
                                return 0
                        fi
                else 
                        echo "User does'nt exist."
                        ((attempt++))
                fi

                
        done
        if (( attempt == maxattempt )); then
                echo "To many attmepts.Returning to User Management menu...."
                return 1
        fi


}

 lock_user(){
        local username
        local attempt=0
        local maxattempt=3
        while ((attempt < maxattempt)); do
                if [[ -z "${usernaeme}" ]]; then
                        echo "Username is empty."
                        ((attempt++))
                elif ! [[ ${username} =~ ^[a-z0-9_-]+$ ]]; then
                        echo "Invalid username entered."
                        ((attempt++))
                elif  getent passwd "${username}" > /dev/null; then
                        echo "User Exist."
                        read -p "Are you sure to lock the ${username}?(yes/no)" choice
                                if [[ ${choice} == 'yes' ]]; then
                                        echo "Locking the user."
                                          if sudo usermod -L ${username}; then
                                                echo "Locked user Successfully."
                                                break
                                          else
                                                echo "ERROR in Locking user."
                                                return 1
                                          fi

                                else
                                        echo "Locking User operation cancelled."
                                        return 0
                                fi 
                else 
                        echo "User Doesn't Exist."
                        ((attempt++))
                fi         

        done
        if (( attempt == maxattempt )); then
                echo "To many attmepts.Returning to User Management menu...."
                return 1
        fi

 }
 unlock_user(){
        local username
        local attempt=0
        local maxattempt=3
        while ((attempt < maxattempt)); do
                read -p "Enter the username:" username

                if [[ -z ${username} ]]; then
                        echo "Username is empty."
                        ((attempt++))
                elif ! [[ ${username} =~ ^[a-z0-9_-]+$ ]]; then
                        echo "Invalid username formate."
                        ((attempt++))
                elif getent passwd "${username}" > /dev/null; then
                        echo "User exist."
                        read -p "Do you actually want to unlock the user ${username}?(yes/no)" choice
                        if [[ "${choice}" == 'yes' ]]; then
                                echo "Unlocking User."
                                if sudo usermod -U "${username}"; then
                                   echo "Unlocked user Successfully."
                                   break
                                else
                                   echo "ERROR in Unlocking user."
                                   return 1
                                fi
                        else
                                echo "Unlocking user operation cancelled."
                                return 0
                        fi
                else 
                        echo "User Don't Exist."
                        ((attempt++))
                fi
        

        done

        if (( attempt == maxattempt )); then
                echo "To many attmepts.Returning to User Management menu...."
                return 1
        fi

 }
create_group(){
        local groupname
        local attempt=0
        local maxattempt=3
        while (( attempt < maxattempt)); do
                read -p "Enter the groupname to Create:" groupname
                if [[ -z "${groupname}" ]]; then
                        echo "Empty groupname.Retry!"
                        ((attempt++))
                elif ! [[ "${groupname}" =~ ^[a-z0-9_-]+$  ]]; then
                        echo "Invalid Groupname Entered."
                        ((attempt++))
                elif getent group "${groupname}" > /dev/null; then
                        echo "Group already exists."
                        ((attempt++))
                else
                        echo "Creating group: ${groupname}."
                        if sudo groupadd "${groupname}"; then
                                 echo "Group created successfully."
                                 break
                        else
                                 echo "ERROR creating group."
                                 return 1
                        fi
                fi
        done
                if (( attempt == maxattempt )); then
                       echo "To many attmepts.Returning to User Management menu...."
                       return 1 
                fi
 }
#  add_user_to_group(){

#  }
# list_users(){

# }
while true
do
    show_user_menu
    get_valid_choice
    handle_user_choice "$choice"
done
	
