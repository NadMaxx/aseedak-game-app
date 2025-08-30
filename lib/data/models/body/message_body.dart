class MessageBody {
  final String text;
  final String id;
  final bool isSender;
  final String sentTime;
  final String senderName;
  final String date;

  final String imageUrl;

  MessageBody(this.text,
      {this.isSender = true, this.sentTime = '', this.date = '', this.imageUrl = '',required this.id,this.senderName = ''});
}