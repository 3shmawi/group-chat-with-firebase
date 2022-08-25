import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/message_model.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  static HomeCubit get(context) => BlocProvider.of(context);

  void sendMessage({
    required String type,
    required String text,
  }) {
    MessageModel message = MessageModel(
      // type: 'sender',
      // time: DateTime.now(),
      text: text,
      name: 'Ashmawi',
    );

    ////////////// sender chat:

    FirebaseFirestore.instance
        .collection('chat')
        .add(message.toMap())
        .then((value) {
      emit(SendMessageSuccessState());
    }).catchError((error) {
      debugPrint(error.toString());
      emit(SendMessageErrorState());
    });
  }

// get Messages .........

  List<MessageModel> messages = [];

  void getMessages() {
    emit(GetMessageLoadingState());
    FirebaseFirestore.instance.collection('chat').snapshots().listen((event) {
      messages.clear();
      for (var element in event.docs) {
        messages.add(
          MessageModel(
            name: element.get('name'),
            // time: element.get('time'),
            text: element.get('text'),
            // type: element.get('type'),
          ),
        );
        print(element.get('text'));
        // messages.add(MessageModel.fromJson(element.data()));
        // print('sdfsdfsdfsdfs                      ${messages[0].name}');
      }
      emit(GetMessageSuccessState());
    });
  }

}
