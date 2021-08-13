import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:preparation/class/LastTime.dart';

class Mylist extends StatefulWidget {
  @override
  MylistState createState() => MylistState();
}

class MylistState extends State<Mylist> {
  int _currentindex = 0;
  String searchCategories = '';

  final mybox = Hive.box<LastTime>('data');
  late TextEditingController titleController;
  late TextEditingController categoriesController;
  late TextEditingController dateController;
  late TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    categoriesController = TextEditingController();
    dateController = TextEditingController();
    searchController = TextEditingController();
    searchCategories = '';
  }

  @override
  void dispose() {
    titleController.dispose();
    categoriesController.dispose();
    dateController.dispose();
    searchController.dispose();
    super.dispose();
  }

  submitText() {
    setState(() {
      LastTime tmp = new LastTime(
          titleController.text, categoriesController.text, DateTime.now());
      mybox.add(tmp);
      _currentindex = 0;
    });
  }

  setSearch() {
    setState(() {
      searchCategories = searchController.text;
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
              SizedBox(
                height: 30,
              ),
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText:
                        'Search Categories ( ทำความสะอาด / งาน / อื่นๆ )'),
              ),
              SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: setSearch,
                child: Text('Search'),
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                  child: ValueListenableBuilder(
                valueListenable: mybox.listenable(),
                builder: (context, Box<LastTime> mybox, _) {
                  return ListView.builder(
                      /*
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(),*/
                      padding: const EdgeInsets.all(8),
                      itemCount: mybox.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (mybox.getAt(index)!.categories == searchCategories)
                          return ListTile(
                            title: Text(mybox.getAt(index)!.title +
                                " at " +
                                mybox.getAt(index)!.date.day.toString() +
                                "/" +
                                mybox.getAt(index)!.date.month.toString() +
                                "/" +
                                mybox.getAt(index)!.date.year.toString() +
                                " " +
                                mybox.getAt(index)!.date.hour.toString() +
                                " : " +
                                mybox.getAt(index)!.date.minute.toString()),
                            subtitle: Text(mybox.getAt(index)!.categories),
                          );
                        else
                          return SizedBox();
                      });
                },
              )),
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
                  controller: titleController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Enter Title'),
                ),
                SizedBox(
                  height: 30,
                ),
                TextField(
                  controller: categoriesController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText:
                          'Enter Categories ( ทำความสะอาด / งาน / อื่นๆ )'),
                ),
                SizedBox(
                  height: 30,
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
