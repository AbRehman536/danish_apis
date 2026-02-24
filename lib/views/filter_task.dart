import 'package:danish_apis/models/taskListing.dart';
import 'package:danish_apis/services/task.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../provider/userTokenProvider.dart';

class FilterTask extends StatefulWidget {
  const FilterTask({super.key});

  @override
  State<FilterTask> createState() => _FilterTaskState();
}

class _FilterTaskState extends State<FilterTask> {
  DateTime? startDate;
  DateTime? endDate;
  bool isLoading = false;
  TaskListingModel? taskListingModel;
  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserTokenProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Filter Task"),
      ),
      body: Column(
        children: [
          Row(children: [
            ElevatedButton(onPressed: (){
              showDatePicker(
                  context: context, 
                  firstDate: DateTime(2000), 
                  lastDate: DateTime.now())
                  .then((val){
                setState(() {
                  startDate = val;
                });
              });
            }, child: Text("Select Start Date")),
            if(startDate != null)
              Center(child: Text(DateFormat.yMMMMEEEEd().format(startDate!)),),
            ElevatedButton(onPressed: (){
              showDatePicker(
                  context: context,
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now())
                  .then((val){
                    setState(() {
                      endDate = val;
                    });
              });
            }, child: Text("Select End Date")),
            if(endDate != null)
              Center(child: Text(DateFormat.yMMMMEEEEd().format(endDate!)),),

          ],),
          ElevatedButton(onPressed: ()async{
            try{
              isLoading = true;
              taskListingModel = null;
              setState(() {});

              final start = startDate!.toUtc().toString();
              final end = endDate!.toUtc().toString();
              TaskListingModel filterTask =
              await TaskServices().filterTask(
                  token: userProvider.getToken().toString(),
                  startDate: start,
                  endDate: end);

              setState(() {
                isLoading = false;
                taskListingModel = filterTask;
              });

            }catch(e){
              isLoading = false;
              setState(() {});
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(e.toString())));
            }
          }, child: Text("Filter Task")),
          if(isLoading == true)
            Center(child: CircularProgressIndicator(),),
          if(taskListingModel == null)
            Center(child: Text("No Data Found"),)
          else
            Expanded(child:
            ListView.builder(
              itemCount: taskListingModel!.tasks!.length,
              itemBuilder: (BuildContext context, int index) {
              return ListTile(
                leading: Icon(Icons.task),
                title: Text(taskListingModel!.tasks![index].description.toString()),
              );
            },))
        ],
      ),
    );
  }
}
