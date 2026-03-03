import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class Task {
  String title;
  bool isDone;

  Task({required this.title, this.isDone = false});
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  int _currentIndex = 0;
  List<Task> tasks = [];

  final TextEditingController _controller = TextEditingController();

  void addTask() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        tasks.add(Task(title: _controller.text));
        _controller.clear();
      });
    }
  }

  void toggleTask(int index) {
    setState(() {
      tasks[index].isDone = !tasks[index].isDone;
    });
  }

  void deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {

    int total = tasks.length;
    int done = tasks.where((t) => t.isDone).length;
    int todo = total - done;
    double efficiency = total == 0 ? 0 : (done / total) * 100;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("TO DO List"),
          centerTitle: true,
        ),

        body: _currentIndex == 0

        //lista todo
            ? Column(
          children: [

            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: "Nuovo task...",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: addTask,
                    child: Text("Aggiungi"),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return Dismissible(
                    key: Key(task.title + index.toString()),
                    onDismissed: (_) => deleteTask(index),
                    background: Container(color: Colors.red),
                    child: CheckboxListTile(
                      title: Text(
                        task.title,
                        style: TextStyle(
                          decoration: task.isDone
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      value: task.isDone,
                      onChanged: (_) => toggleTask(index),
                    ),
                  );
                },
              ),
            ),
          ],
        )

        // stats
            : Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Text("Task totali: $total",
                  style: TextStyle(fontSize: 20)),

              SizedBox(height: 10),

              Text("Completati: $done",
                  style: TextStyle(fontSize: 20)),

              SizedBox(height: 10),

              Text("Da fare: $todo",
                  style: TextStyle(fontSize: 20)),

              SizedBox(height: 20),

              Text(
                "Efficienza: ${efficiency.toStringAsFixed(1)}%",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ),

        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: "Lista",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: "Stats",
            ),
          ],
        ),
      ),
    );
  }

}
