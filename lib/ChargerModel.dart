import 'package:cloud_firestore/cloud_firestore.dart';

class  ChargerModel{
  String? id;
  String? userId;
  String? chargerName;
  String? chargerRate;
  String? phoneNumber;
  GeoPoint? chargerLocation;
  String? chargerType;
  DocumentReference? reference;

  ChargerModel();

  ChargerModel.fromData(
      this.id,
      this.userId,
      this.chargerName,
      this.chargerRate,
      this.phoneNumber,
      this.chargerLocation,
      this.chargerType);

  ChargerModel.fromMap(Map<String, dynamic> map, {required this.reference})
      :
  // assert(map['id'] != null),
        assert(map['userId'] != null),
        assert(map['chargerName'] != null),
        assert(map['chargerRate'] != null),
        assert(map['phoneNumber'] != null),
        assert(map['chargerLocation'] != null),
        assert(map['chargerType'] != null),
        id = reference?.id,
        userId = map['userId'],
        chargerName = map['chargerName'],
        chargerRate = map['chargerRate'],
        phoneNumber = map['phoneNumber'],
        chargerLocation = map['chargerLocation'],
        chargerType = map['chargerType'];


  Map<String, dynamic> toMap() {
    return {
      "userId": userId,
      "chargerName": chargerName,
      "chargerRate": chargerRate,
      "phoneNumber": phoneNumber,
      "chargerLocation": chargerLocation,
      "chargerType": chargerType,
    };
  }

  ChargerModel.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(
    snapshot.data() as Map<String, dynamic>,
    reference: snapshot.reference,
  );



}