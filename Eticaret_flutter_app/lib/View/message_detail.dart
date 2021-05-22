import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_ticaret_flutter_app/Core/Service/message_service.dart';
import 'package:e_ticaret_flutter_app/Model/message.dart';
import 'package:e_ticaret_flutter_app/Model/messageCreate.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../DesignStyle/colors_cons.dart';

class MessageDetail extends StatefulWidget {
  static String routeName = '/routeMessageDetailPage';
  final String userId;
  final String conservationId;


  const MessageDetail({Key key, this.conservationId, this.userId})
      : super(key: key);


  @override
  _MessageDetailState createState() => _MessageDetailState();
}


class _MessageDetailState extends State<MessageDetail> {

  CollectionReference _ref;
  FocusNode _focusNode;
  ScrollController _scrollController;
  
  @override
  void initState() {
    _ref = FirebaseFirestore.instance
        .collection("Conversitons/${widget.conservationId}/Messages");
    _focusNode = FocusNode();
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  dispose() {
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  TextEditingController messageEditingController = TextEditingController();
  MessageService _messageService=MessageService();

  @override
  Widget build(BuildContext context) {
    final args=ModalRoute.of(context).settings.arguments as MessageCreate;
  //  messageEditingController.text=args.message;
    return Consumer<User>(
      builder: (context, user, child) => SafeArea(
        child: Scaffold(
          backgroundColor: background,
          appBar: buildAppBarMessage(),
          body: Column(
            children: <Widget>[
              Expanded(
                flex: 80,
                child: GestureDetector(
                  onTap:()=> _focusNode.unfocus(),
                  child: StreamBuilder(
                      stream: _messageService.getMessage(widget.conservationId),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<Message>> snapshot) {
                        return !snapshot.hasData
                            ? CircularProgressIndicator()
                            : ListView.builder(
                                controller: _scrollController,
                                itemCount: snapshot.data.length,
                                itemBuilder: ((context, index) {
                                  var message = snapshot.data.elementAt(index);

                                  return Container(
                                    padding: EdgeInsets.only(
                                        left: 14, right: 14, top: 10, bottom: 10),
                                    child: Align(
                                      alignment: (widget.userId == message.senderId
                                          ? Alignment.topRight
                                          : Alignment.topLeft),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          (widget.userId !=
                                                  message.senderId
                                              ? Padding(
                                                  padding: const EdgeInsets.only(
                                                      bottom: 8.0),
                                                  child: Row(
                                                    children: [
                                                      CircleAvatar(
                                                        backgroundImage:
                                                            NetworkImage(
                                                                _messageService
                                                                    .profileImage),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets.only(
                                                                left: 8.0),
                                                        child: Text(
                                                          _messageService
                                                              .nameSurname,
                                                          style: TextStyle(
                                                              color: themeColor),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              : SizedBox(
                                                  width: 5,
                                                )),
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color:
                                                  (widget.userId == message.senderId
                                                      ? themeColor
                                                      : filterBackground),
                                            ),
                                            padding: EdgeInsets.all(16),
                                            child: Text(
                                              snapshot.data
                                                  .elementAt(index)
                                                  .message,
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: text),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                              );
                      }),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Container(
                      margin:
                          EdgeInsets.only(right: 5, left: 5, bottom: 8, top: 8),
                      decoration: BoxDecoration(
                          color: filterBackground,
                          borderRadius: BorderRadius.circular(10)),
                      padding: EdgeInsets.only(left: 15),
                      child: TextFormField(
                        focusNode: _focusNode,
                        controller: messageEditingController,
                        //bunla enterlayınca oluyor ama setstate olmalı
                        //onFieldSubmitted:_messageController.messageAdd,
                        style: TextStyle(color: text),
                        decoration: InputDecoration(
                            hintText: "Write message...",
                            hintStyle: TextStyle(color: textDarkHint),
                            border: InputBorder.none),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  FloatingActionButton(
                    onPressed: () async {
                      await _ref.add({
                        'message': messageEditingController.text,
                        'senderId': user.uid,
                        'timeStamp': DateTime.now(),


                      });
                      _scrollController.animateTo(
                          _scrollController.position.maxScrollExtent,
                          duration:Duration(microseconds:200), curve: Curves.easeIn);
                        messageEditingController.text = '';
                    },
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 30,
                    ),
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar buildAppBarMessage() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: filterBackground,
      flexibleSpace: SafeArea(
        child: Container(
          child: Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image(
                    fit: BoxFit.fill,
                    image: NetworkImage(_messageService.productImage),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      _messageService.productName,
                      style: TextStyle(
                          color: themeColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Text(
                      _messageService.productPrices,
                      style: TextStyle(color: text, fontSize: 15),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  //inkwell ile daha yumuşak tıklanma verebiliriz
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
