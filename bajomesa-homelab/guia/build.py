#!/usr/bin/env python3
"""Empotra los renders en la plantilla y escribe guia/montaje.html.

Las imagenes van como data URI a proposito: un Artifact publicado no puede
cargar imagenes externas (la CSP solo admite scripts de unos pocos CDN), asi
que la pagina tiene que llevarlas dentro.
"""
import base64, pathlib, re, sys

here = pathlib.Path(__file__).parent
tpl = (here / "montaje.tpl.html").read_text()

alt = {
    "paso1": "Dos segmentos de rail antes de encajar por el machihembrado",
    "paso2": "Los dos railes unidos por los dos travesanos naranjas",
    "paso3": "El marco contra el tablero con las diez marcas de taladro",
    "paso5": "El marco atornillado al tablero con sus diez tornillos",
    "paso6": "Modulo del M920q entrando deslizando por el canal del rail",
    "paso7": "Travesano volviendo a su sitio con los modulos dentro",
    "paso8": "Brida sujetando el ladron, atornillada al tablero",
    "paso9": "Montaje terminado con todos los aparatos colocados",
    "paso10": "Planta del conjunto vista desde abajo",
}

faltan = []
def img(m):
    name = m.group(1)
    f = here / "img" / f"opt-{name}.png"
    if not f.exists():
        faltan.append(f.name)
        return ""
    b64 = base64.b64encode(f.read_bytes()).decode()
    return (f'<img src="data:image/png;base64,{b64}" '
            f'alt="{alt.get(name, name)}" loading="lazy">')

out = re.sub(r"\{\{(paso\d+)\}\}", img, tpl)

if faltan:
    sys.exit("faltan renders: " + ", ".join(faltan) + "  (corre guia/render.sh)")
if "{{" in out:
    sys.exit("quedan marcadores sin sustituir en la plantilla")

dest = here / "montaje.html"
dest.write_text(out)
print(f"{dest}  {len(out)/1024:.0f} KB")
