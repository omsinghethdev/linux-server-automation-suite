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
