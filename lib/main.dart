import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lonches Music',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Agrupaciones con canciones mías'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Map<String, List<String>>> mainList = [];

  void _agregarNuevaAgrupacion() {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Agregar Nueva Agrupación"),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(labelText: 'Nombre de la agrupación'),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                String inputText = controller.text.trim();
                if (inputText.isNotEmpty &&
                    inputText.contains(RegExp(r'[a-zA-Z]'))) {
                  setState(() {
                    mainList.add({inputText: []});
                  });
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          "El nombre de la agrupación debe contener al menos una letra."),
                    ),
                  );
                }
              },
              child: Text("Agregar"),
            ),
          ],
        );
      },
    );
  }

  void _modificarAgrupacion(int id, String newKey) {
    if (newKey.isEmpty || !RegExp(r'[a-zA-Z]').hasMatch(newKey)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'El nuevo nombre de la agrupación debe contener al menos una letra.')),
      );
    } else {
      setState(() {
        var items = mainList[id].values.first;
        mainList[id] = {newKey: items};
      });
    }
  }

  void _eliminarAgrupacion(int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Eliminar Agrupación"),
          content: Text("¿Estás seguro que deseas eliminar esta agrupación?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  mainList.removeAt(id);
                });
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: Text("Eliminar"),
            ),
          ],
        );
      },
    );
  }

  void _agregarCancion(int id) {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Agregar nueva canción"),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(labelText: 'Nombre de la canción'),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (controller.text.isEmpty ||
                    !RegExp(r'[a-zA-Z]').hasMatch(controller.text)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            'El nombre de la canción debe contener al menos una letra.')),
                  );
                } else {
                  setState(() {
                    mainList[id].values.first.add(controller.text);
                  });
                  Navigator.of(context).pop();
                }
              },
              child: Text("Agregar"),
            ),
          ],
        );
      },
    );
  }

  void _editarCancion(int id, int itemid, String nuevoNombre) {
    if (nuevoNombre.isEmpty || !RegExp(r'[a-zA-Z]').hasMatch(nuevoNombre)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'El nuevo nombre de la canción debe contener al menos una letra.')),
      );
    } else {
      setState(() {
        mainList[id].values.first[itemid] = nuevoNombre;
      });
    }
  }

  void _eliminarCancion(int id, int itemid) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Eliminar Canción"),
          content: Text("¿Estás seguro que deseas eliminar esta canción?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  mainList[id].values.first.removeAt(itemid);
                });
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: Text("Eliminar"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: mainList.length + 1,
        itemBuilder: (BuildContext context, int id) {
          if (id == mainList.length) {
            return Center(
              child: ElevatedButton(
                child: Text("Agregar Nueva Agrupación"),
                onPressed: _agregarNuevaAgrupacion,
              ),
            );
          }
          String key = mainList[id].keys.first;
          return Card(
            child: ExpansionTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(key),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          _showEditMainListDialog(context, id);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _eliminarAgrupacion(id);
                        },
                      ),
                    ],
                  ),
                ],
              ),
              children: [
                ...mainList[id][key]!.map((item) {
                  int itemid = mainList[id][key]!.indexOf(item);
                  return ListTile(
                    title: Text(item),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            _showEditSublistDialog(context, id, itemid);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            _eliminarCancion(id, itemid);
                          },
                        ),
                      ],
                    ),
                  );
                }).toList(),
                ListTile(
                  title: ElevatedButton(
                    child: Text("Agregar Canción"),
                    onPressed: () {
                      _agregarCancion(id);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showEditMainListDialog(BuildContext context, int id) {
    final TextEditingController controller = TextEditingController();
    controller.text = mainList[id].keys.first;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Editar Lista"),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(labelText: 'Nombre de la Lista'),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                _modificarAgrupacion(id, controller.text);
                Navigator.of(context).pop();
              },
              child: Text("Guardar"),
            ),
          ],
        );
      },
    );
  }

  void _showEditSublistDialog(BuildContext context, int id, int itemid) {
    final TextEditingController controller = TextEditingController();
    controller.text = mainList[id].values.first[itemid];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Editar lista"),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(labelText: 'Nombre de la lista'),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                _editarCancion(id, itemid, controller.text);
                Navigator.of(context).pop();
              },
              child: Text("Guardar"),
            ),
          ],
        );
      },
    );
  }
}
