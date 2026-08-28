# Anillas para cortina de ducha

Recambio de las anillas de las cortinas de las duchas. Barra de **22 mm**,
ojal perforado de **~7 mm**. Aro cerrado alrededor de la barra + gancho
abierto para la cortina, todo en una pieza plana de 4 mm.

```
      ,-----.
     /       \      aro cerrado, D interior 26 mm
    (  barra  )     (la barra es de 22: 2 mm de aire por lado)
     \       /
      `--,--'
         |          cuello, 3 mm de hueco
        (_)         gancho abierto, entra el ojal por la derecha
```

## Números

| | |
|---|---|
| Anilla completa | **35 x 52 x 4 mm** |
| Diámetro interior del aro | **26 mm** (barra de 22) |
| Sección del aro | 4,5 x 4 mm |
| Hueco del gancho | 8 mm de diámetro |
| Abertura del gancho | **2,5 mm** |
| Sección más fina de la pieza | 3 mm (el alambre del gancho y el cuello) |
| Peso | 2,6 g por anilla, **31 g las 12** |
| Tiempo | ~1 h la tanda de 12 |
| Soportes | ninguno |

## Por qué está hecho así

**Aro cerrado, no gancho en C.** Un gancho abierto por arriba se pone sin
descolgar la barra, pero es justo la pieza que tiene que abrirse para montarse
y no abrirse nunca más: el tirón de la cortina va en esa misma dirección. Un aro
cerrado no tiene nada que ceder, roza menos y desliza mejor. El precio es
montarlo: hay que descolgar la barra una vez y ensartar las 12.

**Ningún hueco abierto puede ser mayor que la sección más fina de la pieza.** Es
la regla que gobierna el diseño, y la que se saltó la primera versión: tenía 5 mm
de aire por lado dentro de un aro de 32 mm. Con la pieza de 4 mm de espesor, ese
hueco de 5 se traga una anilla entera. Al tumbarse, el borde inferior de una se
cuela por debajo de la barra en la de al lado y quedan **eslabonadas** como una
cadena. No era un problema de acabado ni de rozamiento: el hueco era más grande
que la pieza.

Ahora los dos únicos huecos abiertos son **2 mm** (aire dentro del aro) y **2,5 mm**
(la boca del gancho), contra una sección mínima de **3 mm**. Nada de la anilla
vecina cabe por ninguno de los dos, se tumbe lo que se tumbe: no existe una
postura en la que se puedan enganchar. El `.scad` lo comprueba con un `assert`,
así que si tocas `holgura_barra`, `hueco` o cualquier grosor y rompes la regla, no
exporta.

**El precio es que se inclina menos, y no hay forma de evitarlo.** Un aro holgado
se inclina y toca la barra en un punto, así que rueda en vez de arrastrar; uno
ajustado desliza rozando. Pero inclinarse mucho es exactamente lo que le permite
meterse en la de al lado: son la misma propiedad vista por los dos lados, y no se
pueden separar. Con 26 mm la anilla todavía se ladea unos **24°** (antes 39°), de
sobra para que ruede, y ya no alcanza a su vecina. Si algún día quieres más
holgura, sube `grosor` a la par: lo que manda es que la holgura sea menor que el
espesor.

**El gancho sí es abierto.** Lo que se pone y se quita a menudo es la cortina,
no las anillas. Con el gancho abierto la cortina entra y sale sin tocar la barra,
y la abertura mira hacia arriba-derecha, en contra de la dirección en la que tira
la cortina: para que se salga hay que levantar el ojal y girarlo a mano.

Esa abertura es de **2,5 mm** por la misma regla: con los 3,5 mm que tenía, el
cuello de la anilla vecina (3 mm) entraba justo por ahí. La tela sigue pasando de
sobra. Si el ojal de tu cortina lleva un aro metálico grueso y ves que no entra,
`-D hueco=3.5` y vuelves a exportar, pero pierdes la garantía.

**Se imprime tumbada, y esto no es un detalle.** El plano de la anilla va sobre
la cama:

- no hay un solo voladizo ni hace falta soporte
- el contacto con la cama es toda la cara de la pieza, no se despega
- los hilos de cada capa recorren el aro y el gancho **a lo largo**, que es la
  dirección en la que tira la cortina. No hay ninguna unión entre capas
  trabajando a tracción, que es lo único que se rompe de verdad en una pieza FDM

De canto sería lo contrario: la pieza se partiría por la capa de la unión
cuello-aro con el primer tirón.

**PLA vale, PETG mejor.** Una cortina de baño pesa unos 600 g repartidos entre
12 anillas: 0,5 N cada una sobre una sección de 18 mm², o sea **0,03 MPa**. Son
tres órdenes de magnitud por debajo de cualquier cosa que le pase al PLA, y a esa
tensión la fluencia es irrelevante aunque la carga sea permanente. El vapor del
baño no llega ni de lejos a los 55 ºC que ablandan el PLA. PETG sigue siendo
preferible por ser menos frágil ante un tirón seco, y es lo que usaría si lo hay
en la estantería, pero no hace falta comprarlo.

**Todos los cantos redondeados (0,8 mm).** Es lo que hace que el aro no muerda la
barra al deslizar y que el ojal no se rasgue en el gancho. Está hecho con
`minkowski` sobre el perfil encogido, y las cotas salen clavadas porque se
compensa lo que engorda la esfera facetada, no su radio.

## Antes de imprimir: mide la barra

Es el único dato que importa, y ahora más que antes: el aro solo deja 2 mm de aire
por lado, así que ya no perdona un error de 3 mm. Con el calibre, **por fuera del
tubo**, en la parte que no está solapada si es extensible (una barra telescópica
tiene dos diámetros: usa el **grueso**, que es por donde van a pasar las anillas).
Si la barra tiene un resalte o un embellecedor en algún punto del recorrido,
mídelo también: con esta holgura las anillas ya no pasan por encima de cualquier
cosa.

Si no es de 22 mm, cambia el parámetro y reexporta (el aro crece solo, la holgura
se mantiene):

```bash
openscad -o stl/anilla.stl --export-format binstl -D d_barra=25 anillas-cortina-ducha.scad
```

Y si el ojal de tu cortina es más pequeño de 6 mm, baja `w_gancho` a 2,4: el
alambre tiene que pasar por el agujero (su diagonal es 3 x 4 mm ≈ 5 mm). Ojo, eso
adelgaza la sección mínima a 2,4 mm y el `assert` te va a parar: baja `hueco` a 2
en la misma línea de comandos.

```bash
openscad -o stl/anilla.stl --export-format binstl -D w_gancho=2.4 -D hueco=2 anillas-cortina-ducha.scad
```

## Si la barra tiene un escalón entre tramos

Barras en dos tramos (telescópicas, o con un manguito de unión) a veces
tienen un salto de 1-1,5 mm de diámetro justo en la unión. La holgura del
aro (2 mm por lado) es de sobra para que la anilla quepa, pero el canto
del escalón hace tope contra el borde interior del aro cuando la anilla
va inclinada y a velocidad — se nota como resistencia o, si el salto es
mayor, como atasco. Forrar el tramo fino con cinta para igualar el
diámetro no lo arregla del todo: solo cambia un escalón por dos más
pequeños (los bordes de la cinta).

La solución es agrandar el redondeo del aro con `redondeo_aro`, que es
independiente del `redondeo` del cuello y el gancho: el aro es macizo y
aguanta mucho más chaflán, pero el alambre del gancho (`w_gancho`, la
sección más fina de la pieza) no. Un `assert` para cada uno impide
pasarse y quedarse sin sección.

`redondeo_aro` está en **2 mm**, el límite práctico con `grosor=4`: el
`assert` deja apenas 0,14 mm de banda plana en el centro del aro antes de
que las dos curvas del redondeo se toquen. Si aun así se nota el escalón,
ya no hay margen por este lado — hay que subir `grosor` (o volver a la
cinta en la barra) para poder subir `redondeo_aro` más.

```bash
openscad -o stl/anillas-x12.stl --export-format binstl -D 'pieza="placa"' \
  anillas-cortina-ducha.scad
