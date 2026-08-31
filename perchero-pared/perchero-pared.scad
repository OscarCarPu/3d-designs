// =====================================================================
//  Perchero de pared, sujeto con 2 tornillos, EN DOS MITADES
//
//  De una pieza no cabe en la cama de la Core One+ (250 x 220 mm): con
//  365 mm entre tornillos + margenes son 425 mm. Se parte por el medio
//  en dos mitades identicas en tamaño (~213 mm cada una, sobra de sitio
//  de sobra) que se unen con una COLA DE MILANO deslizante: una lleva
//  la caja (hueco) y la otra la espiga (macho). Se ensamblan deslizando
//  una mitad hacia abajo sobre la otra por la ranura, ya con las dos
//  atornilladas o antes de atornillar la segunda; el peso de lo colgado
//  no tira de la union hacia fuera, solo la mete mas.
//
//  Cada agujero de tornillo tiene DOS diametros:
//    - d_vastago (5 mm): pasante, por donde entra la caña del tornillo
//      hacia la pared.
//    - d_cabeza (9 mm): avellanado en la cara FRONTAL (la visible), un
//      escalon de "prof_cabeza" mm donde se hunde la cabeza del
//      tornillo para que no sobresalga.
//
//  Los ganchos van en DOS NIVELES por mitad, los 3 con la MISMA forma de
//  base -- un gancho de pastor normal y corriente (vastago recto + giro
//  cerrado, seccion circular) -- porque es la forma que de verdad se ve
//  como un gancho y que de verdad engancha por gravedad (el peso empuja
//  el asa hacia el fondo de la curva, no hacia la boca). Lo que cambia
//  entre los 3 NO es solo el punto donde nacen: cada uno tiene su propio
//  grosor, longitud de vastago, radio de curva y angulo, elegidos para su
//  funcion (no un rotate() aplicado desde fuera a la misma pieza):
//    - "bajo" (nivel bajo, 2 por mitad): el mas grueso y largo, para
//      carga real que se balancea -- asas de bolsas y abrigos.
//    - "arriba" (nivel alto, hacia el centro, 1 por mitad): mediano,
//      nace mas vertical -- lazadas ligeras (llaves, bufandas).
//    - "lados" (nivel alto, pegado al canto exterior, 1 por mitad): el
//      mas fino y corto, nace mas tumbado -- cabe en el hueco estrecho
//      junto al agujero de tornillo y remata visualmente el extremo.
//
//  Piezas ("pieza"):
//    "izquierda" = mitad con el agujero de tornillo + la CAJA de la
//                  cola de milano.
//    "derecha"   = mitad con el agujero de tornillo + la ESPIGA.
//    "prueba"    = placa pequeña con DOS agujeros iguales al de la
//                  percha: uno normal (para probar el tornillo de
//                  verdad) y otro cortado justo en el canto, que deja
//                  el escalon del avellanado a la vista.
//    "vista"     = las dos mitades ya montadas, solo para comprobar el
//                  aspecto conjunto (NO para imprimir).
//
//  Las piezas se generan ya en la orientacion de impresion: cara
//  trasera (la de la pared) apoyada en la cama, ganchos hacia arriba.
//  No hace falta rotar nada en el laminador.
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
alto     = 60;   // altura (dimension vertical) del liston (mas alto para
                 // separar bien el nivel de ganchos de arriba y el de abajo)
grosor   = 15;   // espesor del liston, de cara frontal a cara de pared
redondeo = 3;    // redondeo del canto EXTERIOR de cada mitad (el de la
                 // union central queda a escuadra, es cara de encolado)

/* --------------------- GANCHOS: gancho_forma() parametrico ---------- */
// Los 3 usan el mismo modulo gancho_forma(d_base, d_collar, ang_shaft,
// len_shaft, r_curl, sweep_curl, embed) -- ver mas abajo -- cada uno con
// sus propios numeros. ang_shaft ya inclina el gancho en su propia
// geometria local, asi que al colocarlo no hace falta rotate().

