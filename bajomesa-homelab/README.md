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
| Tornillos | 8 (raíles) + 2 (travesaños) + 4 (ladrón) = **14** |
| Peso soportado | ~4 kg |

## Por qué está hecho así

**Dos raíles en vez de uno.** No es por repartir el peso — con un tornillo de 4 mm
y 15 mm de agarre en aglomerado sobras para 4 kg. Es por el **momento de palanca**:
un módulo colgado de una sola línea de tornillos los tira hacia abajo *y hacia
afuera*, que es la dirección en la que el aglomerado de 20 mm falla. Con dos raíles
separados 200 mm ese par se convierte en dos fuerzas verticales y desaparece el
problema.

**Un marco, no dos raíles sueltos.** Los dos travesaños fijan los 200 mm en el
plástico. Eso quita del montaje la medida que era imposible de clavar a mano: el
conjunto se arma en el suelo, se ofrece al tablero y **se marca por sus propios
agujeros**. Si el taladro sale un milímetro corrido da igual, porque la separación
no la manda el taladro. Con los raíles sueltos, un milímetro de más entre ellos y
el módulo ya no entra en los dos canales a la vez.

De paso, cada travesaño tapa la boca de los dos canales y **hace de tope de los
módulos**: es lo que antes hacían cuatro cuñas de fricción.

**Se atornilla directo, sin bocallave.** La bocallave obligaba a dejar cada
tornillo con 3,5 mm de vástago fuera, medidos con calibre, y a que la cabeza
cupiese por un círculo de 13 mm. Ahora el agujero es del tamaño del tornillo
(4,5 mm de paso, avellanado de 8,5 para la cabeza) y el tornillo se aprieta hasta
que asienta. Se pierde poder descolgar el raíl sin destornillador, que no es algo
que se haga.

**La unión entre segmentos ya no trabaja, y ya no es parte del raíl.** Dos cosas:

- Las pestañas van a 16 mm de cada punta, así que la junta queda **pinzada entre dos
  tornillos separados 32 mm** y la flexión se la lleva el tablero, no el plástico.
- Lo que alinea los dos segmentos es una **llave suelta** que entra en un alojamiento
  excavado en el espesor de las paredes. El raíl ya no lleva ningún saliente: un
  machihembrado impreso de 3 mm era lo primero que se partía, y encima se partía en
  la pieza cara. La llave se imprime plana, que es su orientación más fuerte, es una
  pieza de 0,4 g y si se rompe se reimprime en tres minutos. Vale igual un fleje de
  acero o aluminio de 2 mm cortado a 27.

Aun así, **ningún plástico aguanta un raíl de 471 mm cogido por un extremo**. El
marco se levanta con las manos por debajo, cerca de las dos juntas, no por las
puntas.

**PLA vale.** Lo desaconsejé al principio por fluencia bajo carga permanente,
pero al echar los números no se sostiene: la tensión máxima está en el avellanado
de las pestañas, unos 5 N sobre ~30 mm² = **0,17 MPa**, y en las cabezas en T baja
a 0,003 MPa. Son tres o cuatro órdenes de magnitud por debajo del límite del PLA, y
la fluencia a esas tensiones es despreciable. Lo único a vigilar sería la
temperatura junto al M920q, y ahí hay 47 mm de aire libre y rejilla en los cuatro
costados. PETG sigue siendo mejor si lo tienes, pero no hace falta comprarlo.

## Tornillos

**14 iguales: aglomerado 4 x 20, cabeza avellanada.** El tablero es de 20 mm; el
tornillo atraviesa 5 mm de plástico y deja 15 mm dentro de la madera sin asomar
por arriba. Con tornillos de 16 mm quedan 11, que también valen.

Las dos cotas del modelo son `d_vastago = 4` (la caña lisa) y `d_cabeza = 8` (el
sombrero). De ahí salen solos el agujero de paso de 4,5 y el avellanado de 8,5.
**Mídelas con el calibre**, pero ninguna es crítica: si tu cabeza es más gorda
sobresaldrá un par de milímetros por debajo de la pestaña, donde no roza nada.

`arandela.scad` ya no hace falta: existía para agrandar la cabeza sobre la ranura
de la bocallave, y esa ranura ya no existe.

## Orden de impresión

Ordenado por riesgo: cada tanda valida algo antes de comprometer la siguiente.

