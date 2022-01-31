import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/cubit/cubit.dart';
import 'package:todo/cubit/states.dart';

class ArchivedTasks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TaskCubit , TaskStates>(
      listener: (context , index){},
      builder: (context , index){
        final cubitListener = TaskCubit.get(context);
        return cubitListener.archivedTask.isNotEmpty ?  ListView.builder(itemBuilder:(context , index) => Dismissible(
          key: Key(cubitListener.archivedTask[index]['id'].toString()),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Card(
              color: const Color.fromRGBO(204, 204, 209, 1),
              elevation: 15,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30.0,
                        child: Text('${cubitListener.archivedTask[index]['time']}',style: TextStyle(color: Theme.of(context).textTheme.subtitle1.color),),
                        backgroundColor: Theme.of(context).bottomSheetTheme.backgroundColor,
                      ),
                      const SizedBox(width: 10.0),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${cubitListener.archivedTask[index]['title']}',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).textTheme.subtitle1.color,
                              ),
                            ),
                            Text(
                              '${cubitListener.archivedTask[index]['description']}',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).textTheme.subtitle1.color,
                              ),
                            ),
                            Text(
                              '${cubitListener.archivedTask[index]['date']}',
                              style: Theme.of(context).textTheme.caption.copyWith(fontSize: 14,color:Theme.of(context).textTheme.subtitle1.color ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      IconButton(
                        onPressed: () {
                          cubitListener
                              .updateDatabase(status: 'new', id: cubitListener.archivedTask[index]['id']);
                        },
                        icon: const Icon(Icons.replay),
                        color:const Color.fromRGBO(40, 55, 71, 1),
                      ),
                      const SizedBox(width: 10.0),
                      IconButton(
                        onPressed: () {
                          cubitListener
                              .updateDatabase(status: 'done', id: cubitListener.archivedTask[index]['id']);
                        },
                        icon: const Icon(Icons.check_box),
                        color: Colors.green,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          onDismissed: (direction)
          {
            cubitListener.deleteData(id: cubitListener.archivedTask[index]['id']);
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
          itemCount: cubitListener.archivedTask.length,
        ) : const Center(child:Text('No Archived Tasks Yet!',style: TextStyle(color: Colors.white,fontSize: 25),));
      },
    );
  }
}
