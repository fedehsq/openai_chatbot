class ContactDto {
  final int id;
  final String name;
  final String photo;

  ContactDto(this.id, this.name, this.photo);

  factory ContactDto.fromJson(Map<String, dynamic> json) {
    return ContactDto(
      json['id'],
      json['name'],
      json['photo'],
    );
  }
}
