// =====================================================================
//  Perchero de pared, sujeto con 2 tornillos, EN DOS MITADES
//
//  De una pieza no cabe en la cama de la Core One+ (250 x 220 mm), asi
//  que se parte por el medio en dos mitades iguales que se unen con una
//  COLA DE MILANO deslizante: una lleva la caja (hueco) y la otra la
//  espiga. Se ensamblan deslizando una mitad hacia abajo sobre la otra;
//  el peso de lo colgado no tira de la union hacia fuera, solo la mete
//  mas.
//
//  Cada agujero de tornillo tiene DOS diametros: d_vastago pasante y
//  d_cabeza avellanado "prof_cabeza" mm en la cara frontal, para que la
//  cabeza del tornillo quede hundida.
//
//  GANCHOS. Copian el gancho clasico de latón de perchero/sombrerera.
//  brazo largo y gancho pequeño van ALTERNADOS a lo largo del liston (los
//  pequeños caen en el hueco entre dos brazos largos), no apilados dos en
//  la misma vertical:
//    - brazo largo (en brazo_x): sale perpendicular a la pared, se
//      levanta con dos arcos tangentes (cuello de cisne) y remata en
//      bola. La curva es concava hacia la pared, asi que lo que se
//      cuelga cae al fondo del hueco entre el brazo y el liston, no
//      hacia la boca.
//    - gancho pequeño (en peq_x): nace mas abajo, baja un poco y cierra
//      hacia arriba; la bola de la punta hace de tope.
//  Los dos salen del mismo camino parametrico (recta + arcos tangentes,
//  seccion circular que va afinando de la raiz a la punta), no hay tres
//  formas distintas ni codos raros.
//
//  Diferencia a proposito con la foto: el brazo largo va mas tumbado que
//  el de latón.
//
//  ORIENTACION DE IMPRESION: la pieza se apoya en el CANTO INFERIOR del
//  liston (cara Y=-grosor/2, la de la pared, queda VERTICAL), no tumbada
//  sobre esa cara. Motivo: la raiz de cada gancho, embebida en el liston
//  y perpendicular a la pared, es donde se concentra la flexion cuando
//  cuelga peso, y esa tension es axial a la raiz (direccion "avance",
//  perpendicular a la pared). Si esa direccion coincide con el eje Z de
//  impresion (como pasaba tumbando la pieza), la tension tira justo entre
//  capas, que es la union mas debil, y por eso se parte ahi. De pie, esa
//  direccion queda dentro del plano de cada capa (horizontal) y la que
//  sube en Z es la altura del liston, que no es donde se concentra el
//  esfuerzo. Con esta orientacion la raiz de cada gancho sale como un
//  saliente horizontal desde una pared vertical: necesita SOPORTES (ya
//  van activados en los perfiles de impresion, tree(auto)) en el primer
//  tramo de cada gancho, junto al liston.
//
//  GANCHO LATERAL. Uno por mitad, junto al extremo. Nace en la cara de
//  DELANTE como los demas (misma raiz perpendicular a la pared, misma
//  union solida con el liston), pero su plano va girado "lat_giro" grados
//  hacia el extremo: el brazo sale de frente y se va a buscar el lado,
//  asi que la boca y la bola acaban pasado el canto del liston. Es el
//  gancho gordo, para bolsas, paraguas o una percha.
//  Girar el plano sobre el eje de la raiz no cambia el voladizo de
//  impresion (cada punto conserva su distancia a la pared, que es lo que
//  sube en la cama), asi que se imprime igual que los de delante.
//
//  Piezas ("pieza"):
//    "izquierda" = mitad con la CAJA de la cola de milano.
//    "derecha"   = mitad con la ESPIGA.
//    "prueba"    = placa pequeña con dos agujeros de tornillo, uno normal
//                  y otro cortado en el canto para ver el avellanado.
//    "vista"     = las dos mitades montadas (NO para imprimir).
//
//  Unidades: milimetros. Necesita la libreria BOSL2.
// =====================================================================

include <BOSL2/std.scad>

/* --------------------- QUE EXPORTAR -------------------------- */
pieza = "izquierda";   // "izquierda" | "derecha" | "prueba" | "vista"

$fn = 64;

/* --------------------- TORNILLOS ------------------------------ */
sep_tornillos = 365;   // distancia ENTRE CENTROS de los dos tornillos
d_vastago     = 5;     // agujero interior, pasante (caña del tornillo)
d_cabeza      = 9;     // agujero exterior, avellanado (cabeza del tornillo)
prof_cabeza   = 6;     // profundidad del avellanado desde la cara frontal

