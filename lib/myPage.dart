import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:preparation/class/Data.dart';

class Mylist extends StatefulWidget {
  @override
  MylistState createState() => MylistState();
}

class MylistState extends State<Mylist> {
  int _currentindex = 0;

  final mybox = Hive.box<Data>('data');
  late TextEditingController string_controller;
  late TextEditingController int_controller;

  @override
  void initState() {
    super.initState();
    string_controller = TextEditingController();
    int_controller = TextEditingController();
  }

  @override
  void dispose() {
    string_controller.dispose();
    int_controller.dispose();
    super.dispose();
  }

  submitText() {
    setState(() {
      Data tmp =
          new Data(string_controller.text, int.parse(int_controller.text));
      mybox.add(tmp);
      _currentindex = 0;
    });
  }

  deleteData() {
    setState(() {
      mybox.clear();
      _currentindex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hive & Navigation bar"),
      ),
      body: IndexedStack(
        index: _currentindex,
        children: [
          Center(
              child: Column(
            children: <Widget>[
              Expanded(
                child: ListView.separated(
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(),
                    padding: const EdgeInsets.all(8),
                    itemCount: mybox.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(mybox.getAt(index)!.name),
                        subtitle: Text(mybox.getAt(index)!.number.toString()),
                      );
                    }),
              ),
            ],
          )),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 50,
                ),
                TextField(
                  controller: string_controller,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Enter String'),
                ),
                SizedBox(
                  height: 30,
                ),
                TextField(
                  controller: int_controller,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Enter int'),
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: submitText,
                  child: Text('submit'),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Delete All Data"),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: deleteData,
                  child: Text('Delete'),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentindex,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.data_usage), label: "Show Data"),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: "Add"),
          BottomNavigationBarItem(icon: Icon(Icons.delete), label: "Delete")
        ],
        onTap: (index) {
          setState(() {
            _currentindex = index;
          });
        },
      ),
    );
  }
}
