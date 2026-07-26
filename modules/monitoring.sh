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
     df -h --output=source,size,avail,pcent,target | awk ' 
     BEGIN {
        print "["
        first = 1    
     }
     NR > 1 {
        if (first == 0){
           print ","
        }

        printf "{\"filesystem\":\"%s\" , \"total\":\"%s\" , \"free\":\"%s\" , \"use_percent\":\"%s\", \"mounted_on\":\"%s\"}" , $1 ,$2 , $3, $4, $5

        first = 0
        }

     END {
       print "]"
         }'
 }
 show_disk_usage(){ 
    local disk_json
    disk_json=$(get_disk_usage)

    printf "\n"
    printf "===========================================\n"
    printf "        Disk Usage Dashboard\n"
    printf "===========================================\n\n"

    printf "%-20s %-10s %-10s %-10s %-15s\n" \
        "Disk Name" "Total" "Free" "Use%" "Mounted On"
    printf "%-20s %-10s %-10s %-10s %-15s\n" \
        "----------" "-----" "------" "------" "-----------------"

    echo "${disk_json}" |
    jq -r '.[]   |
        [
            .filesystem,
            .total,
            .free,
            .use_percent,
            .mounted_on
        
        
        ] |
        @tsv' |

    while IFS=$'\t' read -r filesystem total free use_percent mounted_on
    do
        printf "%-20s %-10s %-10s %-10s %-15s\n" \
            "$filesystem" \
            "$total" \
            "$free" \
            "$use_percent" \
            "$mounted_on"
    done


    
}
get_open_ports(){
    ss -tunlp | awk '
        BEGIN {
            print "["
            first=1
        }
        NR > 1 {
            if (first == 0)
                print ","
            printf "{\"netid\":\"%s\" , \"state\":\"%s\" , \"localadd\":\"%s\" , \"port\":\"%s\", \"process\":\"%s\"}" ,$1, $2, $5, $6, $7
            


            first=0
        }
        END {
            print "]"
        } 
    
    '

}
 show_open_ports(){
        local port_json
        port_json=$(get_open_ports)
        printf "\n"
        printf "======================================\n"
        printf "           Open Ports Status\n"
        printf "======================================\n\n"

        printf "%-10s %-10s %-15s %-10s %-15s\n"\
        "Protocol" "State" "Address" "Port" "Process"
        printf "%-10s %-10s %-15s %-10s %-15s\n"\
        

        echo "${port_json}" |

        jq -r ' .[] |

          [ .netid,
            .state,
            .localadd,
            .port,
            .process
        
          ] |
          @tsv' |

        while IFS=$'\t' read -r protocol state address port process
        do
            printf "%-10s %-10s %-15s %-10s %-15s\n" \
                "$protocol"\
                "$state"\
                "$address"\
                "$port"\
                "$process"\

        done


        
        

 }
# show_running_services(){

# }



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




while true ; do
    clear_screen
    show_monitoring_menu
    get_valid_monitoring_choice
    clear_screen
    handle_monitoring_choice "${monitoring_choice}"
    if (( $? == 1 )); then
        break
    fi
done