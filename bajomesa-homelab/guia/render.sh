#!/bin/bash
# Regenera los renders de la guia.
#   --camera = cx,cy,cz,rotx,roty,rotz,distancia   (SIN espacios: no los parsea)
cd "$(dirname "$0")/.."
# Cada paso: render + version optimizada (recortada, 1100 px, 64 colores),
# que es la que build.py empotra como data URI en el HTML.
r() { openscad -o "guia/img/paso$1.png" --imgsize=1600,1050 --colorscheme=Tomorrow \
        --camera="$2" -D paso=$1 guia.scad 2>&1 | grep -iE "^ERROR"
      magick "guia/img/paso$1.png" -trim +repage -resize 1100x -colors 64 -strip \
        "guia/img/opt-paso$1.png"; return 0; }
r 1  "250,0,79,66,0,20,430"
r 2  "230,100,80,62,0,25,1150"
r 3  "230,60,60,60,0,25,1450"
r 4  "10,8,82,100,0,270,150"
r 5  "230,60,60,60,0,25,1450"
r 6  "120,100,45,62,0,25,1600"
r 7  "0,100,62,64,0,25,700"
r 8  "230,20,55,58,0,25,1450"
r 9  "230,40,45,60,0,25,1400"
r 10 "230,45,45,0,0,0,1250"
