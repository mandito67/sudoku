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
                    width: 36,
                    height: 36,
                    padding: const EdgeInsets.fromLTRB(12, 4, 5, 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
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
      generarTablero();
      setState(() {
        tablero_ok = validarSolucion();
      });
      if (intentos > 1000) {
        setState(() {
          tablero_ok = true;
        });
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

  void generarTablero() {
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

    for (var num in base) {
      try {
        List<int> q1i = List.from(q1);
        List<int> q2i = List.from(q2);
        List<int> q3i = List.from(q3);
        List<int> q4i = List.from(q4);
        List<int> q5i = List.from(q5);
        List<int> q6i = List.from(q6);
        List<int> q7i = List.from(q7);
        List<int> q8i = List.from(q8);
        List<int> q9i = List.from(q9);
        int randomNumber1 = random.nextInt(q1i.length); // from 0 upto 9
        int check1 = q1i[randomNumber1];
        numeros[check1] = num;
        q1.remove(check1);
        //quita las opcione de q2 y q3
        if (check1 < 10) {
          q2i.remove(3);
          q2i.remove(4);
          q2i.remove(5);
          q3i.remove(6);
          q3i.remove(7);
          q3i.remove(8);
        } else if (check1 < 20) {
          q2i.remove(13);
          q2i.remove(14);
          q2i.remove(15);
          q3i.remove(16);
          q3i.remove(17);
          q3i.remove(18);
        } else {
          q2i.remove(23);
          q2i.remove(24);
          q2i.remove(25);
          q3i.remove(26);
          q3i.remove(27);
          q3i.remove(28);
        }

        //quita las opciones de q4 y q7
        if ([0, 10, 20].contains(check1)) {
          q4i.remove(30);
          q4i.remove(40);
          q4i.remove(50);
          q7i.remove(60);
          q7i.remove(70);
          q7i.remove(80);
        } else if ([1, 11, 21].contains(check1)) {
          q4i.remove(31);
          q4i.remove(41);
          q4i.remove(51);
          q7i.remove(61);
          q7i.remove(71);
          q7i.remove(81);
        } else {
          q4i.remove(32);
          q4i.remove(42);
          q4i.remove(52);
          q7i.remove(62);
          q7i.remove(72);
          q7i.remove(82);
        }
        int randomNumber2 = random.nextInt(q2i.length);
        int check2 = q2i[randomNumber2];
        numeros[check2] = num;
        q2.remove(check2);

        //quita las opciones de q3
        if (check2 < 10) {
          q3i.remove(6);
          q3i.remove(7);
          q3i.remove(8);
        } else if (check2 < 20) {
          q3i.remove(16);
          q3i.remove(17);
          q3i.remove(18);
        } else {
          q3i.remove(26);
          q3i.remove(27);
          q3i.remove(28);
        }

        //quita las opciones de q6 y q8
        if ([3, 13, 23].contains(check2)) {
          q5i.remove(33);
          q5i.remove(43);
          q5i.remove(53);
          q8i.remove(63);
          q8i.remove(73);
          q8i.remove(83);
        } else if ([4, 14, 24].contains(check2)) {
          q5i.remove(34);
          q5i.remove(44);
          q5i.remove(54);
          q8i.remove(64);
          q8i.remove(74);
          q8i.remove(84);
        } else {
          q5i.remove(35);
          q5i.remove(45);
          q5i.remove(55);
          q8i.remove(65);
          q8i.remove(75);
          q8i.remove(85);
        }
        int randomNumber3 = random.nextInt(q3i.length);
        int check3 = q3i[randomNumber3];
        numeros[check3] = num;
        q3.remove(check3);
        if ([6, 16, 26].contains(check3)) {
          q6i.remove(36);
          q6i.remove(46);
          q6i.remove(56);
          q9i.remove(66);
          q9i.remove(76);
          q9i.remove(86);
        } else if ([7, 17, 27].contains(check3)) {
          q6i.remove(37);
          q6i.remove(47);
          q6i.remove(57);
          q9i.remove(67);
          q9i.remove(77);
          q9i.remove(87);
        } else {
          q6i.remove(38);
          q6i.remove(48);
          q6i.remove(58);
          q9i.remove(68);
          q9i.remove(78);
          q9i.remove(88);
        }
        int randomNumber4 = random.nextInt(q4i.length);
        int check4 = q4i[randomNumber4];
        numeros[check4] = num;
        q4.remove(check4);
        if (check4 < 40) {
          q5i.remove(33);
          q5i.remove(34);
          q5i.remove(35);
          q6i.remove(36);
          q6i.remove(37);
          q6i.remove(38);
        } else if (check4 < 50) {
          q5i.remove(43);
          q5i.remove(44);
          q5i.remove(45);
          q6i.remove(46);
          q6i.remove(47);
          q6i.remove(48);
        } else {
          q5i.remove(53);
          q5i.remove(54);
          q5i.remove(55);
          q6i.remove(56);
          q6i.remove(57);
          q6i.remove(58);
        }
        if ([30, 40, 50].contains(check4)) {
          q7i.remove(60);
          q7i.remove(70);
          q7i.remove(80);
        } else if ([31, 41, 51].contains(check4)) {
          q7i.remove(61);
          q7i.remove(71);
          q7i.remove(81);
        } else {
          q7i.remove(62);
          q7i.remove(72);
          q7i.remove(82);
        }
        int randomNumber5 = random.nextInt(q5i.length);
        int check5 = q5i[randomNumber5];
        numeros[check5] = num;
        q5.remove(check5);
        if (check5 < 40) {
          q6i.remove(36);
          q6i.remove(37);
          q6i.remove(38);
        } else if (check5 < 50) {
          q6i.remove(46);
          q6i.remove(47);
          q6i.remove(48);
        } else {
          q6i.remove(56);
          q6i.remove(57);
          q6i.remove(58);
        }
        if ([33, 43, 53].contains(check5)) {
          q8i.remove(63);
          q8i.remove(73);
          q8i.remove(83);
        } else if ([34, 44, 54].contains(check5)) {
          q8i.remove(64);
          q8i.remove(74);
          q8i.remove(84);
        } else {
          q8i.remove(65);
          q8i.remove(75);
          q8i.remove(85);
        }
        int randomNumber6 = random.nextInt(q6i.length);
        int check6 = q6i[randomNumber6];
        numeros[check6] = num;
        q6.remove(check6);
        if ([36, 46, 56].contains(check6)) {
          q9i.remove(66);
          q9i.remove(76);
          q9i.remove(86);
        } else if ([37, 47, 57].contains(check6)) {
          q9i.remove(67);
          q9i.remove(77);
          q9i.remove(87);
        } else {
          q9i.remove(68);
          q9i.remove(78);
          q9i.remove(88);
        }
        int randomNumber7 = random.nextInt(q7i.length);
        int check7 = q7i[randomNumber7];
        numeros[check7] = num;
        q7.remove(check7);
        if (check7 < 70) {
          q8i.remove(63);
          q8i.remove(64);
          q8i.remove(65);
          q9i.remove(66);
          q9i.remove(67);
          q9i.remove(68);
        } else if (check7 < 80) {
          q8i.remove(73);
          q8i.remove(74);
          q8i.remove(75);
          q9i.remove(76);
          q9i.remove(77);
          q9i.remove(78);
        } else {
          q8i.remove(83);
          q8i.remove(84);
          q8i.remove(85);
          q9i.remove(86);
          q9i.remove(87);
          q9i.remove(88);
        }
        int randomNumber8 = random.nextInt(q8i.length);
        int check8 = q8i[randomNumber8];
        numeros[check8] = num;
        q8.remove(check8);
        if (check8 < 70) {
          q9i.remove(66);
          q9i.remove(67);
          q9i.remove(68);
        } else if (check8 < 80) {
          q9i.remove(76);
          q9i.remove(77);
          q9i.remove(78);
        } else {
          q9i.remove(86);
          q9i.remove(87);
          q9i.remove(88);
        }
        numeros[q9i[0]] = num;
        q9.remove(q9i[0]);
      } catch (e) {}
    }
  }

  bool validarSolucion() {
    bool ok = true;
    //revisa filas
    for (int i = 0; i < 9; i++) {
      List<int> check_row = [];
      for (int j = 0; j < 9; j++) {
        if (numeros[i * 10 + j] != null) {
          check_row.add(numeros[i * 10 + j]!);
        }
      }
      var distinctIds = check_row.toSet().toList();
      //compara la longitud, si hay un repetido la longitud es diferente
      print(check_row);
      print(distinctIds);
      if (check_row.length != distinctIds.length) {
        ok = false;
      }
    }

    if (ok) {
      //revisa columnas
      for (int i = 0; i < 9; i++) {
        List<int> check_col = [];
        for (int j = 0; j < 9; j++) {
          if (numeros[i + j * 10] != null) {
            check_col.add(numeros[i + j * 10]!);
          }
        }
        var distinctIds = check_col.toSet().toList();
        //compara la longitud, si hay un repetido la longitud es diferente
        if (check_col.length != distinctIds.length) {
          print(check_col);
          print(distinctIds);
          ok = false;
        }
      }
    }

    numeros.remove(0);
    if (numeros.length < 81) {
      ok = false;
    }
    return ok;
  }

  void checkCompleto() {
    print('validnado...');
    if (validarSolucion()) {
      print('validacion ok');
      setState(() {
        terminado = true;
      });
    } else {
      print('faltan campos');
      setState(() {
        terminado = false;
      });
    }
  }
}