/* --------------------- LISTON ---------------------------------- */
margen   = 30;   // de cada tornillo al extremo del liston
alto     = 68;   // altura del liston: el gancho doble lo cruza entero
                 // (subida junto con los ganchos, para que las raices
                 // mas gordas sigan cabiendo con hueco de sobra)
grosor   = 18;   // espesor, de cara frontal a cara de pared: mas grosor
                 // da mas anclaje a la raiz de los ganchos y mas pared
                 // solida alrededor del agujero de tornillo
redondeo = 3;    // redondeo del canto exterior (la cara de union va a escuadra)

/* --------------------- CAMA DE LA IMPRESORA -------------------- */
cama       = [250, 220];   // Core One+, lo que obliga a partir el perchero
altura_max = 270;          // Z maximo de la Core One+

/* --------------------- GANCHOS: ALTERNADOS ---------------------- */
// medidos desde la cara de union; los peq_x caen en el hueco entre
// brazos, no debajo de uno: brazo - peq - brazo - peq
brazo_x = [34, 110];
peq_x   = [72, 148];

// brazo largo (sombreros, perchas, asas de bolsa)
brazo_z     = 10;    // altura de la raiz: en el tercio de arriba del liston
brazo_raiz  = 10;    // cuanto se hunde la raiz en el liston: mas hundida
                     // reparte la flexion en mas distancia, menos pico
                     // de tension justo donde el brazo sale del liston
brazo_d     = 20;    // diametro en la raiz: la seccion que mas flexion
                     // aguanta, engordada a proposito
brazo_d_fin = 10;    // diametro en la punta
brazo_bola  = 13;    // bola del remate
brazo_r1    = 26;    // primer arco: despega de la perpendicular
brazo_a1    = 50;
brazo_r2    = 40;    // segundo arco: endereza el cuello de cisne
brazo_a2    = 25;
brazo_recta = 8;     // tramo recto antes de la bola

// gancho pequeño (abrigos, lazadas)
peq_z     = -25;
peq_raiz  = 9;
peq_d     = 16;
peq_d_fin = 9;
peq_bola  = 11;
peq_r1    = 10;      // baja al salir del liston
peq_a1    = -30;
peq_r2    = 11;      // cierra hacia arriba
peq_a2    = 135;
peq_recta = 0;

// gancho lateral: nace en la cara de delante, con el plano girado hacia
// el extremo para acabar sobresaliendo por el canto
lat_giro   = 55;     // 0 = como los de delante, 90 = plano tumbado del todo
lat_margen = 13;     // del extremo del liston a la raiz
lat_z      = -10;
lat_raiz   = 10;
lat_d      = 19;     // el mas gordo: es el que tiene que aguantar peso
lat_d_fin  = 10;
lat_bola   = 13;
lat_r1     = 12;     // baja al salir del liston
lat_a1     = -30;
lat_r2     = 16;     // cierra hacia arriba y hacia el lado
lat_a2     = 150;
lat_recta  = 0;

/* --------------------- UNION CENTRAL (cola de milano) ------------ */
// mas cm_prof (engancha mas hacia dentro) + mas cm_alto (desliza mas
// altura) + menos cm_holg (ajuste mas prieto) dejan las dos mitades mas
// firmes entre si antes de soldarlas con acetona: menos bailoteo al
// pegar y mas superficie de contacto para que agarre la soldadura
cm_cuello = 5;     // ancho de la cola junto a la cara de union
cm_base   = 9;     // ancho en el fondo (lo que no sale tirando)
cm_prof   = 8;     // profundidad hacia dentro de la pieza
cm_alto   = 40;    // tramo por el que desliza (abierto por arriba)
cm_holg   = 0.15;  // holgura por lado en la caja: ajuste prieto

/* --------------------- PROBETA DEL AGUJERO ----------------------- */
prueba_ancho  = 18;   // celda del agujero normal
prueba_brecha = 5;    // hasta el canto donde va el agujero cortado

// =====================================================================
//  CAMINOS: recta + arcos TANGENTES en el plano (avance, altura).
//  "dir" es el rumbo en grados: 0 = perpendicular a la pared, +90 =
//  hacia arriba. Cada arco arranca con el rumbo que dejo el tramo
//  anterior, asi que la curva sale continua sin retocar nada a mano.
// =====================================================================
function recta(p, dir, largo, n = 2) =
    largo <= 0 ? [] : [for (i = [1:n]) p + largo * i/n * [cos(dir), sin(dir)]];

