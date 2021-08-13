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
  String categoriesListString = '';

  final mybox = Hive.box<LastTime>('data');
  late TextEditingController titleController;
  late TextEditingController categoriesController;
  late TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    categoriesController = TextEditingController();
    searchController = TextEditingController();
    searchCategories = '';
  }

  @override
  void dispose() {
    titleController.dispose();
    categoriesController.dispose();
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
      titleController.text = '';
      categoriesController.text = '';
    });
  }

  setSearch() {
    setState(() {
      searchCategories = searchController.text;
      searchController.text = '';
    });
  }

  minuteTwoDigit(minute) {
    if (minute < 10)
      return "0$minute";
    else
      return minute.toString();
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
                    color: index == 0 ? Colors.blue[800] : Colors.white,
                    child: Column(
                      children: [
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(
                                date[index].day.toString() +
                                    "/" +
                                    date[index].month.toString() +
                                    "/" +
                                    date[index].year.toString() +
                                    " at " +
                                    date[index].hour.toString() +
                                    ":" +
                                    minuteTwoDigit(date[index].minute),
                                style: TextStyle(
                                    color: index == 0
                                        ? Colors.white
                                        : Colors.black),
                              ),
                            )),
                      ],
                    )),
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
                          title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  mybox.getAt(index)!.title,
                                  style: TextStyle(fontSize: 21),
                                ),
                                Text(
                                    mybox
                                            .getAt(index)!
                                            .date[mybox
                                                    .getAt(index)!
                                                    .date
                                                    .length -
                                                1]
                                            .day
                                            .toString() +
                                        "/" +
                                        mybox
                                            .getAt(index)!
                                            .date[mybox
                                                    .getAt(index)!
                                                    .date
                                                    .length -
                                                1]
                                            .month
                                            .toString() +
                                        "/" +
                                        mybox
                                            .getAt(index)!
                                            .date[mybox
                                                    .getAt(index)!
                                                    .date
                                                    .length -
                                                1]
                                            .year
                                            .toString(),
                                    style: TextStyle(fontSize: 21))
                              ]),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(mybox.getAt(index)!.categories,
                                  style: TextStyle(fontSize: 17)),
                              Text(
                                  mybox
                                          .getAt(index)!
                                          .date[
                                              mybox.getAt(index)!.date.length -
                                                  1]
                                          .hour
                                          .toString() +
                                      ":" +
                                      minuteTwoDigit(mybox
                                          .getAt(index)!
                                          .date[
                                              mybox.getAt(index)!.date.length -
                                                  1]
                                          .minute),
                                  style: TextStyle(fontSize: 17))
                            ],
                          ),
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
                                              List<DateTime> date =
                                                  mybox.getAt(index)!.date;
                                              date.add(DateTime.now());
                                              LastTime newLasttime = LastTime(
                                                  mybox.getAt(index)!.title,
                                                  mybox
                                                      .getAt(index)!
                                                      .categories,
                                                  date);
                                              mybox.put(index, newLasttime);
                                              Navigator.pop(context);
                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title: Text(
                                                          "Successfully Added"),
                                                      actions: <Widget>[
                                                        TextButton(
                                                            onPressed: () =>
                                                                Navigator.pop(
                                                                    context),
                                                            child: Text("OK"))
                                                      ],
                                                    );
                                                  });
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
              Container(
                  width: 500,
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText:
                            'Search Categories ( ทำความสะอาด / งาน / อื่นๆ )'),
                  )),
              SizedBox(
                height: 30,
              ),
              Container(
                width: 120,
                height: 50,
                child: ElevatedButton(
                  onPressed: setSearch,
                  child: Text(
                    'Search',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
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
                            title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(mybox.getAt(index)!.title,
                                      style: TextStyle(fontSize: 21)),
                                  Text(
                                      mybox
                                              .getAt(index)!
                                              .date[mybox
                                                      .getAt(index)!
                                                      .date
                                                      .length -
                                                  1]
                                              .day
                                              .toString() +
                                          "/" +
                                          mybox
                                              .getAt(index)!
                                              .date[mybox
                                                      .getAt(index)!
                                                      .date
                                                      .length -
                                                  1]
                                              .month
                                              .toString() +
                                          "/" +
                                          mybox
                                              .getAt(index)!
                                              .date[mybox
                                                      .getAt(index)!
                                                      .date
                                                      .length -
                                                  1]
                                              .year
                                              .toString(),
                                      style: TextStyle(fontSize: 21))
                                ]),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(mybox.getAt(index)!.categories,
                                    style: TextStyle(fontSize: 17)),
                                Text(
                                    mybox
                                            .getAt(index)!
                                            .date[mybox
                                                    .getAt(index)!
                                                    .date
                                                    .length -
                                                1]
                                            .hour
                                            .toString() +
                                        ":" +
                                        minuteTwoDigit(mybox
                                            .getAt(index)!
                                            .date[mybox
                                                    .getAt(index)!
                                                    .date
                                                    .length -
                                                1]
                                            .minute),
                                    style: TextStyle(fontSize: 17))
                              ],
                            ),
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text(mybox.getAt(index)!.title),
                                      content: ValueListenableBuilder(
                                          valueListenable: mybox.listenable(),
                                          builder: (context,
                                              Box<LastTime> mybox, _) {
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
                                                List<DateTime> date =
                                                    mybox.getAt(index)!.date;
                                                date.add(DateTime.now());
                                                LastTime newLasttime = LastTime(
                                                    mybox.getAt(index)!.title,
                                                    mybox
                                                        .getAt(index)!
                                                        .categories,
                                                    date);
                                                mybox.put(index, newLasttime);
                                                Navigator.pop(context);
                                                showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                        title: Text(
                                                            "Successfully Added"),
                                                        actions: <Widget>[
                                                          TextButton(
                                                              onPressed: () =>
                                                                  Navigator.pop(
                                                                      context),
                                                              child: Text("OK"))
                                                        ],
                                                      );
                                                    });
                                              });
                                            },
                                            child: Text('Add')),
                                      ],
                                    );
                                  });
                            },
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
                Container(
                    width: 500,
                    child: TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Enter Title'),
                    )),
                SizedBox(
                  height: 30,
                ),
                Container(
                    width: 500,
                    child: TextField(
                      controller: categoriesController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText:
                              'Enter Categories ( ทำความสะอาด / งาน / อื่นๆ )'),
                    )),
                SizedBox(
                  height: 30,
                ),
                Container(
                  width: 120,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: submitText,
                    child: Text(
                      'Add',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
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
                Text(
                  "Delete All Data",
                  style: TextStyle(fontSize: 40, color: Colors.blue),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                    height: 50,
                    width: 120,
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Are you sure?"),
                                actions: <Widget>[
                                  TextButton(
                                      onPressed: () {
                                        setState(() {
                                          mybox.clear();
                                          _currentindex = 0;
                                          Navigator.pop(context);
                                        });
                                      },
                                      child: Text("Delete")),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text("Cancel")),
                                ],
                              );
                            });
                      },
                      child: Text('Delete'),
                    )),
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
