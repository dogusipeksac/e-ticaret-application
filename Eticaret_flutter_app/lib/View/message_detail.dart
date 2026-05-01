import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_ticaret_flutter_app/Core/Service/message_service.dart';
import 'package:e_ticaret_flutter_app/Model/message.dart';
import 'package:e_ticaret_flutter_app/Model/product.dart';
import 'package:e_ticaret_flutter_app/View/message_list_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../DesignStyle/colors_cons.dart';

class MessageDetailPage extends StatefulWidget {
  static String routeName = '/routeMessageDetailPage';

  final String? conservationId;
  final Product? product;

  const MessageDetailPage({
    super.key,
    this.conservationId,
    this.product,
  });

  @override
  _MessageDetailState createState() => _MessageDetailState();
}

TextEditingController messageEditingController = TextEditingController();
MessageService _messageService = MessageService();

class _MessageDetailState extends State<MessageDetailPage> {
  MessageService _service = MessageService();
  late final FocusNode _focusNode;
  late final ScrollController _scrollController;
  late final CollectionReference _ref;
  @override
  void initState() {
    final conservationId = widget.conservationId ?? '';
    _ref = FirebaseFirestore.instance
        .collection("Conversitons/$conservationId/Messages");
    _focusNode = FocusNode();
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<User>(
      builder: (context, user, child) => SafeArea(
        child: Scaffold(
          backgroundColor: background,
          appBar: buildAppBarMessage(),
          body: Column(
            children: <Widget>[
              Flexible(
                flex: 80,
                child: GestureDetector(
                  onTap: () => _focusNode.unfocus(),
                  child: StreamBuilder<DocumentSnapshot>(
                      stream:
                          _service.getConversitonsPath(widget.conservationId ?? ''),
                      builder: (context,
                          AsyncSnapshot<DocumentSnapshot> docsnapshot) {
                        final docData = docsnapshot.data?.data() as Map<String, dynamic>?;
                        return StreamBuilder(
                            stream: _messageService
                                .getMessage(widget.conservationId ?? ''),
                            builder: (BuildContext context,
                                AsyncSnapshot<List<Message>> snapshot) {
                              if (snapshot.hasError || docsnapshot.hasError) {
                                return Text("Eror: ${snapshot.error}");
                              }
                              if (snapshot.connectionState ==
                                      ConnectionState.waiting ||
                                  docsnapshot.connectionState ==
                                      ConnectionState.waiting) {
                                return Center(child: CircularProgressIndicator());
                              }
                              final messages = snapshot.data ?? <Message>[];
                              return ListView.builder(
                                controller: _scrollController,
                                itemCount: messages.length,
                                itemBuilder: ((context, index) {
                                  var messageSnapshot =
                                      messages.elementAt(index);
                                  return Container(
                                    padding: EdgeInsets.only(
                                        left: 14,
                                        right: 14,
                                        top: 10,
                                        bottom: 10),
                                    child: Align(
                                      alignment:
                                          (user.uid == messageSnapshot.senderId
                                              ? Alignment.topRight
                                              : Alignment.topLeft),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          (user.uid != messageSnapshot.senderId
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 8.0),
                                                  child: Row(
                                                    children: [
                                                      CircleAvatar(
                                                        backgroundImage: NetworkImage(
                                                          user.uid != docData?['productUserId']
                                                              ? (docData?['receiverImage'] ?? '')
                                                              : (docData?['senderImage'] ?? ''),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 8.0),
                                                        child: Text(
                                                          user.uid !=
                                                                  docData?['productUserId']
                                                              ? (docData?['receiverName'] ?? '')
                                                              : (docData?['senderName'] ?? ''),
                                                          style: TextStyle(
                                                              color:
                                                                  themeColor),
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
                                              color: (user.uid ==
                                                      messageSnapshot.senderId
                                                  ? themeColor
                                                  : filterBackground),
                                            ),
                                            padding: EdgeInsets.all(16),
                                            child: Text(
                                              messageSnapshot.message ?? '',
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
                            });
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
                      _scrollController.animateTo(
                          _scrollController.position.maxScrollExtent,
                          duration: Duration(microseconds: 200),
                          curve: Curves.easeIn);
                      await _messageService.addMessage(
                          messageEditingController.text,
                          user.uid,
                          widget.conservationId ?? '');

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
      flexibleSpace: Consumer<User>(
        builder: (context, user, child) => StreamBuilder<DocumentSnapshot>(
            stream: _service.getConversitonsPath(widget.conservationId ?? ''),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text("Birşeyler yanlış gitti");
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              final data = snapshot.data?.data() as Map<String, dynamic>?;
              return SafeArea(
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Image(
                            fit: BoxFit.fill,
                            image: NetworkImage((data?['productImage'] ?? '').toString()),
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
                              (data?['title'] ?? '').toString(),
                              style: TextStyle(
                                  color: themeColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Text(
                              (data?['productPrize'] ?? '').toString(),
                              style: TextStyle(color: text, fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Center(
                          //inkwell ile daha yumuşak tıklanma verebiliriz
                          child: IconButton(
                            onPressed: () async {
                              Navigator.pushNamed(
                                  context, MessageList.routeName);
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
              );
            }),
      ),
    );
  }
}
