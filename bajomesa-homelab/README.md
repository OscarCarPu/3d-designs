# Soporte bajo-mesa modular "homelab"

Sustituye a `cajon-router/`. Mesa nueva: **IKEA MITTZON 140x80 elevable eléctrica**.

Cuelga bajo el tablero, en la franja trasera: **router**, **conversor de fibra**,
**Lenovo ThinkCentre M920q** (con la fuente integrada) y un **ladrón de 400x60x42**.
Objetivo: que nada toque el suelo y se pueda barrer.

## Números

| | |
|---|---|
| Caída total bajo el tablero | **87,3 mm** |
| Ancho de la fila | 459 mm |
| Fondo ocupado | 348 mm (deja ~430 mm de sitio para las piernas) |
| Aire libre sobre el M920q | 47 mm + rejilla en los cuatro costados |
| Tornillos | 8 (raíles) + 4 (ladrón) = **12** |
| Peso soportado | ~4 kg |

## Por qué está hecho así

**Dos raíles en vez de uno.** No es por repartir el peso — con un tornillo de 4 mm
y 15 mm de agarre en aglomerado sobras para 4 kg. Es por el **momento de palanca**:
un módulo colgado de una sola línea de tornillos los tira hacia abajo *y hacia
afuera*, que es la dirección en la que el aglomerado de 20 mm falla. Con dos raíles
separados 200 mm ese par se convierte en dos fuerzas verticales y desaparece el
problema.

**El ladrón va desacoplado.** Sus dos bridas se atornillan directamente al tablero,
sin tocar el sistema de raíles. Si compartiese canal chocaría con las cabezas en T
de los módulos, que ocupan casi toda su longitud.

**PLA vale.** Lo desaconsejé al principio por fluencia bajo carga permanente,
pero al echar los números no se sostiene: la tensión máxima está en las bocallaves
del raíl, unos 5 N sobre ~40 mm² = **0,13 MPa**, y en las cabezas en T baja a
0,003 MPa. Son tres o cuatro órdenes de magnitud por debajo del límite del PLA, y
la fluencia a esas tensiones es despreciable. Lo único a vigilar sería la
temperatura junto al M920q, y ahí hay 47 mm de aire libre y rejilla en los cuatro
costados. PETG sigue siendo mejor si lo tienes, pero no hace falta comprarlo.

## Antes de imprimir: confirma esto

Solo queda un dato pendiente: **el diámetro de la cabeza de tus tornillos**
(`d_cabeza`, ahora 11 mm). Se mide con el calibre atravesado sobre el sombrero,
por su parte más ancha, la que apoya contra la madera:

```
      |<-- d_cabeza -->|      <- mide AQUI
       \______________/
            |    |
            |    |  <- d_vastago (caña lisa)
            |####|  <- rosca (no importa)
```

Si pasa de 13 mm no cabe por la bocallave; sube `d_cabeza` y el círculo crece solo.

**Tornillos:** tablero de 20 mm → usa tornillos de **20 mm de largo total o menos**.

**Arandela obligatoria bajo la cabeza (`arandela.scad`).** La cabeza del
tornillo es demasiado pequeña respecto a la ranura de deslizamiento y apenas
pisa el labio del raíl: cede en cuanto alguien se apoya. La arandela la agranda.

La definen dos cotas, y son **las del raíl, no las del tornillo**:

| | |
|---|---|
| Menor que el círculo de entrada | **Ø13** — para que pase al colgar el raíl |
| Mayor que la ranura de deslizamiento | **7,5** — para que pise el labio |

Con **Ø12,2** quedan 2,35 mm de apoyo por lado en vez de 1,75, o 31 mm² de
superficie contra 19. Va puesta en el tornillo desde el principio: no hay que
desmontar nada. El raíl desliza 9,9 mm en vez de 10,5 antes de topar, y sigue
bloqueando igual.

**Mide el agujero interior.** Tiene que pasar la caña y ser claramente menor que
la cabeza, o la cabeza se colará por la arandela. Si tu cabeza mide bastante
menos de los 11 mm que asume el diseño — que es lo más probable si apenas
agarra — baja `d_vastago` para que sobre más material.

En metal también vale: una **DIN 125 M6** (Ø12,5 × 1,6) entra y da un pelín más
de apoyo. El acero no fluye con el tiempo y el PLA sí, así que si la tienes a
mano, mejor esa.

Son 12 unidades, 2 g en total.

## Orden de impresión

Ordenado por riesgo: cada tanda valida algo antes de comprometer la siguiente.

**Antes de nada:** confirma si el M920q lleva fuente interna o ladrillo externo.
Si es externa hay que poner `fuente_externa = true`, y eso cambia la longitud de
los segmentos de raíl (235 → 176 mm). Equivocarse aquí obliga a reimprimir los
cuatro raíles.

