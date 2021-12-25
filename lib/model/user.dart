/*
this is user model
 */
class UserModel {
  String uid;
  String name;
  String email;
  String profilePhoto;
  String Degree;
  String Description;
  bool Doctor;
  bool AdminVerified;
  String DoctorVerificationReport;
  int Donations;



  UserModel({
    this.uid,
    this.name,
    this.email,
    this.profilePhoto,
    this.Degree,
    this.Description,
    this.Doctor,
    this.AdminVerified,
    this.DoctorVerificationReport,
    this.Donations
    });

  Map<String,dynamic> toMap(UserModel user) {
    var data = Map<String, dynamic>();
    data['Uid'] = user.uid;
    data['Name'] = user.name;
    data['Email'] = user.email;
    data["ProfilePhoto"] = user.profilePhoto;
    data['Degree'] = user.Degree;
    data['Description'] = user.Description;
    data['Doctor'] = user.Doctor;
    data['AdminVerified'] = user.AdminVerified;
    data['DoctorVerificationReport'] = user.DoctorVerificationReport;
    data['Donations']=user.Donations;
    return data;
  }

  // Named constructor
  UserModel.fromMap(Map<String, dynamic> mapData) {
    this.uid = mapData['Uid'];
    this.name = mapData['Name'];
    this.email = mapData['Email'];
    this.profilePhoto = mapData['ProfilePhoto'];
    this.Degree = mapData['Degree'];
    this.Description = mapData['Description'];
    this.Doctor = mapData['Doctor'];
    this.AdminVerified = mapData['AdminVerified'];
    this.DoctorVerificationReport = mapData['DoctorVerificationReport'];
    this.Donations=mapData['Donations'];
  }
}