function arco(p, dir, r, barrido, n = 16) =
    let (s = sign(barrido), c = p + r * s * [-sin(dir), cos(dir)])
    [for (i = [1:n]) let (a = dir + barrido * i/n) c + r * s * [sin(a), -cos(a)]];

// camino completo de un gancho: raiz hundida en el liston (siempre
// perpendicular, es lo que da la union solida) + dos arcos + recta final
function camino(raiz, r1, a1, r2, a2, largo_recta) =
    let (p0 = [-raiz, 0])
    let (t1 = recta(p0, 0, raiz))
    let (t2 = arco(t1[len(t1)-1], 0, r1, a1))
    let (t3 = arco(t2[len(t2)-1], a1, r2, a2))
    let (t4 = recta(t3[len(t3)-1], a1 + a2, largo_recta))
    concat([p0], t1, t2, t3, t4);

function camino_brazo() = camino(brazo_raiz, brazo_r1, brazo_a1,
                                 brazo_r2, brazo_a2, brazo_recta);
function camino_peq()   = camino(peq_raiz, peq_r1, peq_a1,
                                 peq_r2, peq_a2, peq_recta);
function camino_lat()   = camino(lat_raiz, lat_r1, lat_a1,
                                 lat_r2, lat_a2, lat_recta);

// diametro a lo largo del camino: afina de la raiz a la punta con una
// curva concava, que deja la base acampanada (union fuerte y sin
// escalon) y el resto del brazo esbelto
function d_tubo(d0, d1, t) = d1 + (d0 - d1) * pow(1 - t, 1.4);

// bulto de un gancho ya colocado, para cuadrar la pieza con la cama:
// [lo que vuela desde la cara frontal, lo que se va al lado, techo, suelo].
// El giro del plano reparte la "subida" del camino entre lado y altura.
function bulto(cam, d0, d1, d_bola, z0 = 0, giro = 0) =
    let (n = len(cam) - 1)
    let (r = [for (i = [0:n]) (i == n ? d_bola : d_tubo(d0, d1, i/n)) / 2])
    [max([for (i = [0:n]) cam[i].x + r[i]]),
     max([for (i = [0:n]) cam[i].y * sin(giro) + r[i]]),
     max([for (i = [0:n]) z0 + cam[i].y * cos(giro) + r[i]]),
     min([for (i = [0:n]) z0 + cam[i].y * cos(giro) - r[i]])];

// =====================================================================
//  CALCULOS
// =====================================================================
largo       = sep_tornillos + 2*margen;
largo_medio = largo / 2;
lat_x       = largo_medio - lat_margen;   // raiz del gancho lateral

brazo_bulto = bulto(camino_brazo(), brazo_d, brazo_d_fin, brazo_bola, brazo_z);
peq_bulto   = bulto(camino_peq(), peq_d, peq_d_fin, peq_bola, peq_z);
lat_bulto   = bulto(camino_lat(), lat_d, lat_d_fin, lat_bola, lat_z, lat_giro);

// hasta donde llega el gancho lateral pasado el canto del liston
lat_saliente = lat_x + lat_bulto[1] - largo_medio;

// la pieza se imprime de pie, apoyada en el canto inferior del liston
// (Y = -grosor/2 queda vertical): en la CAMA entra el largo del liston
// (X) y el grosor mas lo que vuelan los ganchos hacia fuera (Y); lo que
// sube en Z es la altura del liston mas lo que suben o bajan los ganchos
huella = [max(largo_medio, lat_x + lat_bulto[1]) + cm_prof,
          grosor + max(brazo_bulto[0], peq_bulto[0], lat_bulto[0])];

altura_impresion = max(alto/2, brazo_bulto[2], peq_bulto[2], lat_bulto[2])
                  - min(-alto/2, brazo_bulto[3], peq_bulto[3], lat_bulto[3]);

// separacion libre entre cada par de ganchos (brazo o pequeño), midiendo
// de superficie a superficie en X: como ya no comparten vertical, lo que
// importa es que no se toquen ni se apiñen entre si
ganchos_planos = concat([for (x = brazo_x) [x, brazo_d]],
                        [for (x = peq_x) [x, peq_d]]);
