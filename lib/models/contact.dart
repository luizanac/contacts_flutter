class Contact {

  int id;
  String name;
  String email;
  String phone;
  String img;

  Contact();

  Contact.fromMap(Map map){
    id = map['id'];
    name = map['name'];
    email = map['email'];
    phone = map['phone'];
    img = map['img'];
  }

  Map toMap(){
    Map<String, dynamic> map = {
      'name': name,
      'email': email,
      'phone': phone,
      'img': img
    };

    if(id != null){
      map['id'] = id;
    }

    return map;
  }

  @override
  String toString() {
    return "Contact(id: $id, name: $name, email: $email, phone: $phone, img: $img)";
  }

}