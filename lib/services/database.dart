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
      String? actionOnTender) async {
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
      String actionOnTender) async {
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
      String? actionOnTender) async {
    // ignore: deprecated_member_use
    return await logCollection
        // ignore: deprecated_member_use
        .doc(data)
        .collection(currentTime!.replaceAll('/', ''))
        // ignore: deprecated_member_use
        .doc(actionOnTender)
        // ignore: deprecated_member_use
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
    });
  }

  // tender list from snapshot
  List<Tender> _tenderListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      //print(doc.data);
      return Tender(
          tenderNumber: (doc.data()! as Map)['tenderNumber'] ?? 'should be specified',
          tenderName: (doc.data()! as Map)['tenderName'] ?? 'should be specified',
          tenderOwnerName:(doc.data()! as Map)['tenderOwnerName'] ?? 'should be specified',
          currentEmployee:
              (doc.data()! as Map)['currentEmployee'] ?? 'should be specified',
          tenderSection: (doc.data()! as Map)['tenderSection'] ?? 'should be specified',
          currentTime: (doc.data()! as Map)['currentTime'] ?? 'should be specified',
          tenderDirection: (doc.data()! as Map)['tenderDirection'] ?? 'inward',
          tenderLocation:
              (doc.data()! as Map)['tenderLocation'] ?? 'should be specified');
    }).toList();
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

  //
  // get user doc stream
  Stream<UserData> get userData {
    return usersCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }

  Stream<String> get currentAppVersion {
    
    return appVersion.doc('version').snapshots().map((event) => (event.data() as Map)['version']);
  }
}
