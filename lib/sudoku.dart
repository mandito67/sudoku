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

  List<int> col0 = [1, 2, 3, 4, 5, 6, 7, 8, 9];
  List<int> col1 = [1, 2, 3, 4, 5, 6, 7, 8, 9];
  List<int> col2 = [1, 2, 3, 4, 5, 6, 7, 8, 9];
  List<int> col3 = [1, 2, 3, 4, 5, 6, 7, 8, 9];
  List<int> col4 = [1, 2, 3, 4, 5, 6, 7, 8, 9];
  List<int> col5 = [1, 2, 3, 4, 5, 6, 7, 8, 9];
  List<int> col6 = [1, 2, 3, 4, 5, 6, 7, 8, 9];
  List<int> col7 = [1, 2, 3, 4, 5, 6, 7, 8, 9];
  List<int> col8 = [1, 2, 3, 4, 5, 6, 7, 8, 9];

  List<List<int>> cuadrantes = [
    [1, 1, 1, 2, 2, 2, 3, 3, 3],
    [1, 1, 1, 2, 2, 2, 3, 3, 3],
    [1, 1, 1, 2, 2, 2, 3, 3, 3],
    [4, 4, 4, 5, 5, 5, 6, 6, 6],
    [4, 4, 4, 5, 5, 5, 6, 6, 6],
    [4, 4, 4, 5, 5, 5, 6, 6, 6],
    [7, 7, 7, 8, 8, 8, 9, 9, 9],
    [7, 7, 7, 8, 8, 8, 9, 9, 9],
    [7, 7, 7, 8, 8, 8, 9, 9, 9],
  ];

  Map<int, int> numeros = {};
  int boton_activo = 1;
  bool tablero_ok = false;

  @override
  void initState() {
    cargarNumeros();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sudoku'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            Text('validacion: ' + tablero_ok.toString()),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
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
                              setState(() {
                                numeros[i * 10 + j] = boton_activo;
                              });
                            },
                            child: Container(
                                width: 42,
                                height: 42,
                                color: (((i > 2 && i < 6) ||
                                            (j > 2 && j < 6)) &&
                                        ((i > 2 && i < 6) != (j > 2 && j < 6)))
                                    ? cellGreyDark
                                    : cellGreyLight,
                                child: Center(
                                    child: Text('${numeros[i * 10 + j]}',
                                        style: const TextStyle(
                                          fontSize: 20,
                                        )))),
                          ),
                        ),
                      ]
                    ]
                  ],
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    for (int k = 1; k < 10; k++) ...[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              boton_activo = k;
                            });
                          },
                          child: Container(
                            foregroundDecoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                                border: Border.all(
                                    color: Colors.green, width: 2.0)),
                            color:
                                boton_activo == k ? Colors.green : Colors.white,
                            width: 27,
                            height: 27,
                            child: Center(
                              child: Text(k.toString()),
                            ),
                          ),
                        ),
                      ),
                    ]
                  ],
                )),
            ElevatedButton(
              onPressed: () {
                cargarNumeros();
              },
              child: const Text('Reiniciar'),
            )
          ],
        ),
      ),
    );
  }

  void cargarNumeros() {
    while (!tablero_ok) {
      generarTablero();

      setState(() {
        tablero_ok = validar_solucion();
      });
    }
  }

  void generarTablero() {
    Map<int, int> nums = {};
    List<int> base = [1, 2, 3, 4, 5, 6, 7, 8, 9];
    //1 cuadrante
    List<int> aleatorios = base..shuffle();
    int q = 0;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        nums[i * 10 + j] = aleatorios[q];
        q++;
      }
    }

    //2 cuadrante
    aleatorios = [1, 2, 3, 4, 5, 6, 7, 8, 9]..shuffle();
    aleatorios.remove(nums[0]);
    aleatorios.remove(nums[1]);
    aleatorios.remove(nums[2]);
    nums[3] = aleatorios[0];
    nums[4] = aleatorios[1];
    nums[5] = aleatorios[2];
    aleatorios = [1, 2, 3, 4, 5, 6, 7, 8, 9]..shuffle();
    aleatorios.remove(nums[3]);
    aleatorios.remove(nums[4]);
    aleatorios.remove(nums[5]);
    aleatorios.remove(nums[10]);
    aleatorios.remove(nums[11]);
    aleatorios.remove(nums[12]);
    nums[13] = aleatorios[0];
    nums[14] = aleatorios[1];
    nums[15] = aleatorios[2];
    aleatorios = [1, 2, 3, 4, 5, 6, 7, 8, 9]..shuffle();
    aleatorios.remove(nums[3]);
    aleatorios.remove(nums[4]);
    aleatorios.remove(nums[5]);
    aleatorios.remove(nums[13]);
    aleatorios.remove(nums[14]);
    aleatorios.remove(nums[15]);
    aleatorios.remove(nums[20]);
    aleatorios.remove(nums[21]);
    aleatorios.remove(nums[22]);
    nums[23] = aleatorios[0];
    nums[24] = aleatorios[1];
    nums[25] = aleatorios[2];
    //3 cuadrante
    aleatorios = [1, 2, 3, 4, 5, 6, 7, 8, 9]..shuffle();
    aleatorios.remove(nums[0]);
    aleatorios.remove(nums[1]);
    aleatorios.remove(nums[2]);
    aleatorios.remove(nums[3]);
    aleatorios.remove(nums[4]);
    aleatorios.remove(nums[5]);
    nums[6] = aleatorios[0];
    nums[7] = aleatorios[1];
    nums[8] = aleatorios[2];
    aleatorios = [1, 2, 3, 4, 5, 6, 7, 8, 9]..shuffle();
    aleatorios.remove(nums[6]);
    aleatorios.remove(nums[7]);
    aleatorios.remove(nums[8]);
    aleatorios.remove(nums[10]);
    aleatorios.remove(nums[11]);
    aleatorios.remove(nums[12]);
    aleatorios.remove(nums[13]);
    aleatorios.remove(nums[14]);
    aleatorios.remove(nums[15]);
    nums[16] = aleatorios[0];
    nums[17] = aleatorios[1];
    nums[18] = aleatorios[2];
    aleatorios = [1, 2, 3, 4, 5, 6, 7, 8, 9]..shuffle();
    aleatorios.remove(nums[6]);
    aleatorios.remove(nums[7]);
    aleatorios.remove(nums[8]);
    aleatorios.remove(nums[16]);
    aleatorios.remove(nums[17]);
    aleatorios.remove(nums[18]);
    nums[26] = aleatorios[0];
    nums[27] = aleatorios[1];
    nums[28] = aleatorios[2];

    setState(() {
      numeros = nums;
    });
  }

  bool validar_solucion() {
    bool ok = true;
    //revisa filas
    for (int i = 0; i < 9; i++) {
      List<int> check = [];
      for (int j = 0; j < 9; j++) {
        if (numeros[i * 10 + j] != null) {
          check.add(numeros[i * 10 + j]!);
        }
        print(check);
        var distinctIds = check.toSet().toList();
        print(distinctIds);
        if (check.length != distinctIds.length) {
          ok = false;
          break;
        }
      }
    }
    return ok;
  }

  void cargarNumeros_op1() {
    Map<int, int> nums = {};
    List<int> base = [1, 2, 3, 4, 5, 6, 7, 8, 9];
    for (int i = 0; i < 9; i++) {
      //i es la fila
      List<int> aleatorios = [];
      bool buscar_siguiente = true;
      while (buscar_siguiente) {
        buscar_siguiente = false;
        if (i < 7) {
          aleatorios = base..shuffle();
        } else {
          List<int> ali0 = col0..shuffle();
          List<int> ali1 = col1..shuffle();
          List<int> ali2 = col2..shuffle();
          List<int> ali3 = col3..shuffle();
          List<int> ali4 = col4..shuffle();
          List<int> ali5 = col5..shuffle();
          List<int> ali6 = col6..shuffle();
          List<int> ali7 = col7..shuffle();
          List<int> ali8 = col8..shuffle();
          aleatorios = [
            ali0[0],
            ali1[0],
            ali2[0],
            ali3[0],
            ali4[0],
            ali5[0],
            ali6[0],
            ali7[0],
            ali8[0]
          ];
        }
        print(aleatorios);

        print('probando...');
        print(aleatorios);
        for (int j = 0; j < 9; j++) {
          int cuadrantei = cuadrantes[i][j];
          print(cuadrantei);
          //j es la columna
          for (int k = 0; k < i; k++) {
            //k son las lineas hasta donde va i
            if (aleatorios[j] == nums[k * 10 + j]) {
              //valida que no coincida en la misma columna
              buscar_siguiente = true;
              break;
            } else if (j >= 0 && j < 4) {
              //primer cuadrante
            }
          }
        }
      }
      col0.remove(aleatorios[0]);
      col1.remove(aleatorios[1]);
      col2.remove(aleatorios[2]);
      col3.remove(aleatorios[3]);
      col4.remove(aleatorios[4]);
      col5.remove(aleatorios[5]);
      col6.remove(aleatorios[6]);
      col7.remove(aleatorios[7]);
      col8.remove(aleatorios[8]);
      print('pintando linea $i');
      print(aleatorios);
      for (int j = 0; j < 9; j++) {
        nums[i * 10 + j] = aleatorios[j];
      }
    }
    setState(() {
      numeros = nums;
    });
  }
}
