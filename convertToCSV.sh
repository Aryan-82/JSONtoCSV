#!/bin/bash

read -p "Enter the starting date for your logs: " start
read -p "Enter the ending date for your logs: " end

fields=".user_id, .display_name, .mobile, .email"

json_to_csv() {
    local input_file="$1"
    local csv_file="$2"
    jq -r "[$fields] | @csv" "$input_file" >> "$csv_file"
}

for file in ./whale*
do
    cur_date=$(echo $file | cut -d "_" -f 4)
    output_file="output_${cur_date}.csv"
    date=$(echo $cur_date | cut -d "-" -f 2)
    
    if [ ${date} -le ${end} -a $date -ge $start ]; then
        echo "userId,displayName,mobile,email" > "$output_file"
        json_to_csv "$file" "$output_file"
    fi

done
echo "Conversion done !"