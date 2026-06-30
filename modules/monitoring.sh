show_cpu_usage(){
    local cpu_usage=$(top -bn1 |grep "Cpu(s)" | awk  '{
        for (i=1 ; i <= NH ; i++) {
            if ($i ~ /id/)
                print 100-$(i-1)
        }
    
    }')
    
    echo "CPU USAGE: ${cpu_usage}%"

}
show_memory_usage(){

}
show_memory_usage(){

}
show_disk_usage(){

}
show_open_ports(){

}
show_running_services(){

}
