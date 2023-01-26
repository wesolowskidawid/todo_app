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

  List<String> itemList = List.of(['Example of a Task', 'Click to edit/complete']);
  List<String> completedList = List.of(['Example of a Completed Task']);
  final ScrollController _scrollController = ScrollController();

  void addItem(String text) {
    setState(() {
      itemList.insert(0, text);
      _scrollController.animateTo(_scrollController.position.minScrollExtent, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    });
  }

  void removeItem(int id, int index) {
    setState(() {
      if(id == 0) {
        itemList.removeAt(index);
      }
      else if(id == 1) {
        completedList.removeAt(index);
      }
      // _scrollController.animateTo(_scrollController.position.minScrollExtent, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    });
  }

  void completedTask(int index) {
    setState(() {
      completedList.insert(0, itemList[index]);
      itemList.removeAt(index);
      // _scrollController.animateTo(_scrollController.position.minScrollExtent, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    });
  }
  void uncompletedTask(int index) {
    setState(() {
      itemList.insert(0, completedList[index]);
      completedList.removeAt(index);
      // _scrollController.animateTo(_scrollController.position.minScrollExtent, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
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

  void showEditAlert(int id, int index) {
    String taskName, compl;
    if(id == 0) {
      taskName = itemList[index];
      compl = 'Completed';
    }
    else {
      taskName = completedList[index];
      compl = 'Uncompleted';
    }
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
                  removeItem(id, index);
                },
                child: const Text('Remove'),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  if(id == 0) {
                    completedTask(index);
                  }
                  else if(id == 1) {
                    uncompletedTask(index);
                  }
                },
                child: Text(compl),
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
            itemCount: itemList.length + completedList.length,
            itemBuilder: (context, index) {
              if(index < itemList.length) {
                String temp = itemList[index];
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: InkWell(
                    onTap: () {
                      showEditAlert(0, index);
                    },
                    child: Text(
                      '• $temp',
                      style: const TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                );
              }
              else {
                String temp = itemList[index-itemList.length];
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: InkWell(
                    onTap: () {
                      showEditAlert(1, index-itemList.length);
                    },
                    child: Text(
                      '• $temp',
                      style: const TextStyle(
                        fontSize: 18.0,
                        decoration: TextDecoration.lineThrough,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                );
              }
            },
        )

      ),
    );
  }
}
