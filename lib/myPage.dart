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

  isHasTitle(title) {
    for (int i = 0; i < mybox.length; i++) {
      if (mybox.getAt(i)!.title == title) {
        return true;
      }
    }
    return false;
  }

  findTitle(title) {
    for (int i = 0; i < mybox.length; i++) {
      if (mybox.getAt(i)!.title == title) {
        return i;
      }
    }
    return 0;
  }

  submitText() {
    setState(() {
      List<DateTime> newlist = [];
      newlist.add(DateTime.now());
      LastTime newLasttime;
      String newTitle = titleController.text;
      if (isHasTitle(titleController.text)) {
        int index = findTitle(newTitle);
        newLasttime = mybox.getAt(index)!;
        newLasttime.date.add(DateTime.now());
        mybox.put(index, newLasttime);
      } else {
        newLasttime =
            new LastTime(newTitle, categoriesController.text, newlist);
        mybox.add(newLasttime);
      }
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

  Widget setupAlertDialogContainer(context, myboxIndex) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          color: Colors.grey,
          height: 300.0,
          width: 300.0,
          child: ListView.builder(
            itemCount: mybox.getAt(myboxIndex)!.date.length,
            itemBuilder: (BuildContext context, int index) {
              dynamic date = mybox.getAt(myboxIndex)!.date.reversed.toList();
              return ListTile(
                title: Card(
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(date[index].day.toString() +
                              "/" +
                              date[index].month.toString() +
                              "/" +
                              date[index].year.toString() +
                              " at " +
                              date[index].hour.toString() +
                              ":" +
                              date[index].minute.toString()),
                        ))),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("LastTime List"),
      ),
      body: IndexedStack(
        index: _currentindex,
        children: [
          Center(
              // Show all data page
              child: Column(
            children: [
              Expanded(
                  child: ValueListenableBuilder(
                valueListenable: mybox.listenable(),
                builder: (context, Box<LastTime> mybox, _) {
                  return ListView.separated(
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(),
                      padding: const EdgeInsets.all(8),
                      itemCount: mybox.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text(mybox.getAt(index)!.title +
                              " at " +
                              mybox
                                  .getAt(index)!
                                  .date[mybox.getAt(index)!.date.length - 1]
                                  .day
                                  .toString() +
                              "/" +
                              mybox
                                  .getAt(index)!
                                  .date[mybox.getAt(index)!.date.length - 1]
                                  .month
                                  .toString() +
                              "/" +
                              mybox
                                  .getAt(index)!
                                  .date[mybox.getAt(index)!.date.length - 1]
                                  .year
                                  .toString() +
                              " " +
                              mybox
                                  .getAt(index)!
                                  .date[mybox.getAt(index)!.date.length - 1]
                                  .hour
                                  .toString() +
                              ":" +
                              mybox
                                  .getAt(index)!
                                  .date[mybox.getAt(index)!.date.length - 1]
                                  .minute
                                  .toString()),
                          subtitle: Text(mybox.getAt(index)!.categories),
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text(mybox.getAt(index)!.title),
                                    content: ValueListenableBuilder(
                                        valueListenable: mybox.listenable(),
                                        builder:
                                            (context, Box<LastTime> mybox, _) {
                                          return setupAlertDialogContainer(
                                              context, index);
                                        }),
                                    actions: <Widget>[
                                      TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                          child: Text('OK')),
                                      TextButton(
                                          onPressed: () {
                                            setState(() {
                                              mybox
                                                  .getAt(index)!
                                                  .date
                                                  .add(DateTime.now());
                                              Navigator.pop(context);
                                            });
                                          },
                                          child: Text('Add')),
                                    ],
                                  );
                                });
                          },
                        );
                      });
                },
              )),
            ],
          )),
          Center(
              // Search Page
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
                      padding: const EdgeInsets.all(8),
                      itemCount: mybox.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (mybox.getAt(index)!.categories == searchCategories)
                          return ListTile(
                            title: Text(mybox.getAt(index)!.title +
                                " at " +
                                mybox
                                    .getAt(index)!
                                    .date[mybox.getAt(index)!.date.length - 1]
                                    .day
                                    .toString() +
                                "/" +
                                mybox
                                    .getAt(index)!
                                    .date[mybox.getAt(index)!.date.length - 1]
                                    .month
                                    .toString() +
                                "/" +
                                mybox
                                    .getAt(index)!
                                    .date[mybox.getAt(index)!.date.length - 1]
                                    .year
                                    .toString() +
                                " " +
                                mybox
                                    .getAt(index)!
                                    .date[mybox.getAt(index)!.date.length - 1]
                                    .hour
                                    .toString() +
                                " : " +
                                mybox
                                    .getAt(index)!
                                    .date[mybox.getAt(index)!.date.length - 1]
                                    .minute
                                    .toString()),
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
            // Add Page
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
            // Delete
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
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.data_usage),
              label: "Show All Data",
              backgroundColor: Colors.blue),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
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
