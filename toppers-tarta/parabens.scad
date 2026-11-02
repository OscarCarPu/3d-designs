// Topper "Parabéns" -> parabens.stl
// Palabra 110 x 44 mm (estirada un 10 % en vertical), mas la aguja de 60 mm. Ver topper-lib.scad.
use <topper-lib.scad>

lineas = ["Parabéns"];
alto   = 24.5;
estirar = 1.1;  // 10 % mas alta, mismo ancho

// Uniones a mano, propuestas por tools/pinceladas.py y repasadas a ojo. Ver
// "LAS UNIONES" en topper-lib.scad antes de tocarlas. El comentario es el
// hueco que cierra cada una.
//
// De la propuesta se quito una de rigidez entre la 'é' y la 'n' (hueco de
// 2,06 mm): para cerrarlo el filete necesitaba r=1,28 y con ese radio se comia
// todo el blanco entre las dos letras. Ese hueco ya lo cose el de 0,09 mm de
// mas abajo.
//
// Tambien se quito la de la panza de la 'P' con la 'a' (hueco de 2,27 mm):
// el filete pegaba la P al resto de la palabra y se veia mal. La P ya la cose
// la barra por el pie.
fuerte = 2.4;   // altura del filete de lo que cuelga, ver topper-lib.scad
entero = 4.0;   // el trazo de refuerzo llega a la cara: sin el, por encima de
                // 'fuerte' la tilde sigue suelta en los 4 mm de la letra

remaches = [
    // Imprescindible: cuelga, no llega a la barra.
    [[   27.57,   12.52], 3.2, 1.17, fuerte],   // 1.84 mm  tilde de la é

    // Rigidez: atan letras que solo se tocan de canto, para que no bailen.
    [[  -39.52,   19.57], 3.2, 0.97],   // 1.44 mm  swash de la P
    [[  -23.02,    9.15], 3.2, 0.60],   // 0.52 mm
    [[    3.07,    9.15], 3.2, 0.60],   // 0.50 mm
    [[    9.35,    0.32], 3.2, 0.60],   // 0.58 mm
    [[   19.69,    5.79], 3.2, 0.92],   // 1.34 mm
    [[   33.07,    4.38], 3.2, 0.60],   // 0.09 mm
    [[   43.91,    1.14], 3.2, 1.16],   // 1.81 mm
];

// Refuerzo de lo que cuelga: el filete solo deja un cuello de reloj de arena;
// este trazo recto le da cuerpo hasta la cara de la letra.
pinceladas = [
    [[  27.60,  10.90], [  27.80,  14.40], 1.4, entero],   // tilde de la é
];

vista = "3d";   // "3d" | "2d" | "2d-grueso" | "letras" | "cotas"
topper(lineas = lineas, alto = alto, estirar = estirar, remaches = remaches,
       pinceladas = pinceladas, vista = vista);
