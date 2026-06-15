show_user_menu(){

	echo "-----------------"
	echo "1.Creat User"
	echo "2.Delete User"
	echo "3.Lock User"
	echo "4.Unlock User"
	echo "5.Create Group"
	echo "6.Delete Group"
	echo "7.Add User to Group"
	echo "8.List Users"
	echo "9.Back to main menu"
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


                elif ! [[ "${choice}" =~ ^[0-9]+$ ]]; then
                        echo "Choice must be number."
                        ((attempt++))


                elif  (( choice <1 || choice > 9 )); then
                        echo "Choice must be between 1 and 9"
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

    case "${selected_choice}" in
        1) create_user ;;
        2) delete_user ;;
        3) lock_user ;;
        4) unlock_user ;;
        5) create_group ;;
	6) delete_group ;;
        7) add_user_to_group ;;
        8) list_users ;;
        9) return 1 ;;
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
                if [[ -z "${username}" ]]; then
                        echo "No User Entered "
                        ((attempt++))
                elif  ! [[ "${username}" =~ ^[a-z0-9_-]+$ ]]; then
                        echo "Invalid user entry."
                        ((attempt++))
                elif getent passwd "${username}" > /dev/null; then
                        echo "User Found! "
                        read -p "Are you sure you want to delete the user '${username}'?(yes/no) " confirm

                        if [[ "$confirm" == "yes" ]]; then
                                echo "Deleting the User ${username}"
                                
                                if sudo userdel "${username}"; then
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
                read -p "Enter the username to Lock:" username
                if [[ -z "${username}" ]]; then
                        echo "Username is empty."
                        ((attempt++))
                elif ! [[ "${username}" =~ ^[a-z0-9_-]+$ ]]; then
                        echo "Invalid username entered."
                        ((attempt++))
                elif  getent passwd "${username}" > /dev/null; then
                        echo "User Exist."
                        read -p "Are you sure to lock the ${username}?(yes/no)" choice
                                if [[ "${choice}" == 'yes' ]]; then
                                        echo "Locking the user."
                                          if sudo usermod -L "${username}"; then
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

                if [[ -z "${username}" ]]; then
                        echo "Username is empty."
                        ((attempt++))
                elif ! [[ "${username}" =~ ^[a-z0-9_-]+$ ]]; then
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

delete_group() {
	local groupname
	local attempt=0
	local maxattempt=3
	
	while (( attempt < maxattempt )); do
	     read -p "Enter the group name:" groupname
	        if [[ -z "${groupname}" ]]; then
		     echo "Empty groupname."
		     ((attempt++))
	     	elif ! [[ "${groupname}" =~ ^[a-z0-9_-]+$ ]]; then
		     echo "Invalid grouname format."
		     ((attempt++))
		elif getent group "${groupname}" > /dev/null; then
		     echo  "Group exists."
		     read -p "Are sure to delete the group ${groupname}?(y/n):" choice
			if [[ "${choice}" == 'y' ]];then
				echo "Deleting the group ${groupname}."
					if sudo groupdel "${groupname}"; then
						echo "Deleted group Successfully."
						break
					else 
						echo "ERROR in deleting group."
						return 1
					fi
	                else
				echo "Deleting group operation cancelled."
				return 0
			fi	    
		else
		     echo "Group does'nt exist."
		     ((attempt++))
		fi
	done
		if (( attempt == maxattempt )); then
			echo "Too many attempts.Returning to User Management menu..."
			return 1
		fi
}
  add_user_to_group(){
                local username
                local groupname
                local attempt_usr=0
                local max_att_usr=3
                local attempt_gp=0
                local max_att_gp=3

                while ((attempt_usr < max_att_usr)); do
                        read -p "Enter the user name to add in the Group:" username
                        if [[ -z "${username}" ]]; then 
                                echo "Username empty.Retry"
                                ((attempt_usr++))
                        elif ! [[ "${username}" =~ ^[a-z0-9_-]+$ ]]; then
                                echo "Invalid username formate Retry."
                                ((attempt_usr++))
                        elif getent passwd "${username}" > /dev/null; then
                                echo "User ${username} found."
                                break
                        else 
                                echo "User does'nt exist."
                        fi

                done
                if ((attempt_usr == max_att_usr)); then
                        echo "Too many attempts.Returning to the user menu"
                        return 1
                fi

                while ((attempt_gp < max_att_gp)); do
                        read -p "Enter the user name to add in the Group:" username
                        if [[ -z "${groupname}" ]]; then 
                                echo "Groupname empty.Retry"
                                ((attempt_gp++))
                        elif ! [[ "${groupname}" =~ ^[a-z0-9_-]+$ ]]; then
                                echo "Invalid groupname format. Retry."
                                ((attempt_gp++))
                        elif getent group "${groupname}" > /dev/null; then
                                echo "Group ${groupname} found" 
                                break
                        else
                                echo "Group does'nt exists."

                                ((attempt_gp++))
                        fi

                done
                if ((attempt_gp == max_att_gp)); then
                        echo "Too many attempts.Returning to the user menu"
                        return 1
                fi
                read -p "Add user '${username}' to group '${groupname}'? (yes/no): " confirm

                if [[ "${confirm}" == "yes" ]]; then
                        if sudo -aG "${groupname}" "${username}"; then  
                                echo "User '${username}' added to group '${groupname} successfully."
                        else 
                                echo "ERROR: Failed to add user to group"
                                return 1
                        fi
                
                else
                        echo "Operation Cancelled."
                        return 0
                fi

}
 list_users(){

    echo "Available Users:"
    getent passwd | cut -d: -f1

}
while true
do
    show_user_menu
    get_valid_choice
    handle_user_choice "$choice"
    if (( $? == 1 )); then
        break
    fi
done
	

