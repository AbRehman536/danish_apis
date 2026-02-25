import 'package:danish_apis/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/userTokenProvider.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({super.key});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  TextEditingController nameController = TextEditingController();
  bool isLoading = false;
  @override
  void initState(){
    var userProvider = Provider.of<UserTokenProvider>(context);
    super.initState();
      nameController = TextEditingController(
        text: userProvider.getUser()!.user!.name.toString()
      );
  }
  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserTokenProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Profile"),
      ),
      body: Column(children: [
        TextField(controller: nameController,),
        isLoading ? Center(child: CircularProgressIndicator(),)
            :ElevatedButton(onPressed: ()async{
              try{
                await AuthService().updateProfile(
                    token: userProvider.getToken().toString(),
                    name: nameController.text)
                    .then((value)async{
                      await AuthService().getProfile(
                          token: userProvider.getToken().toString())
                          .then((val){
                            userProvider.setUser(val);
                            isLoading = false;
                            setState(() {});
                            setState(() {});
                            showDialog(context: context, builder: (BuildContext context) {
                              return AlertDialog(
                                content: Text("Update Profile Successfully"),
                                actions: [
                                  TextButton(onPressed: (){
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  }, child: Text("Ok"))
                                ],
                              );
                            },);
                      });
                });
              }catch(e){
                isLoading = false;
                setState(() {});
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(e.toString())));
              }
        }, child: Text("Update Profile"))
      ],),
    );
  }
}
