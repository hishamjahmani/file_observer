class AppUser{

  final String? uid;
  final String? userName;
  final String? userSection;


  //AppUser({this.uid});
  AppUser({this.uid, this.userName, this.userSection});
}

class UserData {

  final String uid;
  final String userName;
  final String userSection;


  //AppUser({this.uid});
  UserData({required this.uid, required this.userName, required this.userSection});

}