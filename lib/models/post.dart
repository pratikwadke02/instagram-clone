import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String description;
  final String uid;
  final String postId;
  final String username;
  final DateTime datePublished;
  final String postUrl;
  final String profImage;
  final likes;

  const Post(
      {
        required this.description,
        required this.uid,
        required this.postId,
        required this.username,
        required this.datePublished,
        required this.postUrl,
        required this.profImage,
        required this.likes,

      });
      static Post fromSnap(DocumentSnapshot snap){
        var snapshot = snap.data() as Map<String, dynamic>;

        return Post(
          username: snapshot["username"] as String,
          uid: snapshot["uid"] as String,
          postId: snapshot["postId"] as String,
          description: snapshot["description"] as String,
          datePublished: snapshot["datePublished"] as DateTime,
          postUrl: snapshot["postUrl"] as String,
          profImage: snapshot["profImage"] as String,
          likes: snapshot["likes"] as List,
        );
      }

       Map<String, dynamic> toJson()=>{
        "description": description,
        "uid": uid,
        "postId": postId,
        "username": username,
        "datePublished": datePublished,
        "postUrl": postUrl,
        "profImage": profImage,
        "likes": likes,
      };
     
}
