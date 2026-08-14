// ============================================================================
//  Topper de tarta: texto decorado + aguja con punta roma.
//  UNA sola pieza, plana, se imprime tumbada y sin soportes.
//
//  Esto es la biblioteca. Una palabra = un .scad que la usa:
//      parabens.scad, feliz-cumpleanos.scad
//
//  Unidades en mm. Fuentes en ./fonts (OFL).
//  Perfil de impresion: core-one-pla-obxidian-speed-toppers (OrcaSlicer).
//
//  Sistema de coordenadas del dibujo (el que se usa en las uniones):
//      x = 0  ->  centro de la palabra
//      y = 0  ->  linea base de la ULTIMA linea; las de arriba se apilan.
//  La aguja son 'aguja_largo' mm hacia abajo desde esa linea base.
//
//  La letra no se deforma. Lo que mantiene la pieza de una sola pieza son la
//  barra del subrayado, la placa de detras y las uniones.
// ============================================================================
//
//  LAS UNIONES
//  -----------
//  Van a mano, una a una, en las listas 'remaches' y 'pinceladas' de cada
//  palabra. Hacen dos trabajos, y conviene no confundirlos:
//
//    a) Coser lo que CUELGA. La barra cose de por si todo lo que baja hasta la
//       linea base, o sea casi todas las letras. Lo que cuelga son las tildes,
//       los puntos de la 'i' y los swash altos de la 'P' o la 'F': sin su union
//       se quedan sueltos en los 4 mm de grosor, aguantados solo por los 0,9 mm
//       de la placa, y se rompen con nada. Estas no se tocan.
//    b) Atar las letras entre ellas para que no bailen. La barra las sujeta
//       solo por el pie y la placa de detras tiene 0,9 mm: sin uniones las
//       letras flexionan unas contra otras y la palabra hace acordeon. Estas
//       son opcionales: si una queda fea, fuera.
//
//  VAN HUNDIDAS. Las uniones se extruyen solo 'union_z' (por defecto los 0,9 mm
//  de la placa de detras), no los 4 mm de la letra. Desde delante se ve la letra
//  y nada mas: la union queda 3 mm por detras de la cara. Si la subes a los 4 mm
//  se lee como parte del trazo y se nota el remiendo — con la union a ras, la
//  'F' parecia dos piezas y las uniones entre letras se veian como barritas a la
//  altura de la letra. A cambio, lo que cuelga (una tilde) queda aguantado por
//  0,9 mm de espesor; si alguna se ve fragil, sube 'union_z' a 1,5-2 mm, que
//  sigue estando hundido.
//
//  LA REGLA: la union va SIEMPRE en el hueco ENTRE dos letras, en el punto
//  donde mas cerca estan una de otra, y nunca por encima de una letra ni
//  cruzando su ojo. Si tapas el ojo de la 'b', de la 'e' o de la 'P', la
//  palabra se lee como un borron. Por eso esto va a mano: aqui hubo un cierre
//  morfologico automatico (offset +r / -r) sobre toda la palabra y rellenaba de
//  golpe todas las contraformas estrechas: el bucle de la 'b', el de la 'P' y
//  el hueco entero bajo el rasgo de la 'P'.
//
//  DOS FORMAS DE UNIR. La normal es el REMACHE, que es ese mismo cierre pero
//  recortado a un disco pequeno: rellena el pico donde los dos trazos se
//  acercan y sale un filete en punta que se funde con los dos, como se ve la
//  tinta de verdad.
//      remache = [[x,y], zona, r]
//      'zona' es el radio del disco donde actua, 3.2 va bien; si lo aprietas,
//      el disco corta el filete a media merma y deja un canto recto que se ve.
//      'r' es el radio del cierre y tiene que pasar de la mitad del hueco. No
//      te pases: con r grande el cierre se come el blanco de alrededor (con
//      r=1,28 en un hueco de 2 mm rellenaba entero el blanco entre la 'é' y la
//      'n'). Por encima de ~1,5 mm de hueco, mejor pincelada.
//
//  La PINCELADA es un trazo recto de ancho constante, solo para cuando el hueco
//  es demasiado grande para un filete:
//      pincelada = [[x0,y0], [x1,y1], grosor]
//      Que solape ~0,3 mm dentro de cada letra; tocarse de canto no vale.
//      Grosor 1,0-1,4 mm: por debajo de 1,0 no llega ni a tres lineas de
//      extrusion (0,4 mm) y se rompe al despegar la pieza de la cama.
//      Ojo: al ser de ancho constante NO se funde con la letra, se lee como una
//      barrita pegada. Con una pincelada de 1,2 sujetando el swash de la 'F',
//      la F se leia como dos piezas; con el remache, como una sola letra.
//
// ============================================================================
//
//  COMO SE HACE UNA PALABRA NUEVA
//  ------------------------------
//  1. Copia parabens.scad, cambia 'lineas' y deja 'remaches = []'.
//
//  2. Elige 'alto'. Ojo: es el cuerpo de la fuente, no el alto de la palabra, y
//     cada fuente necesita uno distinto para la misma anchura. Medidas ya
//     probadas (la aguja son 8,5 cm mas, desde la linea base):
//         Allura   ["Parabéns"]         alto 24.5 -> palabra 110 x 40 mm
//         Allura   ["Felices 15"]       alto 22.4 -> palabra 105 x 38 mm
//         Allura   ["Feliz cumpleaños"] alto 16.6 -> palabra 134 x 33 mm
//         Allura   ["Parabéns Carmén"]  alto 15.7 -> palabra 132 x 33 mm
//         Playball ["Feliz cumpleaños"] alto 15.6 -> palabra 134 x 22 mm
//     Para un texto nuevo, el cuerpo que da una anchura X sale de una regla de
//     tres con textmetrics, que hay que habilitar a mano:
//         openscad --enable=textmetrics ...
//         echo(textmetrics("mi texto", size = 20, font = "Playball").size[0]);
//         alto = 20 * X / ese_ancho
//     Con Allura no bajes de alto 14: es muy fina y sus contraformas se cierran.
//
//  3. Pide las uniones. La herramienta las propone, elige remache o pincelada
//     segun el hueco, y las separa en imprescindibles (lo que cuelga) y rigidez
//     (lo demas):
//         openscad -D 'vista="letras"' -o /tmp/letras.svg mi-palabra.scad
//         python3 tools/pinceladas.py /tmp/letras.svg
//     Copia las listas que escupe y luego REPASALAS a ojo con vista="cotas",
//     que dibuja en rojo lo que anade cada una:
//         openscad -D 'vista="cotas"' mi-palabra.scad
//     Mira cada zona de cerca, no la palabra entera: a tamano de palabra no se
//     ve nada y luego en la pieza se ve todo. Se cae por si sola la mitad de la
//     propuesta; lo que se queda son las de la letra que cuelga y las de los
//     huecos pequenos.
//
//  4. Comprueba que sale UNA sola pieza:
//         openscad -D 'vista="2d"' -o /tmp/capa.svg mi-palabra.scad
//         python3 tools/piezas.py /tmp/capa.svg
//     Tiene que decir "PIEZAS = 1": esa vista es la huella de la placa con las
//     uniones, o sea lo que decide si algo se cae.
//
//     La otra vista, 'vista="2d-grueso"', es la letra a pelo, sin placa y sin
//     uniones. Ahi salen VARIAS a proposito: son justo los trozos que aguantan
//     solo por la placa hundida. Sirve para saber cuales son y decidir si te
//     fias de los 0,9 mm o subes 'union_z'. En estas dos palabras salen:
//         Parabéns          2 -> la tilde de la é
//         Feliz cumpleaños  4 -> swash de la F, punto de la i, tilde de la ñ
//     Si en 'vista="2d"' sale mas de una, la pieza 2 es la suelta: con su
//     coordenada, mira que hueco tiene debajo y une ahi:
//         python3 tools/piezas.py /tmp/capa.svg --sonda 27,28,29
//     A ojo, lo mismo: carga el STL en el laminador y usa "separar en
//     objetos"; si sale mas de uno, falta union.
//
//  5. Exporta el STL e imprime con el perfil -toppers.
// ============================================================================

