// ignore_for_file: prefer_const_constructors
import 'package:chat_app/src/controllers/auth_controller.dart';
import 'package:chat_app/src/models/chat_user_model.dart';
import 'package:chat_app/src/service_locators.dart';
import 'package:flutter/material.dart';
import '../../controllers/user_settings_controller.dart';
import '../../widgets/avatar.dart';

class BlockedUserScreen extends StatefulWidget {
  const BlockedUserScreen({Key? key, required this.blockeduser}) : super(key: key);
  final List<String> blockeduser;
  @override
  State<BlockedUserScreen> createState() => _BlockedUserScreenState();
}

class _BlockedUserScreenState extends State<BlockedUserScreen> {
  final UserSettingsController userSC = UserSettingsController();
  final AuthController _auth = locator<AuthController>();
  List<String> get blockedUser => widget.blockeduser;
  ChatUser? user;

  @override
  void initState() {
    ChatUser.fromUid(uid: _auth.currentUser!.uid).then((value) {
      if (mounted) {
        setState(() {
          user = value;
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Blocked User",
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (blockedUser.length < 2)
                SizedBox(
                  height: 300,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [
                        Image(
                        image: AssetImage("assets/images/block-user.png"), height: 200, width: 200),
                        Text("No Blocked Tabians"),
                      ],
                    ),
                  ),
                )
              else
                for (var user in blockedUser)
                  if (user != '')
                    FutureBuilder<ChatUser>(
                        future: ChatUser.fromUid(uid: user),
                        builder: ((context, snapshot) {
                          if (!snapshot.hasData) {
                            return CircularProgressIndicator();
                          } else {
                            return ListTile(
                              trailing: TextButton(
                                onPressed: () {
                                  setState(() {
                                    blockedUser.remove(snapshot.data!.uid);
                                    UserSettingsController.removeBlock(
                                        snapshot.data!.uid);
                                  });
                                },
                                child: Text(
                                  "Unblock",
                                  style: TextStyle(
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                              leading: AvatarImage(uid: snapshot.data!.uid),
                              title: Text(
                                snapshot.data!.username,
                              ),
                              subtitle: null,
                            );
                          }
                        }))
            ],
          ),
        ),
      ),
    );
  }
}
