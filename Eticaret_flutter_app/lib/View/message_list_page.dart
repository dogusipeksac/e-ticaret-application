import 'package:e_ticaret_flutter_app/DesignStyle/colors_cons.dart';
import 'package:e_ticaret_flutter_app/Model/chat.dart';
import 'package:e_ticaret_flutter_app/Model/product.dart';
import 'package:e_ticaret_flutter_app/View/message_detail.dart';
import 'package:e_ticaret_flutter_app/ViewModal/chats_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../Map/main_drawer.dart';

//bildirimler sayfasi
class MessageList extends StatefulWidget {

  static String routeName = '/routeMessageList';
  final Product? product;
  final String? conversitonsId;

  const MessageList({super.key, this.product, this.conversitonsId});

  @override
  _MessageListState createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {



  @override
  Widget build(BuildContext context) {
    var model=GetIt.instance<ChatsModel>();
    return Consumer<User?>(
      builder: (context, user, child) => Scaffold(
        backgroundColor: background,
        appBar: AppBar(
          title: Text('Mesajlar-Hepsi'),
          backgroundColor: background,
        ),
        drawer: MainDrawer(),
        body: ChangeNotifierProvider(
          //memory optimizasyonu
          create: (BuildContext context)=>model,
          child: StreamBuilder<List<Chat>>(
            stream: model.conservation(user?.uid ?? ''),
            builder:(BuildContext context,AsyncSnapshot<List<Chat>> snapshot){
              if(snapshot.hasError){
                return Text("Eror: ${snapshot.error}");
              }
              if(snapshot.connectionState==ConnectionState.waiting){
                return Text('Loading..');
              }
              if (user == null) {
                return const Center(child: CircularProgressIndicator());
              }
              final chats = snapshot.data ?? <Chat>[];
              return ListView(
                children: chats
                .map((doc)=> Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder:
                          ((context)=>
                              MessageDetailPage(
                                product: widget.product,
                                conservationId: doc.id,
                              ))));
                    },
                    child: Card(
                      color: background,
                      elevation: 5.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0.0),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: filterBackground,
                        ),
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: Container(
                                margin: EdgeInsets.all(5),
                                height: 55,
                                color: filterBackground,
                                child: CircleAvatar(
                                  child: Container(
                                    child: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          doc.productUserId != user.uid
                                              ? (doc.receiverImage ?? '')
                                              : (doc.senderImage ?? ''),
                                      ),
                                    ),
                                    width: 20,
                                    height: 20,
                                    color: Colors.transparent,
                                    margin: EdgeInsets.only(left: 40, top: 30),
                                  ),
                                  backgroundColor: filterBackground,
                                  foregroundColor: filterBackground,
                                  backgroundImage: NetworkImage(
                                      doc.productImage ?? ''),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    doc.title ?? '',
                                    style: TextStyle(color: themeColor, fontSize: 15),
                                  ),
                                  Text(
                                    doc.productUserId != user.uid
                                        ? (doc.receiverName ?? '')
                                        : (doc.senderName ?? ''),
                                    style: TextStyle(color: Colors.white, fontSize: 15),
                                  ),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  Text(
                                    doc.displayMessage ?? '',
                                    style: TextStyle(color: Colors.white, fontSize: 15),
                                  ),

                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )).toList(),
              );
            },
          ),
        ),
      ),
    );
  }
}