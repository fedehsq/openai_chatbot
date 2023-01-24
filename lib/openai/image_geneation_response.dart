class ImageGenerationResponse {
  final int created;
  final List<Data> data;

  ImageGenerationResponse(this.created, this.data);

  factory ImageGenerationResponse.fromJson(Map<String, dynamic> json) {
    return ImageGenerationResponse(
      json['created'],
      List<Data>.from(json['data'].map((x) => Data.fromJson(x))),
    );
  }
}

class Data {
  final String? b64Json;
  final String? url;

  Data(this.b64Json, this.url);

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      json['b64_json'],
      json['url'],
    );
  }
}
