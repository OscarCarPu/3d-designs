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
//  GANCHOS. Copian el gancho clasico de latón de perchero/sombrerera:
//  cada puesto es un GANCHO DOBLE en la misma vertical, no dos niveles
//  repartidos a lo largo del liston:
//    - brazo largo: sale perpendicular a la pared, se levanta con dos
//      arcos tangentes (cuello de cisne) y remata en bola. La curva es
//      concava hacia la pared, asi que lo que se cuelga cae al fondo del
//      hueco entre el brazo y el liston, no hacia la boca.
//    - gancho pequeño: nace mas abajo, baja un poco y cierra hacia
//      arriba; la bola de la punta hace de tope.
//  Los dos salen del mismo camino parametrico (recta + arcos tangentes,
//  seccion circular que va afinando de la raiz a la punta), no hay tres
//  formas distintas ni codos raros.
//
//  Diferencia a proposito con la foto: el brazo largo va mas tumbado que
//  el de latón. Las piezas se imprimen con la cara de pared en la cama y
//  los ganchos hacia arriba, asi que la inclinacion del brazo ES el
//  angulo de voladizo; pasando de ~75 grados habria que meter soportes.
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
alto     = 60;   // altura del liston: el gancho doble lo cruza entero
grosor   = 15;   // espesor, de cara frontal a cara de pared
redondeo = 3;    // redondeo del canto exterior (la cara de union va a escuadra)

/* --------------------- CAMA DE LA IMPRESORA -------------------- */
cama = [250, 220];   // Core One+, lo que obliga a partir el perchero

/* --------------------- GANCHOS DOBLES -------------------------- */
ganchos_x = [45, 135];   // puesto de cada gancho doble en la mitad,
                         // medido desde la cara de union

// brazo largo (sombreros, perchas, asas de bolsa)
brazo_z     = 8;     // altura de la raiz: en el tercio de arriba del liston
brazo_raiz  = 7;     // cuanto se hunde la raiz en el liston
brazo_d     = 16;    // diametro en la raiz
brazo_d_fin = 9;     // diametro en la punta
brazo_bola  = 13;    // bola del remate
brazo_r1    = 26;    // primer arco: despega de la perpendicular
brazo_a1    = 50;
brazo_r2    = 40;    // segundo arco: endereza el cuello de cisne
brazo_a2    = 25;
brazo_recta = 8;     // tramo recto antes de la bola

// gancho pequeño (abrigos, lazadas)
peq_z     = -22;
peq_raiz  = 7;
peq_d     = 13;
peq_d_fin = 8;
peq_bola  = 11;
peq_r1    = 10;      // baja al salir del liston
peq_a1    = -30;
peq_r2    = 11;      // cierra hacia arriba
peq_a2    = 135;
peq_recta = 0;

// gancho lateral: nace en la cara de delante, con el plano girado hacia
// el extremo para acabar sobresaliendo por el canto
lat_giro   = 55;     // 0 = como los de delante, 90 = plano tumbado del todo
lat_margen = 11;     // del extremo del liston a la raiz
lat_z      = -10;
lat_raiz   = 7;
lat_d      = 15;     // el mas gordo: es el que tiene que aguantar peso
lat_d_fin  = 9;
lat_bola   = 13;
lat_r1     = 12;     // baja al salir del liston
lat_a1     = -30;
lat_r2     = 16;     // cierra hacia arriba y hacia el lado
lat_a2     = 150;
lat_recta  = 0;

/* --------------------- UNION CENTRAL (cola de milano) ------------ */
cm_cuello = 5;    // ancho de la cola junto a la cara de union
cm_base   = 9;    // ancho en el fondo (lo que no sale tirando)
cm_prof   = 6;    // profundidad hacia dentro de la pieza
cm_alto   = 28;   // tramo por el que desliza (abierto por arriba)
cm_holg   = 0.3;  // holgura por lado en la caja

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

