// =====================================================================
//  Perchero de pared, sujeto con 2 tornillos, EN DOS MITADES
//
//  De una pieza no cabe en la cama de la Core One+ (250 x 220 mm), asi
//  que se parte por el medio en dos mitades iguales que se unen con una
//  COLA DE MILANO que atraviesa todo el grosor: una lleva la caja
//  (hueco) y la otra la espiga. Se encajan empujando una mitad contra la
//  otra en perpendicular a la pared; una vez atornilladas, la pared y los
//  tornillos impiden que se separen.
//
//  Cada agujero de tornillo tiene DOS diametros: d_vastago pasante y
//  d_cabeza avellanado "prof_cabeza" mm en la cara frontal, para que la
//  cabeza del tornillo quede hundida.
//
//  GANCHOS SUELTOS. Cada gancho es una pieza PLANA aparte: su perfil
//  (vastago + cuello de cisne + bola) se imprime tumbado en la cama, asi
//  que toda la pieza, raiz y curva incluidas, trabaja a lo largo de las
//  capas y no hace falta ningun soporte. Seccion rectangular con los
//  cantos redondeados, mas alta en la raiz y afinando hacia la punta.
//    - brazo largo (en brazo_x): sale perpendicular a la pared, se
//      levanta con dos arcos tangentes y remata en bola. Lo colgado cae
//      al fondo del hueco entre el brazo y el liston.
//    - gancho pequeño (en peq_x): baja un poco y cierra hacia arriba.
//    - gancho grande (uno por mitad, junto al extremo): el gordo, para
//      bolsas, paraguas o una percha.
//
//  MONTAJE DE CADA GANCHO. El vastago entra por delante en una ranura
//  que atraviesa el liston; el peso lo intenta girar y lo aguantan las
//  caras de la ranura (compresion). Para que no se salga hacia delante,
//  un PASADOR de seccion cuadrada baja desde el canto de arriba del
//  liston por un canal vertical y atraviesa la cola del vastago. Se
//  queda en su sitio por gravedad (apoya en un escalon) y se saca
//  empujandolo desde el canto de abajo por un agujero mas fino, asi que
//  un gancho se puede cambiar con el perchero ya colgado.
//  Canal y agujero van en DIAMANTE (cuadrado girado 45°) para que tanto
//  el liston como el gancho los impriman sin puentes.
//
//  ORIENTACION DE IMPRESION:
//    - mitades del liston: TUMBADAS sobre la cara de la pared. La cara
//      de delante queda arriba (limpia), el avellanado y las ranuras
//      salen verticales y la huella grande agarra mejor a la cama. Las
//      dos mitades caben juntas en una placa.
//    - ganchos: tumbados sobre una de sus caras planas.
//    - pasadores: tumbados.
//
//  Piezas ("pieza"):
//    "izquierda" = mitad con la CAJA de la cola de milano.
//    "derecha"   = mitad con la ESPIGA.
//    "brazo" | "pequeno" | "grande" = ganchos (2 + 1 + 1 por mitad).
//    "pasador"   = uno por gancho (8 en total).
//    "prueba"    = placa pequeña con dos agujeros de tornillo, uno normal
//                  y otro cortado en el canto para ver el avellanado.
//    "prueba_ranura" = trozo de liston con una ranura de gancho pequeño
//                  y su canal, para probar holguras con un "pequeno" y
//                  un "pasador" antes de imprimir las mitades.
//    "vista"     = todo montado (NO para imprimir).
//
//  Unidades: milimetros. Necesita la libreria BOSL2.
// =====================================================================

include <BOSL2/std.scad>

/* --------------------- QUE EXPORTAR -------------------------- */
pieza = "izquierda";   // "izquierda" | "derecha" | "brazo" | "pequeno" | "grande"
                       // | "pasador" | "prueba" | "prueba_ranura" | "vista"

$fn = 64;

/* --------------------- TORNILLOS ------------------------------ */
sep_tornillos = 365;   // distancia ENTRE CENTROS de los dos tornillos
d_vastago     = 5;     // agujero interior, pasante (caña del tornillo)
d_cabeza      = 9;     // agujero exterior, avellanado (cabeza del tornillo)
prof_cabeza   = 6;     // profundidad del avellanado desde la cara frontal