| # | Piezas | Peso | Qué valida |
|---|---|---|---|
| 1 | `testigo-rail` + `testigo-cabeza` + 1 `cuna` | 50 g | El ajuste del canal. Debe deslizar firme y sin traqueteo. Si va duro sube `hol`, si baila bájalo: 0,05 mm cambia el tacto por completo. **No sigas hasta que ajuste.** |
| 2 | 1 `rail` | 90 g | La bocallave contra tu tornillo real, los 241 mm en la cama y el puente de 30 mm de la placa |
| 3 | 3 `rail` + 2 `galga` | 361 g | **Y aquí monta los raíles en la mesa.** Confirma que el bastidor de la elevable no estorba y que la posición es la buena, antes de meter ~30 h en los módulos |
| 4 | `aux`, `m920q`, `router` | 853 g | En ese orden: `aux` es el más pequeño y valida la geometría de módulo barato |
| 5 | 2 `brida` + 3 `cuna` | 186 g | El ladrón, que va desacoplado y es lo de menos riesgo |

Todo sin soportes y sin reorientar nada.

**Por placa:** los módulos van de uno en uno (229 mm sobre el eje de 250 de la
cama, 193 sobre el de 220). Los raíles entran de dos en dos.

## Filamento

**~1,55 kg**, así que **dos bobinas**. Desglose:

| Pieza | ud | g/ud | total |
|---|---|---|---|
| `rail` | 4 | 90 | 359 g |
| `router` | 1 | 364 | 364 g |
| `m920q` | 1 | 321 | 321 g |
| `brida` | 2 | 76 | 152 g |
| `aux` | 1 | 168 | 168 g |
| `galga` | 2 | 46 | 91 g |
| `cuna` | 4 | 11 | 45 g |
| `testigo-cabeza` | 1 | 23 | 23 g |
| `testigo-rail` | 1 | 16 | 16 g |
| | | | **1541 g** |

De esos, 130 g son útiles de montaje (los dos `testigo` y las `galga`) que se
tiran después.

Calculado sobre el volumen de malla por densidad del PLA (1,24 g/cm³), con un 0,9 por las zonas
gruesas. No está cortado con slicer, pero el margen de error es pequeño: casi toda
la pieza son paredes de 3 a 6 mm y con 6 perímetros eso sale macizo pase lo que
pase con el relleno. Cuenta con 1,5–1,8 kg.

## Montaje

1. **Une los dos segmentos de cada raíl** por el machihembrado de los labios.
2. **Mete las dos galgas** en los canales, una cerca de cada extremo. Mantienen los
   dos raíles a 200 mm exactos.
3. **Ofrece el conjunto al tablero**, a unos 150 mm del canto trasero, y **marca las
   8 bocallaves** por el agujero grande.
4. **Taladra en punta** (broca de 3 mm, tope de profundidad a 15 mm) y **atornilla
   dejando 3,5 mm de vástago fuera** — esa cota es la que hace que la bocallave
   agarre. Mide el primero y usa la misma profundidad en los demás.
5. **Cuelga los raíles** y deslízalos 16 mm para bloquear. Quita las galgas.
6. **Mete cada módulo cargado** deslizándolo por el canal desde un extremo, en este
   orden: router, conversor, M920q. Pesan ~1,3 kg cada uno.
7. **Clava una cuña** a cada lado de la fila. Sale con un destornillador por el
   agujero del testero.
8. **Las bridas del ladrón** van aparte, detrás del raíl trasero, con sus 4
   tornillos propios.

El M920q queda en el extremo a propósito: es lo que más vas a tocar y sale sin
desmontar nada más.

## Cables

Deja **un bucle de servicio generoso en la fibra**. La mesa sube y baja 60 cm dos
veces al día y la flexión repetida del latiguillo es el fallo clásico a los meses.
Que cuelgue en bucle suelto, nunca tirante ni doblado en radio corto.

Ranuras para bridas en todos los módulos.

## Variantes

- `puertos_al_frente = false` → gira el hueco de acceso del M920q hacia el fondo
  de la mesa.
- `fuente_externa = true` → si algún día el equipo pasa a llevar ladrillo externo,
  el módulo auxiliar recupera su cubículo. La fila crece 58 mm y el raíl pasa a
  necesitar 3 segmentos por lado (4 tornillos más).
- `N_SEG` y la longitud de segmento se calculan solos a partir del ancho de la fila.

## STLs

En `stl/`, listos para el slicer. Ninguno necesita soportes ni reorientar.

## Guía de montaje

`guia/montaje.html` — guía visual paso a paso con renders del propio modelo.
Publicada como Artifact para poder abrirla en el móvil mientras montas.

Para regenerarla:

```sh
./guia/render.sh     # renders (uno por paso) a guia/img/
python3 guia/build.py   # empotra las imágenes en la plantilla -> guia/montaje.html
```

Las escenas están en `guia.scad`, una por paso, con la pieza que se añade en
naranja y lo ya montado en gris. Las imágenes van empotradas como data URI
porque un Artifact publicado no puede cargar imágenes externas.