**Antes de nada:** confirma si el M920q lleva fuente interna o ladrillo externo.
Si es externa hay que poner `fuente_externa = true`, y eso cambia la longitud de
los segmentos de raíl (235 → 176 mm). Equivocarse aquí obliga a reimprimir los
cuatro raíles.

| # | Piezas | Peso | Qué valida |
|---|---|---|---|
| 1 | `testigo-rail` + `testigo-cabeza` | 40 g | El ajuste del canal. Debe deslizar firme y sin traqueteo. Si va duro sube `hol`, si baila bájalo: 0,05 mm cambia el tacto por completo. **No sigas hasta que ajuste.** |
| 2 | 1 `rail` + `llave` | 75 g | La pestaña contra tu tornillo real, los 235,5 mm en la cama y el puente de 30 mm de la placa. La plancha de llaves saca 6 y hacen falta 4 |
| 3 | 3 `rail` + 2 `travesano` | 309 g | **Y aquí monta el marco en la mesa.** Confirma que el bastidor de la elevable no estorba y que la posición es la buena, antes de meter ~30 h en los módulos |
| 4 | `aux`, `m920q`, `router` | 853 g | En ese orden: `aux` es el más pequeño y valida la geometría de módulo barato |
| 5 | 2 `brida` | 185 g | El ladrón, que va desacoplado y es lo de menos riesgo |

Todo sin soportes y sin reorientar nada.

**Por placa:** los módulos van de uno en uno (229 mm sobre el eje de 250 de la
cama, 193 sobre el de 220). Los raíles (235,5 x 70) entran de dos en dos y el
travesaño mide 236 x 32. Ninguno lleva salientes finos: lo más delicado que hay
en la placa son las llaves, y salen seis de una tacada.

## Filamento

**~1,46 kg**, así que **dos bobinas**. Desglose:

| Pieza | ud | g/ud | total |
|---|---|---|---|
| `rail` | 4 | 73 | 291 g |
| `router` | 1 | 364 | 364 g |
| `m920q` | 1 | 321 | 321 g |
| `brida` | 2 | 92 | 185 g |
| `aux` | 1 | 168 | 168 g |
| `travesano` | 2 | 45 | 91 g |
| `testigo-cabeza` | 1 | 23 | 23 g |
| `testigo-rail` | 1 | 17 | 17 g |
| `llave` | 6 | 0,4 | 2 g |
| | | | **1462 g** |

De esos, 40 g son útiles de montaje (los dos `testigo`) que se tiran después.

Calculado sobre el volumen de malla por densidad del PLA (1,24 g/cm³), con un 0,9 por las zonas
gruesas. No está cortado con slicer, pero el margen de error es pequeño: casi toda
la pieza son paredes de 3 a 6 mm y con 6 perímetros eso sale macizo pase lo que
pase con el relleno. Cuenta con 1,5–1,7 kg.

## Montaje

1. **Une los dos segmentos de cada raíl.** Mete media llave en cada uno de los dos
   alojamientos del testero, empújalas con el dedo y encaja el otro segmento encima.
   Van dos llaves por junta, una en cada pared.
2. **Mete un travesaño en cada boca**, empujándolo hasta que la barra tope contra
   el testero de los raíles. Ya tienes un marco rígido con los 200 mm clavados.
3. **Ofrece el marco al tablero**, a unos 150 mm del canto trasero, y **marca los
   10 agujeros por los del propio marco**. No hay ninguna medida que sacar.
4. **Taladra en punta** (broca de 3 mm, tope de profundidad a 15 mm) y **atornilla**
   los 10 tornillos del marco. Aprieta hasta que la cabeza asiente en el avellanado.
5. **Quita el travesaño del extremo del M920q** (un tornillo) y **mete cada módulo
   cargado** deslizándolo por el canal, en este orden: router, conversor, M920q.
   Pesan ~1,3 kg cada uno.
6. **Vuelve a poner ese travesaño** y su tornillo: es el tope que impide que un
   módulo se salga deslizando.
7. **Las bridas del ladrón** van aparte, detrás del raíl trasero, con sus 4
   tornillos propios.

El M920q queda en el extremo a propósito: es lo que más vas a tocar y sale sin
desmontar nada más — un tornillo, el travesaño fuera y el módulo sale deslizando.

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