/* --------------------- LISTON ---------------------------------- */
margen   = 30;   // de cada tornillo al extremo del liston
alto     = 68;   // altura del liston
grosor   = 18;   // espesor, de cara frontal a cara de pared: es el largo
                 // de la ranura, el brazo de palanca con el que el liston
                 // aguanta el giro de cada gancho
redondeo = 3;    // redondeo del canto exterior (la cara de union va a escuadra)

/* --------------------- CAMA DE LA IMPRESORA -------------------- */
cama = [250, 220];   // Core One+, lo que obliga a partir el perchero

/* --------------------- GANCHOS: COMUN --------------------------- */
g_holg  = 0.1;   // holgura por lado entre vastago y ranura (0.2 bailaba un poco)
g_canto = 2;     // redondeo de los cantos del gancho
g_pared = 0.3;   // la cola del vastago se queda corta de la pared: apoya
                 // el liston, no los ganchos

/* --------------------- GANCHOS: ALTERNADOS ---------------------- */
// medidos desde la cara de union: brazo - peq - brazo a paso constante,
// medio paso hasta la union para que el ritmo siga en la otra mitad
paso    = 60;
brazo_x = [paso/2, 2.5*paso];
peq_x   = [1.5*paso];

// brazo largo (sombreros, perchas, asas de bolsa)
brazo_z     = 10;    // altura del vastago respecto al centro del liston
brazo_ancho = 16;    // grosor de la pieza plana
brazo_d     = 18;    // alto de la seccion en la raiz: la que mas flexion
                     // aguanta (16 x 18 ~ un redondo de 20)
brazo_d_fin = 10;    // alto en la punta
brazo_bola  = 14;    // bola del remate
brazo_r1    = 26;    // primer arco: despega de la perpendicular
brazo_a1    = 50;
brazo_r2    = 40;    // segundo arco: endereza el cuello de cisne
brazo_a2    = 25;
brazo_recta = 8;     // tramo recto antes de la bola

// gancho pequeño (abrigos, lazadas)
peq_z     = -16;
peq_ancho = 14;
peq_d     = 15;
peq_d_fin = 9;
peq_bola  = 12;
peq_r1    = 10;      // baja al salir del liston
peq_a1    = -30;
peq_r2    = 11;      // cierra hacia arriba
peq_a2    = 135;
peq_recta = 0;

// gancho grande, junto al extremo
gr_margen = 14;      // del extremo del liston al centro del vastago
gr_z      = -6;
gr_ancho  = 16;
gr_d      = 20;      // el mas gordo: es el que tiene que aguantar peso
gr_d_fin  = 11;
gr_bola   = 15;
gr_r1     = 12;      // baja al salir del liston
gr_a1     = -30;
gr_r2     = 16;      // cierra hacia arriba
gr_a2     = 150;
gr_recta  = 0;

/* --------------------- PASADOR ---------------------------------- */
pas_lado    = 6;     // lado del cuadrado (va montado en diamante)
pas_holg    = 0.2;   // holgura por lado en canal y agujero
pas_trasera = 3;     // material del gancho entre el pasador y la pared
pas_fondo   = 6;     // lo que sigue el canal por debajo de la ranura mas baja
pas_salida  = 3;     // lado del agujero de abajo, para sacarlo empujando

/* --------------------- UNION CENTRAL (cola de milano) ------------ */
// trapecio en el plano de la pared, atraviesa todo el grosor
cm_cuello = 16;    // alto de la cola junto a la cara de union
cm_base   = 24;    // alto en el fondo (lo que no sale tirando)
cm_prof   = 8;     // profundidad hacia dentro de la pieza
cm_holg   = 0.15;  // holgura por lado en la caja: ajuste prieto

/* --------------------- PROBETA DEL AGUJERO ----------------------- */
prueba_ancho  = 18;   // celda del agujero normal
prueba_brecha = 5;    // hasta el canto donde va el agujero cortado

