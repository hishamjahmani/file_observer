import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_observer/models/tender.dart';
import 'package:file_observer/models/user.dart';

class DatabaseService {
  final String? uid;
  final String? data;

  DatabaseService({this.uid, this.data});

  final CollectionReference tendersCollection =
      FirebaseFirestore.instance.collection('t');
  final CollectionReference logCollection =
      FirebaseFirestore.instance.collection('l');
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference appVersion =
      FirebaseFirestore.instance.collection('version');

  Future updateUsersList(String userUid, String userEmail, String userName,
      String userSection) async {
    // ignore: deprecated_member_use
    return await usersCollection.doc(uid).set({
      'uid': uid,
      'email': userEmail,
      'userName': userName,
      'userSection': userSection
    });
  }

  Future updateTenderData(
      String? tenderNumber,
      String? tenderName,
      String? tenderLocation,
      String? tenderSection,
      String? tenderOwnerName,
      String? tenderDirection,
      String? currentEmployee,
      String? currentTime,
      String? actionOnTender,
      String? lastActionBy) async {
    // ignore: deprecated_member_use
    return await tendersCollection.doc(data).set({
      'tenderNumber': tenderNumber,
      'tenderName': tenderName,
      'tenderOwnerName': tenderOwnerName,
      'tenderSection': tenderSection,
      'tenderLocation': tenderLocation,
      'currentEmployee': currentEmployee,
      'tenderDirection': tenderDirection,
      'currentTime': currentTime,
      'actionOnTender': actionOnTender,
      'lastActionBy': lastActionBy,
    });
  }

  Future addNewTenderData(
      String tenderNumber,
      String tenderName,
      String tenderLocation,
      String tenderSection,
      String tenderOwnerName,
      String tenderDirection,
      String currentEmployee,
      String currentTime,
      String actionOnTender,
      String lastActionBy) async {
    // ignore: deprecated_member_use
    return await tendersCollection.doc(data).set({
      'tenderNumber': tenderNumber,
      'tenderName': tenderName,
      'tenderOwnerName': tenderOwnerName,
      'tenderSection': tenderSection,
      'tenderLocation': tenderLocation,
      'currentEmployee': currentEmployee,
      'tenderDirection': tenderDirection,
      'currentTime': currentTime,
      'actionOnTender': actionOnTender,
      'lastActionBy': lastActionBy,
    });
  }

  Future deleteTenderData(String tenderNumber) async {
    // ignore: deprecated_member_use
    return await tendersCollection.doc(data).delete();
  }

  Future updateLogFile(
      String? tenderNumber,
      String? tenderName,
      String? tenderLocation,
      String? tenderSection,
      String? tenderOwnerName,
      String? tenderDirection,
      String? currentEmployee,
      String? currentTime,
      String? actionOnTender,
      String? lastActionBy) async {
    // ignore: deprecated_member_use
    return await logCollection
        // ignore: deprecated_member_use
        .doc('$data + ${currentTime!.replaceAll('/', '')}')
        .set({
      'tenderNumber': tenderNumber,
      'tenderName': tenderName,
      'tenderOwnerName': tenderOwnerName,
      'tenderSection': tenderSection,
      'tenderLocation': tenderLocation,
      'currentEmployee': currentEmployee,
      'tenderDirection': tenderDirection,
      'currentTime': currentTime,
      'actionOnTender': actionOnTender,
      'lastActionBy': lastActionBy,
    });
  }

  // tender list from snapshot
  List<Tender> _tenderListFromSnapshot(QuerySnapshot snapshot) {
    //tenders numbers List
    return snapshot.docs.map((doc) {
      //print(doc.data);
      return Tender(
          // tender details.
          tenderNumber:
              (doc.data()! as Map)['tenderNumber'] ?? 'should be specified',
          tenderName:
              (doc.data()! as Map)['tenderName'] ?? 'should be specified',
          tenderOwnerName:
              (doc.data()! as Map)['tenderOwnerName'] ?? 'should be specified',
          currentEmployee:
              (doc.data()! as Map)['currentEmployee'] ?? 'should be specified',
          tenderSection:
              (doc.data()! as Map)['tenderSection'] ?? 'should be specified',
          currentTime:
              (doc.data()! as Map)['currentTime'] ?? 'should be specified',
          tenderDirection: (doc.data()! as Map)['tenderDirection'] ?? 'inward',
          tenderLocation:
              (doc.data()! as Map)['tenderLocation'] ?? 'should be specified',
          actionOnTender:
              (doc.data()! as Map)['actionOnTender'] ?? 'should be specified',
          lastActionBy: (doc.data()! as Map)['lastActionBy'] ?? ' --');
    }).toList();
  }
/*
  final String? tenderNumber;
  final String? tenderName;
  final String? currentTime;
  final String? tenderOwnerName;
  final String? currentEmployee;
  final String? tenderSection;
  final String? tenderDirection;
  final String? tenderLocation;
  final String? actionOnTender;
  final String? lastActionBy;
*/

  List<TenderLog> _tenderLogListFromSnapshot(QuerySnapshot snapshot) {
    //tender numbers list
    return snapshot.docs.map((tmDoc) {
      //final subCol = logCollection.doc(tmDoc.id).collection('x').doc('s').get();
      return TenderLog(
          // tender details.
          tenderNumber:
              (tmDoc.data()! as Map)['tenderNumber'] ?? 'should be specified',
          tenderName:
              (tmDoc.data()! as Map)['tenderName'] ?? 'should be specified',
          tenderOwnerName: (tmDoc.data()! as Map)['tenderOwnerName'] ??
              'should be specified',
          currentEmployee: (tmDoc.data()! as Map)['currentEmployee'] ??
              'should be specified',
          tenderSection:
              (tmDoc.data()! as Map)['tenderSection'] ?? 'should be specified',
          currentTime:
              (tmDoc.data()! as Map)['currentTime'] ?? 'should be specified',
          tenderDirection:
              (tmDoc.data()! as Map)['tenderDirection'] ?? 'inward',
          tenderLocation:
              (tmDoc.data()! as Map)['tenderLocation'] ?? 'should be specified',
          actionOnTender:
              (tmDoc.data()! as Map)['actionOnTender'] ?? 'should be specified',
          lastActionBy: (tmDoc.data()! as Map)['lastActionBy'] ?? ' --');
    }).toList();

    // for(String t in tm){print(t);};

    //  snapshot.docs.map((tenderNo){
    //   tenderNo.data((){});
  }

  //
  // user data from snapshots
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    //print(snapshot.data()['userName']);
    return UserData(
      uid: (snapshot.data()! as Map)['uid'],
      userName: (snapshot.data()! as Map)['userName'],
      userSection: (snapshot.data()! as Map)['userSection'],
    );
  }

  Stream<List<Tender>> get tenders {
    return tendersCollection.snapshots().map(_tenderListFromSnapshot);
  }

  Stream<List<TenderLog>> get tendersLog {
    return logCollection.snapshots().map(_tenderLogListFromSnapshot);
  }

  //
  // get user doc stream
  Stream<UserData> get userData {
    return usersCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }

  Stream<String> get currentAppVersion {
    return appVersion
        .doc('version')
        .snapshots()
        .map((event) => (event.data() as Map)['version']);
  }
}
