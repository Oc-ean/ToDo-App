import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tyc_flutter/utils/database.dart';

import 'package:tyc_flutter/utils/todo_tile.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();

  // calling hive box
  final _myBox = Hive.box('myBox');
  TodoDataBase dataBase = TodoDataBase();

  @override
  void initState() {
    if (_myBox.get('TODOLIST') == null) {
      dataBase.createData();
    } else {
      dataBase.loadData();
    }

    super.initState();
  }

  void checkBoxChanged(bool? value, int index) {
    setState(() {
      dataBase.toDoList[index][1] = !dataBase.toDoList[index][1];
    });
    dataBase.updateDataBase();
  }

  void _saveNewTasks() {
    setState(() {
      if (_controller.text.isNotEmpty) {
        dataBase.toDoList.add([_controller.text, false]);
        _controller.clear();
      }
    });
    dataBase.updateDataBase();
  }

  void deleteTasks(int index) {
    setState(() {
      dataBase.toDoList.removeAt(index);
    });
    dataBase.updateDataBase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[200],
      appBar: AppBar(
        elevation: 2,
        automaticallyImplyLeading: false, // hides leading widget
        title: const Text(
          'To Do List',
          style: TextStyle(fontSize: 28),
        ),
      ),
      body: Column(
        children: [
          Flexible(
            child: SizedBox(
              width: double.maxFinite,
              height: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: dataBase.toDoList.length,
                itemBuilder: (context, index) {
                  return TodoTile(
                    taskName: dataBase.toDoList[index][0],
                    isCompleted: dataBase.toDoList[index][1],
                    onChanged: (value) => checkBoxChanged(value, index),
                    deleteFunction: (context) => deleteTasks(index),
                  );
                },
              ),
            ),
          ),
          _bottomNavigationBar(context),
        ],
      ),
    );
  }

  Widget _bottomNavigationBar(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.only(top: 15),
          margin: const EdgeInsets.only(left: 2, right: 5, bottom: 1),
          width: MediaQuery.of(context).size.width * 0.7,
          // height: 55.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.purple.withOpacity(0.5),
          ),
          child: SizedBox(
            width: 200,
            // width: MediaQuery.of(context).size.width - 90,
            child: TextField(
              controller: _controller,
              style: const TextStyle(color: Colors.black),
              textAlignVertical: TextAlignVertical.center,
              keyboardType: TextInputType.multiline,
              maxLines: 5,
              minLines: 1,
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(
                  top: 0,
                  left: 10,
                  bottom: 20,
                ),
                hintText: 'Add a new task',
                hintStyle: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 18,
        ),
        InkWell(
          onTap: () {
            _saveNewTasks();
          },
          child: Container(
            height: 60,
            width: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.purple,
            ),
            child: const Icon(
              Icons.add,
              size: 32,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
// Quick reminder of things that needs to be done.
