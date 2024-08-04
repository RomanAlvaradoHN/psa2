#!/bin/bash

directorio="$HOME/psa2/cronlogs"

hora=$(date +"%H%M%S")

echo "Creando directorio Log$hora"

mkdir "$directorio/Log$hora"
