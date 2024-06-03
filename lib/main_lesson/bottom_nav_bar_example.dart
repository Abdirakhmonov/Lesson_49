import 'package:flutter/material.dart';

class BottomNavBar1 extends StatefulWidget {
  const BottomNavBar1({super.key});

  @override
  State<BottomNavBar1> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar1> {
  int selectIndex = 0;
  List<Widget> widgets = [
    const Center(
      child: Text("Bosh sahifa"),
    ),
    const Center(
      child: Text("Card qismi"),
    ),
    const Center(
      child: Text("Izlash qismi"),
    )
  ];
  void tapped(int index) {
    setState(() {
      selectIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: selectIndex,
        children: widgets,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.card_travel_sharp), label: "Card"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
        ],
        currentIndex: selectIndex,
        selectedItemColor: Colors.amber,
        onTap: tapped,
      ),
    );
  }
}
