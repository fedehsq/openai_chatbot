class ContactModel {
  final int id;
  final String name;
  final String photo;

  ContactModel(this.id, this.name, this.photo);

  Map<String, dynamic> toJson() {
    return {
      //'id': id,
      'name': name,
      'photo': photo,
    };
  }

}
