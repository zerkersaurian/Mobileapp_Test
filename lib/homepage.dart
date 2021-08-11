import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:preparation/class/Data.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
        TextField(
          controller: string_controller,
          decoration: InputDecoration(
              border: OutlineInputBorder(), labelText: 'Enter String'),
        ),
        SizedBox(
          height: 20,
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
    );
  }
}