separacion_min = min([for (i = [0:len(ganchos_planos)-2], j = [i+1:len(ganchos_planos)-1])
                      abs(ganchos_planos[i][0] - ganchos_planos[j][0])
                      - (ganchos_planos[i][1] + ganchos_planos[j][1])/2]);

echo(str("Perchero: ", largo, " x ", alto, " x ", grosor, " mm en 2 mitades"));
echo(str("Ganchos alternados por mitad: brazo largo en ", brazo_x,
         ", pequeño en ", peq_x, " mm de la union",
         " + 1 gancho lateral con la raiz a ", lat_margen,
         " mm del canto, que se sale ", lat_saliente, " mm por el lado"));
echo(str("Vuelo: brazo largo ", brazo_bulto[0] + grosor,
         " mm desde la pared (punta a ", brazo_bulto[2],
         " mm del centro), gancho lateral ", lat_bulto[0] + grosor, " mm"));
echo(str("Separacion minima entre ganchos vecinos: ", separacion_min, " mm"));
echo(str("Huella al imprimir: ", huella, " mm sobre cama de ", cama,
         " mm, ", altura_impresion, " mm de alto (maximo ", altura_max, " mm)"));

// =====================================================================
//  COMPROBACIONES
// =====================================================================
assert(d_cabeza > d_vastago, "d_cabeza tiene que ser mayor que d_vastago");
assert(grosor - prof_cabeza >= 3,
       "prof_cabeza deja menos de 3 mm de pared trasera: sube grosor o baja prof_cabeza");
assert(cm_base < grosor - 4, "cm_base no deja pared suficiente dentro de grosor");
assert(cm_alto < alto, "cm_alto no puede ser mayor que alto");
assert(huella.x <= cama.x - 8 && huella.y <= cama.y - 8,
       "una mitad no cabe en la cama: baja margen o acorta el gancho lateral");
assert(altura_impresion <= altura_max - 5,
       "de pie, la pieza no entra en la altura Z de la impresora");
assert(min([brazo_bulto[3], peq_bulto[3], lat_bulto[3]]) >= -alto/2,
       "algun gancho baja mas que el canto inferior del liston: el apoyo en la cama dejaria de ser plano");
assert(min([for (gx = concat(brazo_x, peq_x)) largo_medio - margen - gx]) > 30,
       "un gancho se acerca demasiado al agujero de tornillo");
assert(min(brazo_x) > cm_prof + brazo_d,
       "un brazo largo pisa la cola de milano");
assert(min(peq_x) > cm_prof + peq_d,
       "un gancho pequeño pisa la cola de milano");
assert(separacion_min >= 8,
       "dos ganchos vecinos (brazo o pequeño) quedan demasiado juntos: separa mas brazo_x/peq_x");
assert(lat_saliente >= 8,
       "el gancho lateral no llega a sobresalir por el canto: sube lat_giro o baja lat_margen");
assert(lat_margen >= lat_d/2 + 2,
       "la raiz del gancho lateral se sale por la cara del extremo");
assert(norm([largo_medio - margen - lat_x, lat_z]) > lat_d/2 + d_cabeza/2 + 2,
       "la raiz del gancho lateral pisa el agujero de tornillo");

// =====================================================================
//  AGUJERO DE TORNILLO: avellanado (d_cabeza) en la cara frontal
//  (Y = +grosor/2) + pasante (d_vastago) por todo el grosor.
// =====================================================================
module agujero_tornillo() {
    rotate([-90, 0, 0])
        cylinder(h = grosor + 2, d = d_vastago, center = true);
    translate([0, grosor/2 - prof_cabeza, 0])
        rotate([-90, 0, 0])
            cylinder(h = prof_cabeza + 0.1, d = d_cabeza);
}

// =====================================================================
//  TUBO: cadena de esferas hulleadas a lo largo del camino, con el
//  diametro de d_tubo(). Se construye en el plano Y-Z (Y = hacia fuera
//  de la pared) y remata en bola.
// =====================================================================
module tubo(cam, d0, d1, d_bola) {
    n = len(cam) - 1;
    for (i = [0:n-1])
        hull() {
            translate([0, cam[i].x, cam[i].y])
                sphere(d = d_tubo(d0, d1, i/n), $fn = 32);
            translate([0, cam[i+1].x, cam[i+1].y])
                sphere(d = d_tubo(d0, d1, (i+1)/n), $fn = 32);
        }
    translate([0, cam[n].x, cam[n].y]) sphere(d = d_bola, $fn = 48);
}

