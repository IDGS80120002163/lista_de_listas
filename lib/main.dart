import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
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
  final List<Map<String, List<String>>> mainList = [
    {'Lista 1': ['Lista 1', 'Lista 2']},
    {'Lista 2': ['Lista 1', 'Lista 2']},
    {'Lista 3': ['Lista 1', 'Lista 2']}
  ];

  void _addNewList() {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add New List"),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(labelText: 'List Name'),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  mainList.add({controller.text: []});
                });
                Navigator.of(context).pop();
              },
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }

  void _editList(int index, String newKey) {
    setState(() {
      var items = mainList[index].values.first;
      mainList[index] = {newKey: items};
    });
  }

  void _deleteList(int index) {
    setState(() {
      mainList.removeAt(index);
    });
  }

  void _addItemToList(int index) {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add New Item"),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(labelText: 'Item'),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  mainList[index].values.first.add(controller.text);
                });
                Navigator.of(context).pop();
              },
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }

  void _editItemInList(int index, int itemIndex, String newItem) {
    setState(() {
      mainList[index].values.first[itemIndex] = newItem;
    });
  }

  void _deleteItemFromList(int index, int itemIndex) {
    setState(() {
      mainList[index].values.first.removeAt(itemIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _addNewList,
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: mainList.length,
        itemBuilder: (BuildContext context, int index) {
          String key = mainList[index].keys.first;
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
                          _showEditDialog(context, index);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _deleteList(index);
                        },
                      ),
                    ],
                  ),
                ],
              ),
              children: [
                ...mainList[index][key]!.map((item) {
                  int itemIndex = mainList[index][key]!.indexOf(item);
                  return ListTile(
                    title: Text(item),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            _showEditItemDialog(context, index, itemIndex);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            _deleteItemFromList(index, itemIndex);
                          },
                        ),
                      ],
                    ),
                  );
                }).toList(),
                ListTile(
                  title: ElevatedButton(
                    child: Text("Add Item"),
                    onPressed: () {
                      _addItemToList(index);
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

  void _showEditDialog(BuildContext context, int index) {
    final TextEditingController controller = TextEditingController();
    controller.text = mainList[index].keys.first;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit List"),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(labelText: 'List Name'),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                _editList(index, controller.text);
                Navigator.of(context).pop();
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void _showEditItemDialog(BuildContext context, int index, int itemIndex) {
    final TextEditingController controller = TextEditingController();
    controller.text = mainList[index].values.first[itemIndex];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit Item"),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(labelText: 'Item'),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                _editItemInList(index, itemIndex, controller.text);
                Navigator.of(context).pop();
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }
}
