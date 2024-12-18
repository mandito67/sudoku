import 'package:flutter/material.dart';
import 'package:sudoku/sudoku.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Sudoku',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        initialRoute: "/nivel",
        routes: {
          "/sudoku": (BuildContext context) {
            return Sudoku();
          },
          "/nivel": (BuildContext context) {
            return SeleccionNivel();
          },
          "/configuracion": (BuildContext context) {
            return Sudoku();
          },
        });
  }
}

class SeleccionNivel extends StatefulWidget {
  const SeleccionNivel({Key? key}) : super(key: key);

  @override
  State<SeleccionNivel> createState() => SeleccionNivelState();
}

class SeleccionNivelState extends State<SeleccionNivel> {
  @override
  int nivel = 1;
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Sudoku only fun!'),
      ),
      body: Center(
        child: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.blue,
              Colors.white,
            ],
          )),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 150,
                  child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll<Color>(
                            nivel == 1 ? Colors.green : Colors.grey),
                      ),
                      onPressed: () => setState(() {
                            nivel = 1;
                          }),
                      child: Text(
                        'Fácil',
                        style: TextStyle(
                            color: nivel == 1 ? Colors.white : Colors.black),
                      )),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 150,
                    child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll<Color>(
                              nivel == 2 ? Colors.green : Colors.grey),
                        ),
                        onPressed: () => setState(() {
                              nivel = 2;
                            }),
                        child: Text(
                          'Intermedio',
                          style: TextStyle(
                              color: nivel == 2 ? Colors.white : Colors.black),
                        )),
                  ),
                ),
                SizedBox(
                  width: 150,
                  child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll<Color>(
                            nivel == 3 ? Colors.green : Colors.grey),
                      ),
                      onPressed: () => setState(() {
                            nivel = 3;
                          }),
                      child: Text(
                        'Duro',
                        style: TextStyle(
                            color: nivel == 3 ? Colors.white : Colors.black),
                      )),
                ),
                const SizedBox(
                  height: 100,
                ),
                SizedBox(
                  width: 250,
                  child: ElevatedButton(
                    onPressed: () => setState(() {
                      Navigator.pushNamed(context, '/sudoku', arguments: nivel);
                    }),
                    child: const Text(
                      'Nuevo juego',
                      style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
