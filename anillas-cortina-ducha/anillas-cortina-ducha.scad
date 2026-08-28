// =====================================================================
//  Anillas para cortina de ducha
//  Barra de 22 mm, ojal perforado de ~7 mm.
//
//  Una sola pieza PLANA con dos partes:
//    - ARO CERRADO que rodea la barra. Cerrado = hay que descolgar la
//      barra para montarlas, pero no hay nada que se abra con el tiron
//      de la cortina y desliza mucho mejor que un gancho en C.
//    - GANCHO ABIERTO para el ojal. La cortina se pone y se quita sin
//      tocar las anillas ni la barra.
//
//  REGLA QUE NO SE PUEDE ROMPER: ningun hueco abierto de la pieza
//  (holgura_barra, hueco) puede ser mayor que su seccion mas fina.
//  Si lo es, una anilla tumbada se cuela por el hueco de la de al lado
//  y quedan eslabonadas. Con la regla puesta es imposible.
//
//  Se imprime TUMBADA (el plano de la anilla sobre la cama):
//    - sin soportes, sin voladizos, contacto amplio con la cama
//    - los hilos de cada capa recorren el aro y el gancho a lo largo,
//      que es la direccion en la que tira la cortina: no hay ninguna
//      union entre capas trabajando a traccion
//
//  Unidades: milimetros. Sin librerias externas.
// =====================================================================

/* --------------------- QUE EXPORTAR ------------------------- */
// "anilla" = una sola     |  "placa" = tanda para imprimir
pieza  = "anilla";
copias = 12;      // solo para "placa"
cols   = 4;       // columnas de la placa
sep    = 5;       // separacion entre piezas en la placa

/* --------------------- BARRA -------------------------------- */
d_barra       = 22;    // diametro EXTERIOR del tubo de la barra
holgura_barra = 2;     // aire por lado dentro del aro (ver README)
                       // TIENE que ser menor que la seccion mas fina
                       // de la pieza o las anillas se eslabonan: al
                       // tumbarse, el borde de una entra por el hueco
                       // entre barra y aro de la de al lado.
                       // Lo comprueba el assert del final.

/* --------------------- ARO ---------------------------------- */
w_aro   = 4.5;   // grosor radial del aro
grosor  = 4;     // espesor de la pieza (altura de impresion)

/* --------------------- REDONDEO ------------------------------ */
redondeo     = 0.8;   // radio del redondeo del cuello y el gancho
redondeo_aro = 2;     // radio del redondeo del aro (ver README:
                       // "la barra tiene un escalon entre tramos").
                       // Puede subirse mas que `redondeo` porque el
                       // aro es macizo (w_aro y grosor dan margen);
                       // el gancho no, su alambre (w_gancho) ya es
                       // la seccion minima de toda la pieza.

/* --------------------- GANCHO ------------------------------- */
w_gancho  = 3.0;   // seccion del alambre del gancho
r_gancho  = 4.0;   // radio interior de la curva (aloja el ojal)
hueco     = 2.5;   // abertura por la que entra la cortina
                   // misma regla que holgura_barra: por 3,5 mm cabia
                   // el cuello (3,0 mm) de la anilla vecina

/* --------------------- CUELLO ------------------------------- */
cuello   = 3;          // hueco libre entre aro y gancho
w_cuello = w_gancho;   // igual al alambre: el entronque sale sin escalon
w_union  = 9;          // ancho del cuello donde se pega al aro

/* --------------------- CALIDAD ------------------------------ */
n_aro    = 96;
n_gancho = 64;
n_esfera = 12;    // facetas de la esfera de redondeo (0,8 mm: no se ve)

/* =====================================================================
   GEOMETRIA DERIVADA
   ===================================================================== */
r_int = d_barra/2 + holgura_barra;   // radio interior del aro
r_ext = r_int + w_aro;               // radio exterior del aro

// Seccion mas fina de toda la pieza, medida en su dimension menor.
// Ninguna anilla puede meterse por un hueco mas estrecho que esto.
seccion_min = min(w_gancho, w_cuello, w_aro, grosor);

assert(holgura_barra < seccion_min,
       str("holgura_barra (", holgura_barra, ") debe ser < ", seccion_min,
           " o las anillas se eslabonan entre si"));
assert(hueco < seccion_min,
       str("hueco (", hueco, ") debe ser < ", seccion_min,
           " o el cuello de la anilla vecina entra por el gancho"));

// El redondeo se hace encogiendo el perfil "r_esf" antes de extruir y
// volviendolo a engordar con minkowski (ver mas abajo). Si "r_esf" llega
// a la mitad de una seccion, esa seccion desaparece del perfil en vez de
// redondearse: el aro y el resto (cuello+gancho) se redondean por
// separado y cada uno tiene su propio margen.
r_esf     = redondeo*cos(180/n_esfera);
r_esf_aro = redondeo_aro*cos(180/n_esfera);

assert(2*r_esf < min(w_gancho, w_cuello, grosor),
       str("redondeo (", redondeo, ") es demasiado grande: el cuello o el gancho se quedan sin seccion"));
