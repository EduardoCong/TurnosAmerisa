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
    final mediaQuery = MediaQuery.of(context);
    return Stack(
      children: <Widget>[
        logo(mediaQuery),
        Container(
          width: mediaQuery.size.width,
          margin: EdgeInsets.only(top: mediaQuery.size.height* 0.35),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: EdgeInsets.all(mediaQuery.size.width * 0.06),
            child: ListView(
              children: <Widget>[
                formUser(mediaQuery),
                formPassword(mediaQuery),
                buttonSubmmit(context, mediaQuery),
                forgotPassword(mediaQuery),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget logo(MediaQueryData mediaQuery) {
    return Container(
      width: mediaQuery.size.width,
      height: mediaQuery.size.height * 0.35,
      child: Center(
        child: Image.asset(
          "assets/amerisalogo.png",
          width: mediaQuery.size.width * 0.6,
        ),
      ),
    );
  }

  Widget formUser(MediaQueryData mediaQuery) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: mediaQuery.size.height * 0.02),
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

  Widget formPassword(MediaQueryData mediaQuery) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: mediaQuery.size.height * 0.02),
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

  Widget buttonSubmmit(BuildContext context, MediaQueryData mediaQuery) {
    return Padding(
      padding: EdgeInsets.only(top: mediaQuery.size.height * 0.02),
      child: ElevatedButton(
        onPressed: () async {
          String usuarios = _userController.text;
          String password = _passwordController.text;
          bool isLoginSuccessful = await loginClients(context, usuarios, password);
          if (isLoginSuccessful) {
            await sharedprefs.writeCache(key: 'numero', value: usuarios);
            Navigator.of(context).pushReplacementNamed('/home');
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Inicio de sesion fallido, intente de nuevo.')),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Color.fromARGB(255, 35, 38, 204),
          elevation: 0,
          minimumSize: Size(mediaQuery.size.width - 46, 50),
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

  Widget forgotPassword(MediaQueryData mediaQuery) {
    return Padding(
      padding: EdgeInsets.only(top: mediaQuery.size.height * 0.02),
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
