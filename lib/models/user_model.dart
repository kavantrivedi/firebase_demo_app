import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? userName;
  String? userAddress;
  String? uid;
  String? email;

  UserModel({this.userName, this.userAddress, this.uid, this.email});

  factory UserModel.fromMap(map) {
    return UserModel(
      userName: map['userName'],
      userAddress: map['userAddress'],
      uid: map['uid'],
      email: map['email'],
    );
  }

  factory UserModel.fromSnapshot(DocumentSnapshot docSnap) {
    return UserModel(
      userName: docSnap.get('name'),
      uid: docSnap.get('uid'),
      userAddress: docSnap.get('userAddress'),
      email: docSnap.get('email'),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'userAddress': userAddress,
      'uid': uid,
      'email': email,
    };
  }
}
