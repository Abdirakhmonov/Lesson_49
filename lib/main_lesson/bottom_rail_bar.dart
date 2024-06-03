import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

  int selectIndex = 0;

  void onItemTapped(int index) {
    setState(() {
      selectIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
              onDestinationSelected: onItemTapped,
              labelType: NavigationRailLabelType.selected,
              destinations: const <NavigationRailDestination>[
                NavigationRailDestination(
                  icon: Icon(Icons.home),
                  label: Text("Home"),
                ),
                NavigationRailDestination(
                    icon: Icon(Icons.card_travel_sharp), label: Text("Card")),
                NavigationRailDestination(
                    icon: Icon(Icons.search), label: Text("Search"))
              ],
              selectedIndex: selectIndex),
          Expanded(
            child: widgets.elementAt(selectIndex),
          ),
        ],
      ),
    );
  }
}
