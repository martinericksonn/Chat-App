// ignore_for_file: prefer_const_constructors, non_constant_identifier_names

import 'package:flutter/material.dart';

import '../../controllers/auth_controller.dart';

class RegisterScreen extends StatefulWidget {
  final AuthController auth;

  const RegisterScreen(
    this.auth, {
    Key? key,
  }) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  
  bool isEmailEmpty = false;
  bool isPasswordEmpty = false;
  bool isUsernameEmpty = false;
  bool isAgeEmpty = false;
  bool isGenderEmpty = false;
  bool isRegisterSuccess = false;
  String prompts = '';

  final TextEditingController _emailCon = TextEditingController();
  final TextEditingController _passCon = TextEditingController();
  final TextEditingController _unCon = TextEditingController();
  final TextEditingController _ageCon = TextEditingController();

  final genderList = ["Prefer not to say", "Male", "Female", "Others"];
  String dropdownValue = 'Prefer not to say';


  AuthController get _auth => widget.auth;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        // appBar: appBar(context),
        // ignore: prefer_const_literals_to_create_immutables
        body: SingleChildScrollView(
          reverse: true,
          child: Center(
            child: Form(
              onChanged: () => setState(() {
                prompts = "";
              }),
              key: _formKey,
              child: Column(
                children: [
                  upperBody(context),
                  lowerBody(context),
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Padding lowerBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28.0),
      child: SizedBox(
        // color: Colors.pink,
        height: MediaQuery.of(context).size.height * 0.6,
        // color: Colors.pink,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            Column(
              children: [
                title(),

                usernameTextField(context),
                emailTextField(context),
                passwordTextField(context),
                ageTextField(context),
                genderDropDownButton(context),
              ],
            ),
            promptMessage(),
            Column(
              children: [
                registerButton(context),
                loginButton(context),
              ],
            ),
            // TextFormField(),
          ],
        ),
      ),
    );
  }

  Text promptMessage() {
    return Text(
      prompts,
      style: TextStyle(
        color: isRegisterSuccess ? Colors.green : Colors.red,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget loginButton(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.03,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Joined us before? ",
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                // backgroundColor: Colors.red,
                minimumSize: Size(10, 10),
                padding: EdgeInsets.zero,
              ),
              child: Text(
                "Login",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              )),
        ],
      ),
    );
  }

  Future<void> register() async {
    try {
      await _auth.register(
          username: _unCon.text.trim(),
          email: _emailCon.text.trim(),
          password: _passCon.text.trim());
    } catch (error) {
      setState(() {
        prompts = error.toString();
      });
    }
  }

  Widget registerButton(BuildContext context) {
    return Container(
      // color: Colors.red,
      width: 320,
      height: 68,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(50)),
      child: TextButton(
        onPressed: () {
          if (_formKey.currentState!.validate() && isFieldEmpty()) {
            setState(() {
              register();
            });
          } else {
            setState(() {
              prompts = "Fields cannot be empty";
            });
          }
        },
        child: Center(
          child: Text(
            "Register",
            style: TextStyle(
              fontSize: 18,
              color: Theme.of(context).scaffoldBackgroundColor,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
            ),
          ),
        ),
      ),
    );
  }

  Container forgetPassword(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {},
        child: Text(
          "Forget password?",
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }

  Container title() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      alignment: Alignment.topLeft,
      child: Text(
        "Join Tabi-Tabi now.",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

    Container genderDropDownButton(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.all(13),
        decoration: BoxDecoration(
            border: Border.all(
              color: isAgeEmpty
                  ? Colors.red
                  : Theme.of(context).colorScheme.primary, // set border
              width: isAgeEmpty ? 2.0 : 1.0,
            ), // set
            // color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(20)),
        child: DropdownButtonFormField(     
          value: dropdownValue, 
          icon: Icon(Icons.arrow_drop_down),
           decoration: InputDecoration(
                labelStyle: TextStyle(
                color:  Theme.of(context).colorScheme.primary),
                labelText: "Gender",
                border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
                ),
           items: genderList.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  dropdownValue = newValue!;
                });
              },
              validator: (value) {
                 // setState(() {
            //   isGenderEmpty = (value == null || value.isEmpty) ? true : false;
            // });
                return null;
              },
            ),

        );
  }

   Container ageTextField(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
            border: Border.all(
              color: isAgeEmpty
                  ? Colors.red
                  : Theme.of(context).colorScheme.primary, // set border
              width: isAgeEmpty ? 2.0 : 1.0,
            ), // set
            // color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(20)),
        child: TextFormField(
          controller: _ageCon,
          validator: (value) { 
            // setState(() {
            //   isAgeEmpty = (value == null || value.isEmpty) ? true : false;
            // });
            return null;
          },
          keyboardType: TextInputType.number,
          style: TextStyle(fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            hintStyle: TextStyle(
                color: isPasswordEmpty
                    ? Colors.red
                    : Theme.of(context).colorScheme.primary),
            hintText: "Age",
            contentPadding:
                EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
          ),
        ));
  }

  Container passwordTextField(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
            border: Border.all(
              color: isPasswordEmpty
                  ? Colors.red
                  : Theme.of(context).colorScheme.primary, // set border

              width: isPasswordEmpty ? 2.0 : 1.0,
            ), // set
            // color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(20)),
        child: TextFormField(
          controller: _passCon,
          validator: (value) {
            setState(() {
              isPasswordEmpty = (value == null || value.isEmpty) ? true : false;
            });
            return null;
          },
          obscureText: true,
          enableSuggestions: false,
          autocorrect: false,
          style: TextStyle(fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            hintStyle: TextStyle(
                color: isPasswordEmpty
                    ? Colors.red
                    : Theme.of(context).colorScheme.primary),
            hintText: "Password",
            contentPadding:
                EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
          ),
        ));
  }

  Container usernameTextField(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
            border: Border.all(
              color: isUsernameEmpty
                  ? Colors.red
                  : Theme.of(context).colorScheme.primary,
              width: isUsernameEmpty ? 2.0 : 1.0,
            ), // set
            // color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(20)),
        child: TextFormField(
          controller: _unCon,
          validator: (value) {
            setState(() {
              isUsernameEmpty = (value == null || value.isEmpty) ? true : false;
            });
            return null;
          },
          style: TextStyle(fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            hintStyle: TextStyle(
                color: isUsernameEmpty
                    ? Colors.red
                    : Theme.of(context).colorScheme.primary),
            hintText: "Username",
            contentPadding:
                EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
          ),
        ));
  }

  Container emailTextField(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
            border: Border.all(
              color: isEmailEmpty
                  ? Colors.red
                  : Theme.of(context).colorScheme.primary,
              // Colors.red,

              width: isEmailEmpty ? 2.0 : 1.0,
            ), // set
            // color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(20)),
        child: TextFormField(
          controller: _emailCon,
          validator: (value) {
            setState(() {
              isEmailEmpty = (value == null || value.isEmpty) ? true : false;
            });
            return null;
          },
          style: TextStyle(fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            hintStyle: TextStyle(
                color: isEmailEmpty
                    ? Colors.red
                    : Theme.of(context).colorScheme.primary),
            hintText: "Email",
            contentPadding:
                EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
          ),
        ));
  }

  Stack upperBody(BuildContext context) {
    return Stack(children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Image.asset("assets/images/tabi_lightmode.png", width: 45, height: 45),
            Text(
              " Tabi-Tabi",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ],
        ),
      ),
      Container(
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height * 0.33,
        padding: EdgeInsets.only(top: 18.0),
        child: Image(
          image: AssetImage("assets/images/register.png"),
        ),
      )
    ]);
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Container(
        alignment: Alignment.centerRight,
        child: Text(
          "Tabi-Tabi",
          style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  bool isFieldEmpty() {
    return !(isEmailEmpty || isPasswordEmpty || isUsernameEmpty);
  }
}
