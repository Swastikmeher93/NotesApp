import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        title: Text("Notes",
        style: TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.bold
        ),
        ),
      ),
      body:ListView(

      ), 
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add_rounded),),
        
    );
  }
}