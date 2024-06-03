import 'package:flutter/material.dart';
import 'package:lesson_49/homework/views/screens/statistic_screen.dart';
import 'package:lesson_49/homework/views/widgets/drawer_page.dart';

class HomeScreen extends StatelessWidget {
  final Function(int) onItemTapped;
  final int currentIndex;

  const HomeScreen(
      {super.key, required this.onItemTapped, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerPage(),
      appBar: AppBar(
        title: const Text(
          "Home Screen",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(10),
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        children: [
          InkWell(
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => StatisticScreen(
                          onItemTapped: onItemTapped,
                          currentIndex: currentIndex)));
            },
            child: const Card(
              child: Center(
                  child: Text(
                "Todos",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                textAlign: TextAlign.center,
              )),
            ),
          ),
          InkWell(
            onTap: () {},
            child: const Card(
              child: Center(
                  child: Text("Notes",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 24))),
            ),
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: Colors.green,
        onTap: onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.stacked_bar_chart), label: "Statistic"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
