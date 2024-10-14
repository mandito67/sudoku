import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';

class Sudoku extends StatefulWidget {
  const Sudoku({super.key});
  @override
  State<Sudoku> createState() => SudokuState();
}

const cellRed = Color(0xffc73232);
const cellMustard = Color(0xffd7aa22);
const cellGreyLight = Color(0xffcfd4e0);
const cellGreyDark = Color.fromARGB(255, 129, 131, 134);
const cellBlue = Color(0xff1553be);
const background = Color.fromARGB(255, 139, 139, 139);

class SudokuState extends State<Sudoku> {
  int timer = 0;
  bool isLoading = true;
  ValueNotifier<int> nivel = ValueNotifier<int>(0);

  Map<int, int> numeros = {
    0: 0,
    1: 0,
    2: 0,
    3: 0,
    4: 0,
    5: 0,
    6: 0,
    7: 0,
    8: 0,
    10: 0,
    11: 0,
    12: 0,
    13: 0,
    14: 0,
    15: 0,
    16: 0,
    17: 0,
    18: 0,
    20: 0,
    21: 0,
    22: 0,
    23: 0,
    24: 0,
    25: 0,
    26: 0,
    27: 0,
    28: 0,
    30: 0,
    31: 0,
    32: 0,
    33: 0,
    34: 0,
    35: 0,
    36: 0,
    37: 0,
    38: 0,
    40: 0,
    41: 0,
    42: 0,
    43: 0,
    44: 0,
    45: 0,
    46: 0,
    47: 0,
    48: 0,
    50: 0,
    51: 0,
    52: 0,
    53: 0,
    54: 0,
    55: 0,
    56: 0,
    57: 0,
    58: 0,
    60: 0,
    61: 0,
    62: 0,
    63: 0,
    64: 0,
    65: 0,
    66: 0,
    67: 0,
    68: 0,
    70: 0,
    71: 0,
    72: 0,
    73: 0,
    74: 0,
    75: 0,
    76: 0,
    77: 0,
    78: 0,
    80: 0,
    81: 0,
    82: 0,
    83: 0,
    84: 0,
    85: 0,
    86: 0,
    87: 0,
    88: 0
  };
  List<int> celdas_ocultas = [];
  int boton_activo = 1;
  int boton_activo_fijo = -1;
  bool tablero_ok = false;
  int intentos = 0;
  bool terminado = false;

  @override
  void initState() {
    super.initState();
    nivel.addListener(() async => cargarNumeros());
  }

