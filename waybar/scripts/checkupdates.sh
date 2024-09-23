#!/bin/bash

# Получаем количество обновлений
updates_count=$(checkupdates | wc -l)

# Форматируем вывод для tooltip
tooltip_output=$(checkupdates)

# Возвращаем JSON-вывод для Waybar
echo "{\"text\":\"$updates_count\", \"tooltip\":\"$tooltip_output\"}"