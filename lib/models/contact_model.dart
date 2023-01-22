class ContactModel {
  final int? id;
  final String name;
  final String photo;
  final bool trained;

  ContactModel(this.name, this.photo, this.trained, {this.id});

  Map<String, dynamic> toJson() {
    return {
      //'id': id,
      'name': name,
      'photo': photo,
      'trained': trained ? 1 : 0,
    };
  }

}
