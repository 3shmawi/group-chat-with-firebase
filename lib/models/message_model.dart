class MessageModel {
  // DateTime? time;
  String? text;
  String? name;
  // String? type;


  MessageModel({
    required this.name,
    // required this.time,
    required this.text,
    // required this.type,
  });

  MessageModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    // time = json['time'];
    text = json['text'];
    // type = json['type'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      // 'time': time,
      'text': text,
      // 'type': type,
    };
  }
}