// =====================================================================
//  CAMINOS: arcos TANGENTES + recta en el plano (avance, altura) del
//  gancho, desde la cara frontal del liston. "dir" es el rumbo en
//  grados: 0 = perpendicular a la pared, +90 = hacia arriba.
// =====================================================================
function recta(p, dir, largo, n = 2) =
    largo <= 0 ? [] : [for (i = [1:n]) p + largo * i/n * [cos(dir), sin(dir)]];

function arco(p, dir, r, barrido, n = 16) =
    let (s = sign(barrido), c = p + r * s * [-sin(dir), cos(dir)])
    [for (i = [1:n]) let (a = dir + barrido * i/n) c + r * s * [sin(a), -cos(a)]];

function camino(r1, a1, r2, a2, largo_recta) =
    let (p0 = [0, 0])
    let (t1 = arco(p0, 0, r1, a1))
    let (t2 = arco(t1[len(t1)-1], a1, r2, a2))
    let (t3 = recta(t2[len(t2)-1], a1 + a2, largo_recta))
    concat([p0], t1, t2, t3);

// alto de la seccion a lo largo del camino: afina de la raiz a la punta
// con una curva concava (raiz acampanada, resto esbelto)
function d_tubo(d0, d1, t) = d1 + (d0 - d1) * pow(1 - t, 1.4);

// un gancho = [ancho, alto raiz, alto punta, bola, camino]
BRAZO   = [brazo_ancho, brazo_d, brazo_d_fin, brazo_bola,
           camino(brazo_r1, brazo_a1, brazo_r2, brazo_a2, brazo_recta)];
PEQUENO = [peq_ancho, peq_d, peq_d_fin, peq_bola,
           camino(peq_r1, peq_a1, peq_r2, peq_a2, peq_recta)];
GRANDE  = [gr_ancho, gr_d, gr_d_fin, gr_bola,
           camino(gr_r1, gr_a1, gr_r2, gr_a2, gr_recta)];

// =====================================================================
//  CALCULOS
// =====================================================================
largo       = sep_tornillos + 2*margen;
largo_medio = largo / 2;
hole_x      = largo_medio - margen;    // tornillo, desde la cara de union
gr_x        = largo_medio - gr_margen;

// pasador: diamante de lado s, medio diagonal s/√2
pas_hueco = pas_lado + 2*pas_holg;
pas_semi  = pas_hueco / sqrt(2);
// centro del canal, medido hacia delante desde la cara de pared
pas_y     = g_pared + pas_trasera + pas_semi;

// todos los ganchos montados: [x, z, gancho]
ganchos = concat([for (x = brazo_x) [x, brazo_z, BRAZO]],
                 [for (x = peq_x)   [x, peq_z, PEQUENO]],
                 [[gr_x, gr_z, GRANDE]]);

// escalon del canal: el pasador baja hasta pas_fondo por debajo de la
// ranura mas baja; todos los pasadores salen iguales
pas_tope  = min([for (g = ganchos) g[1] - g[2][1]/2 - g_holg]) - pas_fondo;
pas_largo = alto/2 - pas_tope - 0.5;

// distancia de un punto a un rectangulo (centro c, semilados h)
function dist_rect(p, c, h) =
    norm([max(abs(p.x - c.x) - h.x, 0), max(abs(p.y - c.y) - h.y, 0)]);

function semi_ranura(g) = [g[2][0]/2 + g_holg, g[2][1]/2 + g_holg];

separacion_min = min([for (i = [0:len(ganchos)-2], j = [i+1:len(ganchos)-1])
                      abs(ganchos[i][0] - ganchos[j][0])
                      - semi_ranura(ganchos[i]).x - semi_ranura(ganchos[j]).x]);

echo(str("Perchero: ", largo, " x ", alto, " x ", grosor, " mm en 2 mitades"));
echo(str("Mitad tumbada: ", largo_medio + cm_prof, " x ", alto,
         " mm (cama ", cama, ")"));
echo(str("Pasador: ", pas_lado, " x ", pas_lado, " x ", pas_largo, " mm"));
echo(str("Separacion minima entre ranuras vecinas: ", separacion_min, " mm"));

// =====================================================================
//  COMPROBACIONES
// =====================================================================
assert(d_cabeza > d_vastago, "d_cabeza tiene que ser mayor que d_vastago");
assert(grosor - prof_cabeza >= 3,
       "prof_cabeza deja menos de 3 mm de pared trasera: sube grosor o baja prof_cabeza");
