part of 'home_cubit.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}



class GetChatUsersInfoLoadingState extends HomeState {}

class GetChatUsersInfoSuccessState extends HomeState {}

class GetChatUsersInfoErrorState extends HomeState {}

class SendMessageSuccessState extends HomeState {}

class SendMessageErrorState extends HomeState {}

class GetMessageLoadingState extends HomeState {}

class GetMessageSuccessState extends HomeState {}

