class OpenAiRequest {
  final String model;
  final String prompt;
  final int maxTokens;
  final double temperature;
  final double topP;
  final double frequencyPenalty;
  final double presencePenalty;
  final List<String> stop;

  OpenAiRequest({
    required this.prompt,
    this.model = "text-davinci-003",
    this.maxTokens = 60,
    this.temperature = 0.5,
    this.topP = 1,
    this.frequencyPenalty = 0.5,
    this.presencePenalty = 0.0,
    this.stop = const ["Io", "Jane"],
  });

  Map<String, dynamic> toJson() {
    return {
      'model': model,
      'prompt': prompt,
      'max_tokens': maxTokens,
      'temperature': temperature,
      'top_p': topP,
      'frequency_penalty': frequencyPenalty,
      'presence_penalty': presencePenalty,
      'stop': stop,
    };
  }
}