assert(2*r_esf_aro < min(w_aro, grosor),
       str("redondeo_aro (", redondeo_aro, ") es demasiado grande: el aro se queda sin seccion"));

r_c  = r_gancho + w_gancho/2;        // radio de la linea media del gancho
cy   = -(r_ext + cuello + r_gancho + w_gancho);   // centro del gancho

// El alambre arranca justo debajo del cuello (90 grados) y da la vuelta
// completa menos lo que hace falta para dejar "hueco" libre entre su
// punta y el cuello: esa separacion es la cuerda entre los dos extremos.
a_ini = 90;
a_fin = 90 - 2*asin(min(0.98, (hueco + w_gancho) / (2*r_c)));

/* =====================================================================
   PERFIL 2D
   ===================================================================== */

// Sector circular desde el centro, valido tambien para angulos > 180.
module sector(r, a1, a2, n) {
    polygon(concat([[0, 0]],
        [for (i = [0:n]) let (a = a1 + (a2 - a1)*i/n) r*[cos(a), sin(a)]]));
}

// Perfil del aro solo. Va aparte porque se redondea con "redondeo_aro",
// distinto del resto de la pieza (ver seccion REDONDEO mas arriba).
module perfil_aro() {
    difference() {
        circle(r = r_ext, $fn = n_aro);
        circle(r = r_int, $fn = n_aro);
    }
}

// Cuello + gancho. El borde inferior del trapecio del cuello cae dentro
// de la banda radial del aro (entre r_int y r_ext) a proposito: aunque
// el aro y el resto se redondeen por separado y con distinto radio,
// siguen solapando ahi y la union no deja hueco.
module perfil_resto() {
    union() {
        // --- cuello: trapecio, ancho arriba para no hacer esquina viva ---
        polygon([[-w_cuello/2, cy + r_c],
                 [ w_cuello/2, cy + r_c],
                 [ w_union/2,  -r_ext + w_aro/2],
                 [-w_union/2,  -r_ext + w_aro/2]]);

        // --- gancho: anillo al que se le quita el sector del hueco ---
        translate([0, cy]) difference() {
            difference() {
                circle(r = r_c + w_gancho/2, $fn = n_gancho);
                circle(r = r_c - w_gancho/2, $fn = n_gancho);
            }
            sector(r_c + w_gancho, a_fin, a_ini, n_gancho);
        }

        // --- extremos redondeados: la punta, y el arranque bajo el
        //     cuello (tapan las dos caras rectas del corte) ---
        for (a = [a_ini, a_fin])
            translate([0, cy] + r_c*[cos(a), sin(a)])
                circle(d = w_gancho, $fn = 32);
    }
}

/* =====================================================================
   EXTRUSION CON TODOS LOS CANTOS REDONDEADOS
   El perfil se encoge, se extruye mas bajo y se vuelve a engordar con
   una esfera: la pieza sale a su medida y sin una sola arista viva.
   Se encoge y se sube "r_esf" y no "redondeo" porque la esfera facetada
   engorda eso y no su radio; asi las cotas salen clavadas y la pieza
   apoya en z=0.

   El aro y el resto (cuello+gancho) pasan por este mismo truco por
   separado, cada uno con su propio radio (redondeo_aro / redondeo) y
   su propio "r_esf" (r_esf_aro / r_esf), y se unen ya en 3D. Los dos
   arrancan en z=0 y miden "grosor" de alto sea cual sea su redondeo,
   asi que encajan sin escalon entre ellos.
   ===================================================================== */
module redondear(r_esf_local, r_redondeo) {
    translate([0, 0, r_esf_local])
    minkowski() {
        linear_extrude(grosor - 2*r_esf_local)
            offset(delta = -r_esf_local) children();
        sphere(r = r_redondeo, $fn = n_esfera);
    }
}

module anilla() {
    union() {
        redondear(r_esf_aro, redondeo_aro) perfil_aro();
        redondear(r_esf,     redondeo)     perfil_resto();
    }
}

/* =====================================================================
   PLACA
   ===================================================================== */
module placa() {
    paso_x = 2*r_ext + sep;
    paso_y = (r_ext - cy + w_gancho/2 + r_c) + sep;
    for (i = [0:copias-1])
        translate([(i % cols)*paso_x, -floor(i/cols)*paso_y, 0]) anilla();
}

/* ===================================================================== */
if (pieza == "placa") placa();
else                  anilla();

echo(str("Anilla: ", 2*r_ext, " x ",
         r_ext - (cy - r_c - w_gancho/2), " x ", grosor, " mm"));
echo(str("Diametro interior del aro: ", 2*r_int, " mm para barra de ",
         d_barra, " mm"));
echo(str("Anti-enganche: huecos ", holgura_barra, " / ", hueco,
         " mm frente a seccion minima de ", seccion_min, " mm"));
echo(str("Redondeo: aro ", redondeo_aro, " mm, cuello/gancho ", redondeo, " mm"));
