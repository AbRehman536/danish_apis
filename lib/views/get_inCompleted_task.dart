import 'package:danish_apis/models/taskListing.dart';
import 'package:danish_apis/services/task.dart';
import 'package:danish_apis/views/create_task.dart';
import 'package:danish_apis/views/update_task.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/userTokenProvider.dart';

class GetInCompletedTask extends StatelessWidget {
  const GetInCompletedTask({super.key});

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserTokenProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Get In Completed Task"),
      ),
      body: FutureProvider.value(
        value: TaskServices().getInCompletedTask(userProvider.getToken().toString()),
        initialData: [TaskListingModel()],
        builder: (context, child){
          TaskListingModel taskListingModel = context.watch<TaskListingModel>();
          return taskListingModel.tasks == null ?
          Center(child: CircularProgressIndicator(),) :
          ListView.builder(itemBuilder: (BuildContext context, int index) {
            return ListTile(
              leading: Icon(Icons.task),
              title: Text(taskListingModel.tasks![index].description.toString()),
              trailing: Row(children: [
                IconButton(onPressed: ()async{
                  try{
                    await TaskServices().deleteTask(
                        token: userProvider.getToken().toString(),
                        taskID: taskListingModel.tasks![index].id.toString())
                        .then((val){
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text("Task Deleted Successfully")));
                    });
                  }catch(e){
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(e.toString())));

                  }
                }, icon: Icon(Icons.delete)),
                IconButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> UpdateTask(model: taskListingModel.tasks![index])));
                }, icon: Icon(Icons.edit))
              ],),
            );
          },);
        },
      ) ,
    );
  }
}
