import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';

var name = "Morena";

void main() {
  runApp(FriendlychatApp());
}

final ThemeData kIOSTheme = new ThemeData(
  primarySwatch: Colors.orange,
  primaryColor: Colors.grey[100],
  primaryColorBrightness: Brightness.light,
);

final ThemeData kDefaultTheme = new ThemeData(
  primarySwatch: Colors.purple,
  accentColor: Colors.orangeAccent[400],
);

class FriendlychatApp extends StatefulWidget {
  @override
  _FriendlychatAppState createState() => _FriendlychatAppState();
}

class _FriendlychatAppState extends State<FriendlychatApp>
    with TickerProviderStateMixin {
  final TextEditingController _text = TextEditingController();
  final List<Messages> _messages = List<Messages>();
  bool _iscomposing = false;
  _sendtext(String text) {
    _text.clear();
    setState(() {
      _iscomposing = false;
    });
    Messages message = Messages(
        text,
        AnimationController(
          duration: Duration(milliseconds: 700),
          vsync: this,
        ));

    setState(() {
      _messages.insert(0, message);
    });
    message.animationController.forward();
  }

  @override
  void dispose() {
    for (Messages message in _messages) message.animationController.dispose();
    super.dispose();
  }

  Widget _textarea() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).accentColor),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _text,
                decoration: InputDecoration.collapsed(hintText: 'send message'),
                onChanged: (text) {
                  setState(() {
                    _iscomposing = text.length > 0;
                  });
                },
                onSubmitted: _sendtext,
              ),
            ),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 4.0),
                child: Theme.of(context).platform == TargetPlatform.iOS
                    ? CupertinoButton(
                  child: Text("Send"),
                  onPressed:
                  _iscomposing ? () => _sendtext(_text.text) : null,
                )
                    : IconButton(
                    icon: Icon(Icons.send),
                    onPressed:
                    _iscomposing ? () => _sendtext(_text.text) : null))
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Friendlychat",
      theme: defaultTargetPlatform == TargetPlatform.iOS
          ? kIOSTheme
          : kDefaultTheme,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Friendly chat'),
          elevation:
          Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
        ),
        body: Container(
            child: Column(
              children: <Widget>[
                Flexible(
                  child: ListView.builder(
                    padding: EdgeInsets.all(8.0),
                    reverse: true,
                    itemBuilder: (_, int index) => _messages[index],
                    itemCount: _messages.length,
                  ),
                ),
                Divider(
                  height: 1.5,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                  ),
                  child: _textarea(),
                )
              ],
            ),
            decoration: Theme.of(context).platform == TargetPlatform.iOS
                ? BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey[200]),
              ),
            )
                : null),
      ),
    );
  }
}

class Messages extends StatelessWidget {
  final text;
  final AnimationController animationController;
  Messages(this.text, this.animationController);
  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor:
      CurvedAnimation(parent: animationController, curve: Curves.easeInOut),
      axisAlignment: 0.0,
      child: Container(
        margin: EdgeInsets.all(10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 16.0),
              child: CircleAvatar(
                child: Text(name[0]),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(name, style: Theme.of(context).textTheme.subhead),
                  Container(
                    margin: EdgeInsets.only(top: 5.0),
                    child: Text(text),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
