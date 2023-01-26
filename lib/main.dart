import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'TaskMaster'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<String> itemList = List.generate(100, (i) => "ex $i");
  List<String> completedList = List.of(['Example of Completed Task']);
  final ScrollController _scrollController = ScrollController();

  void addItem(String text) {
    setState(() {
      itemList.insert(0, text);
      _scrollController.animateTo(_scrollController.position.minScrollExtent, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      print('Item Added');
    });
  }

  void removeItem(int index) {
    setState(() {
      itemList.removeAt(index);
      _scrollController.animateTo(_scrollController.position.minScrollExtent, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      print('Item no. $index removed');
    });
  }

  void showAddAlert() {
    String inputValue = "";

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Add a new task',
          ),
          content: TextField(
            onChanged: (value) {
              inputValue = value;
            },
          ),
          actions: <Widget>[
            FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
            ),
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
                addItem(inputValue);
                // TODO check if task != null
              },
              child: const Text('OK'),
            ),
          ],
        );
      }
    );
  }

  void showEditAlert(int index) {
    String taskName = itemList[index];
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Edit task no. $index',
            ),
            content: Text(
              'Title: $taskName',
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  removeItem(index);
                },
                child: const Text('Remove'),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Complete'),
              ),
            ],
          );
        }
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title,
          style: const TextStyle(color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.add,
              color: Colors.black
            ),
            onPressed: () {
              showAddAlert();
            },
          ),
        ],
      ),
      body: Center(
        child:
          ListView.builder(
            controller: _scrollController,
            itemCount: itemList.length,
            itemBuilder: (context, index) {
              return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: InkWell(
                    onTap: () {
                      showEditAlert(index);
                    },
                    child: Text(
                        itemList[index],
                        style: const TextStyle(
                          fontSize: 18.0,
                        ),
                    ),
                  ),
              );
            },
        )

      ),
    );
  }
}
