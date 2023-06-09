import 'package:firebase_database/firebase_database.dart';
import 'FirebaseService.dart';

final FirebaseAuthServices firebaseAuthServices = FirebaseAuthServices();

class ModelProfileData {
  late final String userID;
  late final String userName;
  late final String userEmail;

  ModelProfileData(
      {required this.userID,
      required this.userEmail,
      required this.userName
      });

  String get getStudentUid {
    return userID;
  }



  String get getStudentEmail {
    return userEmail;
  }



  String get getStudentUSN {
    return userName;
  }



  set setStudentUid(String StudentUid) {
    this.userID = StudentUid;
  }


  set setStudentUSN(String StudentUSN) {
    this.userName = StudentUSN;
  }



  set setStudentEmail(String StudentEmail) {
    this.userEmail = StudentEmail;
  }




  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        'StudentUID': userID,
        'StudentUSN': userName,
        'StudentEmail': userEmail,

      };

  ModelProfileData.fromJson(Map<dynamic, dynamic> json) {
    userID = json['StudentUID'] as String;
    userName = json['StudentUSN'] as String;
    userEmail = json['StudentEmail'] as String;
  }
}


// Retrieve User Data from Firebase RTDB and Stream
late ModelProfileData modelProfileData;

Stream<ModelProfileData?> getUserInfo() {
  return FirebaseDatabase.instance.ref("SHIKSHA_APP/USERS_DATA/${firebaseAuthServices.firebaseUser?.uid}")
      .onValue.map((event) {
    return modelProfileData = ModelProfileData.fromJson(event.snapshot.value as Map<dynamic, dynamic>);
  });
}