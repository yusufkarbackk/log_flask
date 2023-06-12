#!/bin/bash

# Karakter token yang didapatkan dari BOT FATHER Telegram
TOKEN="6282401844:AAGiWIxqy4-3ixDWCD1CVS0cubOCB7fYPuE"
# ID Chat grup Telegram
ID_CHAT="-1001880819798"
# URL API Telegram
URL="https://api.telegram.org/bot6282401844:AAGiWIxqy4-3ixDWCD1CVS0cubOCB7fYPuE/sendMessage?parse_mode=HTML"

# Path Log File
log_file=/home/mylinux/pertemuan13/cpu_usage.log
# Timestamp untuk menjunjukan waktu secara real time
timestamp=$(date "+%Y-%m-%d %H:%M:%S")

# Penggunaan CPU
cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')

# Menampilkan pada terminal penggunaan CPU
echo "Pengunaan anda $cpu_usage%"
# Memasukan keluaran pengunaan CPU lalu memasukannya kedalam file Log
echo "Waktu: $timestamp,Pengunaan CPU: $cpu_usage%"

# Pengkondisian apabila pengunaan CPU > 25% maka akan memberikan notifikasi
if (( $(echo "$cpu_usage > 3.0" | bc -l) ));then
echo "cpu overload"
# Mengirim notifikasi ke Telegram
curl -s -o /dev/null --data chat_id=$ID_CHAT --data-urlencode "text=[$timestamp] Penggunaan CPU Anda Sudah Mencapai $cpu_usage% !" "$URL"
fi
