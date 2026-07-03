clear_screen(){
    clear
}
pause_screen(){
    read -p "Press Enter to continue..."
}
show_monitoring_menu(){
        echo "--------------------"
        echo "   Monitoring Menu  "
        echo "--------------------"
        echo "1.Show CPU Usage"
        echo "2.Show Memory Usage"
        echo "3.Show Disk Usage"
        echo "4.Show Open Ports Machine"
        echo "5.Show Running Services"
        echo "6.Backup to main menu"
}

get_valid_monitoring_choice(){
        local attempt=0
        local maxattempt=3
        local monitoring_choice

        while ((attempt < maxattempt)); do
            read  -e -p "Enter Your Choice:" monitoring_choice
            if [[ -z "${monitoring_choice}" ]]; then
                echo "Your Choice is Empty.Retry" >&2
                ((attempt++))
            elif (( monitoring_choice < 1 || monitoring_choice > 6)); then
                        echo "Choice must be from 1 to 6" >&2
                        ((attempt++))
                else
                        echo "Valid Choice." >&2
                        echo "${monitoring_choice}"
                        break
                fi
                echo "Attempt left :$((maxattempt - attempt))"
        done

            if ((attempt == maxattempt)); then
                        echo "To many invalid attempt.Exiting..." >&2
                        return 1
            fi

}

handle_monitoring_choice(){
    local select_choice="$1"
    case  "${select_choice}" in
        1)show_cpu_usage
          pause_screen
          ;;
        2)show_memory_usage
          pause_screen
          ;;
        3)show_disk_usage
          pause_screen
          ;;
        4)show_open_ports
          pause_screen
          ;;
        5)show_running_services
          pause_screen
          ;;
        6)return 1
          pause_screen;;
        *)echo "Invalid Choice" ;;
    esac

}

get_cpu_usage(){
    top -bn1 |grep "Cpu(s)" | awk  '{
        for (i=1 ; i <= NF ; i++) {
            if ($i ~ /id/)
                print 100-$(i-1)
        }
    
    }'
    

}
show_cpu_usage(){
    local cpu_usage
    cpu_usage=$(get_cpu_usage)
    echo "CPU Usage: ${cpu_usage}%"
}
get_memory_usage(){
    free -m | awk '/^Mem:/{
        total=$2
        used=$3
        available=$7
        usage=(used/total)*100
        printf "{\"total\": \"%sMB\", \"used\": \"%sMB\", \"available\": \"%sMB\", \"usage_percent\": \"%.2f\" }\n",total,used,available,usage  
    }'
}
show_memory_usage(){
    local memory_data
    memory_data=$(get_memory_usage)
    echo "==================="
    echo "   Memory INFO     "
    echo "==================="
    echo "Total Memory :$(echo "${memory_data}" | jq -r '.total')"
    echo "Used Memory :$(echo "${memory_data}" | jq -r '.used')"
    echo "Available Memory :$(echo "${memory_data}" | jq -r '.available')"
    echo "Usage Memory :$(echo "${memory_data}" | jq -r '.usage_percent')%"
    

}
get_disk_usage(){
    df -h 
}
show_disk_usage(){

}
show_open_ports(){

}
show_running_services(){

}


get_valid_monitoring_choice(){
        local attempt=0
        local maxattempt=3
        local monitoring_choice

        while ((attempt < maxattempt)); do
            read  -e -p "Enter Your Choice:" monitoring_choice
            if [[ -z "${monitoring_choice}" ]]; then
                echo "Your Choice is Empty.Retry" >&2
                ((attempt++))
            elif (( monitoring_choice < 1 || monitoring_choice > 6)); then
                        echo "Choice must be from 1 to 6" >&2
                        ((attempt++))
                else
                        echo "Valid Choice." >&2
                        echo "${monitoring_choice}"
                        break
                fi
                echo "Attempt left :$((maxattempt - attempt))"
        done

            if ((attempt == maxattempt)); then
                        echo "To many invalid attempt.Exiting..." >&2
                        return 1
            fi

}



while true ; do
    clear_screen
    show_monitoring_menu
    get_valid_monitoring_choice
    handle_monitoring_choice "${monitoring_choice}"
    if (( $? == 1 )); then
        break
    fi
done