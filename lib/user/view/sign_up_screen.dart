import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mywall/common/utills/login_validators.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  String? userName;
  String? email;
  String? password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Signup',
                style: TextStyle(
                  fontSize: 36.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                autovalidateMode: AutovalidateMode.always,
                validator: nameValidator,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xffebebeb),
                  hintText: 'name',
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                  ),
                  prefixIcon: const Icon(Icons.person),
                  border: nameValidator(userName) == null && userName != null
                      ? const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(28.0)),
                          borderSide: BorderSide.none,
                        )
                      : const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(28.0)),
                        ),
                ),
                onChanged: (String s) {
                  setState(() {
                    userName = s;
                  });
                },
              ),
              const SizedBox(height: 8.0),
              TextFormField(
                autovalidateMode: AutovalidateMode.always,
                validator: emailValidator,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xffebebeb),
                  hintText: 'email',
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                  ),
                  prefixIcon: const Icon(Icons.email),
                  border: emailValidator(email) == null && email != null
                      ? const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(28.0)),
                          borderSide: BorderSide.none,
                        )
                      : const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(28.0)),
                        ),
                ),
                onChanged: (String s) {
                  setState(() {
                    email = s;
                  });
                },
              ),
              const SizedBox(height: 8.0),
              TextFormField(
                autovalidateMode: AutovalidateMode.always,
                validator: passwordValidator,
                obscureText: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xffebebeb),
                  hintText: 'password',
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                  ),
                  prefixIcon: const Icon(Icons.lock),
                  border: passwordValidator(password) == null &&
                          password != null
                      ? const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(28.0)),
                          borderSide: BorderSide.none,
                        )
                      : const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(28.0)),
                        ),
                ),
                onChanged: (String s) {
                  setState(() {
                    password = s;
                  });
                },
              ),
              const SizedBox(height: 8.0),
              TextButton(
                style: TextButton.styleFrom(
                  minimumSize: Size(MediaQuery.of(context).size.width - 48, 60),
                  backgroundColor: Colors.black38,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28)),
                ),
                child: const Text(
                  'Sign up',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;
                  try {
                    // firebase user 생성
                    final createUser = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                      email: email!,
                      password: password!,
                    );
                    if (createUser.user != null) {
                      await createUser.user!.sendEmailVerification();
                      await createUser.user!.updateDisplayName(userName);
                    }
                  } catch (e) {
                    final snackBar = SnackBar(content: Text(e.toString()));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    print(e);
                  } finally {
                    Navigator.popUntil(context, ModalRoute.withName('/'));
                  }
                },
              ),
              const SizedBox(height: 4.0),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                        onPressed: () {
                          Navigator.popUntil(context, ModalRoute.withName('/'));
                        },
                        child: const Text('Go back to the Login page')),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
