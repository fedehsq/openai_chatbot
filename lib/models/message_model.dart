class MessageModel {
  final int? id;
  final String text;
  final int contactId;
  final bool sent;

  MessageModel(this.text, this.contactId, this.sent, {this.id});

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      json['text'],
      json['contact_id'],
      json['sent'] == 1,
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      //'id': id,
      'text': text,
      'contact_id': contactId,
      'sent': sent ? 1 : 0,
    };
  }
}