module gancho_brazo(x) {
    translate([x, grosor/2, brazo_z])
        tubo(camino_brazo(), brazo_d, brazo_d_fin, brazo_bola);
}

module gancho_peq(x) {
    translate([x, grosor/2, peq_z])
        tubo(camino_peq(), peq_d, peq_d_fin, peq_bola);
}

// gancho lateral: el mismo tubo, con la raiz en la cara de delante como
// los demas y el plano girado sobre el eje de la raiz hacia el extremo,
// asi que sale de frente y acaba pasado el canto
module gancho_lateral() {
    translate([lat_x, grosor/2, lat_z])
        rotate([0, lat_giro, 0])
            tubo(camino_lat(), lat_d, lat_d_fin, lat_bola);
}

// =====================================================================
//  COLA DE MILANO: seccion trapezoidal en el plano X-Y (X = profundidad
//  hacia dentro de la pieza, Y = ancho a lo largo del grosor), extruida
//  en Z: solo se monta deslizando en vertical.
// =====================================================================
function cola2d(holg = 0) = [
    [0,       -(cm_cuello/2 + holg)],
    [cm_prof, -(cm_base/2   + holg)],
    [cm_prof,  (cm_base/2   + holg)],
    [0,        (cm_cuello/2 + holg)],
];

module cola_hueco() {
    translate([0, 0, alto/2 - cm_alto])
        linear_extrude(cm_alto + 1)
            polygon(cola2d(cm_holg));
}

module cola_macho() {
    translate([0, 0, alto/2 - cm_alto])
        linear_extrude(cm_alto)
            mirror([1, 0, 0]) polygon(cola2d(0));
}

// =====================================================================
//  MITAD: cuerpo con redondeo solo en el extremo del tornillo; la cara
//  de union (x = 0) queda a escuadra. El corte final por la cara de
//  pared deja la trasera plana pase lo que pase con las raices de los
//  ganchos, que se hunden en el liston.
// =====================================================================
module mitad(union_central) {   // union_central = "hueco" | "macho"
    hole_x = largo_medio - margen;
    difference() {
        union() {
            translate([largo_medio/2, 0, 0])
                cuboid([largo_medio, grosor, alto], rounding = redondeo, edges = RIGHT);
            for (x = brazo_x) gancho_brazo(x);
            for (x = peq_x) gancho_peq(x);
            gancho_lateral();
            if (union_central == "macho") cola_macho();
        }
        translate([hole_x, 0, 0]) agujero_tornillo();
        if (union_central == "hueco") cola_hueco();
        translate([largo_medio/2, -grosor/2 - alto/2, 0])
            cube([largo_medio*2 + 4*alto, alto, 4*alto], center = true);
    }
}

module prueba() {
    prueba_largo = prueba_ancho + prueba_brecha;
    difference() {
        cuboid([prueba_largo, grosor, prueba_ancho], rounding = redondeo, edges = LEFT);
        translate([-prueba_largo/2 + prueba_ancho/2, 0, 0]) agujero_tornillo();
        translate([prueba_largo/2, 0, 0]) agujero_tornillo();
    }
}

// =====================================================================
//  ORIENTACION DE IMPRESION: la pieza ya nace de pie (cara de pared
//  vertical, ganchos saliendo de costado); solo hay que levantarla para
//  que su canto inferior (Z = -alto_pieza/2) apoye en la cama.
// =====================================================================
module para_imprimir(alto_pieza) {
    translate([0, 0, alto_pieza/2]) children();
}

// =====================================================================
//  SALIDA
//  "izquierda" y "derecha" tienen que ser espejo real una de otra, si no
//  la union repite el mismo lado dos veces. mitad() siempre construye
//  con la union en su x=0 y el tornillo hacia +x, asi que la mitad
//  "izquierda" se refleja.
// =====================================================================
if (pieza == "izquierda") para_imprimir(alto) mirror([1, 0, 0]) mitad("hueco");
else if (pieza == "derecha") para_imprimir(alto) mitad("macho");
else if (pieza == "prueba") para_imprimir(prueba_ancho) prueba();
else if (pieza == "vista")
    union() {
        mirror([1, 0, 0]) mitad("hueco");
        mitad("macho");
    }
else assert(false, str("pieza desconocida: ", pieza));
