class PostModel {
  final String content;
  final String V_I;
  final int likes;
  final int comment;
  final String lastTimePost;

  //final String user_owner_id;
  //final String user_liked_id;

  PostModel({
    this.V_I,
    this.likes,
    this.content,
    this.comment,
    this.lastTimePost,
  });
}
