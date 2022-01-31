import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo/cubit/cubit.dart';
import '../cubit/states.dart';
import 'package:timezone/data/latest.dart' as tz;
import '../notificationservice.dart';

class HomeScreen extends StatefulWidget {

  static const String routeName = '/home-screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  var formKey = GlobalKey<FormState>();
  var taskTitleController = TextEditingController();
  var taskDescriptionController = TextEditingController();
  var taskTimeController = TextEditingController();
  TimeOfDay selectedTime;
  DateTime selectedDate;
  var taskDateController = TextEditingController();


@override
  void initState() {
  tz.initializeTimeZones();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TaskCubit , TaskStates>(
      listener: (context , state){},
      builder: (context , state){
        final cubitListener = TaskCubit.get(context);
        return  Scaffold(
          appBar: AppBar(
            title: Text(cubitListener.titles[cubitListener.currentIndex]),
            centerTitle: true,
          ),
          body: cubitListener.screens[cubitListener.currentIndex],
          floatingActionButton: FloatingActionButton(
            onPressed: (){
              showModalBottomSheet(context: context, builder: (context)=>
                  Form(
                    key: formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                              ),
                              child: TextFormField(
                                decoration: const InputDecoration(
                                    prefixIcon:  Icon(Icons.task_rounded),
                                    label:  Text('Task Title'),
                                    hintText: 'Task Title',
                                    border: InputBorder.none
                                ),
                                validator: (value){
                                  if(value.isEmpty){
                                    return 'Please Enter A Title';
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.text,
                                controller: taskTitleController,
                              ),
                            ),
                            const SizedBox(height: 15,),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                              ),
                              child: TextFormField(
                                decoration: const InputDecoration(
                                    prefixIcon:  Icon(Icons.details_rounded),
                                    label:  Text('Task Description'),
                                    hintText: 'Task Description',
                                    border: InputBorder.none
                                ),
                                validator: (value){
                                  if(value.isEmpty){
                                    return 'Please Enter A Description';
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.multiline,
                                maxLines: 2,
                                controller: taskDescriptionController,
                              ),
                            ),
                            const SizedBox(height: 15,),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                              ),
                              child: TextFormField(
                                decoration: const InputDecoration(
                                    prefixIcon:  Icon(Icons.watch_later_rounded ),
                                    label:  Text('Task Time'),
                                    hintText: 'Task Time',
                                    border: InputBorder.none
                                ),
                                validator: (value){
                                  if(value.isEmpty){
                                    return 'Please Select A Time';
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.datetime,
                                controller: taskTimeController,
                                onTap: ()=> showTimePicker(context: context, initialTime: TimeOfDay.now()).then((date) {
                                  taskTimeController.text = date.format(context).toString();
                                  selectedTime = date;

                                }),
                              ),
                            ),
                            const SizedBox(height: 15,),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                              ),
                              child: TextFormField(
                                decoration: const InputDecoration(
                                    prefixIcon:  Icon(Icons.calendar_today_rounded),
                                    label:  Text('Task Date'),
                                    hintText: 'Task Date',
                                    border: InputBorder.none,
                                ),
                                validator: (value){
                                  if(value.isEmpty){
                                    return 'Please Select A Date';
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.datetime,
                                controller: taskDateController,
                                onTap: (){
                                  showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime.parse('2028-12-31')).then((value){
                                    taskDateController.text = DateFormat.yMMMd().format(value);
                                    selectedDate = value;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(height: 15,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                FlatButton(
                                  onPressed: (){
                                  cubitListener.insertToDatabase(
                                      title: taskTitleController.text,
                                      description:taskDescriptionController.text ,
                                      time: taskTimeController.text,
                                      date: taskDateController.text).then((value){
                                        var currentDateTime = DateTime.now();
                                        var currentDate  =  DateTime(currentDateTime.year, currentDateTime.month, currentDateTime.day, 0, 0, 0, 0, 0);
                                        var dateInSeconds =  selectedDate.difference(currentDate).inSeconds ;
                                        var currentTime = TimeOfDay.now();
                                        var currentTimeSeconds = (currentTime.hour * 3600) + (currentTime.minute* 60);
                                        var selectedTimeSeconds = (selectedTime.hour * 3600) + (selectedTime.minute* 60);
                                        var timeInSeconds = selectedTimeSeconds - currentTimeSeconds;
                                        if(selectedTimeSeconds >= currentTimeSeconds){
                                          NotificationService().showNotification(0,
                                            'Your Task (${taskTitleController.text}) is ready to go',
                                            taskDescriptionController.text,
                                            (dateInSeconds+timeInSeconds),);
                                        }
                                    taskTitleController.clear();
                                    taskDescriptionController.clear();
                                    taskTimeController.clear();
                                    taskDateController.clear();
                                    Navigator.of(context).pop();
                                  });
                                }, child: Container(
                                  height: 50,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.green, width: 2),
                                    borderRadius: BorderRadius.circular(20),
                                    gradient:  LinearGradient(
                                      colors:[
                                        Colors.orange.withOpacity(0.4),
                                        Colors.orange,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    )
                                  ),
                                  child: const Center(
                                    child:
                                    Text(
                                      'Add Task',
                                      style: TextStyle(
                                          color: Colors.black,
                                      ),
                                    ),
                                  )
                                  ,),
                                ),
                                FlatButton(
                                    onPressed: (){
                                      taskTitleController.clear();
                                      taskDescriptionController.clear();
                                      taskTimeController.clear();
                                      taskDateController.clear();
                                      Navigator.of(context).pop();
                                }, child: Container(
                                  height: 50,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.green , width: 2),
                                    borderRadius: BorderRadius.circular(20),
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.orange.withOpacity(0.4),
                                        Colors.orange,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                  child:const Center(
                                    child:
                                    Text(
                                      'Cancel',
                                      style: TextStyle(
                                          color: Colors.black
                                      ),
                                    ),
                                  )
                                  ,),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                backgroundColor: Colors.grey[400]
              );
            },
            child: const Icon(Icons.add , color: Colors.white,),
            elevation: 8,
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.menu) , label: 'Tasks'),
              BottomNavigationBarItem(icon: Icon(Icons.done) , label: 'Done'),
              BottomNavigationBarItem(icon: Icon(Icons.archive) , label: 'Archived'),
            ],
            currentIndex:cubitListener.currentIndex ,
            onTap: (int index){
              cubitListener.changeNavBarIndex(index);
            },
          ),
        );
      },
    );
  }
}

