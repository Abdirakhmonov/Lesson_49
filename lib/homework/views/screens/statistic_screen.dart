import 'package:flutter/material.dart';
import 'package:lesson_49/homework/views/widgets/drawer_page.dart';
import '../../models/todo_model.dart';
import '../../viewmodels/todo_viewmodel.dart';
import '../widgets/manage_todo.dart';

class StatisticScreen extends StatefulWidget {
  final Function(int) onItemTapped;
  final int currentIndex;

  StatisticScreen({super.key, required this.onItemTapped, required this.currentIndex});

  @override
  State<StatisticScreen> createState() => _StatisticScreenState();
}

class _StatisticScreenState extends State<StatisticScreen> {
  final todosViewModel = TodosViewModel();

  void addTodo() async {
    final data = await showDialog(
      context: context,
      builder: (ctx) {
        return const ManageTodoDialog();
      },
    );

    if (data != null) {
      try {
        await todosViewModel.addTodo(
          data['title'],
          data['date'],
          data['isCompleted'],
        );
        setState(() {});
      } catch (e) {
        print(e);
      }
    }
  }

  void editTodo(Todo todo) async {
    final data = await showDialog(
      context: context,
      builder: (ctx) {
        return ManageTodoDialog(todo: todo);
      },
    );

    if (data != null) {
      await todosViewModel.editTodo(
         todo.id,
        data['title'],
        data['date'],
        data['isCompleted'],
      );
      setState(() {});
    }
  }

  void changeStatus(String id, bool isCompleted) async {
    await todosViewModel.changeStatus(id, isCompleted);
    setState(() {});
  }

  void deleteTodo(Todo todo) async {
    final response = await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("Ishonchingiz komilmi?"),
          content: Text("Siz ${todo.title} nomli vazifani o'chirmoqchisiz."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text("Bekor qilish"),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text("Ha, ishonchim komil"),
            ),
          ],
        );
      },
    );

    if (response == true) {
      await todosViewModel.deleteTodo(todo.id);
      setState(() {});
    }
  }

  Future<Map<String, int>> countTasks() async {
    final todos = await todosViewModel.list;
    int done = todos.where((todo) => todo.isCompleted).length;
    return {
      "total": todos.length,
      "completed": done,
      "notCompleted": todos.length - done,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerPage(),
      appBar: AppBar(
        title: const Text("Statistic Screen", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          FutureBuilder(
            future: todosViewModel.list,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              }
              if (!snapshot.hasData) {
                return const Center(
                  child: Text("Rejalar mavjud emas, iltimos qo'shing"),
                );
              }
              final todos = snapshot.data!;
              return todos.isEmpty
                  ? const Center(
                child: Text("Rejalar mavjud emas, iltimos qo'shing"),
              )
                  : Padding(
                padding: const EdgeInsets.all(10.0),
                child: SizedBox(
                  height: 300, // Adjust height as needed
                  child: ListView.separated(
                    itemCount: todos.length,
                    itemBuilder: (context, index) {
                      final todo = todos[index];
                      return ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(color: Colors.amber),
                        ),
                        leading: IconButton(
                          onPressed: () {
                            changeStatus(todo.id, !todo.isCompleted);
                          },
                          icon: Icon(
                            todo.isCompleted ? Icons.check_circle : Icons.circle_outlined,
                            color: todo.isCompleted ? Colors.green : null,
                          ),
                        ),
                        title: Text(
                          todo.title,
                          style: TextStyle(
                            decoration: todo.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
                            decorationThickness: 2,
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                          ),
                        ),
                        subtitle: Text(
                          todo.date,
                          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                editTodo(todo);
                              },
                              icon: const Icon(Icons.edit),
                            ),
                            IconButton(
                              onPressed: () {
                                deleteTodo(todo);
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(height: 10);
                    },
                  ),
                ),
              );
            },
          ),
          FutureBuilder<Map<String, int>>(
            future: countTasks(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final counts = snapshot.data!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Umumiy Takslar soni: ${counts['total']}", style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold, color: Colors.yellow),),
                  Text("Bajarilgan vazifalar: ${counts['completed']}", style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold, color: Colors.green),),
                  Text("Bajarilmagan: ${counts['notCompleted']}", style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold, color: Colors.red),),
                ],
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addTodo,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: widget.currentIndex,
        selectedItemColor: Colors.green,
        onTap: widget.onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.stacked_bar_chart), label: "Statistic"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
