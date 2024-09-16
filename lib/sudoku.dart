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

  Map<int, int> numeros = {};
  int boton_activo = 1;

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
                ))
          ],
        ),
      ),
    );
  }

  void cargarNumeros() {
    Map<int, int> nums = {};
    List<int> base = [1, 2, 3, 4, 5, 6, 7, 8, 9];
    for (int i = 0; i < 9; i++) {
      bool buscar_siguiente = true;
      List<int> aleatorios = [];
      while (buscar_siguiente) {
        buscar_siguiente = false;
        aleatorios = base..shuffle();
        for (int j = 0; j < 9; j++) {
          for (int k = 0; k < i; k++) {
            if (aleatorios[j] == numeros[k * 10 + j]) {
              buscar_siguiente = true;
            }
          }
        }
      }
      for (int j = 0; j < 9; j++) {
        nums[i * 10 + j] = aleatorios[j];
      }
    }
    setState(() {
      numeros = nums;
    });
  }
}
