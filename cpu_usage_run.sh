#!/bin/bash

# Karakter token yang didapatkan dari BOT FATHER Telegram
TOKEN="6282401844:AAGiWIxqy4-3ixDWCD1CVS0cubOCB7fYPuE"
# ID Chat grup Telegram
ID_CHAT="-1001880819798"
# URL API Telegram
URL="https://api.telegram.org/bot$TOKEN/sendMessage"

# Path Log File
log_file=/home/mylinux/pertemuan13/cpu_usage.log
# Timestamp untuk menjunjukan waktu secara real time
timestamp=$(date "+%Y-%m-%d %H:%M:%S")

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
