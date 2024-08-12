import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:turnos_amerisa/model/sharedPreferences.dart';
import 'package:turnos_amerisa/services/login_service.dart';

class SignInScreen extends StatefulWidget {
  SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  SharedPrefsService sharedprefs = SharedPrefsService();

  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: formLogin(context),
    );
  }

  Widget formLogin(BuildContext context) {
    return Stack(
      children: <Widget>[
        logo(),
        Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(top: 270),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: Padding(
            padding: EdgeInsets.all(23),
            child: ListView(
              children: <Widget>[
                formUser(),
                formPassword(),
                buttonSubmmit(context),
                forgotPassword(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget logo() {
    return Container(
      child: Image.asset("assets/amerisalogo.png"),
      width: 1200,
      height: 300,
      decoration: BoxDecoration(color: Colors.white),
    );
  }

  Widget formUser() {
    return Padding(
      padding: EdgeInsets.only(top: 20, bottom: 20),
      child: Container(
        color: Color(0xfff5f5f5),
        child: TextFormField(
          controller: _userController,
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'SFUIDisplay',
          ),
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Usuario',
            prefixIcon: Icon(Icons.person_outline),
            labelStyle: TextStyle(fontSize: 15),
          ),
        ),
      ),
    );
  }

  Widget formPassword() {
    return Padding(
      padding: EdgeInsets.only(top: 20, bottom: 20),
      child: Container(
        color: Color(0xfff5f5f5),
        child: TextFormField(
          controller: _passwordController,
          obscureText: true,
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'SFUIDisplay',
          ),
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Contraseña',
            prefixIcon: Icon(Icons.lock_outline),
            labelStyle: TextStyle(fontSize: 15),
          ),
        ),
      ),
    );
  }

  Widget buttonSubmmit(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: ElevatedButton(
        onPressed: () async {
          String usuarios = _userController.text;
          String password = _passwordController.text;
          bool isLoginSuccessful =
              await loginClients(context, usuarios, password);
          if (isLoginSuccessful) {
            AwesomeDialog(
              context: context,
              dialogType: DialogType.success,
              width: 400,
              buttonsBorderRadius: BorderRadius.all(Radius.circular(2)),
              dismissOnTouchOutside: false,
              dismissOnBackKeyPress: false,
              headerAnimationLoop: true,
              animType: AnimType.bottomSlide,
              title: 'Sesion Iniciada Correctamente',
              descTextStyle: TextStyle(color: Colors.green, fontSize: 18),
              btnCancel: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  elevation: 0,
                  minimumSize: Size(MediaQuery.of(context).size.width - 46, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () async {
                  await sharedprefs.writeCache(key: 'numero', value: usuarios);
                  Navigator.of(context).pushReplacementNamed('/home');
                },
                child: Text(
                  'Ok',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ).show();
          } else {
            AwesomeDialog(
              context: context,
              dialogType: DialogType.error,
              width: 400,
              buttonsBorderRadius: BorderRadius.all(Radius.circular(2)),
              dismissOnTouchOutside: false,
              dismissOnBackKeyPress: false,
              headerAnimationLoop: true,
              animType: AnimType.bottomSlide,
              title: 'Datos Incorrectos',
              descTextStyle: TextStyle(color: Colors.red, fontSize: 18),
              btnCancel: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  elevation: 0,
                  minimumSize: Size(MediaQuery.of(context).size.width - 46, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Ok',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ).show();
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Color.fromARGB(255, 35, 38, 204),
          elevation: 0,
          minimumSize: Size(MediaQuery.of(context).size.width - 46, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          'Entrar',
          style: TextStyle(
            fontSize: 15,
            fontFamily: 'SFUIDisplay',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget forgotPassword() {
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: Center(
        child: Text(
          'Olvidaste tu contraseña?',
          style: TextStyle(
            fontFamily: 'SFUIDisplay',
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
