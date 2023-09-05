import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String? userName;
  final String? userAddress;
  final String? uid;
  final String? email;
  final bool? isSelected;

  const UserModel({
    this.userName,
    this.userAddress,
    this.uid,
    this.email,
    this.isSelected = false,
  });

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

  @override
  List<Object?> get props => [userName, userAddress, uid, email, isSelected];
  UserModel copyWith(
      {String? userName,
      String? userAddress,
      String? uid,
      String? email,
      bool? isSelected}) {
    return UserModel(
      userName: userName ?? this.userName,
      userAddress: userAddress ?? this.userAddress,
      uid: uid ?? this.uid,
      email: email ?? this.email,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
