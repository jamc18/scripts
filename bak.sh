#!/bin/bash

function ctrl_c(){
  echo -e "\n\nExit.....\n"
  exit 1
}

#ctrl+c
trap ctrl_c INT

#Variables globales
inicio=/home/$USER/Documentos
destino=/home/$USER/bak
 
for file in $(find $inicio -printf "%P\n"); do
  if [ -a $destino/$file ]; then
    if [ $inicio/$file -nt $destino/$file ]; then
      echo " Nuevo archivo detectado, guardando...."
      cp -r $inicio/$file $destino/$file
    else
      echo" El $file existe ,skipping. "
    fi
  else
    echo "$file se esta copiendo en $destino"
    cp -r $inicio/$file $destino/$file

  fi
