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
# lock_user(){

# }
# unlock_user(){

# }
# create_group(){

# }
# add_user_to_group(){

# }
# list_users(){

# }
	