// el camino con su altura y su radio en cada punto (la bola al final),
// para medir huecos entre un gancho y otro
function ptos(cam, z0, d0, d1, d_bola) =
    let (n = len(cam) - 1)
    [for (i = [0:n]) [cam[i] + [0, z0],
                      (i == n ? d_bola : d_tubo(d0, d1, i/n)) / 2]];

function hueco(a, b) =
    min([for (p = a) for (q = b) norm(p[0] - q[0]) - p[1] - q[1]]);

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

// lo que ocupa una mitad en la cama (se imprime tumbada, asi que el alto
// del liston y lo que sobresalen los ganchos por arriba y por abajo van
// en el ANCHO de la huella, y el vuelo de los brazos en la altura)
huella = [max(largo_medio, lat_x + lat_bulto[1]) + cm_prof,
          max(alto/2, brazo_bulto[2], peq_bulto[2], lat_bulto[2])
          - min(-alto/2, brazo_bulto[3], peq_bulto[3], lat_bulto[3])];

// hueco libre entre el brazo largo y el gancho pequeño del mismo puesto:
// por ahi entra la lazada del abrigo, asi que si el brazo se tumba sobre
// el pequeño la boca se cierra y el pequeño no sirve para nada
boca = hueco(ptos(camino_brazo(), brazo_z, brazo_d, brazo_d_fin, brazo_bola),
             ptos(camino_peq(), peq_z, peq_d, peq_d_fin, peq_bola));

echo(str("Perchero: ", largo, " x ", alto, " x ", grosor, " mm en 2 mitades"));
echo(str("Ganchos dobles por mitad a ", ganchos_x, " mm de la union",
         " + 1 gancho lateral con la raiz a ", lat_margen,
         " mm del canto, que se sale ", lat_saliente, " mm por el lado"));
echo(str("Vuelo: brazo largo ", brazo_bulto[0] + grosor,
         " mm desde la pared (punta a ", brazo_bulto[2],
         " mm del centro), gancho lateral ", lat_bulto[0] + grosor, " mm"));
echo(str("Boca entre el brazo largo y el gancho pequeño: ", boca, " mm"));
echo(str("Huella al imprimir: ", huella, " mm sobre cama de ", cama, " mm"));

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
assert(min([for (gx = ganchos_x) largo_medio - margen - gx]) > 30,
       "un gancho doble se acerca demasiado al agujero de tornillo");
assert(min(ganchos_x) > cm_prof + brazo_d,
       "un gancho doble pisa la cola de milano");
assert(brazo_a1 + brazo_a2 <= 75,
       "el brazo largo queda tan vertical que al imprimirlo pide soportes");
assert(boca >= 10,
       "el brazo largo cierra la boca del gancho pequeño: sube brazo_z o baja peq_z");
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

// gancho doble: brazo largo + gancho pequeño en la misma vertical
module gancho_doble(x) {
    translate([x, grosor/2, brazo_z])
        tubo(camino_brazo(), brazo_d, brazo_d_fin, brazo_bola);
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
            for (gx = ganchos_x) gancho_doble(gx);
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
//  ORIENTACION DE IMPRESION: tumba la pieza para que la cara trasera
//  (Y = -grosor/2) apoye en la cama y los ganchos apunten hacia arriba.
// =====================================================================
module para_imprimir() {
    rotate([90, 0, 0]) translate([0, grosor/2, 0]) children();
}

// =====================================================================
//  SALIDA
//  "izquierda" y "derecha" tienen que ser espejo real una de otra, si no
//  la union repite el mismo lado dos veces. mitad() siempre construye
//  con la union en su x=0 y el tornillo hacia +x, asi que la mitad
//  "izquierda" se refleja.
// =====================================================================
if (pieza == "izquierda") para_imprimir() mirror([1, 0, 0]) mitad("hueco");
else if (pieza == "derecha") para_imprimir() mitad("macho");
else if (pieza == "prueba") para_imprimir() prueba();
else if (pieza == "vista")
    union() {
        mirror([1, 0, 0]) mitad("hueco");
        mitad("macho");
    }
else assert(false, str("pieza desconocida: ", pieza));