use <fonts/Allura-Regular.ttf>
use <fonts/Playball-Regular.ttf>
use <fonts/Courgette-Regular.ttf>
use <fonts/KaushanScript-Regular.ttf>
use <fonts/Lobster-Regular.ttf>
use <fonts/GreatVibes-Regular.ttf>

// Tesela adaptativa: curvas finas donde hacen falta. Con $fn fijo la cursiva
// sale facetada y se ven kinks en los trazos.
$fn = 0; $fs = 0.4; $fa = 8;

// ----------------------------------------------------------------------------
//  lineas        una entrada por linea de texto
//  alto          altura de la letra
//  fuente        "Allura", "Playball", "Courgette", "Kaushan Script",
//                "Lobster", "Great Vibes"
//  remaches      uniones a mano, filete conico: [ [[x,y], zona, r], ... ]
//                'zona' es el radio del disco donde actua y 'r' el radio del
//                cierre, que tiene que pasar de la mitad del hueco. Es la
//                forma normal de unir: se funde con los trazos.
//  pinceladas    uniones a mano, trazo recto: [ [[x0,y0],[x1,y1],grosor], ... ]
//                Solo cuando el hueco es tan grande que un filete no llega
//                (>2*r) o no hay nada con que fundirse.
//  barra         subrayado: une palabras y sujeta el arranque de la aguja
//  base          placa fina por detras: es la que da la resistencia
//  interlineado  separacion entre lineas, fraccion de 'alto'; va bajo a
//                proposito, asi las lineas se enganchan entre ellas
//  union_z       altura de las uniones. 0 = automatico: los 0,9 mm de la placa,
//                o los 4 mm si no hay placa. Ver "VAN HUNDIDAS"
//  cierre        suelda letras deformandolas; solo para el look sin barra ni
//                base (prueba 0.9 con Great Vibes y alto 35)
//  aguja_ancho   4,5 mm: con 0,4 de linea y los 6 loops del perfil sale toda
//                de perimetro, y con 4 mm de grosor no flexa al clavarla
//  aguja_largo   8,5 cm desde la linea base del texto
//  vista         "3d"        la pieza, lo que se exporta a STL
//                "2d"        huella de la placa con las uniones, que es lo que
//                            decide si algo se cae -> tools/piezas.py
//                "2d-grueso" la letra a pelo, sin placa y sin uniones: lo que
//                            sale suelto aqui es lo que aguanta solo por la
//                            placa hundida -> tools/piezas.py
//                "letras"    solo las letras           -> tools/pinceladas.py
//                "cotas"     las uniones en rojo sobre la letra, a revisar
// ----------------------------------------------------------------------------