// --- NIVEL BAJO: los 4 ganchos de pastor (2 por mitad), el mas grueso ---
nivel_bajo_z   = -16;   // altura (Z) de la base
gancho_margen  = 45;    // separacion minima al agujero de tornillo
bajo_d_base    = 16;    // diametro del vastago: seccion robusta (carga pesada)
bajo_d_collar  = 22;    // diametro de referencia del collar en la base
bajo_ang_shaft = 35;    // angulo del vastago respecto de la vertical (grados)
bajo_r_bend    = 14;    // radio del codo que dobla la raiz hasta ese angulo
bajo_len_shaft = 40;    // longitud del vastago recto
bajo_r_curl    = 11;    // radio de la curva del gancho
bajo_sweep     = 170;   // barrido angular de la curva (grados)

// --- NIVEL ALTO: 1 "arriba" (hacia el centro, mediano) y 1 "lados"
//     (pegado al canto exterior, el mas fino) por mitad ---
nivel_alto_z    = 18;   // altura (Z) de la base
arriba_x        = 90;   // posicion (desde la union)
arriba_d_base   = 10;   // mas fino que el de abajo: carga ligera
arriba_d_collar = 15;
arriba_ang_shaft = 20;  // mas vertical que el de abajo
arriba_r_bend    = 10;  // codo mas cerrado: el angulo a doblar es pequeño
arriba_len_shaft = 26;
arriba_r_curl    = 9;
arriba_sweep     = 150;

lados_x         = 198;  // posicion (desde la union): pegado al canto
                        // exterior del liston, bien marcado como "lateral"
lados_d_base    = 8;    // el mas fino de los 3: cabe en el hueco estrecho
lados_d_collar  = 10;
lados_ang_shaft = 55;   // el mas tumbado: mas horizontal que arriba y bajo
lados_r_bend    = 9;    // codo bien visible: dobla 55° desde la raiz recta
lados_len_shaft = 16;
lados_r_curl    = 7;
lados_sweep     = 150;
lados_medio_ancho = lados_d_collar * 1.3 / 2;  // mitad del ancho en X,
                        // para comprobar holgura contra tornillo/canto

/* --------------------- UNION CENTRAL (cola de milano) ------------ */
cm_cuello = 5;    // ancho de la cola junto a la cara de union (el "cuello")
cm_base   = 9;    // ancho en el fondo (lo que no se puede sacar tirando)
cm_prof   = 6;    // profundidad de la cola hacia dentro de la pieza
cm_alto   = 28;   // tramo de altura por el que desliza (abierto por arriba)
cm_holg   = 0.3;  // holgura por lado en la caja, para que entre sin forzar

/* --------------------- PROBETA DEL AGUJERO ----------------------- */
// Pieza pequeña con DOS agujeros iguales al de la percha:
//   - uno normal, envuelto por todos lados: para probar que el tornillo
//     de verdad entra y la cabeza queda a ras.
//   - otro justo en el canto de la pieza, centrado en ese canto: queda
//     cortado por la mitad y deja el escalon (5/9 mm) A LA VISTA, para
//     comprobar de un vistazo la profundidad del avellanado sin tener
//     que partir ni adivinar nada.
prueba_ancho  = 18;   // celda cuadrada del agujero normal (justo lo que
                      // pide d_cabeza + pared minima)
prueba_brecha = 5;    // separacion hasta el canto donde va el agujero cortado

// =====================================================================
//  COMPROBACIONES
// =====================================================================
assert(d_cabeza > d_vastago, "d_cabeza tiene que ser mayor que d_vastago");
assert(grosor - prof_cabeza >= 3,
       "prof_cabeza deja menos de 3 mm de pared trasera: sube grosor o baja prof_cabeza");
assert(cm_base < grosor - 4, "cm_base no deja pared suficiente dentro de grosor");
assert(cm_alto < alto, "cm_alto no puede ser mayor que alto");
assert(lados_x > largo_medio - margen + lados_medio_ancho,
       "lados_x se mete en el agujero de tornillo: alejalo o revisa gancho_lados_forma()");
assert(lados_x < largo_medio - lados_medio_ancho,
       "lados_x se sale del canto del liston: acercalo o revisa gancho_lados_forma()");

