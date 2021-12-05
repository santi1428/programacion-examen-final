import 'document_type.dart';

class User {
  String firstName = '';
  String lastName = '';
  DocumentType documentType = DocumentType(id: 0, description: '');
  String document = '';
  String address = '';
  String imageId = '';
  String imageFullPath = '';
  int userType = 1;
  int loginType = 0;
  String fullName = '';
  int vehiclesCount = 0;
  String id = '';
  String userName = '';
  String email = '';
  String countryCode = '';
  String phoneNumber = '';

  User({
    required this.firstName,
    required this.lastName,
    required this.documentType,
    required this.document,
    required this.address,
    required this.imageId,
    required this.imageFullPath,
    required this.userType,
    required this.loginType,
    required this.fullName,
    required this.vehiclesCount,
    required this.id,
    required this.userName,
    required this.email,
    required this.countryCode,
    required this.phoneNumber,
  });

  User.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    documentType = DocumentType.fromJson(json['documentType']);
    document = json['document'];
    address = json['address'];
    imageId = json['imageId'];
    imageFullPath = json['imageFullPath'];
    userType = json['userType'];
    loginType = json['loginType'];
    fullName = json['fullName'];
    vehiclesCount = json['vehiclesCount'];
    id = json['id'];
    userName = json['userName'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
    countryCode = json['countryCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['documentType'] = this.documentType.toJson();
    data['document'] = this.document;
    data['address'] = this.address;
    data['imageId'] = this.imageId;
    data['imageFullPath'] = this.imageFullPath;
    data['userType'] = this.userType;
    data['loginType'] = this.loginType;
    data['fullName'] = this.fullName;
    data['vehiclesCount'] = this.vehiclesCount;
    data['id'] = this.id;
    data['userName'] = this.userName;
    data['email'] = this.email;
    data['phoneNumber'] = this.phoneNumber;
    data['countryCode'] = this.countryCode;
    return data;
  }
}