  @override
  Widget build(BuildContext context) {
    nivel.value = ModalRoute.of(context)!.settings.arguments as int;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sudoku'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
      ),
      body: Center(
        child: Column(children: [
          Text('activo $boton_activo fijo $boton_activo_fijo'),
          Text(
              'Nivel: ${nivel.value == 1 ? 'Fácil' : nivel.value == 2 ? 'Intermedio' : 'Duro'}',
              style: const TextStyle(fontSize: 20)),
          if (terminado) ...[
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text('Felicidades!!!', style: TextStyle(fontSize: 30)),
            ),
          ],
          if (isLoading) ...[
            const SizedBox(
                height: 350,
                width: 350,
                child: Padding(
                  padding: EdgeInsets.all(100),
                  child: CircularProgressIndicator(),
                ))
          ] else ...[
            Padding(
              padding: const EdgeInsets.all(10),
              child: tablero(),
            ),
            botones()
          ],
          const SizedBox(height: 20),
          opciones(),
        ]),
      ),
    );
  }

  Widget tablero() {
    return Container(
      height: 350,
      width: 350,
      color: background,
      child: LayoutGrid(
        columnGap: 2,
        rowGap: 2,
        areas: '''
                                c00 c01 c02 c03 c04 c05 c06 c07 c08
                                c10 c11 c12 c13 c14 c15 c16 c17 c18
                                c20 c21 c22 c23 c24 c25 c26 c27 c28
                                c30 c31 c32 c33 c34 c35 c36 c37 c38
                                c40 c41 c42 c43 c44 c45 c46 c47 c48
                                c50 c51 c52 c53 c54 c55 c56 c57 c58
                                c60 c61 c62 c63 c64 c65 c66 c67 c68
                                c70 c71 c72 c73 c74 c75 c76 c77 c78
                                c80 c81 c82 c83 c84 c85 c86 c87 c88 
                              ''',
        // A number of extension methods are provided for concise track sizing
        columnSizes: [
          37.0.px,
          37.0.px,
          37.0.px,
          37.0.px,
          37.0.px,
          37.0.px,
          37.0.px,
          37.0.px,
          37.0.px
        ],
        rowSizes: [
          37.0.px,
          37.0.px,
          37.0.px,
          37.0.px,
          37.0.px,
          37.0.px,
          37.0.px,
          37.0.px,
          37.0.px
        ],
        children: [
          for (int i = 0; i < 9; i++) ...[
            for (int j = 0; j < 9; j++) ...[
              gridArea('c$i$j').containing(
                GestureDetector(
                  onTap: () {
                    if (celdas_ocultas.contains(i * 10 + j)) {
                      setState(() {
                        numeros[i * 10 + j] = boton_activo;
                      });
                      checkCompleto();
                    }
                  },
                  child: Container(
                      width: 42,
                      height: 42,
                      color: numeros[i * 10 + j] == boton_activo_fijo
                          ? Colors.blue
                          : (((i > 2 && i < 6) || (j > 2 && j < 6)) &&
                                  ((i > 2 && i < 6) != (j > 2 && j < 6)))
                              ? cellGreyDark
                              : cellGreyLight,
                      child: Center(
                          child: Text(
                              numeros[i * 10 + j]! > 0
                                  ? numeros[i * 10 + j].toString()
                                  : '',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: celdas_ocultas
                                          .contains(i * 10 + j)
                                      ? FontWeight.bold
                                      : numeros[i * 10 + j] == boton_activo_fijo
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                  color: celdas_ocultas.contains(i * 10 + j)
                                      ? const Color.fromARGB(255, 128, 250, 133)
                                      : numeros[i * 10 + j] == boton_activo_fijo
                                          ? Colors.white
                                          : Colors.black)))),
                ),
              ),
            ]
          ]
        ],
      ),
    );
  }

  Widget botones() {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int k = 1; k < 10; k++) ...[
              Padding(
                padding: const EdgeInsets.all(4),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      boton_activo = k;
                      boton_activo_fijo = boton_activo_fijo == -1 ? -1 : k;
                    });
                  },
                  onLongPress: () {
                    setState(() {
                      boton_activo_fijo = boton_activo_fijo > -1 ? -1 : k;
                      boton_activo = k;
                    });
                  },
                  onDoubleTap: () {
                    setState(() {
                      boton_activo_fijo = boton_activo_fijo > -1 ? -1 : k;
                      boton_activo = k;
                    });
                  },
                  child: Container(
                    width: 30,
                    height: 30,
                    padding: const EdgeInsets.fromLTRB(9, 2, 5, 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: boton_activo == k ? Colors.blue : Colors.green,
                    ),
                    child: Text(
                      k.toString(),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: boton_activo == k
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: boton_activo == k
                            ? Colors.white
                            : const Color.fromARGB(255, 60, 60, 60),
                      ),
                    ),
                  ),
                ),
              ),
            ]
          ],
        ));
  }

  Widget opciones() {
    return Row(
      children: [
        ElevatedButton(
          onPressed: () async {
            setState(() {
              numeros = {};
              tablero_ok = false;
              isLoading = true;
              terminado = false;
            });
            await Future.delayed(const Duration(seconds: 1))
                .then((onValue) async {
              await cargarNumeros();
            });
          },
          child: const Text('Reiniciar'),
        )
      ],
    );
  }

  Future<void> cargarNumeros() async {
    intentos = 0;

    while (!tablero_ok) {
      intentos++;
      print("intentos: $intentos");
      generaDiagonal();
      setState(() {
        tablero_ok = resolverSudoku();
      });
      if (intentos == 100) {
        setState(() {
          tablero_ok = true;
        });
        break;
      }
    }
    print("total intentos: $intentos");

    //genera array de celdas fijas
    List<int> todos = [
      0,
      1,
      2,
      10,
      11,
      12,
      20,
      21,
      22,
      3,
      4,
      5,
      13,
      14,
      15,
      23,
      24,
      25,
      6,
      7,
      8,
      16,
      17,
      18,
      26,
      27,
      28,
      30,
      31,
      32,
      40,
      41,
      42,
      50,
      51,
      52,
      33,
      34,
      35,
      43,
      44,
      45,
      53,
      54,
      55,
      36,
      37,
      38,
      46,
      47,
      48,
      56,
      57,
      58,
      60,
      61,
      62,
      70,
      71,
      72,
      80,
      81,
      82,
      63,
      64,
      65,
      73,
      74,
      75,
      83,
      84,
      85,
      66,
      67,
      68,
      76,
      77,
      78,
      86,
      87,
      88
    ]..shuffle();
    List<int> celhid = [];
    if (nivel.value == 1) {
      celhid = todos.sublist(0, 20);
    } else if (nivel.value == 2) {
      celhid = todos.sublist(0, 30);
    } else if (nivel.value == 3) {
      celhid = todos.sublist(0, 40);
    }
    celhid.forEach((co) {
      numeros[co] = 0;
    });
    setState(() {
      isLoading = false;
      celdas_ocultas = celhid;
      numeros = numeros;
    });
  }

  void generaDiagonal() {
    List<int> base = [1, 2, 3, 4, 5, 6, 7, 8, 9];
    List<int> q1 = [0, 1, 2, 10, 11, 12, 20, 21, 22];
    List<int> q2 = [3, 4, 5, 13, 14, 15, 23, 24, 25];
    List<int> q3 = [6, 7, 8, 16, 17, 18, 26, 27, 28];
    List<int> q4 = [30, 31, 32, 40, 41, 42, 50, 51, 52];
    List<int> q5 = [33, 34, 35, 43, 44, 45, 53, 54, 55];
    List<int> q6 = [36, 37, 38, 46, 47, 48, 56, 57, 58];
    List<int> q7 = [60, 61, 62, 70, 71, 72, 80, 81, 82];
    List<int> q8 = [63, 64, 65, 73, 74, 75, 83, 84, 85];
    List<int> q9 = [66, 67, 68, 76, 77, 78, 86, 87, 88];
    Random random = Random();

    //genera aleatorio de los 3 cuadrantes de la diagonal
    q1.shuffle();
    q5.shuffle();
    q9.shuffle();
    //llena la matrix de numeros con los valores aleatorios de q1, q5 y q9
    for (int i = 1; i < 10; i++) {
      numeros[q1[i - 1]] = i;
      numeros[q5[i - 1]] = i;
      numeros[q9[i - 1]] = i;
    }

    //llena el resto con 0 para que se pueda mostrar
    for (int i = 1; i < 10; i++) {
      numeros[q2[i - 1]] = 0;
      numeros[q3[i - 1]] = 0;
      numeros[q4[i - 1]] = 0;
      numeros[q6[i - 1]] = 0;
      numeros[q7[i - 1]] = 0;
      numeros[q8[i - 1]] = 0;
    }
    print(numeros);
  }

  bool resolverSudoku() {
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        if (numeros[i * 10 + j] == 0) {
          for (int k = 1; k <= 9; k++) {
            if (validaFila(i, k) &&
                validaColumna(j, k) &&
                validarCuadrante(i, j, k)) {
              numeros[i * 10 + j] = k;
              if (resolverSudoku()) {
                print(numeros);
                return true;
              }
              numeros[i * 10 + j] = 0;
            }
          }
          print(numeros);
          return false;
        }
      }
    }
    print(numeros);
    return true;
  }

  bool validaFila(int fila, int valor) {
    for (int j = 0; j < 9; j++) {
      if (numeros[fila * 10 + j] == valor) {
        return false;
      }
    }
    return true;
  }

  bool validaColumna(int col, int valor) {
    for (int j = 0; j < 9; j++) {
      if (numeros[j * 10 + col] == valor) {
        return false;
      }
    }
    return true;
  }

  bool validarCuadrante(int fila, int col, int valor) {
    int posI = subCuadranteActual(fila);
    int posJ = subCuadranteActual(col);
    for (int k = posI - 3; k < posI; k++) {
      for (int l = posJ - 3; l < posJ; l++) {
        if (numeros[k * 10 + l] == valor) {
          return false;
        }
      }
    }
    return true;
  }

  int subCuadranteActual(int pos) {
    if (pos < 3) {
      return 3;
    } else if (pos < 6) {
      return 6;
    } else {
      return 9;
    }
  }

  void checkCompleto() {
    print('validnado...');
    for (int i in numeros.keys) {
      if (numeros[i] == 0) {
        setState(() {
          terminado = false;
        });
      }
    }
    setState(() {
      terminado = true;
    });
  }
}