// =====================================================================
//  CALCULOS
// =====================================================================
largo       = sep_tornillos + 2*margen;   // liston completo (solo referencia)
largo_medio = largo / 2;                  // lo que mide cada mitad al imprimir

// nivel bajo: los 4 de siempre (2 por mitad), a partes iguales dentro
// de la zona que deja gancho_margen; posiciones dentro de UNA mitad,
// medidas desde la cara de union (x=0) hacia el extremo del tornillo:
gancho_bajo_zona    = sep_tornillos - 2*gancho_margen;
gancho_bajo_xs      = [for (i = [0:3]) -gancho_bajo_zona/2 + i*gancho_bajo_zona/3];
gancho_bajo_locales = [for (gx = gancho_bajo_xs) if (gx > 0) gx];

echo(str("Perchero: ", largo, " x ", alto, " x ", grosor,
         " mm, en 2 mitades de ", largo_medio, " mm (+", cm_prof,
         " mm de espiga la mitad 'derecha')"));
echo(str("Tornillos separados ", sep_tornillos, " mm, agujero ",
         d_vastago, "/", d_cabeza, " mm (vastago/cabeza), avellanado ",
         prof_cabeza, " mm"));
echo(str("Ganchos por mitad: 2 de pastor (nivel bajo) a ", gancho_bajo_locales,
         " mm de la union, + 1 'arriba' a ", arriba_x,
         " mm y 1 'lados' a ", lados_x, " mm (nivel alto)"));

// =====================================================================
//  AGUJERO DE TORNILLO: avellanado (d_cabeza) en la cara frontal
//  (Y = +grosor/2) + pasante (d_vastago) por todo el grosor.
// =====================================================================
module agujero_tornillo() {
    // vastago: pasante, con margen de sobra a los dos lados
    rotate([-90, 0, 0])
        cylinder(h = grosor + 2, d = d_vastago, center = true);
    // avellanado: solo el ultimo tramo, desde la cara frontal hacia dentro
    translate([0, grosor/2 - prof_cabeza, 0])
        rotate([-90, 0, 0])
            cylinder(h = prof_cabeza + 0.1, d = d_cabeza);
}

