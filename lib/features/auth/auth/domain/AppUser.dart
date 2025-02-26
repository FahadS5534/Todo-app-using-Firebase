
class AppUser {
  String name;
  String email;
  String uid;

  AppUser(this.name, this.email, this.uid);
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'uid': uid,
    };
  }
    factory AppUser.fromMap(Map<String, dynamic> map) {
      return AppUser(
        map['name'],
        map['email'],
        map['uid'],
      );
    }
  }
    
  