module topper(lineas, alto, fuente = "Allura", remaches = [], pinceladas = [],
              barra = true, base = true, interlineado = 0.62,
              grosor = 4.0, base_z = 0.9, union_z = 0, cierre = 0,
              aguja_ancho = 4.5, aguja_largo = 85, vista = "3d") {

    // Las uniones van HUNDIDAS: solo en la placa de detras, no en los 4 mm de
    // la letra. Asi desde delante se ve la letra y nada mas. Si suben a los 4
    // mm se leen como parte del trazo y se nota el remiendo.
    z_union = union_z > 0 ? union_z : (base ? base_z : grosor);

    // Engorde minimo: la placa de detras es la que da resistencia, asi que al
    // trazo solo se le pide no bajar de ~0.6 mm. Engordar mas aplasta el
    // contraste de la cursiva (los finos crecen mucho y los gruesos poco) y
    // ensucia la letra.
    halo = max(0.30, alto * 0.012);

    if (vista == "3d") {
        if (base)
            linear_extrude(base_z)
                _capa(lineas, alto, fuente, barra, interlineado, cierre,
                      aguja_ancho, aguja_largo, halo);
        linear_extrude(grosor)
            _capa(lineas, alto, fuente, barra, interlineado, cierre,
                  aguja_ancho, aguja_largo, 0);
        linear_extrude(z_union)
            _uniones(remaches, pinceladas, lineas, alto, fuente, interlineado,
                     cierre);

    } else if (vista == "2d") {
        // Huella de la placa de detras, uniones incluidas: es la que dice si
        // algo se cae.
        _capa(lineas, alto, fuente, barra, interlineado, cierre, aguja_ancho,
              aguja_largo, base ? halo : 0);
        _uniones(remaches, pinceladas, lineas, alto, fuente, interlineado,
                 cierre);

    } else if (vista == "2d-grueso") {
        // La capa de la letra a pelo, sin placa y sin uniones: lo que sale
        // suelto aqui es lo que aguanta solo por la placa hundida.
        _capa(lineas, alto, fuente, barra, interlineado, cierre, aguja_ancho,
              aguja_largo, 0);

    } else if (vista == "letras") {
        _letras(lineas, alto, fuente, interlineado, cierre);

    } else if (vista == "cotas") {
        // Las uniones abajo y la letra encima y mas alta: mirando desde arriba,
        // la letra tapa lo que no es anadido. Sin restas: una diferencia de
        // caras coincidentes ensucia la vista previa con artefactos.
        color("red") linear_extrude(1)
            _uniones(remaches, pinceladas, lineas, alto, fuente, interlineado,
                     cierre);
        translate([0, 0, 1])
            linear_extrude(1) _letras(lineas, alto, fuente, interlineado,
                                      cierre);

    } else {
        assert(false, str("vista desconocida: ", vista));
    }
}

