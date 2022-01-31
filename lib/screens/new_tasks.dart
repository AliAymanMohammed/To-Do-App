import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/cubit/cubit.dart';
import 'package:todo/cubit/states.dart';

class NewTasks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TaskCubit , TaskStates>(
      listener: (context , index){},
      builder: (context , index){
        final cubitListener = TaskCubit.get(context);
        return cubitListener.newTask.isNotEmpty ? ListView.builder(itemBuilder:(context , index) => Dismissible(
          key: Key(cubitListener.newTask[index]['id'].toString()),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ClipRect(
              child: Card(
                shape:RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ) ,
                color: Colors.grey[250],
                elevation: 15,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: const Color.fromRGBO(46, 204, 113, 1),
                          radius: 30.0,
                          child: Text('${cubitListener.newTask[index]['time']}',),
                        ),
                        const SizedBox(width: 10.0),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${cubitListener.newTask[index]['title']}',
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white
                                ),
                              ),
                              Flexible(
                                child: Text(
                                  '${cubitListener.newTask[index]['description']}',
                                  style: const TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white
                                  ),
                                ),
                              ),
                              Text(
                                '${cubitListener.newTask[index]['date']}',
                                style: const TextStyle(
                                  color: Colors.white60
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        IconButton(
                          onPressed: () {
                            cubitListener
                                .updateDatabase(status: 'done', id: cubitListener.newTask[index]['id']);
                          },
                          icon: const Icon(Icons.check_box),
                          color: Colors.greenAccent,
                        ),
                        const SizedBox(width: 10.0),
                        IconButton(
                          onPressed: () {
                           cubitListener
                                .updateDatabase(status: 'archived', id: cubitListener.newTask[index]['id']);
                          },
                          icon: const Icon(Icons.archive),
                          color: Colors.white60,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          onDismissed: (direction)
          {
            cubitListener.deleteData(id: cubitListener.newTask[index]['id']);
          },
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            color: Theme.of(context).errorColor,
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(10),
            child: const Icon(Icons.delete ,color: Colors.white,size: 40,),
          ),
          confirmDismiss: (direction){
            return showDialog(context: context, builder: (context)=> AlertDialog(
              actionsAlignment: MainAxisAlignment.center,
              title: const Text('Are You Sure ? '),
              content: const Text('Your Are gonna delete the task.'),
              actions: [
                FlatButton(onPressed: (){
                  Navigator.of(context).pop(false);
                }, child: const Text('No'),),
                FlatButton(onPressed: (){
                  Navigator.of(context).pop(true);
                }, child: const Text('Yes'),),
              ],
            ),);
          },
        ),
          itemCount: cubitListener.newTask.length,
          shrinkWrap: true,
        ) : const Center(child:Text('No Tasks Yet!',style: TextStyle(color: Colors.white,fontSize: 25),),);
      },
    );
  }
}
