import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/screens/archived_tasks.dart';
import 'package:todo/screens/done_tasks.dart';
import 'package:todo/screens/new_tasks.dart';

import '/cubit/states.dart';

class TaskCubit extends Cubit<TaskStates>{

  TaskCubit() : super(TaskInitialStateState());

  static TaskCubit get(context){
    return BlocProvider.of(context);
  }

  var currentIndex = 0;
  void changeNavBarIndex(int index){
    currentIndex = index;
    emit(ChangeNavBarIndex());
  }
List <String> titles = [
  'New Tasks',
  'Done Tasks',
  'Archived Tasks',
];
  List<Widget> screens = [
    NewTasks(),
    DoneTasks(),
    ArchivedTasks(),
  ];

  List<Map> newTask = [];
  List<Map> doneTask = [];
  List<Map> archivedTask = [];
  Database dataBase;

  void createDatabase()
  {
    openDatabase(
        'tasks.db',
        version: 1,
        onCreate: (dataBase , version){
          dataBase.execute('CREATE TABLE tasks(id INTEGER PRIMARY KEY , title TEXT , description TEXT , time TEXT , date TEXT , status TEXT)').then((value){
          });
        },
        onOpen: (dataBase)
        {
          getDataFromDatabase(dataBase);
        }
    ).then((value) {
      dataBase = value;
      emit(CreateDataBaseState());
    });
  }

  Future insertToDatabase({
    @required String title,
    @required String description,
    @required String time,
    @required String date,
  })async
  {
    return await dataBase.transaction((txn){
      txn.rawInsert('INSERT INTO tasks(title , description,time , date , status) VALUES("$title","$description","$time","$date","new")').then((value){
        emit(InsertDataBaseState());
        getDataFromDatabase(dataBase);
      });
      return null;
    });
  }

  void getDataFromDatabase(dataBase)
  {
    newTask = [];
    doneTask = [];
    archivedTask = [];

    emit(GetDataBaseLoadingState());
    dataBase.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element) {
        if(element['status'] == 'new') {
          newTask.add(element);
        } else if(element['status'] == 'done') {
          doneTask.add(element);
        } else {
          archivedTask.add(element);
        }

      });
      emit(GetDataBaseSuccessState());
    });
  }

  void updateDatabase({
    @required String status,
    @required int id
  })
  {
    dataBase.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?',
        [status, id]).then((value) {
      emit(UpdateDataBaseState());
      getDataFromDatabase(dataBase);
    });
  }

  void deleteData({@required int id})
  {
    dataBase.rawDelete('DELETE FROM tasks WHERE id = ?', [id]);
    emit(DeleteDataBaseState());
    getDataFromDatabase(dataBase);
  }

}