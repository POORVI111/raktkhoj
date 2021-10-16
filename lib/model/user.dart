/*
this is user model
 */
class UserModel {
  String uid;
  String name;
  String email;
  String profilePhoto;

  UserModel({
    this.uid,
    this.name,
    this.email,
    this.profilePhoto,
  });

  Map<String,dynamic> toMap(UserModel user) {
    var data = Map<String, dynamic>();
    data['Uid'] = user.uid;
    data['Name'] = user.name;
    data['Email'] = user.email;
    data["ProfilePhoto"] = user.profilePhoto;
    return data;
  }

  // Named constructor
  UserModel.fromMap(Map<String, dynamic> mapData) {
    this.uid = mapData['Uid'];
    this.name = mapData['Name'];
    this.email = mapData['Email'];
    this.profilePhoto = mapData['ProfilePhoto'];
  }
}