// =====================================================================
//  GANCHO DE PASTOR, parametrico. El camino tiene TRES tramos:
//    1. RAIZ: recta y siempre PERPENDICULAR a la pared (pura +Y local),
//       hundida "root_embed" mm dentro del liston -- SIEMPRE en esa
//       direccion, sin importar el angulo del brazo. Es lo que asegura
//       una union solida y profunda con el liston (antes, al hundir el
//       arranque en la misma direccion inclinada del brazo, un angulo
//       muy tumbado apenas penetraba la pared en Y y la base quedaba
//       pegada de canto en vez de fundida).
//    2. CODO: arco de radio "r_bend" que dobla esa raiz perpendicular
//       hasta la direccion del brazo ("ang_shaft" grados). Con angulos
//       pequeños (mas vertical) el codo apenas se nota; con angulos
//       grandes (mas tumbado) se ve un codo real, no un simple giro de
//       toda la pieza -- por eso los 3 ganchos no son la misma curva
//       rotada, sino un brazo que nace igual (perpendicular) y luego se
//       tuerce mas o menos segun su funcion.
//    3. BRAZO + RIZO: tramo recto ("len_shaft") y luego el giro de
//       "sweep_curl" grados con radio "r_curl" que cierra la boca hacia
//       la pared -- el asa cae al fondo de la curva por gravedad, y
//       cualquier balanceo la empuja contra el brazo en vez de hacia la
//       salida.
// =====================================================================
module gancho_forma(d_base, d_collar, ang_shaft, len_shaft, r_curl, sweep_curl,
                     r_bend = undef, root_embed = 6,
                     n_bend = 20, n_shaft = 10, n_curl = 48) {

    r_bend_ = is_undef(r_bend) ? max(8, d_collar * 0.6) : r_bend;

    ux = cos(ang_shaft);  uy = sin(ang_shaft);
    px = -sin(ang_shaft); py = cos(ang_shaft);

    // raiz: recta, pura +Y local, de y=-root_embed a y=0
    path_root = [
        for (i = [0:n_shaft])
            let(t = -root_embed + root_embed * i / n_shaft)
            [0, t, 0]
    ];

    // codo: arco que dobla de "pura +Y" (fi=0) a "direccion del brazo"
    // (fi=ang_shaft), mismo patron r*(1-cos) que el rizo del final
    bend_end_y = r_bend_ * sin(ang_shaft);
    bend_end_z = r_bend_ * (1 - cos(ang_shaft));
    path_bend = [
        for (i = [1:n_bend])
            let(fi = ang_shaft * i / n_bend)
            [0, r_bend_ * sin(fi), r_bend_ * (1 - cos(fi))]
    ];

    // brazo recto, continuando desde el final del codo
    path_shaft = [
        for (i = [1:n_shaft])
            let(s = len_shaft * i / n_shaft)
            [0, bend_end_y + s*ux, bend_end_z + s*uy]
    ];

    shaft_end_y = bend_end_y + len_shaft*ux;
    shaft_end_z = bend_end_z + len_shaft*uy;

    center_y = shaft_end_y + r_curl*px;
    center_z = shaft_end_z + r_curl*py;

    nrx = -px; nry = -py;

    path_curl = [
        for (i = [1:n_curl])
            let(b = sweep_curl * i / n_curl)
            let(rx = nrx*cos(b) - nry*sin(b))
            let(rz = nrx*sin(b) + nry*cos(b))
            [0, center_y + r_curl*rx, center_z + r_curl*rz]
    ];

    path = concat(path_root, path_bend, path_shaft, path_curl);

    path_sweep(circle(d = d_base, $fn = 32), path, closed = false);

    tip = path[len(path) - 1];
    translate(tip) sphere(d = d_base);

    // collar: sigue el mismo camino real (raiz -> mitad del codo), asi
    // queda bien fundido con el liston pase lo que pase con ang_shaft
    bend_mid_y = r_bend_ * sin(ang_shaft/2);
    bend_mid_z = r_bend_ * (1 - cos(ang_shaft/2));
    hull() {
        translate([0, -root_embed, 0])
            scale([1, 0.45, 1])
                sphere(d = d_collar * 1.3);
        translate([0, bend_mid_y, bend_mid_z])
            sphere(d = d_collar * 0.85);
        translate([0, bend_end_y + len_shaft * 0.3 * ux, bend_end_z + len_shaft * 0.3 * uy])
            sphere(d = d_collar * 0.72);
    }
}

// =====================================================================
//  Los 3 ganchos: misma forma base, cada uno con su propio grosor,
//  longitud de brazo, radio de curva y angulo (ver seccion de
//  parametros mas arriba) -- solo cambia donde nace cada uno en el
//  liston (x, z0), no un rotate() encima de la misma pieza. El angulo
//  de cada uno se resuelve con su propio codo (ver gancho_forma), no
//  con un giro externo de la misma curva.
// =====================================================================
module gancho_bajo(x) {
    translate([x, grosor/2, nivel_bajo_z])
        gancho_forma(bajo_d_base, bajo_d_collar, bajo_ang_shaft,
                      bajo_len_shaft, bajo_r_curl, bajo_sweep,
                      r_bend = bajo_r_bend, root_embed = 6);
}
module gancho_arriba() {
    translate([arriba_x, grosor/2, nivel_alto_z])
        gancho_forma(arriba_d_base, arriba_d_collar, arriba_ang_shaft,
                      arriba_len_shaft, arriba_r_curl, arriba_sweep,
                      r_bend = arriba_r_bend, root_embed = 6);
}
module gancho_lados() {
    translate([lados_x, grosor/2, nivel_alto_z])
        gancho_forma(lados_d_base, lados_d_collar, lados_ang_shaft,
                      lados_len_shaft, lados_r_curl, lados_sweep,
                      r_bend = lados_r_bend, root_embed = 6);
}

