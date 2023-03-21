import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mywall/user/view/sign_up_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String? userEmail;
  String? userPassword;

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height/5),
                  const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 36.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Color(0xffebebeb),
                      hintText: 'email',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(28.0)),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    // onSubmitted -> 완료버튼 눌러야 업데이트, onChanged->글자 타이핑 될때마다 업데이트
                    onChanged: (String text) {
                      setState(() {
                        userEmail = text;
                      });
                    },
                  ),
                  const SizedBox(height: 8.0),
                  TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Color(0xffebebeb),
                      hintText: 'password',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(28.0)),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    // onSubmitted -> 완료버튼 눌러야 업데이트, onChanged->글자 타이핑 될때마다 업데이트
                    onChanged: (String text) {
                      setState(() {
                        userPassword = text;
                      });
                    },
                  ),
                  const SizedBox(height: 8.0),
                  TextButton(
                    onPressed: () async {
                      if(userEmail!=null && userPassword!=null){
                        try{
                          await FirebaseAuth.instance.signInWithEmailAndPassword(
                            email: userEmail!,
                            password: userPassword!,
                          );
                        } catch(e){
                          final snackBar = SnackBar(content: Text(e.toString()));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          return;
                        } finally {
                          Navigator.popUntil(context, ModalRoute.withName('/'));
                        }
                      } else{
                        // userEmail, userPassword 입력을 완전히 끝내지 못한 상태
                        const snackBar = SnackBar(content: Text('Please enter your id and password'));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }

                    },
                    style: TextButton.styleFrom(
                      minimumSize:
                          Size(MediaQuery.of(context).size.width - 48, 60),
                      backgroundColor: Colors.black38,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28)),
                    ),
                    child: const Text(
                      'Sign in',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) {
                                  return const SignupScreen();
                                },
                              ),
                            );
                          },
                          // style: TextButton.styleFrom(
                          //   foregroundColor: Colors.black,
                          // ),
                          child: const Text('Sign up with Email'),
                        ),
                      ),
                      const SizedBox(width: 4.0),
                      const Text('|'),
                      const SizedBox(width: 4.0),
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            signInWithGoogle();
                          },
                          style: TextButton.styleFrom(
                              // foregroundColor: isGuide ? Colors.grey : Colors.black,
                              ),
                          child: const Text('Sign in with Google'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
