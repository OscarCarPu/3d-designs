#!/usr/bin/env python3
"""Propone las pinceladas de una palabra. Son una PROPUESTA, se curan a mano.

    openscad -D 'vista="letras"' -o /tmp/letras.svg parabens.scad
    python3 tools/pinceladas.py /tmp/letras.svg [--r 1.4] [--grosor 1.2]

Mira las letras solas, ve en cuantos trozos que no se tocan quedan y saca tres
listas:

  IMPRESCINDIBLES  Los trozos que cuelgan, o sea los que no bajan hasta la
                   barra: las tildes y el punto de la 'i'. Sin su pincelada se
                   quedan sueltos en los 4 mm de grosor, aguantados solo por
                   los 0,9 mm de la placa de detras, y se rompen con nada.

  RIGIDEZ (trozos) Trozos que no se tocan entre ellos pero que SI llegan a la
                   barra, asi que ya estan cosidos por el pie. Su pincelada
                   solo sirve para que no bailen. Se pueden quitar, y conviene
                   quitarlas si quedan feas: son las mas largas y las que mas
                   se ven.

  RIGIDEZ (huecos) Huecos ABIERTOS mas estrechos que 2*r entre letras que ya se
                   tocan de canto, cruzados por lo mas angosto. Solo huecos
                   abiertos: los ojos cerrados de la 'b', la 'e' o la 'P' se
                   descartan aqui mismo, que es lo que hacia mal el cierre
                   automatico que habia antes.

Las de rigidez hay que MIRARLAS y quitar las que sobren: un hueco abierto
tambien puede ser la abertura de la propia letra (la boca de la 'e', la panza
de la 'a') o el cruce de dos trazos de la misma letra, y taparlo ensucia igual.
Revisa con vista="cotas" antes de dar una palabra por buena, y luego comprueba
con tools/piezas.py que sale una pieza.
"""
import sys

import numpy as np
from scipy import ndimage
from scipy.spatial import KDTree

from svg2mm import PPMM, Raster

SOLAPE = 0.3     # mm que se mete el trazo dentro de cada letra
GROSOR = 1.2     # mm de ancho del trazo
LARGO_MAX = 4.0  # mm: un trazo mas largo es un costuron, mejor decidirlo a ojo
AREA_MIN = 0.15  # mm2: por debajo de esto el hueco es ruido de rasterizado
Y_BARRA = 0.5    # borde superior de la barra (barra_solape en topper-lib.scad):
                 # lo que baja de aqui ya lo cose la barra y no cuelga

# Remache: 'r' tiene que pasar de la mitad del hueco para cerrarlo, y un pelo
# mas para que el filete tenga cuerpo. 'ZONA' va holgada a proposito: si aprieta,
# el disco corta el filete a media merma y deja un canto recto que se ve.
R_MIN = 0.6
ZONA = 3.2
HUECO_MAX_REMACHE = 2.0   # por encima de esto el cierre necesario es tan gordo
                          # que no hay filete que salve el hueco: trazo recto
R_REVISAR = 1.1           # de aqui para arriba el cierre empieza a comerse el
                          # blanco de alrededor y hay que mirarlo: con r=1.28 en
                          # un hueco de 2 mm relleno entero el blanco entre la
                          # 'é' y la 'n', y con r=1.17 en uno de 1,84 quedo bien.
                          # Depende de cuanto blanco haya al lado, no del hueco


def medidas_remache(hueco):
    return ZONA, round(max(R_MIN, hueco / 2 + 0.25), 2)


def contorno_mm(r, m):
    """Puntos (x, y) en mm del borde de una mascara."""
    filas, cols = np.nonzero(m & ~ndimage.binary_erosion(m))
    return np.array([r.mm(f, c) for f, c in zip(filas, cols)])


def mas_cerca(a, b):
    """Los dos puntos mas cercanos entre dos nubes, y su distancia."""
    d, j = KDTree(b).query(a)
    i = int(np.argmin(d))
    return a[i], b[int(j[i])], float(d[i])


def trozos(r, mask):
    etiq, n = ndimage.label(mask)
    return [contorno_mm(r, etiq == i) for i in range(1, n + 1)]


def coser(piezas):
    """Prim: n-1 trazos que unen todas las piezas por sus huecos mas estrechos.

    Reparte en dos: los que atan un trozo que CUELGA (no baja hasta la barra,
    asi que sin pincelada se queda suelto) y los que solo dan rigidez, porque
    los dos trozos que unen ya llegan a la barra.
    """
    cuelga = [p[:, 1].min() > Y_BARRA for p in piezas]
    dentro, hay_que, rigidez = {0}, [], []
    while len(dentro) < len(piezas):
        mejor = None
        for i in dentro:
            for j in range(len(piezas)):
                if j not in dentro:
                    pa, pb, d = mas_cerca(piezas[i], piezas[j])
                    if mejor is None or d < mejor[2]:
                        mejor = (pa, pb, d, i, j)
        pa, pb, d, i, j = mejor
        dentro.add(j)
        (hay_que if cuelga[i] or cuelga[j] else rigidez).append((pa, pb, d))
    return hay_que, rigidez


