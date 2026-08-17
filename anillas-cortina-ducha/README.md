# Anillas para cortina de ducha

Recambio de las anillas de las cortinas de las duchas. Barra de **22 mm**,
ojal perforado de **~7 mm**. Aro cerrado alrededor de la barra + gancho
abierto para la cortina, todo en una pieza plana de 4 mm.

```
      ,-----.
     /       \      aro cerrado, D interior 32 mm
    (  barra  )     (la barra es de 22: 5 mm de aire por lado)
     \       /
      `--,--'
         |          cuello, 3 mm de hueco
        (_)         gancho abierto, entra el ojal por la derecha
```

## Números

| | |
|---|---|
| Anilla completa | **41 x 58 x 4 mm** |
| Diámetro interior del aro | **32 mm** (barra de 22) |
| Sección del aro | 4,5 x 4 mm |
| Hueco del gancho | 8 mm de diámetro |
| Abertura del gancho | **3,5 mm** |
| Peso | 3 g por anilla, **37 g las 12** |
| Tiempo | ~1 h la tanda de 12 |
| Soportes | ninguno |

## Por qué está hecho así

**Aro cerrado, no gancho en C.** Un gancho abierto por arriba se pone sin
descolgar la barra, pero es justo la pieza que tiene que abrirse para montarse
y no abrirse nunca más: el tirón de la cortina va en esa misma dirección. Un aro
cerrado no tiene nada que ceder, roza menos y desliza mejor. El precio es
montarlo: hay que descolgar la barra una vez y ensartar las 12.

**El gancho sí es abierto.** Lo que se pone y se quita a menudo es la cortina,
no las anillas. Con el gancho abierto la cortina entra y sale sin tocar la barra,
y la abertura (3,5 mm) mira hacia arriba-derecha, en contra de la dirección en la
que tira la cortina: para que se salga hay que levantar el ojal y girarlo a mano.

**El aro va holgado a propósito: 32 mm para una barra de 22.** No es holgura de
tolerancia, es de funcionamiento. Un aro ajustado se apoya en la barra en toda su
mitad superior y desliza rozando; uno holgado se inclina y toca en un punto, así
que **rueda** en vez de arrastrar. Es por lo que las anillas compradas son tan
grandes en comparación con la barra. Con 5 mm por lado la anilla se inclina lo
suficiente para rodar y no tanto como para trabarse en diagonal.

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

Es el único dato que importa. Con el calibre, **por fuera del tubo**, en la parte
que no está solapada si es extensible (una barra telescópica tiene dos diámetros:
usa el **grueso**, que es por donde van a pasar las anillas).

Si no es de 22 mm, cambia el parámetro y reexporta (el aro crece solo, la holgura
se mantiene):

```bash
openscad -o stl/anilla.stl --export-format binstl -D d_barra=25 anillas-cortina-ducha.scad
```

Y si el ojal de tu cortina es más pequeño de 6 mm, baja `w_gancho` a 2,4: el
alambre tiene que pasar por el agujero (su diagonal es 3 x 4 mm ≈ 5 mm).

## Imprimir

| | |
|---|---|
| Altura de capa | 0,2 mm |
| Perímetros | 3 |
| Relleno | 100 % (son 3 g, no merece la pena ahorrar) |
| Soportes | no |
| Orientación | tal cual sale del STL, tumbada |

`anillas-x12.stl` es la tanda de 12 ya colocada (179 x 184 mm, entra en una cama
de 220). Si prefieres duplicar en el laminador, usa `anilla.stl`.

**Imprime una primero.** Cuesta 3 g y dos minutos, y comprueba lo único que puede
salir mal: que el aro pase por la barra con soltura y que el ojal entre y no se
salga solo.

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
