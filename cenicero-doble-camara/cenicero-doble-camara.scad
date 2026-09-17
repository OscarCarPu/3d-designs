// =====================================================================
//  CENICERO DE DOBLE CAMARA — separa "donde se fuma" de "donde se guarda"
// ----------------------------------------------------------------------
//  Piezas a imprimir:
//    cuerpo -> camara inferior, sellada por todos lados salvo el tubo
//              bajante de la tapa: ahi se acumulan ceniza y colillas ya
//              frias, casi sin contacto con el aire de la habitacion.
//    tapa   -> pieza de uso diario, a doble altura: el borde exterior
//              (3 muescas para apoyar el cigarro encendido) y, mas
//              adentro y mas bajo, un plato donde cae la ceniza suelta
//              mientras se fuma. En el centro, un agujero + tubo
//              bajante que se hunde en la camara del cuerpo: al acabar,
//              se empuja colilla y ceniza por ahi y quedan guardadas
//              abajo, ya fuera de la zona donde se huele.
//    tapon  -> sella el agujero entre caladas (opcional, imprime 1).
//
//  Por que el tubo es largo: el aire caliente y oloroso de la camara
//  sube y queda atrapado bajo la tapa, mientras que su unica salida (la
//  boca del tubo) esta 20 mm mas abajo. Es un sifon al reves, sin agua.
//
//  La tapa esta modelada en posicion de impresion: el tubo bajante
//  queda abajo (pared vertical delgada, sin voladizos) y el disco con
//  el plato y las muescas queda arriba, tal cual se usa.
//
//  Activa con 1 lo que quieras dibujar/exportar (0 = no). Milimetros.
// =====================================================================

// --- Que dibujar (1 = si, 0 = no) ---
cuerpo = 1;
tapa   = 0;
tapon  = 0;

$fn = 96;

// --- 1. CUERPO: camara sellada de almacenamiento --------------------
body_od   = 82;
body_wall = 2.4;
body_h    = 46;   // altura total, incluido el suelo
floor_h   = 3;
body_cham = 0.8;  // chaflan anti "pata de elefante"

// --- 2. Encaje tapa/cuerpo: la tapa hace de capuchon por fuera -------
fit_clr    = 0.3; // holgura diametral del faldon sobre el cuerpo
skirt_wall = 2.0;
skirt_h    = 10;  // cuanto abraza el faldon la pared exterior del cuerpo

// --- 3. TAPA: doble altura -------------------------------------------
rim_h      = 12;   // grosor del disco (zona del borde exterior)
dish_depth = 3;    // hondo del plato interior (zona de ceniza suelta)
dish_d     = 58;   // diametro del plato interior

// Muescas para el cigarro (borde exterior, a 120 grados)
notch_n     = 3;
notch_r     = 4;    // radio del canal (controla ancho y curvatura)
notch_depth = 3.5;  // hondo del canal, medido desde la cara superior

// Agujero central + tubo bajante (la garganta hacia la camara sellada).
// El tubo tiene el mismo diametro que el agujero: es el unico camino
// entre el plato y la camara de abajo.
hole_d    = 19;   // deja pasar una colilla incluso de lado
tube_wall = 1.6;
tube_len  = 20;   // cuanto se hunde el tubo en el cuerpo

// --- 4. TAPON del agujero (sella entre caladas) -----------------------
plug_clr = 0.3;   // holgura para que entre y salga sin forzar
plug_h   = 8;     // cuanto se mete por el agujero
head_lip = 3;     // cuanto sobresale la cabeza del hueco: apoya en el plato
head_h   = 2;
tab_l = 12;  tab_w = 5;  tab_h = 10;

// --- Geometria derivada -------------------------------------------------
body_id  = body_od - 2*body_wall;
skirt_id = body_od + fit_clr;
skirt_od = skirt_id + 2*skirt_wall;

// =====================================================================
//  CUERPO: cubo cerrado, solo se abre por arriba (donde entra el tubo).
// =====================================================================
module cenicero_cuerpo() {
    difference() {
        union() {
            cylinder(h = body_cham, d1 = body_od - 2*body_cham, d2 = body_od);
            translate([0, 0, body_cham])
                cylinder(h = body_h - body_cham, d = body_od);
        }
        translate([0, 0, floor_h])
            cylinder(h = body_h - floor_h + 1, d = body_id);
    }
}

// =====================================================================
//  TAPA
// =====================================================================
// Canal redondeado donde se apoya el cigarro: cilindro horizontal que
// solo asoma su parte de arriba sobre la cara del disco (0 = suelo del
// disco, rim_h = cara donde se apoya el cigarro).
module muesca() {
    center_z = rim_h - notch_depth + notch_r;
    L = skirt_od/2 + 6;
    translate([-2, 0, center_z])
        rotate([0, 90, 0])
            cylinder(h = L, d = 2*notch_r);
}

module cenicero_tapa() {
    z_disc = tube_len; // altura donde empieza el disco (apoya en el cuerpo)
    difference() {
        union() {
            // tubo bajante: se hunde en la camara sellada del cuerpo
            cylinder(h = tube_len, d = hole_d + 2*tube_wall);
            // faldon que abraza por fuera el borde superior del cuerpo
            translate([0, 0, z_disc - skirt_h])
                difference() {
                    cylinder(h = skirt_h, d = skirt_od);
                    translate([0, 0, -1]) cylinder(h = skirt_h + 2, d = skirt_id);
                }
            // disco: borde exterior (muescas) + plato interior mas bajo
            translate([0, 0, z_disc])
                cylinder(h = rim_h, d = skirt_od);
        }
        // garganta: agujero del disco + hueco del tubo, de una vez
        translate([0, 0, -1])
            cylinder(h = tube_len + rim_h + 2, d = hole_d);
        // plato interior donde cae la ceniza suelta mientras se fuma
        translate([0, 0, z_disc + rim_h - dish_depth])
            cylinder(h = dish_depth + 1, d = dish_d);
        // muescas para el cigarro, a 120 grados
        for (i = [0 : notch_n - 1])
            translate([0, 0, z_disc]) rotate([0, 0, i*360/notch_n]) muesca();
    }
}

// =====================================================================
//  TAPON: sella el agujero entre caladas para cortar del todo el paso
//  de aire hacia la camara de abajo. Cuerpo que entra por el agujero,
//  cabeza que apoya en el plato (para que no se cuele) y una aleta
//  para sacarlo. Se imprime tal cual: la cabeza crece a 45 grados.
// =====================================================================
module cenicero_tapon() {
    pd = hole_d - 2*plug_clr;
    hd = hole_d + 2*head_lip;
    cylinder(h = plug_h, d = pd);
    translate([0, 0, plug_h])
        cylinder(h = head_lip, d1 = pd, d2 = hd);
    translate([0, 0, plug_h + head_lip])
        cylinder(h = head_h, d = hd);
    translate([-tab_l/2, -tab_w/2, plug_h + head_lip + head_h - 0.01])
        cube([tab_l, tab_w, tab_h]);
}

// =====================================================================
//  RENDER: cada pieza activa en su carril para no solaparse.
// =====================================================================
if (cuerpo) cenicero_cuerpo();
if (tapa)   translate([body_od/2 + skirt_od/2 + 20, 0, 0]) cenicero_tapa();
if (tapon)  translate([body_od/2 + skirt_od/2 + 20, skirt_od + 20, 0]) cenicero_tapon();
