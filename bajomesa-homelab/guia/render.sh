#!/bin/bash
# Regenera los renders de la guia.
#   --camera = cx,cy,cz,rotx,roty,rotz,distancia   (SIN espacios: no los parsea)
cd "$(dirname "$0")/.."
r() { openscad -o "guia/img/paso$1.png" --imgsize=1600,1050 --colorscheme=Tomorrow \
        --camera="$2" -D paso=$1 guia.scad 2>&1 | grep -iE "^ERROR"; return 0; }
r 1  "300,0,80,68,0,20,620"
r 2  "230,100,80,62,0,25,1150"
r 3  "230,60,60,60,0,25,1450"
r 4  "50,29,80,72,0,35,260"
r 5  "230,60,60,60,0,25,1450"
r 6  "120,100,45,62,0,25,1600"
r 7  "-5,100,55,64,0,35,520"
r 8  "230,20,55,58,0,25,1450"
r 9  "230,40,45,60,0,25,1400"
r 10 "230,45,45,0,0,0,1250"
