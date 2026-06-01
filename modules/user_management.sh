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



	
