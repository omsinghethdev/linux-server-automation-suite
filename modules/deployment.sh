show_deployment_menu(){
        echo "--------------------"
        echo "   Deployment Menu. "
        echo "--------------------"
        echo "1.Deploy Application"
        echo "2.Start Application"
        echo "3.Stop Application"
        echo "4.Restart Application"
        echo "5.Check Deployment Status"
        echo "6.View Deployment Logs"
        echo "7.Backup to main menu"
}

get_valid_choice(){
        local attempt=0
        local maxattemp=3

        while ((attempt < maxattempt)); do
            read -r "Enter Your Choice:" choice
            if [[ -z "${choice}" ]]; then
                echo "Your Choice is Empty.Retry"
                ((attempt++))
            elif (( choice < 1 || choice > 7)); then
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

handle_choice(){
    local select_choice="$1"
    case  "${select_choice}" in
        1)deploy_appli ;;
        2)start_app ;;
        3)stop_app ;;
        4)restart_app ;;
        5)check_deploy_status ;;
        6)view_deploy_logs ;;
        7)return 1 ;;
        *)echo "Invalid Choice" ;;
    esac

}
get_valid_project_path(){
    path=''
    attempt=0
    maxattempt=3
    while ((attempt < maxattempt)); do
        read -p "Enter the Application path:" path 
        if [[ -d "${path}" ]]; then 
            echo "Application Directory exist."
                if [[ -f "${path}/Dockerfile" && -f "${path}/docker_compose.yml" ]]; then
                        echo "Both Dockerfile and Docker Compose YML exist"
                        return 0
                else 
                        echo "Dockerfile and Docker compose YML does'nt exist"
                        return 1
                fi
            
        else
            echo "Retry."
            ((attempt++))
        fi
    done
        if ((attempt == maxattempt)); then
                echo "Too many attempts.Exiting.."
                return 1
        fi
}

deploy_app(){

}

# stop_app(){

# }
# restart_app(){

# }
# check_deploy_status(){

# }
# view_deploy_logs(){

# }
main(){
    show_deployment_menu
    get_valid_choice
    handle_choice

}
main