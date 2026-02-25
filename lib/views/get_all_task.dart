import 'package:danish_apis/models/taskListing.dart';
import 'package:danish_apis/services/task.dart';
import 'package:danish_apis/views/create_task.dart';
import 'package:danish_apis/views/filter_task.dart';
import 'package:danish_apis/views/get_completed_task.dart';
import 'package:danish_apis/views/get_inCompleted_task.dart';
import 'package:danish_apis/views/profile.dart';
import 'package:danish_apis/views/search_task.dart';
import 'package:danish_apis/views/update_task.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/userTokenProvider.dart';

class GetAllTask extends StatefulWidget {
  const GetAllTask({super.key});

  @override
  State<GetAllTask> createState() => _GetAllTaskState();
}

class _GetAllTaskState extends State<GetAllTask> {
  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserTokenProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text("Get All Task"),
          actions: [
            IconButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> GetCompletedTask()));
            }, icon: Icon(Icons.circle)),
            IconButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> GetInCompletedTask()));
            }, icon: Icon(Icons.incomplete_circle)),
            IconButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> SearchTask()));
            }, icon: Icon(Icons.search)),
            IconButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> FilterTask()));
            }, icon: Icon(Icons.filter)),
            IconButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> Profile()));
            }, icon: Icon(Icons.person)),
          ],
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
           ListView.builder(
             itemCount: taskListingModel.tasks?.length,
             itemBuilder: (BuildContext context, int index) {
              return ListTile(
                leading: Icon(Icons.task),
                title: Text(taskListingModel.tasks![index].description.toString()),
                trailing: Row(children: [
                  Checkbox(
                      value: taskListingModel.tasks![index].complete,
                      onChanged: (value)async{
                        await TaskServices().markTaskAsCompleted(
                            token: userProvider.getToken().toString(),
                            taskID : taskListingModel.tasks![index].id.toString());
                      }),
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
