"""Lee un SVG 2D exportado por OpenSCAD y lo rasteriza en coordenadas mm.

OpenSCAD exporta la geometria 2D como poligonos (solo M/L/z, sin curvas) y con
el eje y hacia abajo, asi que  y_openscad = -y_svg.

Los agujeros salen como subtrazos propios y aqui se pintan TODOS rellenos, a
proposito y no por vaguera: asi la contraforma de una letra es material, y
tools/pinceladas.py no puede proponer una union dentro del ojo de la 'b' o de
la 'P' porque ahi no ve ningun hueco. Para contar trozos rellenarlos da igual.

Ojo si alguna vez hace falta el relleno par-impar de verdad (XOR por subtrazo):
no sirve como red de seguridad, porque en la Allura casi ninguna contraforma es
un agujero cerrado; comunican con el exterior por el cruce de los trazos.
"""
import re

import numpy as np
from PIL import Image, ImageDraw

PPMM = 16          # pixeles por mm: 0,0625 mm de resolucion
MARGEN = 2.0       # mm de aire alrededor, para que nada toque el borde


def subtrazos(ruta):
    """Lista de poligonos [(x_svg, y_svg), ...] del SVG."""
    svg = open(ruta).read()
    out = []
    for d in re.findall(r'd="(.*?)"', svg, re.S):
        for sub in d.split('M')[1:]:
            pts = [tuple(map(float, p.split(',')))
                   for p in re.findall(r'(-?[\d.]+,-?[\d.]+)', sub)]
            if len(pts) >= 3:
                out.append(pts)
    if not out:
        raise SystemExit(f"{ruta}: no hay geometria 2D "
                         "(¿exportaste con -D 'vista=\"2d\"' o \"letras\"?)")
    return out


class Raster:
    """Mascara booleana del dibujo, con la conversion pixel <-> mm."""

    def __init__(self, ruta):
        polis = subtrazos(ruta)
        xs = [p[0] for s in polis for p in s]
        ys = [p[1] for s in polis for p in s]
        self.x0, self.y0 = min(xs) - MARGEN, min(ys) - MARGEN
        w = int((max(xs) + MARGEN - self.x0) * PPMM)
        h = int((max(ys) + MARGEN - self.y0) * PPMM)
        img = Image.new('L', (w, h), 0)
        dib = ImageDraw.Draw(img)
        for s in polis:
            dib.polygon([self.px(x, y) for x, y in s], fill=255)
        self.mask = np.array(img) > 128

    def px(self, x_svg, y_svg):
        return ((x_svg - self.x0) * PPMM, (y_svg - self.y0) * PPMM)

    def mm(self, fila, col):
        """Pixel -> mm en el sistema de OpenSCAD (y hacia arriba)."""
        return (self.x0 + col / PPMM, -(self.y0 + fila / PPMM))
