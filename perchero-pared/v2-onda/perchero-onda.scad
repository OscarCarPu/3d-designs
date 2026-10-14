pieza = "vista";

$fn = 48;

sep_tornillos = 365;
vueltas_entre_tornillos = 8;
semialto = 25;
profundidad = 28;
ancho_linea = 10;
suavizado = 5;
lados = 20;

fijaciones = [-4, 4];
tipo_fijacion = "avellanado";
d_vastago = 3;
d_cabeza = 6.5;
prof_cabeza = 3;
d_taco = 18;
grosor_taco = 10;
llave_labio = 3;
llave_fondo = 3.5;
llave_largo = 7;

radio = ancho_linea / 2;
paso = sep_tornillos / vueltas_entre_tornillos;
z_atras = radio;
z_delante = radio + profundidad;
j_inicial = -vueltas_entre_tornillos / 2;
referencia = [0.5, 0.7, 0.3];

function ciclo(j) = let(
    x0 = j * paso, x1 = (j + 1) * paso, x2 = (j + 2) * paso,
    yb = -semialto, yt = semialto
) [
    [x0, yt, z_atras], [x1, yt, z_atras], [x1, yb, z_atras], [x1, yb, z_delante],
    [x1, yt, z_delante], [x2, yt, z_delante], [x2, yb, z_delante], [x2, yb, z_atras]
];

function control() = concat(
    [[j_inicial * paso, -semialto, z_atras]],
    [for (p = [0 : vueltas_entre_tornillos / 2 - 1]) each ciclo(j_inicial + 2 * p)],
    [[-j_inicial * paso, semialto, z_atras]]
);

function chaikin(p, n) = n == 0 ? p : chaikin(
    concat(
        [p[0]],
        [for (i = [0 : len(p) - 2]) each [0.75 * p[i] + 0.25 * p[i + 1], 0.25 * p[i] + 0.75 * p[i + 1]]],
        [p[len(p) - 1]]
    ), n - 1);

camino = chaikin(control(), suavizado);
n_puntos = len(camino);

function unitario(v) = v / norm(v);
function tangente(i) = unitario(camino[min(i + 1, n_puntos - 1)] - camino[max(i - 1, 0)]);
function anillo(i) = let(
    t = tangente(i),
    n = unitario(cross(t, referencia)),
    b = cross(t, n)
) [for (j = [0 : lados - 1]) camino[i] + radio * (cos(360 * j / lados) * n + sin(360 * j / lados) * b)];

module varilla() {
    anillos = [for (i = [0 : n_puntos - 1]) each anillo(i)];
    caras = concat(
        [for (i = [0 : n_puntos - 2], j = [0 : lados - 1])
            [i * lados + j, (i + 1) * lados + j, (i + 1) * lados + (j + 1) % lados, i * lados + (j + 1) % lados]],
        [[for (j = [0 : lados - 1]) j]],
        [[for (j = [lados - 1 : -1 : 0]) (n_puntos - 1) * lados + j]]
    );
    polyhedron(points = anillos, faces = caras, convexity = 10);
}

module alargado(d, h, largo) {
    hull() {
        cylinder(d = d, h = h);
        translate([0, largo, 0]) cylinder(d = d, h = h);
    }
}

module taco() {
    hull() {
        cylinder(d = d_taco, h = grosor_taco);
        if (tipo_fijacion == "cerradura") translate([0, llave_largo, 0]) cylinder(d = d_taco, h = grosor_taco);
    }
}

module agujero_fijacion() {
    if (tipo_fijacion == "cerradura") {
        d_entrada = d_cabeza + 0.5;
        d_cuello = d_vastago + 0.4;
        translate([0, 0, -1]) cylinder(d = d_entrada, h = llave_labio + 1);
        translate([0, 0, -1]) alargado(d_cuello, llave_labio + 1, llave_largo);
        translate([0, 0, llave_labio - 0.01]) alargado(d_entrada, llave_fondo + 0.01, llave_largo);
    } else {
        translate([0, 0, -1]) cylinder(d = d_vastago, h = grosor_taco + 2);
        translate([0, 0, grosor_taco - prof_cabeza]) cylinder(d = d_cabeza, h = prof_cabeza + 1);
    }
}

module completo() {
    difference() {
        union() {
            varilla();
            for (k = fijaciones) translate([k * paso, 0, 0]) taco();
        }
        for (k = fijaciones) translate([k * paso, 0, 0]) agujero_fijacion();
    }
}

x_corte = paso / 2;

module mitad(signo) {
    intersection() {
        completo();
        translate([signo > 0 ? x_corte : x_corte - 400, -100, -1]) cube([400, 200, 200]);
    }
}

if (pieza == "izquierda") mitad(-1);
else if (pieza == "derecha") mitad(1);
else if (pieza == "vista") {
    color("tomato") mitad(-1);
    color("indianred") mitad(1);
}
