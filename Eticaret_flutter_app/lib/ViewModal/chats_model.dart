import 'package:e_ticaret_flutter_app/Core/Service/chat_service.dart';
import 'package:e_ticaret_flutter_app/Model/chat.dart';
import 'package:e_ticaret_flutter_app/ViewModal/base_model.dart';
import 'package:get_it/get_it.dart';

class ChatsModel extends BaseModel{
  final ChatService db=GetIt.instance<ChatService>();
  Stream<List<Chat>> conservation(String userId){
    return db.getConversition(userId);
  }


}