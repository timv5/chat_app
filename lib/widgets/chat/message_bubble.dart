import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {

  final String message;
  final bool isMe;
  final Key key;
  final String username;

  MessageBubble(this.message, this.isMe, this.username, {required this.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: isMe ? Colors.grey[300] : Theme.of(context).accentColor,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(12),
              topRight: const Radius.circular(12),
              bottomLeft: !isMe ? const Radius.circular(0) : const Radius.circular(12),
              bottomRight: isMe ? const Radius.circular(0) : const Radius.circular(12),
            ),
          ),
          width: 140,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Column(
            crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                username,
                textAlign: isMe ? TextAlign.end : TextAlign.start,
                style: TextStyle(
                color: isMe ? Colors.black : Theme.of(context).accentTextTheme.headline1!.color,
                fontWeight: FontWeight.bold
                ),
              ),
              Text(
                message,
                style: TextStyle(color: isMe ? Colors.black : Theme.of(context).accentTextTheme.headline1!.color),
              ),
            ],
          )
        )
      ],
    );
  }
}
