import 'package:flutter/material.dart';
import 'package:frontend/models/user_model.dart';


class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  LoginFormState createState() {
    return LoginFormState();
  }
}

class LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  List<User>? users;


  // void _submit() async{
  //   if(_formKey.currentState!.validate()){
  //     setState(() => _isLoading = true);

  //     await Future.delayed(const Duration(seconds: 2));

  //     setState(() => _isLoading = false);

  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Email',
              icon: Icon(Icons.email_outlined),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Email is required';
              }
              if (!value.contains('@')) {
                return 'Enter a valid email';
              }
              return null;
            },
          ),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Password',
              icon: Icon(Icons.lock_outline),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Password is required';
              }
              // if(!value.contains('@')){
              //   return 'Enter a valid pasword';
              // }
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Logged in'),
                    ), //comes up when submit is pressed
                  );
                }
              },
              child: const Text('Log in'), //the button
            ),
          ),
        ],
      ),
    );
  }
}
