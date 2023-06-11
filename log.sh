#!/bin/bash

# URL aplikasi Flask yang akan dicatat log
APP_URL="http://localhost:5000"

APP_URL_404="http://localhost:5000/hai"

telegram_url = "https://api.telegram.org/bot6282401844:AAGiWIxqy4-3ixDWCD1CVS0cubOCB7fYPuE/sendMessage?parse_mode=HTML"

chat_id = "-1001880819798"


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
    # Penggunaan CPU
    cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')
    
    # Menampilkan pada terminal penggunaan CPU
    echo "Pengunaan anda $cpu_usage%"
    # Memasukan keluaran pengunaan CPU lalu memasukannya kedalam file Log
    echo "Waktu: $timestamp,Pengunaan CPU: $cpu_usage%" >> "$log_file"
    
    # Pengkondisian apabila pengunaan CPU > 25% maka akan memberikan notifikasi
    if [ "$cpu_usage" -ge "25" ];then
        # Mengirim notifikasi ke Telegram
        curl -s -X POST "$URL" -d "chat_id=$ID_CHAT" -d "text=[$timestamp] Penggunaan CPU Anda Sudah Mencapai $cpu_usage% !"
    fi
}

function cek_localhost() {
    local url=$1
    local method=$2
    #local response=$(curl -s -o /dev/null -w "%{http_code}" "$APP_URL")
    
    SERVICE_NAME='main.py'
    
    if ps aux | awk '{print $12}' >/dev/null | grep -q "main.py"; then
        echo "$(date): Service $SERVICE_NAME is running."
        curl -s -o /dev/null --data chat_id="-1001880819798" --data-urlencode "$(date): Service $SERVICE_NAME is running." "https://api.telegram.org/bot6282401844:AAGiWIxqy4-3ixDWCD1CVS0cubOCB7fYPuE/sendMessage?parse_mode=HTML"
        
    else
        echo "$(date): Service $SERVICE_NAME is not running."
        curl -s -o /dev/null --data chat_id="-1001880819798" --data-urlencode "$(date): Service $SERVICE_NAME is not running." "https://api.telegram.org/bot6282401844:AAGiWIxqy4-3ixDWCD1CVS0cubOCB7fYPuE/sendMessage?parse_mode=HTML"
        
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

# Membuat beberapa permintaan HTTP ke aplikasi Flask sebagai contoh
make_request "$APP_URL" "GET"
make_request_404 "$APP_URL_404" "GET"