assert(largo_medio + cm_prof <= cama.x - 8 && 2*alto + 10 <= cama.y,
       "las dos mitades tumbadas no caben juntas en la cama");
assert(cm_base < alto - 20, "la cola de milano no deja liston por encima y por debajo");
for (g = ganchos) {
    h = semi_ranura(g);
    assert(alto/2 - (g[1] + h.y) >= 6 && (g[1] - h.y) + alto/2 >= 6,
           str("la ranura del gancho en x=", g[0], " deja menos de 6 mm hasta un canto"));
    assert(dist_rect([hole_x, 0], [g[0], g[1]], h) >= d_cabeza/2 + 3,
           str("la ranura del gancho en x=", g[0], " pisa el tornillo"));
    assert(g[0] - h.x >= cm_prof + 6,
           str("la ranura del gancho en x=", g[0], " pisa la cola de milano"));
    assert(largo_medio - (g[0] + h.x) >= 4,
           str("la ranura del gancho en x=", g[0], " se sale por el extremo"));
    assert(g[2][0]/2 - pas_semi >= 2,
           str("el gancho de ", g[2][0], " mm de ancho deja menos de 2 mm a los lados del pasador"));
    assert(abs(hole_x - g[0]) - pas_semi >= d_cabeza/2 + 3,
           str("el canal del pasador en x=", g[0], " pisa el tornillo"));
}
assert(separacion_min >= 8,
       "dos ranuras vecinas quedan demasiado juntas: separa mas brazo_x/peq_x");
assert(pas_y + pas_semi <= grosor - 4,
       "el canal del pasador deja menos de 4 mm de liston por delante");
assert(pas_tope + alto/2 >= 3, "el escalon del pasador queda pegado al canto de abajo");

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

// prisma de seccion cuadrada girada 45° (vertices en ±X y ±Y), en Z
module diamante(lado, z0, z1) {
    translate([0, 0, z0])
        linear_extrude(z1 - z0)
            rotate(45) square(lado, center = true);
}

// =====================================================================
//  GANCHO, en su sistema propio: X = ancho de la pieza plana (centrado),
//  Y = avance desde la cara frontal del liston (0) hacia fuera, Z =
//  altura desde el eje del vastago. El vastago va de la pared (-grosor)
//  a la cara frontal; fuera del liston, cadena de discos redondeados
//  a lo largo del camino.
// =====================================================================
module gancho(g) {
    ancho = g[0]; d0 = g[1]; d1 = g[2]; d_bola = g[3]; cam = g[4];
    n = len(cam) - 1;
    largo_v = grosor - g_pared;
    module disco(p, d)
        translate([0, p.x, p.y])
            cyl(l = ancho, d = d, rounding = g_canto, orient = RIGHT, $fn = 48);
    difference() {
        union() {
            translate([0, -largo_v/2, 0])
                cuboid([ancho, largo_v, d0], rounding = g_canto, edges = "Y");
            for (i = [0:n-1])
                hull() {
                    disco(cam[i], d_tubo(d0, d1, i/n));
                    disco(cam[i+1], d_tubo(d0, d1, (i+1)/n));
                }
            disco(cam[n], d_bola);
        }
        // agujero del pasador, atravesando la cola en vertical
        translate([0, -grosor + pas_y, 0])
            diamante(pas_hueco, -d0, d0);
    }
}

// ranura pasante que se le quita al liston, en el sistema del gancho
module hueco_gancho(g) {
    translate([0, -grosor/2, 0])
        cube([g[0] + 2*g_holg, grosor + 2, g[1] + 2*g_holg], center = true);
}

// canal del pasador, en coordenadas del liston (Y = 0 en el centro)
module canal_pasador(x) {
    translate([x, -grosor/2 + pas_y, 0]) {
        diamante(pas_hueco, pas_tope, alto/2 + 1);
        diamante(pas_salida, -alto/2 - 1, pas_tope + 0.01);
    }
}

