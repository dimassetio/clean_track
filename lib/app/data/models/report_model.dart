import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clean_track/app/data/helpers/database.dart';
import 'package:nb_utils/nb_utils.dart';

class ReportModel extends Database {
  static const String COLLECTION_NAME = "reports";

  static const String ID = "ID";
  static const String STATUS = "STATUS";
  static const String REPORTER_ID = "REPORTER_ID";
  static const String REPORTER_NAME = "REPORTER_NAME";
  static const String REPORTER_LOCATION = "REPORTER_LOCATION";
  static const String OFFICER_ID = "OFFICER_ID";
  static const String OFFICER_NAME = "OFFICER_NAME";
  static const String REPORTER_DESCRIPTION = "REPORTER_DESCRIPTION";
  static const String REPORTER_PHOTO = "REPORTER_PHOTO";
  static const String OFFICER_BEFORE_PHOTO = "OFFICER_BEFORE_PHOTO";
  static const String OFFICER_PROGRESS_PHOTO = "OFFICER_PROGRESS_PHOTO";
  static const String OFFICER_LAST_LOCATION = "OFFICER_LAST_LOCATION";
  static const String OFFICER_NOTE = "OFFICER_NOTE";
  static const String CREATED_AT = "CREATED_AT";
  static const String UPDATED_AT = "UPDATED_AT";

  String? id;
  String? status;
  String? reporterId;
  String? reporterName;
  GeoPoint? reporterLocation;
  String? officerId;
  String? officerName;
  String? reporterDescription;
  String? reporterPhoto;
  String? officerBeforePhoto;
  List<String>? officerProgressPhoto;
  GeoPoint? officerLastLocation;
  String? officerNote;
  DateTime? createdAt;
  DateTime? updatedAt;

  ReportModel({
    this.id,
    this.status,
    this.reporterId,
    this.reporterName,
    this.reporterLocation,
    this.officerId,
    this.officerName,
    this.reporterDescription,
    this.reporterPhoto,
    this.officerBeforePhoto,
    this.officerProgressPhoto,
    this.officerLastLocation,
    this.officerNote,
    this.createdAt,
    this.updatedAt,
  }) : super(
         collectionReference: firestore.collection(COLLECTION_NAME),
         storageReference: storage.ref(COLLECTION_NAME),
       );

  ReportModel.fromSnapshot(DocumentSnapshot doc)
    : id = doc.id,
      super(
        collectionReference: firestore.collection(COLLECTION_NAME),
        storageReference: storage.ref(COLLECTION_NAME),
      ) {
    var json = doc.data() as Map<String, dynamic>?;
    status = json?[STATUS];
    reporterId = json?[REPORTER_ID];
    reporterName = json?[REPORTER_NAME];
    reporterLocation = json?[REPORTER_LOCATION];
    officerId = json?[OFFICER_ID];
    officerName = json?[OFFICER_NAME];
    reporterDescription = json?[REPORTER_DESCRIPTION];
    reporterPhoto = json?[REPORTER_PHOTO];
    officerBeforePhoto = json?[OFFICER_BEFORE_PHOTO];
    officerProgressPhoto = List<String>.from(
      json?[OFFICER_PROGRESS_PHOTO] ?? [],
    );
    officerLastLocation = json?[OFFICER_LAST_LOCATION];
    officerNote = json?[OFFICER_NOTE];
    createdAt = (json?[CREATED_AT] as Timestamp?)?.toDate();
    updatedAt = (json?[UPDATED_AT] as Timestamp?)?.toDate();
  }

  Map<String, dynamic> toJson() {
    return {
      ID: id,
      STATUS: status,
      REPORTER_ID: reporterId,
      REPORTER_NAME: reporterName,
      REPORTER_LOCATION: reporterLocation,
      OFFICER_ID: officerId,
      OFFICER_NAME: officerName,
      REPORTER_DESCRIPTION: reporterDescription,
      REPORTER_PHOTO: reporterPhoto,
      OFFICER_BEFORE_PHOTO: officerBeforePhoto,
      OFFICER_PROGRESS_PHOTO: officerProgressPhoto,
      OFFICER_LAST_LOCATION: officerLastLocation,
      OFFICER_NOTE: officerNote,
      CREATED_AT: createdAt,
      UPDATED_AT: updatedAt,
    };
  }

  Future<ReportModel> save({File? file, bool? isSet}) async {
    id.isEmptyOrNull
        ? id = await super.add(toJson())
        : (isSet ?? false)
        ? super.collectionReference.doc(id).set(toJson())
        : await super.edit(toJson());
    if (file != null && !id.isEmptyOrNull) {
      reporterPhoto = await super.upload(id: id!, file: file);
      await super.edit(toJson());
    }
    return this;
  }

  // static Stream<List<ReportModel>>

  Future<ReportModel?> getReport() async {
    return id.isEmptyOrNull
        ? null
        : ReportModel.fromSnapshot(await super.getID(id!));
  }

  Stream<ReportModel> stream() {
    return super.collectionReference
        .doc(id)
        .snapshots()
        .map((event) => ReportModel.fromSnapshot(event));
  }

  Stream<ReportModel> streamById(String reportId) {
    return super.collectionReference
        .doc(reportId)
        .snapshots()
        .map((event) => ReportModel.fromSnapshot(event));
  }
}
