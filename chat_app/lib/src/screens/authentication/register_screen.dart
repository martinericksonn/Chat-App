// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:username_gen/username_gen.dart';
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
  bool isAgeValid = true;
  bool isRegisterSuccess = false;
  String prompts = '';

  // final GeolocationController geoCon = GeolocationController();
  final TextEditingController _emailCon = TextEditingController();
  final TextEditingController _passCon = TextEditingController();
  final TextEditingController _unCon = TextEditingController();
  final TextEditingController _ageCon = TextEditingController();

  final genderList = ["Prefer not to say", "Male", "Female", "Others"];
  String dropdownValue = 'Prefer not to say';

  AuthController get _auth => widget.auth;

  // scroll controller

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // resizeToAvoidBottomInset: false,
        body: Center(
          child: Form(
            onChanged: () => setState(() {
              prompts = "";
            }),
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  upperBody(context),
                  lowerBody(context),
                  // Padding(
                  //   padding: EdgeInsets.only(
                  //       bottom: MediaQuery.of(context).viewInsets.bottom),
                  // )
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
        height: MediaQuery.of(context).size.height * .75,
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
                SizedBox(
                  height: 5,
                ),
                loginButton(context),
              ],
            ),

            // Padding(
            //   padding: EdgeInsets.only(
            //       bottom: MediaQuery.of(context).viewInsets.bottom),
            // )
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
                minimumSize: const Size(10, 10),
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
        username:
            _unCon.text.isEmpty ? UsernameGen().generate() : _unCon.text.trim(),
        email: _emailCon.text.trim(),
        password: _passCon.text.trim(),
        age: _ageCon.text.trim(),
        gender: dropdownValue,
      );
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
              print(isAgeValid);

              prompts = isAgeValid
                  ? "Fields cannot be empty"
                  : "Sorry, you're too young for this app";
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      alignment: Alignment.topLeft,
      child: const Text(
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
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.primary, // set border
            width: 1.0,
          ), // set
          // color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(20)),
      child: DropdownButtonFormField(
        value: dropdownValue,
        icon: const Icon(Icons.arrow_drop_down),
        decoration: InputDecoration(
          labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
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
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            border: Border.all(
              color: !isAgeValid
                  ? Colors.red
                  : Theme.of(context).colorScheme.primary, // set border
              width: !isAgeValid ? 2.0 : 1.0,
            ), // set
            // color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(20)),
        child: TextFormField(
          controller: _ageCon,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
          ],
          validator: (value) {
            setState(() {
              if ((value == null ||
                  value.isEmpty ||
                  !(int.parse(value) > 17 && int.parse(value) < 100))) {
                isAgeValid = false;
                print("dapat false");
              } else if (int.parse(value) > 17 && int.parse(value) < 100) {
                print("dapat true");
                isAgeValid = true;
              }
            });
            print(isAgeValid.toString() + ' age');
            return null;
          },
          keyboardType: TextInputType.number,
          style: const TextStyle(fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            hintStyle: TextStyle(
                color: !isAgeValid
                    ? Colors.red
                    : Theme.of(context).colorScheme.primary),
            hintText: "Age",
            contentPadding:
                const EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
          ),
        ));
  }

  Container passwordTextField(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.all(5),
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
          style: const TextStyle(fontWeight: FontWeight.bold),
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
                const EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
          ),
        ));
  }

  Container usernameTextField(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.primary,
              width: 1.0,
            ), // set
            // color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(20)),
        child: TextFormField(
          maxLength: 20,
          controller: _unCon,
          validator: (value) {
            setState(() {
              // isUsernameEmpty = (value == null || value.isEmpty) ? true : false;
            });
            return null;
          },
          style: const TextStyle(fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            counterText: '',
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
            hintText: "Username (optional)",
            contentPadding:
                const EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
          ),
        ));
  }

  Container emailTextField(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.all(5),
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
          style: const TextStyle(fontWeight: FontWeight.bold),
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
                const EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
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
            Image.asset("assets/images/tabi_lightmode.png",
                width: 45, height: 45),
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
        height: MediaQuery.of(context).size.height * 0.40,
        padding: const EdgeInsets.only(top: 18.0),
        child: const Image(
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
    return !(isEmailEmpty || isPasswordEmpty || !isAgeValid);
  }
}
