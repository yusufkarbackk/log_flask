#!/bin/bash

# URL aplikasi Flask yang akan dicatat log
APP_URL="http://localhost:5000"

APP_URL_404="http://localhost:5000/hai"

# Nama file log
LOG_FILE="flask.log"

# Fungsi untuk mencatat log
function log_flask() {
  local timestamp=$(date +"%Y-%m-%d %T")
  local message=$1
  echo "[$timestamp] $message" >> "$LOG_FILE"

  curl -s -o /dev/null --data chat_id="-1001880819798" --data-urlencode "text=[$timestamp] $message" >> "$LOG_FILE" "https://api.telegram.org/bot6282401844:AAGiWIxqy4-3ixDWCD1CVS0cubOCB7fYPuE/sendMessage?parse_mode=HTML"
}

# function cek_cpu(){
#   threshold=80

# # Get the CPU usage percentage using the top command and extract the value
# cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')

# # Compare the CPU usage to the threshold
# if (( $(echo "$cpu_usage > $threshold" | bc -l) )); then
#   echo "CPU usage is above the threshold of $threshold%"
# else
#   echo "CPU usage is below the threshold of $threshold%"
# fi

# log_flask $cpu_usage

# }

function cek_localhost() {
  local url=$1
  local method=$2
  local response=$(curl -s -o /dev/null -w "%{http_code}" "$APP_URL")

  if [[ $response -eq 200 ]]; then
        echo "Aplikasi Flask sudah menyala di $APP_URL"
  else
        echo "starting flask..."
        python3 main.py
        echo "flask started"
  fi

  log_flask "[$method] $url $response"
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

# cek_cpu

# Membuat beberapa permintaan HTTP ke aplikasi Flask sebagai contoh
make_request "$APP_URL" "GET"
make_request_404 "$APP_URL_404" "GET"

