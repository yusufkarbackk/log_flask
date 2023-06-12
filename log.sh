#!/bin/bash

# URL aplikasi Flask yang akan dicatat log
APP_URL="http://localhost:5000"

APP_URL_404="http://localhost:5000/hai"

telegram_url="https://api.telegram.org/bot6282401844:AAGiWIxqy4-3ixDWCD1CVS0cubOCB7fYPuE/sendMessage?parse_mode=HTML"

chat_id="-1001880819798"


# Nama file log
LOG_FILE="flask.log"

# Fungsi untuk mencatat log
function log_flask() {
    local timestamp=$(date +"%Y-%m-%d %T")
    local message=$1
    echo "[$timestamp] $message" >> "$LOG_FILE"
    
    curl -s -o /dev/null --data chat_id=$chat_id --data-urlencode "text=[$timestamp] $message" "$telegram_url"
}

function cek_cpu(){
    # Penggunaan CP
    . cpu_usage_run.sh
}

function cek_localhost() {
    local url=$1
    local method=$2
    #local response=$(curl -s -o /dev/null -w "%{http_code}" "$APP_URL")
    
    SERVICE_NAME=$(ps aux | awk '{print $12}' | grep -m 1 "main.py")
    
    if [ "$SERVICE_NAME" == "main.py" ]; then
        echo "$(date): Service $SERVICE_NAME is running."
      	curl -s -o /dev/null --data chat_id=$chat_id --data-urlencode "text=Flask is running" "$telegram_url"
       	make_request "$APP_URL" "GET"
       	make_request_404 "$APP_URL_404" "GET"	
    else
        echo "$(date): Service $SERVICE_NAME is not running."
	curl -s -o /dev/null --data chat_id=$chat_id --data-urlencode "text=Flask is down" "$telegram_url"
        
    fi
    
    
    #log_flask "[$method] $url $response"
}


# Membuat permintaan HTTP ke aplikasi Flask dan mencatat responsnya ke log
function make_request() {
    local url=$1
    local method=$2
    local response=$(curl -s -X $method $url)
    log_flask "[$method] $url $response"
}

function make_request_404() {
    local url=$1
    local method=$2
    response=$(curl -s -o /dev/null -w "%{http_code}" "$url")
    if [[ $response -eq 404 ]]; then
        log_flask "[$method] $url $response"
    fi
}

#cek apakah localhost sudah nyala
cek_localhost "$APP_URL" "GET"

cek_cpu

