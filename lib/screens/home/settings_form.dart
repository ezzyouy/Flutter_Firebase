import 'package:brewcrew/models/user.dart';
import 'package:brewcrew/services/db.dart';
import 'package:brewcrew/shared/constants.dart';
import 'package:brewcrew/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsForm extends StatefulWidget {

  @override
  State<SettingsForm> createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> sugares = ['0', '1', '2', '3', '4'];

  String? _currentName;
  String? _currentSugars;
  int? _currentStrength;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserE>(context);
    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: user.uid).userData,
      builder: (context, snapshot) {
        if(snapshot.hasData){
          UserData? userData= snapshot.data;
          return Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    'Update your brew settings.',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  SizedBox(height: 20.0,),
                  TextFormField(
                    initialValue: userData?.name,
                    decoration: textInputDecoration,
                    validator: (val) =>
                    val!.isEmpty
                        ? 'Please enter a name'
                        : null,
                    onChanged: (val) => setState(() => _currentName = val),
                  ),
                  SizedBox(height: 20.0,),
                  DropdownButtonFormField(
                    decoration: textInputDecoration,
                    value: _currentSugars ?? userData?.sugars,
                    items: sugares.map((sugar) {
                      return DropdownMenuItem(
                          value: sugar,
                          child: Text('$sugar sugars')
                      );
                    }).toList(),
                    onChanged: (val) =>
                        setState(() => _currentSugars = val as String),
                  ),
                  Slider(
                      min: 100,
                      max: 900,
                      divisions: 8,
                      value: (_currentStrength ?? userData?.strength)!.toDouble(),
                      activeColor: Colors.brown[_currentStrength ?? userData?.strength as int],
                      inactiveColor: Colors.brown[_currentStrength ?? userData?.strength as int],
                      onChanged: (val) =>
                          setState(() => _currentStrength = val.round())
                  ),
                  RaisedButton(
                      color: Colors.pink[400],
                      child: Text(
                        'Update',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        if(_formKey.currentState!.validate()){
                          await DatabaseService(uid: user.uid).updateUserData(
                            _currentSugars ?? userData?.sugars as String,
                            _currentName ??  userData?.name as String,
                            _currentStrength ??  userData?.strength as int
                          );
                          Navigator.pop(context);
                        }
                      }
                  )
                ],
              )
          );
        }else{
          return Loading();
        }

      },

    );
  }
}
