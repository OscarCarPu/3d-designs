// Topper "Parabéns" -> parabens.stl
// Palabra 110 x 40 mm, mas la aguja de 85 mm. Ver topper-lib.scad.
use <topper-lib.scad>

lineas = ["Parabéns"];
alto   = 24.5;

// Uniones a mano, propuestas por tools/pinceladas.py y repasadas a ojo. Ver
// "LAS UNIONES" en topper-lib.scad antes de tocarlas. El comentario es el
// hueco que cierra cada una.
//
// De la propuesta se quito una de rigidez entre la 'é' y la 'n' (hueco de
// 2,06 mm): para cerrarlo el filete necesitaba r=1,28 y con ese radio se comia
// todo el blanco entre las dos letras. Ese hueco ya lo cose el de 0,09 mm de
// mas abajo.
remaches = [
    // Imprescindible: cuelga, no llega a la barra.
    [[  27.57,  11.38], 3.2, 1.17],   // 1.84 mm  tilde de la é

    // Rigidez: atan letras que solo se tocan de canto, para que no bailen.
    [[ -39.52,  17.79], 3.2, 0.97],   // 1.44 mm  swash de la P
    [[ -31.37,   9.29], 3.2, 1.39],   // 2.27 mm
    [[ -23.02,   8.32], 3.2, 0.60],   // 0.52 mm
    [[   3.07,   8.32], 3.2, 0.60],   // 0.50 mm
    [[   9.35,   0.29], 3.2, 0.60],   // 0.58 mm
    [[  19.69,   5.26], 3.2, 0.92],   // 1.34 mm
    [[  33.07,   3.98], 3.2, 0.60],   // 0.09 mm
    [[  43.91,   1.04], 3.2, 1.16],   // 1.81 mm
];

vista = "3d";   // "3d" | "2d" | "2d-grueso" | "letras" | "cotas"
topper(lineas = lineas, alto = alto, remaches = remaches, vista = vista);