// =====================================================================
//  COLA DE MILANO: seccion trapezoidal en el plano X-Y (X = profundidad
//  hacia dentro de la pieza, Y = ancho a lo largo del grosor), extruida
//  en Z. Al extruirse en Z, la unica forma de montarla es deslizando
//  verticalmente; tirar en X (a lo largo del liston) no la saca.
// =====================================================================
function cola2d(holg = 0) = [
    [0,       -(cm_cuello/2 + holg)],
    [cm_prof, -(cm_base/2   + holg)],
    [cm_prof,  (cm_base/2   + holg)],
    [0,        (cm_cuello/2 + holg)],
];

// caja: se resta de la mitad "izquierda", abierta por arriba
module cola_hueco() {
    translate([0, 0, alto/2 - cm_alto])
        linear_extrude(cm_alto + 1)
            polygon(cola2d(cm_holg));
}

// espiga: se suma a la mitad "derecha", sobresale hacia -X desde x=0
module cola_macho() {
    translate([0, 0, alto/2 - cm_alto])
        linear_extrude(cm_alto)
            mirror([1, 0, 0]) polygon(cola2d(0));
}

// =====================================================================
//  MITAD: cuerpo con redondeo solo en el extremo del tornillo (x =
//  largo_medio); la cara de union (x = 0) queda a escuadra.
// =====================================================================
module mitad(union_central) {   // union_central = "hueco" | "macho"
    hole_x = largo_medio - margen;
    union() {
        difference() {
            translate([largo_medio/2, 0, 0])
                cuboid([largo_medio, grosor, alto], rounding = redondeo, edges = RIGHT);
            translate([hole_x, 0, 0]) agujero_tornillo();
            if (union_central == "hueco") cola_hueco();
        }
        // nivel bajo: los 2 ganchos de pastor (carga pesada) de esta mitad
        for (gx = gancho_bajo_locales) gancho_bajo(gx);
        // nivel alto: "arriba" (brazo en "?", lazadas) y "lados" (coma/remate)
        gancho_arriba();
        gancho_lados();
        if (union_central == "macho") cola_macho();
    }
}

module prueba() {
    prueba_largo = prueba_ancho + prueba_brecha;
    difference() {
        // redondeo solo en el extremo del agujero normal; el otro canto
        // tiene que quedar a escuadra, es donde se ve la seccion.
        cuboid([prueba_largo, grosor, prueba_ancho], rounding = redondeo, edges = LEFT);
        // agujero normal, centrado en su celda
        translate([-prueba_largo/2 + prueba_ancho/2, 0, 0]) agujero_tornillo();
        // agujero cortado: centrado justo en el canto derecho
        translate([prueba_largo/2, 0, 0]) agujero_tornillo();
    }
}

// =====================================================================
//  ORIENTACION DE IMPRESION: tumba la pieza para que la cara trasera
//  (Y = -grosor/2) quede apoyada en la cama y los ganchos apunten hacia
//  arriba con su inclinacion, sin soportes.
// =====================================================================
module para_imprimir() {
    rotate([90, 0, 0]) translate([0, grosor/2, 0]) children();
}

// =====================================================================
//  SALIDA
// =====================================================================
// "izquierda" y "derecha" tienen que ser espejo real una de otra (no
// solo dos copias con hueco/macho distinto), si no la union queda con
// el mismo lado repetido dos veces y no hay forma de encajarlas sin
// que una acabe con la cara frontal mirando a la pared. mitad() siempre
// construye con la union en su x=0 local y el tornillo hacia +x, asi
// que la mitad "izquierda" se refleja para que su union quede a SU
// derecha (mirando al centro) y el tornillo a su izquierda (el extremo
// de la percha); "derecha" se deja tal cual.
if (pieza == "izquierda") para_imprimir() mirror([1, 0, 0]) mitad("hueco");
else if (pieza == "derecha") para_imprimir() mitad("macho");
else if (pieza == "prueba") para_imprimir() prueba();
else if (pieza == "vista")
    union() {
        mirror([1, 0, 0]) mitad("hueco");
        mitad("macho");
    }
else assert(false, str("pieza desconocida: ", pieza));
