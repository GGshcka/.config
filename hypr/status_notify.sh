#!/bin/bash

# Функция для вывода уведомления с яркостью
notify_brightness() {
    brightness=$(brightnessctl get)
    max_brightness=$(brightnessctl max)
    percent=$((brightness * 100 / max_brightness))
    notify-send -u normal -i /usr/share/icons/FontAwesomeSVGs/sun-solid.svg -r 9991 -t 1000 "Яркость:" "${percent}%"
}

notify_volume() {
    volume=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)
    if echo "${volume}" | grep -q "[MUTED]"; then
        notify-send -u normal -i /usr/share/icons/FontAwesomeSVGs/volume-xmark-solid.svg -r 9991 -t 1000 "Громкость:" "Заглушен"
    else
        volume_value=$(echo "$volume" | awk '{print $2}')
        percent=$(echo "$volume_value * 100" | bc -l)
        int_percent=$(printf "%.0f" "$percent")
        notify-send -u normal -i /usr/share/icons/FontAwesomeSVGs/volume-high-solid.svg -r 9991 -t 1000 "Громкость:" "${int_percent}%"
    fi
}

notify_microphone() {
    volume=$(wpctl get-volume @DEFAULT_SOURCE@)
    if echo "${volume}" | grep -q "[MUTED]"; then
        notify-send -u normal -i /usr/share/icons/FontAwesomeSVGs/microphone-slash-solid.svg -r 9991 -t 1000 "Громкость:" "Заглушен"
    else
        volume_value=$(echo "$volume" | awk '{print $2}')
        percent=$(echo "$volume_value * 100" | bc -l)
        int_percent=$(printf "%.0f" "$percent")
        notify-send -u normal -i /usr/share/icons/FontAwesomeSVGs/microphone-solid.svg -r 9991 -t 1000 "Громкость:" "${int_percent}%"
    fi
}

notify_airdrop() {
    status=$(systemctl is-active shairport-sync)
    if [ "$1" == "0" ]; then
        if [ "$status" == "active" ]; then
            systemctl stop shairport-sync
        else
            systemctl start shairport-sync
        fi
        status=$(systemctl is-active shairport-sync)
    fi

    case "$status" in 
        active)
            status="Запущен"
            ;;
        inactive)
            status="Остановлен"
            ;;
        *)
            ;;
    esac
    notify-send -u normal -i /usr/share/icons/FontAwesomeSVGs/podcast-solid.svg -r 9991 -t 1000 "AirPlay" "${status}"
}

notify_nbfc() {
    status=$(systemctl is-active nbfc_service)
    
    if [ "$1" == "0" ]; then
        if [ "$status" == "active" ]; then
            systemctl stop nbfc_service
        else
            systemctl start nbfc_service  
        fi
        status=$(systemctl is-active nbfc_service)
    fi
    
    case "$status" in 
        active)
            status="Запущен"
            ;;
        inactive)
            status="Остановлен"
            ;;
        *)
            ;;
    esac
    notify-send -u normal -i /usr/share/icons/FontAwesomeSVGs/podcast-solid.svg -r 9991 -t 1000 "GameMode (NBFC)" "${status}"
}

# Обработка аргументов командной строки
case "$1" in
    brightness.up)
        brightnessctl set 1%+
        notify_brightness
        ;;
    brightness.down)
        brightnessctl set 1%-
        notify_brightness
        ;;
    volume.up)
        wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%+
        wpctl set-mute @DEFAULT_AUDIO_SINK@ 0
        notify_volume
        ;;
    volume.down)
        wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%-
        wpctl set-mute @DEFAULT_AUDIO_SINK@ 0
        notify_volume
        ;;
    volume.mute)
        wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
        notify_volume
        ;;
    microphone.up)
        wpctl set-volume @DEFAULT_SOURCE@ 1%+
        wpctl set-mute @DEFAULT_SOURCE@ 0
        notify_microphone
        ;;
    microphone.down)
        wpctl set-volume @DEFAULT_SOURCE@ 1%-
        wpctl set-mute @DEFAULT_SOURCE@ 0
        notify_microphone
        ;;
    microphone.mute)
        wpctl set-mute @DEFAULT_SOURCE@ toggle
        notify_microphone
        ;;
    airdrop.toogle)
        notify_airdrop 0
        ;;
    airdrop.status)
        notify_airdrop 1
        ;;
    nbfc.toogle)
        notify_nbfc 0
        ;;
    nbfc.status)
        notify_nbfc 1
        ;;
    touchpad.on)
        notify-send -u normal -i /usr/share/icons/FontAwesomeSVGs/laptop-solid.svg -r 9991 -t 1000 "Touchpad" "Разблокирован"
        ;;
    touchpad.off)
        notify-send -u normal -i /usr/share/icons/FontAwesomeSVGs/laptop-solid.svg -r 9991 -t 1000 "Touchpad" "Заблокирован"
        ;;
    *)
        echo "Использование: $0 [up|down]"
        exit 1
        ;;
esac