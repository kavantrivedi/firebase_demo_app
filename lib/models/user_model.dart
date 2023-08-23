import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  String? userName;
  String? userAddress;
  String? uid;

  UserModel({this.userName, this.userAddress,this.uid});

  factory UserModel.fromMap(map) {
    return UserModel(
      userName: map['userName'],
      userAddress: map['userAddress'],
      uid: map['uid'],
    );
  }

  factory UserModel.fromSnapshot(DocumentSnapshot docSnap){
    return UserModel(
        userName: docSnap.get('name'),
        uid: docSnap.get('uid'),
        userAddress: docSnap.get('userAddress'),
    );
  }

  Map<String,dynamic> toMap(){
    return {
      'userName': userName,
      'userAddress': userAddress,
      'uid':uid,
    };
  }
}
