import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/home_cubit.dart';
import '../models/message_model.dart';
import '../shared/constants/constants.dart';

class ChatDetails extends StatefulWidget {
  const ChatDetails({Key? key}) : super(key: key);

  @override
  State<ChatDetails> createState() => _ChatDetailsState();
}

class _ChatDetailsState extends State<ChatDetails> {
  var sendMessageController = TextEditingController();

  var listController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (BuildContext context, Object? state) {
        if (state is SendMessageSuccessState) {
          sendMessageController.clear();
          Timer(
              const Duration(seconds: 1),
              () => listController
                  .jumpTo(listController.position.maxScrollExtent));
        }
      },
      builder: (BuildContext context, Object? state) {
        var cubit = HomeCubit.get(context);

        return Scaffold(
            appBar: AppBar(
              titleSpacing: 0.0,
              centerTitle: true,
              title: const Text('Chats'),
            ),
            bottomSheet: BottomSheet(
              builder: (BuildContext context) => Padding(
                padding: const EdgeInsets.only(bottom: 5.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                   const SizedBox(width: 20,),
                    Expanded(
                      child: Container(
                        height: 40.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          color: Colors.grey[300],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: TextFormField(
                            maxLines: null,
                            minLines: 1,
                            autofocus: true,
                            controller: sendMessageController,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              hintText: 'Send a Message...',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        if (sendMessageController.text.isNotEmpty) {
                          cubit.sendMessage(
                            text: sendMessageController.text,
                            type: 'sender',
                          );
                        }
                      },
                      icon: const Icon(
                        Icons.send,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
              onClosing: () {},
            ),
            body: state is GetMessageLoadingState
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : cubit.messages.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                          top: 20,
                          bottom: 100,
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: ListView.separated(
                                  controller: listController,
                                  physics: const BouncingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    if (cubit.messages[index].name == 'Ashmawi') {
                                      return sendMessage(
                                          cubit.messages[index], context);
                                    } else {
                                     //return  ChatList(messageStream: cubit.messagesStream);
                                      return receiveMessage(
                                          cubit.messages[index], context);
                                    }
                                  },
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(
                                        height: 15,
                                      ),
                                  itemCount: cubit.messages.length),
                            ),
                          ],
                        ),
                      )
                    : const Center(
                        child: Text('Start your first chat'),
                      ));
      },
    );
  }

  // Widget bottomSheetDesign(HomeCubit cubit, Object? state) {
  Widget sendMessage(MessageModel model, context) => Align(
        alignment: AlignmentDirectional.centerEnd,
        child: Container(
          decoration: BoxDecoration(
            color: defaultColor.withOpacity(
              .2,
            ),
            borderRadius: const BorderRadiusDirectional.only(
              bottomStart: Radius.circular(
                10.0,
              ),
              topStart: Radius.circular(
                10.0,
              ),
              topEnd: Radius.circular(
                10.0,
              ),
            ),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 5.0,
            horizontal: 10.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                model.text.toString(),
              ),
              // Text(
              //   daysBetween(DateTime.parse(model.time.toString())),
              //   style:
              //       Theme.of(context).textTheme.caption!.copyWith(fontSize: 8),
              // ),
            ],
          ),
        ),
      );

  Widget receiveMessage(MessageModel model, context) => Align(
        alignment: AlignmentDirectional.centerStart,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: const BorderRadiusDirectional.only(
              bottomEnd: Radius.circular(
                10.0,
              ),
              topStart: Radius.circular(
                10.0,
              ),
              topEnd: Radius.circular(
                10.0,
              ),
            ),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 5.0,
            horizontal: 10.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(model.name.toString(),style: const TextStyle(color: defaultColor),),
              Text(
                '${model.text}',
              ),
              // Text(
              //   daysBetween(DateTime.parse(model.time.toString())),
              //   style:
              //       Theme.of(context).textTheme.caption!.copyWith(fontSize: 8),
              // ),
            ],
          ),
        ),
      );
}

class ChatList extends StatelessWidget {
  final Stream? messageStream;

   ChatList({ this.messageStream});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: messageStream,
      builder: (context,snapshot)
      {
        if(snapshot.hasData)
        {
          QuerySnapshot values=snapshot.data as QuerySnapshot;
          return Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: values.docs.length,
              itemBuilder: (context,index)
              {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          decoration: const BoxDecoration(
                              color:Colors.orange,
                              borderRadius: BorderRadius.only(
                                  topLeft:Radius.circular(20),
                                  topRight: Radius.circular(20),
                                  bottomRight: Radius.circular(20)
                              )
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(values.docs[index]['text']),
                          )),
                    ),
                    Text(values.docs[index]['name']),
                  ],
                );
              },
            ),
          );

        }
        else{
          const Text('Error Occured!');
        }
        return Container();
      },
    );
  }
}