def dilata(m, r_px):
    """Dilatacion euclidea por distancia: exacta y rapida para radios grandes."""
    return ndimage.distance_transform_edt(~m) <= r_px


def huecos_abiertos(r, mask, r_mm):
    """Trazos que cruzan cada hueco abierto mas estrecho que 2*r_mm."""
    r_px = r_mm * PPMM
    cierre = ~dilata(~dilata(mask, r_px), r_px)     # cierre morfologico
    fondo, _ = ndimage.label(~mask)
    abierto = fondo == fondo[0, 0]                  # lo que comunica con fuera
    etiq, n = ndimage.label(cierre & ~mask & abierto)

    trazos = []
    for i in range(1, n + 1):
        hueco = etiq == i
        if hueco.sum() / PPMM ** 2 < AREA_MIN:
            continue
        orillas, k = ndimage.label(dilata(hueco, 2) & mask)
        if k < 2:                                   # grieta ciega: nada que unir
            continue
        areas = ndimage.sum(orillas > 0, orillas, range(1, k + 1))
        a, b = np.argsort(areas)[::-1][:2] + 1
        pa, pb, d = mas_cerca(contorno_mm(r, orillas == a),
                              contorno_mm(r, orillas == b))
        if d > LARGO_MAX:
            continue
        trazos.append((pa, pb, d))
    return trazos


def sin_repetir(trazos, ya):
    """Quita las candidatas que caen donde ya hay una obligatoria."""
    puntos = [(np.array(pa) + np.array(pb)) / 2 for pa, pb, _ in ya]
    return [t for t in trazos
            if not any(np.linalg.norm((np.array(t[0]) + np.array(t[1])) / 2 - p)
                       < 1.0 for p in puntos)]


def alargar(pa, pb):
    """Mete el trazo SOLAPE mm dentro de cada letra: tocarse de canto no vale."""
    v = np.array(pb) - np.array(pa)
    n = np.linalg.norm(v)
    u = v / n if n > 1e-9 else np.array([0.0, 1.0])
    return np.array(pa) - u * SOLAPE, np.array(pb) + u * SOLAPE


def imprime(titulo, trazos, grosor):
    """Cada union como remache (filete), o como trazo recto si el hueco es
    demasiado grande para cerrarlo con un filete decente."""
    remaches, pinceladas = [], []
    for pa, pb, d in sorted(trazos, key=lambda t: t[0][0]):
        if d <= HUECO_MAX_REMACHE:
            m = (np.array(pa) + np.array(pb)) / 2
            zona, r = medidas_remache(d)
            remaches.append(f"    [[{m[0]:7.2f}, {m[1]:6.2f}], {zona}, {r}],"
                            f"   // hueco {d:.2f} mm" +
                            ("   <-- REVISAR, radio grande"
                             if r >= R_REVISAR else ""))
        else:
            a, b = alargar(pa, pb)
            pinceladas.append(
                f"    [[{a[0]:7.2f}, {a[1]:6.2f}], [{b[0]:7.2f}, {b[1]:6.2f}],"
                f" {grosor}],   // hueco {d:.2f} mm")
    return titulo, remaches, pinceladas


if __name__ == '__main__':
    if len(sys.argv) < 2:
        raise SystemExit(__doc__)

    def opt(nombre, si_no):
        return (float(sys.argv[sys.argv.index(nombre) + 1])
                if nombre in sys.argv else si_no)

    r = Raster(sys.argv[1])
    grosor = opt('--grosor', GROSOR)
    piezas = trozos(r, r.mask)
    print(f"// {len(piezas)} trozos de letra que no se tocan", file=sys.stderr)

    hay_que, rigidez = coser(piezas) if len(piezas) > 1 else ([], [])
    huecos = sin_repetir(huecos_abiertos(r, r.mask, opt('--r', 1.4)),
                         hay_que + rigidez)

    grupos = [
        imprime("imprescindibles: trozos que cuelgan, no llegan a la barra",
                hay_que, grosor),
        imprime("rigidez: la barra ya los cose; quitalas si quedan feas",
                rigidez, grosor),
        imprime("rigidez: huecos abiertos entre letras, repasar a ojo",
                huecos, grosor),
    ]
    for lista, nombre in ((1, "remaches"), (2, "pinceladas")):
        if not any(g[lista] for g in grupos):
            continue
        print(f"{nombre} = [")
        for titulo, *cols in grupos:
            if cols[lista - 1]:
                print(f"    // --- {titulo} ---")
                print("\n".join(cols[lista - 1]))
        print("];")
