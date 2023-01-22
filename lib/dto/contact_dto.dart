class ContactDto {
  final int id;
  final String name;
  final String photo;
  final bool trained;

  ContactDto(this.id, this.name, this.photo, this.trained);

  factory ContactDto.fromJson(Map<String, dynamic> json) {
    return ContactDto(
      json['id'],
      json['name'],
      json['photo'],
      json['trained'] == 1,
    );
  }
}