// tumbado sobre una cara, con las puntas achaflanadas para que entre
module pasador() {
    cuboid([pas_largo, pas_lado, pas_lado], chamfer = 0.6,
           edges = [LEFT, RIGHT], anchor = BOTTOM);
}

// gancho colocado en el liston: (x, z) del eje del vastago
module en_liston(x, z) translate([x, grosor/2, z]) children();

// =====================================================================
//  COLA DE MILANO: trapecio en el plano X-Z (X = profundidad hacia
//  dentro de la pieza, Z = alto), extruido a lo largo de todo el grosor.
// =====================================================================
function cola2d(holg = 0, x0 = 0) = [
    [x0,      -(cm_cuello/2 + holg)],
    [cm_prof, -(cm_base/2   + holg)],
    [cm_prof,  (cm_base/2   + holg)],
    [x0,       (cm_cuello/2 + holg)],
];

module cola(holg = 0, h = grosor, x0 = 0)
    rotate([90, 0, 0]) linear_extrude(h, center = true) polygon(cola2d(holg, x0));

// =====================================================================
//  MITAD: cuerpo con redondeo solo en el extremo del tornillo; la cara
//  de union (x = 0) queda a escuadra.
// =====================================================================
module mitad(union_central) {   // union_central = "hueco" | "macho"
    difference() {
        union() {
            translate([largo_medio/2, 0, 0])
                cuboid([largo_medio, grosor, alto], rounding = redondeo, edges = RIGHT);
            if (union_central == "macho") mirror([1, 0, 0]) cola(x0 = -0.01);
        }
        translate([hole_x, 0, 0]) agujero_tornillo();
        if (union_central == "hueco") cola(cm_holg, grosor + 2, -0.01);
        for (g = ganchos) {
            en_liston(g[0], g[1]) hueco_gancho(g[2]);
            canal_pasador(g[0]);
        }
    }
}

module ganchos_montados() {
    for (g = ganchos) {
        color("darkorange") en_liston(g[0], g[1]) gancho(g[2]);
        color("gold") translate([g[0], -grosor/2 + pas_y, pas_tope])
            rotate(45) translate([-pas_lado/2, -pas_lado/2, 0])
                cube([pas_lado, pas_lado, pas_largo]);
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

// trozo de liston con la ranura y el canal de un gancho pequeño
module prueba_ranura() {
    difference() {
        cuboid([peq_ancho + 16, grosor, alto]);
        en_liston(0, peq_z) hueco_gancho(PEQUENO);
        canal_pasador(0);
    }
}

// =====================================================================
//  ORIENTACIONES DE IMPRESION
// =====================================================================
// liston: cara de pared (Y = -grosor/2) sobre la cama
module tumbar_liston() translate([0, 0, grosor/2]) rotate([90, 0, 0]) children();

// gancho: tumbado sobre su cara X = -ancho/2
module tumbar_gancho(g) translate([0, 0, g[0]/2]) rotate([0, -90, 0]) children();

// =====================================================================
//  SALIDA
//  "izquierda" y "derecha" tienen que ser espejo real una de otra, si no
//  la union repite el mismo lado dos veces. mitad() siempre construye
//  con la union en su x=0 y el tornillo hacia +x, asi que la mitad
//  "izquierda" se refleja.
// =====================================================================
if (pieza == "izquierda") tumbar_liston() mirror([1, 0, 0]) mitad("hueco");
else if (pieza == "derecha") tumbar_liston() mitad("macho");
else if (pieza == "brazo") tumbar_gancho(BRAZO) gancho(BRAZO);
else if (pieza == "pequeno") tumbar_gancho(PEQUENO) gancho(PEQUENO);
else if (pieza == "grande") tumbar_gancho(GRANDE) gancho(GRANDE);
else if (pieza == "pasador") pasador();
else if (pieza == "prueba") translate([0, 0, prueba_ancho/2]) prueba();
else if (pieza == "prueba_ranura") tumbar_liston() prueba_ranura();
else if (pieza == "vista")
    union() {
        color("ivory") mirror([1, 0, 0]) mitad("hueco");
        color("ivory") mitad("macho");
        mirror([1, 0, 0]) ganchos_montados();
        ganchos_montados();
    }
else assert(false, str("pieza desconocida: ", pieza));
