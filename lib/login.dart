import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'Welcome to TnT',
      home: Container( //컨테이너로 감싼다.
        decoration: BoxDecoration( //decoration 을 준다.
            image: DecorationImage(
                image: AssetImage("images/logo.png"), fit: BoxFit.contain)),
        child: Scaffold(
          backgroundColor: Colors.black54, //스캐폴드에 백그라운드를 투명하게 한다.
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: Text(''),
            centerTitle: true,
          ),
          body: SafeArea(
                child: Container(
                  alignment: Alignment(0.0, 0.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center, //spaceAround
                    //crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 300,
                        height: 50,
                        child: ElevatedButton.icon(
                          label: Text(
                              "Google로 로그인",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              )
                          ),
                          icon: Image.asset(
                              'images/google_logo.png',
                              width: 50,
                              height: 50,
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            onPrimary: Colors.grey,
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(15.0),
                            ),
                          ),
                          onPressed: () async{
                            //구글 로그인
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      SizedBox(height: 50),
                    ],
                  ),
                )
          )
        ),
      ),
    );
  }
}