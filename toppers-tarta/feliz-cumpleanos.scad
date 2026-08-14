// Topper "Feliz cumpleaños" -> feliz-cumpleanos.stl
// Palabra 134 x 22 mm, mas la aguja de 85 mm. Ver topper-lib.scad.
//
// Va en Playball, no en Allura: la o, la c y la F de Allura no gustaban, y de
// paso su trazo mas fino se queda en 0,31 mm, por debajo del ancho de linea del
// perfil. Playball no baja de 0,56 mm.
use <topper-lib.scad>

lineas = ["Feliz cumpleaños"];
alto   = 15.6;          // 134 mm de palabra en Playball
fuente = "Playball";

// Uniones a mano, propuestas por tools/pinceladas.py y repasadas a ojo. Ver
// "LAS UNIONES" en topper-lib.scad antes de tocarlas. El comentario es el
// hueco que cierra cada una.
//
// De la propuesta se quitaron cuatro de rigidez:
//   - tres trazos rectos de 2,2 a 5,4 mm, dos de ellos cruzando el espacio
//     entre "Feliz" y "cumpleaños": hacian un zigzag que se veia por el hueco,
//     y ahi ya cose la barra.
//   - un filete de r=1,18 entre la 'l' y la 'i': para cerrar un hueco de
//     1,86 mm necesitaba tanto radio que rellenaba el blanco de las dos.
remaches = [
    // Imprescindibles: cuelgan, no llegan a la barra.
    [[ -39.90,   9.56], 3.2, 0.97],   // 1.44 mm  punto de la i
    [[  46.10,   9.46], 3.2, 0.75],   // 1.00 mm  tilde de la ñ

    // Rigidez: atan letras que solo se tocan de canto, para que no bailen.
    [[ -56.12,   7.27], 3.2, 0.60],   // 0.58 mm
    [[ -49.65,   5.84], 3.2, 0.73],   // 0.95 mm
    [[ -16.00,   6.15], 3.2, 0.72],   // 0.95 mm
    [[  11.75,   7.87], 3.2, 0.60],   // 0.09 mm
    [[  29.69,   5.87], 3.2, 0.71],   // 0.92 mm
    [[  34.75,   2.93], 3.2, 0.60],   // 0.09 mm
    [[  58.94,   2.90], 3.2, 0.60],   // 0.42 mm
    [[  65.13,   1.93], 3.2, 0.60],   // 0.09 mm
];

vista = "3d";   // "3d" | "2d" | "2d-grueso" | "letras" | "cotas"
topper(lineas = lineas, alto = alto, fuente = fuente, remaches = remaches,
       vista = vista);
