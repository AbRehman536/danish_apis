import 'package:danish_apis/services/task.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/task.dart';
import '../provider/userTokenProvider.dart';

class UpdateTask extends StatefulWidget {
  final Task model;
  const UpdateTask({super.key, required this.model});

  @override
  State<UpdateTask> createState() => _UpdateTaskState();
}

class _UpdateTaskState extends State<UpdateTask> {
  TextEditingController descriptionController = TextEditingController();
  bool isLoading = false;
  @override
  void initState(){
    super.initState();
  descriptionController = TextEditingController(
    text: widget.model.description.toString()
  );

  }
  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserTokenProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Task"),
      ),
      body: Column(children: [
        TextField(controller: descriptionController,),
        isLoading ? Center(child: CircularProgressIndicator(),)
            :ElevatedButton(onPressed: ()async{
          try{
            isLoading = true;
            setState(() {});
            await TaskServices().updateTask(
                token: userProvider.getToken().toString(),
                description: descriptionController.text,
                taskID: widget.model.id.toString())
                .then((val){
              isLoading = false;
              setState(() {});
              showDialog(context: context, builder: (BuildContext context) {
                return AlertDialog(
                  content: Text("Update Successfully"),
                  actions: [
                    TextButton(onPressed: (){
                      Navigator.pop(context);
                      Navigator.pop(context);
                    }, child: Text("Ok"))
                  ],
                );
              },);
            });
          }catch(e){
            isLoading = false;
            setState(() {});
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(e.toString())));

          }
        }, child: Text("Update Task"))
      ],),
    );
  }
}
