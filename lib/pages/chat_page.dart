import 'dart:io';

import 'package:chat_flutter/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final _textcontroller = new TextEditingController();
  final _focusNode = new FocusNode();

  List<ChatMessage> _messages = [];

  bool _estaEscribiendo = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          elevation: 1,
          backgroundColor: Colors.white,
          title: Column(
            children: [
              CircleAvatar(
                child: Text(
                  'TE',
                  style: TextStyle(fontSize: 12),
                ),
                backgroundColor: Colors.blue[100],
                maxRadius: 14,
              ),
              SizedBox(height: 3),
              Text(
                "Melissa Flores",
                style: TextStyle(color: Colors.black87, fontSize: 12),
              )
            ],
          )),
      body: Container(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemBuilder: (_, i) => _messages[i],
                itemCount: _messages.length,
                reverse: true,
              ),
            ),
            Divider(height: 1),
            Container(
              color: Colors.white,
              child: _inputChat(),
            )
          ],
        ),
      ),
    );
  }

  Widget _inputChat() {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: _textcontroller,
                onSubmitted: _handleSubmit,
                onChanged: (texto) {
                  setState(() {
                    if (texto.trim().length > 0) {
                      _estaEscribiendo = true;
                    } else {
                      _estaEscribiendo = false;
                    }
                  });
                  //cuando hay un valor para poder psite
                },
                decoration:
                    InputDecoration.collapsed(hintText: "Enviar Mensaje"),
                focusNode: _focusNode,
              ),
            ),

            //boton de enviar
            Container(
              margin: EdgeInsets.symmetric(horizontal: 5),
              child: Platform.isIOS
                  ? CupertinoButton(
                      child: Text("Enviar"),
                      onPressed: _estaEscribiendo
                          ? () => _handleSubmit(_textcontroller.text.trim())
                          : null)
                  : Container(
                      margin: EdgeInsets.symmetric(horizontal: 4.0),
                      child: IconTheme(
                        data: IconThemeData(color: Colors.blue[400]),
                        child: IconButton(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            icon: Icon(
                              Icons.send,
                            ),
                            onPressed: _estaEscribiendo
                                ? () =>
                                    _handleSubmit(_textcontroller.text.trim())
                                : null),
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }

  _handleSubmit(String texto) {
    if (texto.length == 0) return;
    print(texto);
    _textcontroller.clear();
    _focusNode.requestFocus();

    final newMessage = new ChatMessage(
      uid: "123",
      texto: texto,
      animationController: AnimationController(
          vsync: this, duration: Duration(milliseconds: 400)),
    );
    _messages.insert(0, newMessage);
    newMessage.animationController.forward();
    setState(() {
      _estaEscribiendo = false;
    });
  }

  @override
  void dispose() {
    //off del socket limpiar

    for (ChatMessage message in _messages) {
      message.animationController.dispose();
    }
    super.dispose();
  }
}
