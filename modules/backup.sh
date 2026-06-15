show_backup_menu(){
        echo "---------------------"
        echo "1.Create Backup"
        echo "2.List Available Backup"
        echo "3.Restore Backup"
        echo "4.Delete Backup"
        echo "5.View Backup log"
        echo "6.Back to Main menu"
        echo "----------------------"
}
get_valid_choice() {
        local attempt=0
        local maxattempt=3

        while ((attempt < maxattempt)); do
                read -p "Enter your choice:" choice
                if [[ -z "${choice}" ]]; then
                        echo "Your Choice is empty.Retry"
                        ((attempt++))
                elif ! [[ "${choice}" =~ ^[0-9]+$ ]]; then
                        echo "Choice must be number."
                        ((attempt++))
                elif (( choice < 1 || choice > 6)); then
                        echo "Choice must be between 1 and 6"
                        ((attempt++))
                else
                        echo "Valid Choic."
                        break
                fi
                echo "Attempt left :$((maxattempt - attempt))"

        done

                if ((attempt == maxattempt)); then
                        echo "To many envalid attempt.Exiting..."
                        return 1
                fi
}

handle_backup_choice() {
        local select_choice="$1"

        case "${select_choice}" in
                1)main_backup ;;
                2)list_avl_backup ;;
                3)restore_backup ;;
                4)delete_backup ;;
                5)view_backup_log ;;
                6)return 1 ;;
                *)echo "Invalid Choice."
        esac
}
#Creating backup function 
#Source folder input
get_source_folder(){
	folder=''
	local attempt=1
	local count=3
	echo "---------------------------"
	echo "Starting Backup Automation"
	echo "---------------------------"
while [[ ${attempt} -le  ${count} ]]; do
	read -e -p "Enter the folder name: " folder

	if [[ -d "${folder}" ]]; then
		echo "Folder found."
		break
	else
		echo "Folder not found."
		echo "Try Again"
		(( attempt++ ))
        fi
done


	if [[ ${attempt} -gt ${count} ]]; then
		echo "You reached your max attempt ."
        exit
	fi
}

#Destination folder input
get_destination_folder(){

destination_back=''
local attempt_back=1
local count_back=3
while [[ ${attempt_back} -le ${count_back} ]]; do
        read -e -p "Enter the destination folder for backup:" destination_back
        if [[ -d "${destination_back}" ]]; then
            echo "Destination folder exists."
            return 0
        else 
            echo "Destination folde doesn't exist."
            echo "Try again."
        ((attempt_back++))
        fi
done 
if [[ ${attempt_back} -gt ${count_back} ]]; then
		echo "You reached your max attempt ."
        exit
	fi
}

#Backup summary
show_backup_summary(){
size=$(du -sh "${folder}" | awk '{print $1}')
files=$(find "${folder}" -type f | wc -l)   
dirs=$(find "${folder}" -type d | wc -l)
dirs=$((dirs - 1))

echo " Size of Backup Folder:${size}."
echo " Number of Files :${files}."
echo " Number of Directory :${dirs}."
}
#Creating backup
create_backup(){
read -p "Proceed with backup?(y/n)" confirm
    if [[ "${confirm}" == "y" ]]; then
        timestamp=$(date '+%Y-%m-%d_%H-%M-%S')
        folder_name=$(basename "${folder}")
        backup_file=${destination_back}/${folder_name}_${timestamp}.tar
        
        if tar -czf "${backup_file}"  "${folder}"; then
                echo "Backup Completed successfully."
        else
                echo "Error in backup exiting..."
                exit 1
        fi     
    else
        echo "Backup Cancelled."
        exit 0
    fi    
}
main_backup(){
        get_source_folder
        get_destination_folder
        show_backup_summary
        create_backup

}
 list_avl_backup(){
        get_destination_folder
        echo "Available backups in : ${destination_back}"
        backups=$(find "${destination_back}" -maxdepth 1 -type f \( -name "*.tar" \))
        if [[ -z "${backups}" ]]; then
                echo "No backups available."
        else
                echo "${backups}"
        fi
 }
# restore_backup(){}
# delete_backup(){}
# view_backup_log(){}