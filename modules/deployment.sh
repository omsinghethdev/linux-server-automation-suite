show_deployment_menu(){
        echo "--------------------"
        echo "   Deployment Menu. "
        echo "--------------------"
        echo "1.Deploy Application"
        echo "2.Start Application"
        echo "3.Stop Application"
        echo "4.Restart Application"
        echo "5.Check Deployment Status"
        echo "6.Backup to main menu"
}

get_valid_choice(){
        local attempt=0
        local maxattempt=3
        local choice

        while ((attempt < maxattempt)); do
            read -rp "Enter Your Choice:" choice
            if [[ -z "${choice}" ]]; then
                echo "Your Choice is Empty.Retry"
                ((attempt++))
            elif (( choice < 1 || choice > 7)); then
                        echo "Choice must be between 1 and 7"
                        ((attempt++))
                else
                        echo "Valid Choice."
                        return 0
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
        1)deploy_app ;;
        2)start_app ;;
        3)stop_app ;;
        4)restart_app ;;
        5)check_deploy_status ;;
        6)return 1 ;;
        *)echo "Invalid Choice" ;;
    esac

}
get_valid_project_path(){
    local path=''
    local attempt=0
    local maxattempt=3
    while ((attempt < maxattempt)); do
        read -p "Enter the Application path:" path 
        if [[ -d "${path}" ]]; then 
            echo "Application Directory exist." >&2
                if [[ -f "${path}/Dockerfile" && -f "${path}/docker-compose.yml" ]]; then
                        echo "Both Dockerfile and Docker Compose YML exist" >&2
                        echo "${path}"
                        return 0
                else 
                        echo "Dockerfile and Docker compose YML does'nt exist" >&2
                        return 1
                fi
            
        else
            echo "Retry." >&2
            ((attempt++))
        fi
    done
        if ((attempt == maxattempt)); then
                echo "Too many attempts.Exiting.." >&2
                return 1
        fi
}

deploy_app(){
    local project_path 
    project_path=$(get_valid_project_path) || return 1
    cd "${project_path}" || return 1
    docker compose up -d --build

    
}

 stop_app(){
    local project_path
    project_path=$(get_valid_project_path) || return 1
    cd "${project_path}" || return 1 
    if docker compose down ; then
        echo "Stopped Application successfully."
    else
        echo "Error in Stopping application."
    fi

 }
 restart_app(){
    local project_path
    project_path=$(get_valid_project_path) || return 1
    cd "${project_path}" || return 1

    echo "Deployment statues:"
    docker compose ps


 }
 check_deploy_status(){
    locat project_path
    project_path=$(get_valid_project_path) || return 1
    cd "${project_path}" || return 1
    echo "Deployment status:"
    docker compose ps
    read -p "Restart this application? (yes/no): " confirm
    if [[ "${confirm}" == "yes"]]; then
        if docker compose restart ; then
            echo "Application restarted successfully."
        else
            echo "Error in Restarting Application."
            return 1
        fi
    else
        echo "Restart cancelled."
    fi

 }
# view_deploy_logs(){

# }
main(){
    show_deployment_menu
    
    choice=$(get_valid_choice) || return 1
    handle_choice "${choice}"

}
main