```

## Imprimir

| | |
|---|---|
| Altura de capa | 0,2 mm |
| Perímetros | 3 |
| Relleno | 100 % (son 2,6 g, no merece la pena ahorrar) |
| Soportes | no |
| Orientación | tal cual sale del STL, tumbada |

`anillas-x12.stl` es la tanda de 12 ya colocada (155 x 166 mm, entra en una cama
de 220). Si prefieres duplicar en el laminador, usa `anilla.stl`.

**Imprime dos primero.** Cuestan 5 g y cuatro minutos, y comprueban las tres cosas
que pueden salir mal: que el aro pase por la barra y deslice, que el ojal entre y
no se salga solo, y —con las dos en la barra— que no haya forma de engancharlas
una con otra por mucho que las retuerzas.

## Montaje

1. Descuelga la barra y quita la cortina vieja.
2. Ensarta las 12 anillas en la barra.
3. Vuelve a colgar la barra.
4. Mete cada ojal por la abertura del gancho, girándolo.

Si tu barra está atornillada a la pared por los dos extremos y no se puede
descolgar, este diseño no te sirve: haría falta la variante de gancho en C
abierto por arriba.

## Archivos

| | |
|---|---|
| `anillas-cortina-ducha.scad` | el diseño, todo parametrizado |
| `stl/anilla.stl` | una anilla |
| `stl/anillas-x12.stl` | tanda de 12 lista para laminar |

Para reexportar:

```bash
openscad -o stl/anilla.stl     --export-format binstl                      anillas-cortina-ducha.scad
openscad -o stl/anillas-x12.stl --export-format binstl -D 'pieza="placa"'  anillas-cortina-ducha.scad
```
