import 'package:flutter/material.dart';
import 'package:todo_app/Task.dart';

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
        fontFamily: 'Arial',
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

  List<Task> taskList = [Task('Example: Task', 0), Task('Click to remove/complete', 0), Task('Example: Completed task', 1)];
  List<Task> sortedTaskList = [];
  final ScrollController _scrollController = ScrollController();

  void updateList() {
    setState(() {
      sortedTaskList.clear();
      for(Task task in taskList) {
        if(task.getState() == 0) {
          sortedTaskList.add(task);
        }
      }
      for(Task task in taskList) {
        if(task.getState() == 1) {
          sortedTaskList.add(task);
        }
      }
    });
  }

  void addItem(Task task) {
    setState(() {
      taskList.insert(0, task);
      updateList();
      _scrollController.animateTo(_scrollController.position.minScrollExtent, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    });
  }

  void removeItem(Task task) {
    setState(() {
      for(int i = 0; i < taskList.length; i++) {
        if(taskList[i].getName() == task.getName()) {
          taskList.removeAt(i);
        }
      }
      updateList();
      // _scrollController.animateTo(_scrollController.position.minScrollExtent, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    });
  }

  void changeState(Task task) {
    setState(() {
      if(task.getState() == 0) {
        task.setState(1);
      }
      else {
        task.setState(0);
      }
      updateList();
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
                addItem(Task(inputValue, 0));
                // TODO check if task != null
                // TODO tasks cant have the same name
              },
              child: const Text('OK'),
            ),
          ],
        );
      }
    );
  }

  void showEditAlert(Task task) {
    String taskName = task.getName();
    String compl;
    if(task.getState() == 0) {
      compl = 'Completed';
    }
    else {
      compl = 'Uncompleted';
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Edit task \"$taskName\"',
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
                  removeItem(task);
                },
                child: const Text('Remove'),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  changeState(task);
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
    updateList();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title,
          style: const TextStyle(color: Color(0xff00adb5),
          ),
        ),
        backgroundColor: const Color(0xff222831),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.add,
              color: Color(0xff00adb5)
            ),
            onPressed: () {
              showAddAlert();
            },
          ),
        ],
      ),
      body: Center(
        child: Container(
          color: const Color(0xff393e46),
          child: ListView.builder(
            controller: _scrollController,
            itemCount: sortedTaskList.length,
            itemBuilder: (BuildContext context, int index) {
              Task task = sortedTaskList[index];
              String taskName = task.getName();
              if(task.state == 0) {
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: InkWell(
                    onTap: () {
                      showEditAlert(task);
                    },
                    child: Text(
                      '• $taskName',
                      style: const TextStyle(
                          fontSize: 20.0,
                          color: Color(0xff00adb5)
                      ),
                    ),
                  ),
                );
              }
              else {
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: InkWell(
                    onTap: () {
                      showEditAlert(task);
                    },
                    child: RichText(
                      text: TextSpan(
                        text: '• ',
                        style: const TextStyle(
                          fontSize: 20.0,
                          color: Color(0xff00adb5)
                        ),
                        children: [
                          TextSpan(
                            text: taskName,
                            style: const TextStyle(
                              fontSize: 20.0,
                              color: Color(0xff00adb5),
                              decoration: TextDecoration.lineThrough,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ]
                      ),
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
