#!/bin/bash

read -p "Do you want active Py(Y/N):" PY 
read -p "Please input PY version:" PV
while :; do
	[ "$PY" == "y" ] || [ "$PY" == P"Y" ] && {
		pyenv activate ${PV}-env
		continue
	}
	[ "$PY" == "N" ] || [ "$PY" == "n" ] && {
		break
	}
	read -p "I don\'t now you input !"
done
