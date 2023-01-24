class ImageGenerationRequest {
  final String prompt;
  final int n;
  final String size;
  final String responseFormat;

  ImageGenerationRequest(this.prompt,
      {this.n = 1, this.size = "256x256", this.responseFormat = "b64_json"});

  Map<String, dynamic> toJson() {
    return {
      'prompt': prompt,
      'n': n,
      'size': size,
      'response_format': responseFormat,
    };
  }
}
