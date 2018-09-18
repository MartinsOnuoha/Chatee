import 'package:flutter/material.dart';

void main() {
  runApp(new FriendlyChatApp());
}

class FriendlyChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return new MaterialApp(
      theme: ThemeData( primaryColor: Colors.white, accentColor: Colors.indigoAccent ),
      // theme: ThemeData.dark(),
      title: "Chatty",
      home: new ChatScreen(),
    );
  }
}

// 
class ChatMessage extends StatelessWidget {
  ChatMessage({ this.text, this.animationController });
  
  final AnimationController animationController;
  final String text;
  final String _name = "Martins";

  @override
  Widget build(BuildContext context) {

    return new SizeTransition(
      sizeFactor: new CurvedAnimation(
        parent: animationController, curve: Curves.easeOut
      ),
      axisAlignment: 0.0,

      child: new Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
          child: new Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Container(
                margin: const EdgeInsets.only(right: 10.0),
                child: new CircleAvatar(child: new Text(_name[0])),
              ),
              new Expanded(
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text(_name, style: Theme.of(context).textTheme.subhead),
                    new Container(
                      margin: const EdgeInsets.only(top: 5.0),
                      child: Text(text),
                    )
                  ]
                )
              )
            ],
          )
        )
    );
  }
}


class ChatScreen extends StatefulWidget {
  @override
  State createState() => new ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {

  // Prefix an underscore to identifier to make it private to its class
  // List to represent each chat message
  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textController = new TextEditingController();
  bool _isComposing = false;
  
  @override
  // dispose of your animation controllers to free up your resources
  void dispose() {
    for (ChatMessage message in _messages)
      message.animationController.dispose();
    super.dispose();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( 
        leading: Icon(Icons.chat),
        title: Text("Chatty", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: new Column(
        children: <Widget>[
          // let the list of received messages expand to fill the Column height
          new Flexible(
            child: new ListView.builder(
              padding: new EdgeInsets.all(8.0),
              reverse: true,
              itemBuilder: (_, int index) => _messages[index],
              itemCount: _messages.length,
            )
          ),

          // draw a horizontal rule between the UI for displaying messages 
          new Divider(height: 1.0),
          new Container(
            decoration: new BoxDecoration(
              color: Theme.of(context).cardColor
            ),
            child: _builTextComposer()
          )
        ],
      )
    );
  }


  Widget _builTextComposer() {
    return new IconTheme(
      data: new IconThemeData(color: Theme.of(context).accentColor),
      child: new Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: new Row(
            children: <Widget>[
              
              new Flexible(
                child: new TextField(
                  controller: _textController,
                  decoration: new InputDecoration.collapsed( hintText: "Send a message" ),

                  onSubmitted: _handleSubmitted,
                  onChanged: (String text) {
                    setState(() {
                      _isComposing = text.length > 0;                    
                    });
                  },
                
                )
              ),

              new Container(
                margin: new EdgeInsets.symmetric(horizontal: 4.0),
                child: new IconButton(
                  icon: new Icon(Icons.send),
                  // Tenary operator to setState of Send button
                  onPressed: _isComposing
                    ? () => _handleSubmitted(_textController.text)
                    : null,
                ),
              )
            ]
          )
        )
    );
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    setState(() {
      _isComposing = false;      
    });
    ChatMessage message = new ChatMessage(
      text: text,
      animationController: new AnimationController(
        duration: new Duration(milliseconds: 700),
        vsync: this,
      ),
    );
    // call setState()to modify _messages
    setState(() {
      _messages.insert(0, message);
    });
    message.animationController.forward();
  }


}