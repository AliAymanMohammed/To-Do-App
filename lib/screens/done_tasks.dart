import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/cubit/cubit.dart';
import 'package:todo/cubit/states.dart';

class DoneTasks extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TaskCubit , TaskStates>(
      listener: (context , index){},
      builder: (context , index){
        final cubitListener = TaskCubit.get(context);
        return cubitListener.doneTask.isNotEmpty ?  ListView.builder(itemBuilder:(context , index) => Dismissible(
          key: Key(cubitListener.doneTask[index]['id'].toString()),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Card(
              color: Theme.of(context).accentColor,
              elevation: 15,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30.0,
                        child: Text('${cubitListener.doneTask[index]['time']}',style: TextStyle(color: Theme.of(context).textTheme.subtitle1.color),),
                        backgroundColor: Theme.of(context).bottomSheetTheme.backgroundColor,
                      ),
                      const SizedBox(width: 10.0),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${cubitListener.doneTask[index]['title']}',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).textTheme.subtitle1.color,
                              ),
                            ),
                            Text(
                              '${cubitListener.doneTask[index]['description']}',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).textTheme.subtitle1.color,
                              ),
                            ),
                            Text(
                              '${cubitListener.doneTask[index]['date']}',
                              style: Theme.of(context).textTheme.caption.copyWith(fontSize: 14,color:Theme.of(context).textTheme.subtitle1.color ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      IconButton(
                        onPressed: () {
                          cubitListener
                              .updateDatabase(status: 'new', id: cubitListener.doneTask[index]['id']);
                        },
                        icon: const Icon(Icons.replay),
                        color: const Color.fromRGBO(40, 55, 71, 1),
                      ),
                      const SizedBox(width: 10.0),
                      IconButton(
                        onPressed: () {
                          cubitListener
                              .updateDatabase(status: 'archived', id: cubitListener.doneTask[index]['id']);
                        },
                        icon: const Icon(Icons.archive),
                        color: Colors.white70,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          onDismissed: (direction)
          {
            cubitListener.deleteData(id: cubitListener.doneTask[index]['id']);
          },
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            color: Theme.of(context).errorColor,
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(10),
            child:const Icon(Icons.delete ,color: Colors.white,size: 40,),
          ),
          confirmDismiss: (direction){
            return showDialog(context: context, builder: (context)=> AlertDialog(
              actionsAlignment: MainAxisAlignment.center,
              title: const Text('Are You Sure ? '),
              content: const Text('Your Are gonna delete the task.'),
              actions: [
                FlatButton(onPressed: (){
                  Navigator.of(context).pop(false);
                }, child:const Text('No'),),
                FlatButton(onPressed: (){
                  Navigator.of(context).pop(true);
                }, child: const Text('Yes'),),
              ],
            ),);
          },
        ),
          itemCount: cubitListener.doneTask.length,
        ) : const Center(child:Text('No Done Tasks Yet!',style: TextStyle(color: Colors.white,fontSize: 25),));
      },
    );
  }
}
