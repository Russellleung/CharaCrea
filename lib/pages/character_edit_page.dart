import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/CharacterListProvider.dart';
import '../provider/messageProvider.dart';
import '../widgets/widgets.dart';
import 'home_screen.dart';

class CharacterEditPage extends StatefulWidget {
  const CharacterEditPage({required this.originalCharacter, required this.callback});

  final Character originalCharacter;
  final void Function(Character character) callback;

  @override
  _CharacterEditPage createState() => _CharacterEditPage();
}

class _CharacterEditPage extends State<CharacterEditPage> {
  Character editedCharacter = Character();

  final _formKey = GlobalKey<FormState>(debugLabel: '_CharacterEditPage');
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    editedCharacter = widget.originalCharacter.copy();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        appBar: AppBar(
          title: Text("hello"),
        ),
        onTap: () {
          print("hi");
          Navigator.of(context).popUntil((route) => route.isFirst);
        },
      ),
      body: Form(
        key: _formKey,
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: 'Leave a message',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter your message to continue';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 8),
            StyledButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  await context.read<MessageProvider>().addMessageToGuestBook(_controller.text);
                  _controller.clear();
                }
              },
              child: Row(
                children: const [
                  Icon(Icons.send),
                  SizedBox(width: 4),
                  Text('SEND'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
