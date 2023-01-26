# openai_chatbot

## Description
This mobile app, built with Flutter, utilizes the power of OpenAI's Text Completion and DALL-E APIs to bring a cutting-edge chatbot experience to users.  
The goal of the app is to provide a user-friendly interface for users to interact with advanced AI technologies and to explore the capabilities of OpenAI's powerful AI models.   
Whether you're looking to have a casual chat or get information on a specific topic, this app is the perfect tool for the job.  
Experience the future of AI-powered communication with this app.

## Technologies used:
- [OpenAI Text Completion API](https://openai.com/api/text-completion/)
- [OpenAI DALL-E API](https://openai.com/dall-e/)
- [Flutter](https://flutter.dev/)
- [SQLite](https://www.sqlite.org/index.html)

## Installation:
- In order to use this app, you will need to obtain an OpenAI API key. You can get one from [here](https://beta.openai.com/signup/)
- Once you have the key, please paste it in the ```lib/openai/api_key.dart``` file provided in the project.
- Make sure that you have added the openaikey.dart file to the project.

## Instructions:
You can give the bot an identity. As reported by [OpenAI docs](https://beta.openai.com/docs/guides/completion/prompt-design), the bot will behave differently depending on the identity you give it: 
1. We tell the API the intent but we also tell it how to behave. Just like the other prompts, we cue the API into what the example represents, but we also add another key detail: we give it explicit instructions on how to interact with the phrase "The assistant is helpful, creative, clever, and very friendly."  
Without that instruction the API might stray and mimic the human it's interacting with and become sarcastic or some other behavior we want to avoid.
2. We give the API an identity. At the start we have the API respond as an AI assistant. While the API has no intrinsic identity, this helps it respond in a way that's as close to the truth as possible. You can use identity in other ways to create other kinds of chatbots. If you tell the API to respond as a woman who works as a research scientist in biology, you'll get intelligent and thoughtful comments from the API similar to what you'd expect from someone with that background.

If you give the bot an identity, a bot image will be generated for it using the DALL-E API.  
If you don't want to give the bot an identity, you can just start a conversation with it.  
When you start a conversation with the bot, you can choose to give it an identity. If you choose to do so, the bot will behave accordingly.
- The first message you submit will be used to give it an identity and to generate the bot image.
- The other messages you submit will be used to help the bot understand its personality and to generate a response (one message from you and one from the bot).
- Tap to the right upper icon to start a the conversation. 

There is a "pre-trained" model (Jane) provided in the project. Its behavior is similar to that of a girlfirend:
``` 
Quella che segue è una conversazione con la mia ragazza Jane. Jane è disponibile, creativa, intelligente, molto amichevole e mi vuole molto bene. Non mancano però i classici litigi di coppia; d'altronde l'amore non è bello se non è litigarello.

Io: Buongiorno Jane
Bot: Buongiorno tesoro
Io: Come stai?
Bot: Sto bene, ma mi manchi tanto!
Io: Anche tu!
Bot: Oh, tesoro! Oggi pomeriggio, quando esco dal lavoro, potremmo andare a bere qualcosa?
Io: Sì!
Bot: Fantastico. Ci vediamo alle sei allora! :)
Io: Alle sei?
Bot: Sì, alle sei! Non vedo l'ora!
Io: Perché devi decidere sempre tu l'orario?
Bot: Be', sai che io sono molto organizzata! Voglio semplicemente assicurarmi che sia comodo per entrambi. :)Io: Per me non è comodo come orario
Bot: Ah, capisco. Pensi che potremmo andare a bere qualcosa prima?
Io: no
Bot: Allora potremmo andare a cena?
```