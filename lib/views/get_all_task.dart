import 'package:danish_apis/models/taskListing.dart';
import 'package:danish_apis/services/task.dart';
import 'package:danish_apis/views/create_task.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/userTokenProvider.dart';

class GetAllTask extends StatelessWidget {
  const GetAllTask({super.key});

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserTokenProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text("Get All Task"),
        ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> CreateTask()));
      }),
      body: FutureProvider.value(
          value: TaskServices().getAllTask(userProvider.getToken().toString()),
          initialData: [TaskListingModel()],
          builder: (context, child){
            TaskListingModel taskListingModel = context.watch<TaskListingModel>();
           return taskListingModel.tasks == null ?
            Center(child: CircularProgressIndicator(),) :
           ListView.builder(itemBuilder: (BuildContext context, int index) {
              return ListTile(
                leading: Icon(Icons.task),
                title: Text(taskListingModel.tasks![index].description.toString()),
              );
            },);
          },
      ) ,
    );
  }
}
