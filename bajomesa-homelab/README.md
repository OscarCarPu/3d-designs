# Soporte bajo-mesa modular "homelab"

Sustituye a `cajon-router/`. Mesa nueva: **IKEA MITTZON 140x80 elevable eléctrica**.

Cuelga bajo el tablero, en la franja trasera: **router**, **conversor de fibra**,
**Lenovo ThinkCentre M920q**, **su fuente** y un **ladrón de 400 mm**.
Objetivo: que nada toque el suelo y se pueda barrer.

## Números

| | |
|---|---|
| Caída total bajo el tablero | **87,3 mm** |
| Ancho de la fila | 517 mm |
| Fondo ocupado | 341 mm (deja ~435 mm de sitio para las piernas) |
| Aire libre sobre el M920q | 47 mm + rejilla en los cuatro costados |
| Tornillos | 12 (raíles) + 4 (ladrón) = **16** |
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

**Nada de PLA.** Carga permanente más el calor del M920q: acabaría descolgándose
por fluencia. PETG o ASA.

## Antes de imprimir: mide esto

1. **Alto del ladrón** (`la_z`, ahora 40) — es el único dato que no tengo.
2. **La fuente del M920q** (`ps_x/y/z`, ahora 55x125x30) — es una estimación del
   ladrillo slim-tip de 90 W.
3. **El diámetro de la cabeza de tus tornillos** (`d_cabeza`, ahora 11) — con
   calibre. Es lo que hace que la bocallave agarre o no.
4. **El grosor real del tablero.** Las fuentes dicen 20 mm; si el tuyo es más fino,
   usa tornillos más cortos para no atravesarlo.

## Orden de impresión

Primero **`testigo`** (10 minutos). Es un trozo de raíl y un trozo de cabeza en T.
Tienen que deslizar con la mano, firmes pero sin traqueteo. Si va duro sube `hol`,
si baila bájalo — 0,05 mm cambia mucho. **No imprimas nada más hasta que eso ajuste.**

Luego:

| Pieza | Cant. | Notas |
|---|---|---|
| `rail` | 6 | 3 por raíl |
| `galga` | 2 | útil de montaje, no queda puesto |
| `m920q` | 1 | eje Y del modelo (229 mm) sobre el eje de 250 de tu cama |
| `fuente` | 1 | ídem |
| `router` | 1 | ídem |
| `cuna` | 4 | bloqueo por fricción |
| `brida` | 2 | ladrón |

Todo sin soportes. Los raíles llevan un puente de 30 mm en la placa superior:
sale limpio en cualquier impresora.

## Montaje

1. **Une los tres segmentos de cada raíl** por el machihembrado de los labios.
2. **Mete las dos galgas** en los canales, una cerca de cada extremo. Mantienen los
   dos raíles a 200 mm exactos.
3. **Ofrece el conjunto al tablero**, a unos 150 mm del canto trasero, y **marca las
   12 bocallaves** por el agujero grande.
4. **Taladra en punta** (broca de 3 mm, tope de profundidad a 15 mm) y **atornilla
   dejando 3,5 mm de vástago fuera** — esa cota es la que hace que la bocallave
   agarre. Mide el primero y usa la misma profundidad en los demás.
5. **Cuelga los raíles** y deslízalos 16 mm para bloquear. Quita las galgas.
6. **Mete cada módulo cargado** deslizándolo por el canal desde un extremo, en este
   orden: router, fuente, M920q. Pesan ~1,3 kg cada uno.
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
- `N_SEG` se calcula solo a partir del ancho de la fila. Si achicas algún aparato
  puede bajar a 2 segmentos y ahorrarte 4 tornillos.
