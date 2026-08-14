#!/usr/bin/env python3
"""Cuenta en cuantos trozos sueltos queda un topper. Tiene que salir 1.

    openscad -D 'vista="2d"' -o /tmp/capa.svg parabens.scad
    python3 tools/piezas.py /tmp/capa.svg
    python3 tools/piezas.py /tmp/capa.svg --sonda 27,28,29

La pieza 1 es el cuerpo; cualquier otra es lo que se cae al despegar la pieza
de la cama y necesita pincelada (ver topper-lib.scad). '--sonda x,x,x' lista,
para esas columnas, los tramos de material en y: sirve para ver que hueco hay
debajo de una tilde suelta y hasta donde tiene que llegar el trazo.
"""
import sys

import numpy as np
from scipy import ndimage

from svg2mm import PPMM, Raster


# mm2: por debajo de esto no es una pieza, es un pelo de rasterizado donde dos
# trazos se rozan de canto. Lo suelto de verdad (una tilde) pasa de 2 mm2.
MOTA = 0.2


def piezas(r):
    etiq, n = ndimage.label(r.mask)
    cortes = ndimage.find_objects(etiq)
    areas = [(etiq[c] == i).sum() / PPMM ** 2 for i, c in enumerate(cortes, 1)]
    motas = sum(1 for a in areas if a < MOTA)
    print(f"PIEZAS = {n - motas}" +
          (f"   ({motas} motas de <{MOTA} mm2 ignoradas)" if motas else ""))
    for i, corte in enumerate(cortes, 1):
        area = areas[i - 1]
        if area < MOTA:
            continue
        x0, y1 = r.mm(corte[0].start, corte[1].start)
        x1, y0 = r.mm(corte[0].stop, corte[1].stop)
        print(f"  pieza {i}: area={area:8.1f} mm2  "
              f"x=[{x0:7.2f},{x1:7.2f}]  y=[{y0:7.2f},{y1:7.2f}]  "
              f"centro=({(x0 + x1) / 2:7.2f},{(y0 + y1) / 2:7.2f})")
    return n - motas


def sonda(r, columnas):
    print("\ntramos de material en y (mm):")
    for xq in columnas:
        col = int((xq - r.x0) * PPMM)
        if not 0 <= col < r.mask.shape[1]:
            print(f"  x={xq:7.2f} : fuera del dibujo")
            continue
        v = r.mask[:, col]
        bordes = np.flatnonzero(np.diff(np.r_[False, v, False]))
        tramos = sorted((r.mm(b, col)[1], r.mm(a, col)[1])
                        for a, b in zip(bordes[::2], bordes[1::2]))
        print(f"  x={xq:7.2f} : " +
              "  ".join(f"[{lo:6.2f},{hi:6.2f}]" for lo, hi in tramos))


if __name__ == '__main__':
    if len(sys.argv) < 2:
        raise SystemExit(__doc__)
    r = Raster(sys.argv[1])
    n = piezas(r)
    if '--sonda' in sys.argv:
        sonda(r, [float(v) for v in
                  sys.argv[sys.argv.index('--sonda') + 1].split(',')])
    sys.exit(0 if n == 1 else 1)
