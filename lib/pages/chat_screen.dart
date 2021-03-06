import 'dart:io';
import 'dart:math';

// import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ChatScreen extends StatefulWidget {
  static const routeName = "/chat_screen";
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController _editingController = TextEditingController();
  // var emojiParser = EmojiParser(init: false);
  // var serverParser = EmojiParser(init: false);

  // initEmojis() async {
  //   await serverParser.initServerData();
  // }

  @override
  void initState() {
    // initEmojis();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {},
            icon: FaIcon(FontAwesomeIcons.ellipsisVertical),
          )
        ],
        centerTitle: true,
        title: Text("Customer Name", style: TextStyle(color: Colors.white)),
        elevation: 10,
        shadowColor: Colors.grey.withOpacity(.3),
        backgroundColor: Color.fromARGB(255, 133, 101, 34),
      ),
      body: Container(
          width: size.width,
          height: size.height,
          color: Color.fromARGB(255, 255, 255, 255).withOpacity(.15),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  reverse: true,
                  itemCount: 100,
                  itemBuilder: (_, index) {
                    return Random().nextInt(2) % 2 == 0
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(width: size.width * .1),
                              SizedBox(
                                  width: size.width * .9,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: SizedBox(
                                      child: Card(
                                          shadowColor:
                                              Colors.black.withOpacity(.15),
                                          elevation: 10,
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 10),
                                          color: Color.fromARGB(
                                              255, 248, 217, 113),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                                "this would not seem to be very nice since the day started and you know now how far this would go.",
                                                style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 0, 0, 0))),
                                          )),
                                    ),
                                  )),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: size.width * .9,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: SizedBox(
                                    child: Card(
                                        shadowColor:
                                            Color.fromARGB(255, 59, 56, 46)
                                                .withOpacity(.15),
                                        elevation: 10,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 10),
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 18.0, vertical: 10),
                                          child: Text(
                                              "this would not seem to be very nice since the day started and you know now how far this would go.",
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 68, 68, 68))),
                                        )),
                                  ),
                                ),
                              ),
                              SizedBox(width: size.width * .1),
                            ],
                          );
                  },
                ),
              ),
              Container(
                width: size.width,
                height: size.height * .12,
                color: Colors.grey.withOpacity(.15),
                child: Column(
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            child: TextField(
                              controller: _editingController,
                              decoration: InputDecoration(
                                prefix: IconButton(
                                    icon: FaIcon(
                                      FontAwesomeIcons.faceSmileWink,
                                    ),
                                    onPressed: () {
                                      ;
                                    }),
                                hintText: "Message",
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(30),
                                    ),
                                    borderSide: BorderSide.none),
                              ),
                              maxLines: 3,
                              minLines: 1,
                            ),
                          ),
                          FloatingActionButton.small(
                            onPressed: () {},
                            child: Icon(Icons.send),
                          )
                        ]),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
