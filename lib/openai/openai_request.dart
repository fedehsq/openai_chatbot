const String stopword = "\nIo:";
const String botStopword = "\nBot:";

const String trainingDescription =
    "La seguente descrizione ed i seguenti messaggi sono opzionali per guidare il mio comportamento verso l'approccio che desideri.";

const String training =
    "Quella che segue è una conversazione con la mia ragazza Jane. Jane è disponibile, creativa, intelligente, molto amichevole e mi vuole molto bene. Non mancano però i classici litigi di coppia; d'altronde l'amore non è bello se non è litigarello.\n\nIo: Buongiorno Jane\nBot: Buongiorno tesoro \nIo: Come stai?\nBot: Sto bene, ma mi manchi tanto!\nIo: Anche tu!\nBot: Oh, tesoro! Oggi pomeriggio, quando esco dal lavoro, potremmo andare a bere qualcosa?\nIo: Sì!\nBot: Fantastico. Ci vediamo alle sei allora! :)\nIo: Alle sei?\nBot: Sì, alle sei! Non vedo l'ora!\nIo: Perché devi decidere sempre tu l'orario?\nBot: Be', sai che io sono molto organizzata! Voglio semplicemente assicurarmi che sia comodo per entrambi. :)\nIo: Per me non è comodo come orario\nBot: Ah, capisco. Pensi che potremmo andare a bere qualcosa prima?\nIo: no\nBot: Allora potremmo andare a cena?\nIo: ";

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
    this.maxTokens = 128,
    this.temperature = 0.5,
    this.topP = 1,
    this.frequencyPenalty = 0.5,
    this.presencePenalty = 0.0,
    this.stop = const ["Io", "Bot"],
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
