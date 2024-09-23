#############____Binary__________
##		save as a executable on any bin directory eg . ~/bin/powermenu
 
#!/bin/env bash
 
# Options for powermenu
lock=""
#logout=""
shutdown=""
reboot=""
sleep=""
 
# Get answer from user via rofi
selected_option=$(echo "$shutdown
$reboot
$sleep
$lock" | rofi -dmenu\
                  -i\
                  -p "Power"\
		  -theme "~/.config/rofi/powermenu.rasi")
# Do something based on selected option
if [ "$selected_option" == "$lock" ]
then
    hyprlock
elif [ "$selected_option" == "$shutdown" ]
then
    systemctl poweroff
elif [ "$selected_option" == "$reboot" ]
then
    systemctl reboot
elif [ "$selected_option" == "$sleep" ]
then
    systemctl sleep
    hyprlock
else
    echo "Ничего не выбрано..."
fi
 
 
 
 
 
