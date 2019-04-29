#!/bin/bash

user="jenkins"
passwd="espnstar@206"

useradd $name
echo $passwd | passwd $name --stdin $>/null
