import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  late Box box;
  TextEditingController todocontroller = TextEditingController();
  List<String> todoItems = [];

  @override
  void initState() {
    super.initState();
    box = Hive.box('mybox'); // Open the box during initialization
    loadTodoItems();
  }

  loadTodoItems() async {
    // Load saved tasks from the box
    List<String>? tasks = box.get('todoItems')?.cast<String>();

    if (tasks != null) {
      setState(() {
        todoItems = tasks; // Assign loaded tasks to todoItems
      });
    }
  }

  saveTodoItems() async {
    // Save updated todoItems list to Hive
    box.put('todoItems', todoItems);
  }

  void _addTodoItem(String task) {
    if (task.isNotEmpty) {
      setState(() {
        todoItems.add(task);
      });
      saveTodoItems();
      todocontroller.clear(); // Clear the input after adding
    }
  }

  void _removeTodoItem(int index) {
    setState(() {
      todoItems.removeAt(index);
    });
    saveTodoItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todo with Hive"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                    height: 50,
                    width: 300,
                    child: TextField(
                      controller: todocontroller,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20))),
                    )),
                SizedBox(width: 5),
                IconButton(
                    onPressed: () {
                      _addTodoItem(todocontroller.text);
                    },
                    icon: Icon(Icons.add)),
              ],
            ),
            Expanded(
                child: ListView.builder(
                    itemCount: todoItems.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(todoItems[index]),
                        trailing: GestureDetector(
                            onTap: () {
                              _removeTodoItem(index);
                            },
                            child: Icon(Icons.delete)),
                      );
                    }))
          ],
        ),
      ),
    );
  }
}
