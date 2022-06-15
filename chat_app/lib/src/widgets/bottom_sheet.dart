import 'package:chat_app/src/models/chat_message_model.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class BottomSheetModal extends StatelessWidget {
  BottomSheetModal(
      {required this.chat,
      required this.chatroom,
      Key? key,
      required this.recipient})
      : super(key: key);

  final ChatMessage chat;
  final String recipient;
  final String chatroom;

  final FocusNode _messageFN = FocusNode();
  final TextEditingController _textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Material(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Visibility(
                visible: !chat.isImage,
                child: ListTile(
                  title: Text(
                    'Edit',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  leading: Icon(
                    Icons.edit,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  onTap: () => {
                    _textController.text = chat.message,
                    Navigator.of(context).pop(),
                    showMaterialModalBottomSheet(
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      context: context,
                      builder: (context) => SingleChildScrollView(
                        controller: ModalScrollController.of(context),
                        child: SingleChildScrollView(child: rowe(context)),
                      ),
                    )
                  },
                ),
              ),
              ListTile(
                title: Text(
                  'Delete',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                leading: Icon(
                  Icons.delete,
                  color: Theme.of(context).colorScheme.primary,
                ),
                onTap: () => {
                  Navigator.of(context).pop(),
                  chat.deleteMessage(chatroom, recipient),
                },
              )
            ],
          ),
        ));
  }

  Widget rowe(context) {
    _messageFN.requestFocus();
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                " Editing Message",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _messageFN.unfocus();
                },
                icon: Icon(
                  Icons.close_rounded,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  focusNode: _messageFN,
                  controller: _textController,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.all(12),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      borderSide: BorderSide(
                        width: 1,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.send_rounded,
                  size: 35,
                  color: Theme.of(context).colorScheme.primary,
                ),
                onPressed: () => {
                  if (_textController.text != '')
                    {
                      _messageFN.unfocus(),
                      chat.updateMessage(
                          _textController.text, chatroom, recipient),
                      Navigator.of(context).pop(),
                    }
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}
