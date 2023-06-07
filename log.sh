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
}

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


# Membuat beberapa permintaan HTTP ke aplikasi Flask sebagai contoh
make_request "$APP_URL" "GET"
make_request_404 "$APP_URL_404" "GET"