// ----------------------------------------------------------------------------
module _letras(lineas, alto, fuente, interlineado, cierre) {
    engorde = max(0.15, alto * 0.007);
    n = len(lineas);
    // La ultima linea apoya en y = 0; las de arriba se apilan sobre ella.
    for (i = [0 : n - 1])
        translate([0, (n - 1 - i) * interlineado * alto])
            _letra_linea(lineas[i], alto, fuente, engorde, cierre);
}

module _letra_linea(linea, alto, fuente, engorde, cierre) {
    if (cierre > 0) offset(r = -cierre) offset(r = cierre)
                        _trazo(linea, alto, fuente, engorde);
    else                _trazo(linea, alto, fuente, engorde);
}

module _trazo(linea, alto, fuente, engorde) {
    offset(r = engorde)
        text(linea, size = alto, font = fuente,
             halign = "center", valign = "baseline");
}

module _uniones(remaches, pinceladas, lineas, alto, fuente, interlineado,
                cierre) {
    _remaches(remaches, lineas, alto, fuente, interlineado, cierre);
    _pinceladas(pinceladas);
}

module _pinceladas(pinceladas) {
    for (p = pinceladas)
        hull() {
            translate(p[0]) circle(d = p[2]);
            translate(p[1]) circle(d = p[2]);
        }
}

// Remache: el cierre morfologico de siempre (offset +r / -r) pero recortado a
// un disco. Dentro del disco rellena el pico entre los dos trazos y sale un
// filete en punta que se funde con los dos, que es como se ve la tinta; fuera
// del disco no toca nada, asi que no se come ninguna contraforma.
//
// El recorte previo a 'zona + 2.5*r' es solo velocidad: el cierre en un punto
// depende de lo que haya a 2*r, asi que lo que se tira no puede cambiar el
// resultado dentro del disco.
module _remaches(remaches, lineas, alto, fuente, interlineado, cierre) {
    for (m = remaches) {
        zona = m[1];
        r    = m[2];
        intersection() {
            offset(r = -r) offset(r = r)
                intersection() {
                    _letras(lineas, alto, fuente, interlineado, cierre);
                    translate(m[0]) circle(r = zona + 2.5 * r);
                }
            translate(m[0]) circle(r = zona);
        }
    }
}

// ----------------------------------------------------------------------------
//  Una capa: 'halo' 0 es el texto tal cual (los 4 mm de grosor), 'halo' > 0 es
//  la placa fina de detras.
// ----------------------------------------------------------------------------
module _capa(lineas, alto, fuente, barra, interlineado, cierre, aguja_ancho,
             aguja_largo, halo) {

    barra_alto   = 1.8;   // fina y por debajo de la linea base: si sube mas,
    barra_solape = 0.5;   // se come el arranque de las letras

    y_barra = barra ? barra_solape - barra_alto : 0;   // borde inferior

    // --- Aguja ---
    solape      = 1.5;   // cuanto se mete la aguja en la barra
    refuerzo_w  = 16;    // ensanche del arranque, contra la barra
    refuerzo_h  = 12;
    punta_largo = 16;
    punta_r     = 1.5;   // punta roma, no corta

    // Se recorta del casco convexo de la ultima linea, asi sale exactamente de
    // su ancho sea cual sea la fuente, el tamano o el texto.
    module barra_2d() {
        intersection() {
            hull() _letra_linea(lineas[len(lineas) - 1], alto, fuente,
                                max(0.15, alto * 0.007), cierre);
            translate([-1000, barra_solape - barra_alto])
                square([2000, barra_alto]);
        }
    }

    // Arranca dentro de la barra y baja hasta -aguja_largo.
    module aguja_2d() {
        y_top = y_barra + solape;
        y_fin = -aguja_largo;
        y_ini = y_fin + punta_largo;
        union() {
            // refuerzo del arranque contra la barra
            polygon([[-refuerzo_w/2, y_top], [refuerzo_w/2, y_top],
                     [ aguja_ancho/2, y_top - refuerzo_h],
                     [-aguja_ancho/2, y_top - refuerzo_h]]);
            translate([-aguja_ancho/2, y_ini])
                square([aguja_ancho, y_top - y_ini]);
            hull() {
                translate([-aguja_ancho/2, y_ini]) square([aguja_ancho, 0.01]);
                translate([0, y_fin + punta_r]) circle(r = punta_r);
            }
        }
    }

    union() {
        if (halo > 0) offset(r = halo) _letras(lineas, alto, fuente,
                                               interlineado, cierre);
        else                          _letras(lineas, alto, fuente,
                                               interlineado, cierre);
        if (barra) barra_2d();
        aguja_2d();
    }
}
