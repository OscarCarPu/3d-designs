// Topper "Feliz cumpleaños" -> feliz-cumpleanos.stl
// Palabra 134 x 24 mm (estirada un 10 % en vertical), mas la aguja de 60 mm. Ver topper-lib.scad.
//
// Va en Playball, no en Allura: la o, la c y la F de Allura no gustaban, y de
// paso su trazo mas fino se queda en 0,31 mm, por debajo del ancho de linea del
// perfil. Playball no baja de 0,56 mm.
use <topper-lib.scad>

lineas = ["Feliz cumpleaños"];
alto   = 15.6;          // 134 mm de palabra en Playball
fuente = "Playball";
estirar = 1.1;          // 10 % mas alta, mismo ancho

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
fuerte = 2.4;   // altura del filete de lo que cuelga, ver topper-lib.scad
entero = 4.0;   // el trazo de refuerzo llega a la cara: sin el, por encima de
                // 'fuerte' la tilde sigue suelta en los 4 mm de la letra

remaches = [
    // Imprescindibles: cuelgan, no llegan a la barra.
    [[  -39.90,   10.52], 3.2, 0.97, fuerte],   // 1.44 mm  punto de la i
    [[   46.10,   10.41], 3.2, 0.75, fuerte],   // 1.00 mm  tilde de la ñ

    // Rigidez: atan letras que solo se tocan de canto, para que no bailen.
    [[  -56.12,    8.00], 3.2, 0.60],   // 0.58 mm
    [[  -49.65,    6.42], 3.2, 0.73],   // 0.95 mm
    [[  -16.00,    6.77], 3.2, 0.72],   // 0.95 mm
    [[   11.75,    8.66], 3.2, 0.60],   // 0.09 mm
    [[   29.69,    6.46], 3.2, 0.71],   // 0.92 mm
    [[   34.75,    3.22], 3.2, 0.60],   // 0.09 mm
    [[   58.94,    3.19], 3.2, 0.60],   // 0.42 mm
    [[   65.13,    2.12], 3.2, 0.60],   // 0.09 mm
];

// Refuerzo de lo que cuelga: el filete solo deja un cuello de reloj de arena;
// este trazo recto le da cuerpo hasta la cara de la letra.
pinceladas = [
    [[ -39.30,   9.00], [ -38.60,  12.40], 1.4, entero],   // punto de la i
    [[  45.60,   9.10], [  45.60,  11.90], 1.4, entero],   // tilde de la ñ
];

vista = "3d";   // "3d" | "2d" | "2d-grueso" | "letras" | "cotas"
topper(lineas = lineas, alto = alto, fuente = fuente, estirar = estirar,
       remaches = remaches, pinceladas = pinceladas, vista = vista);
