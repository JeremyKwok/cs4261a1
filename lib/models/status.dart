import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

Status statusFromJson(String str) {
  final jsonData = json.decode(str);
  return Status.fromJson(jsonData);
}

String statusToJson(Status data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class Status {
  DateTime date;
  String userId;
  double temp;
  bool tiredness;
  bool bodyache;
  bool nasalCongestion;
  bool soreThroat;
  bool diarrhoea;


  Status({
    this.date,
    this.userId,
    this.temp,
    this.tiredness,
    this.bodyache,
    this.nasalCongestion,
    this.soreThroat,
    this.diarrhoea
  });


  void initState() {
      this.date = null;
      this.userId = null;
      this.temp = null;
      if (this.nasalCongestion == null || this.tiredness == null || this.bodyache == null || this.soreThroat == null || this.diarrhoea == null) {
        this.tiredness = false;
        this.bodyache = false;
        this.nasalCongestion = false;
        this.soreThroat = false;
        this.diarrhoea = false;
      }
  }

  factory Status.fromJson(Map<String, dynamic> json) => new Status(
    date: json["date"],
    userId: json["userId"],
    temp: json["temp"],
    tiredness: json["tire"],
    bodyache: json["ache"],
    nasalCongestion: json["nasalCongestion"],
    soreThroat: json["soreThroat"],
    diarrhoea: json["diarrhoea"]
  );

  Map<String, dynamic> toJson() => {
    "date": date,
    "userId": userId,
    "temp": temp,
    "tiredness": tiredness,
    "bodyache": bodyache,
    "nasalCongestion": nasalCongestion,
    "soreThroat": soreThroat,
    "diarrhoea": diarrhoea
  };

  factory Status.fromDocument(DocumentSnapshot doc) {
    return Status.fromJson(doc.data);
  }
}