import 'package:hive_flutter/hive_flutter.dart';

class TodoDataBase {
  List toDoList = [];
  // calling hive box
  final _myBox = Hive.box('myBox');

  void createData() {
    toDoList = [
      ["This is a default list", true],
      ["Delete and create your own lists", true],
    ];
  }

  void loadData() {
    toDoList = _myBox.get('TODOLIST');
  }

  void updateDataBase() {
    _myBox.put('TODOLIST', toDoList);
  }
}
