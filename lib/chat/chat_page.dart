import 'dart:io';
import 'dart:typed_data';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lottie/lottie.dart';

class chat_ai extends StatefulWidget {
  const chat_ai({super.key});

  @override
  State<chat_ai> createState() => _chat_aiState();
}

class _chat_aiState extends State<chat_ai> {
  final Gemini gemini = Gemini.instance;
  List<ChatMessage> messages = [];
  bool isLoading = false;

  ChatUser currentUser = ChatUser(id: "0", firstName: "user");
  ChatUser geminiUser = ChatUser(
    id: "1",
    firstName: "Learners AI",
    profileImage: "https://raw.githubusercontent.com/Onnesok/Learners/main/assets/icon/app_icon1.png",
  );

  @override
  void initState() {
    super.initState();
    _initializeGemini();
  }

  Future<void> _initializeGemini() async {
    await dotenv.load(fileName: 'api_key.env');
    String? apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      Fluttertoast.showToast(msg: 'API Key is not set.');
      return;
    }
    Gemini.init(apiKey: apiKey);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white60,
      appBar: AppBar(
        title: const Text(
          "Learners AI Assistant",
          style: TextStyle(
            color: Colors.black87,
            fontFamily: "shadow",
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.orange[700],
        shadowColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            child: _buildUi(),
          ),
          if (isLoading)
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                height: MediaQuery.of(context).size.width * 0.5,
                child: Lottie.asset(
                  'assets/animation/loader3.json',
                  repeat: true,
                ),
              ),
              // CircularProgressIndicator(
              //   color: Colors.amber[800],
              // ),
            ),
        ],
      ),
    );
  }

  Widget _buildUi() {
    return DashChat(
      currentUser: currentUser,
      onSend: _sendMessage,
      messages: messages,
      inputOptions: InputOptions(
        trailing: [
          IconButton(
            onPressed: _sendMediaMessage,
            icon: const Icon(Icons.image),
          ),
        ],
        alwaysShowSend: true,
      ),
    );
  }

  void _sendMessage(ChatMessage chatMessage) {
    setState(() {
      isLoading = true;
      messages = [chatMessage, ...messages];
    });
    try {
      String question = chatMessage.text;
      List<Uint8List> images = [];
      if (chatMessage.medias?.isNotEmpty ?? false) {
        images = [
          File(chatMessage.medias!.first.url).readAsBytesSync(),
        ];
      }
      gemini.streamGenerateContent(question, images: images).listen((event) {
        String response = event.content?.parts?.fold("", (previous, current) => "$previous ${current.text}") ?? "";
        if (messages.isNotEmpty && messages.first.user == geminiUser) {
          ChatMessage? lastMessage = messages.removeAt(0);
          lastMessage.text += response;
          setState(() {
            messages = [lastMessage, ...messages];
            isLoading = false;
          });
        } else {
          ChatMessage message = ChatMessage(
            user: geminiUser,
            createdAt: DateTime.now(),
            text: response,
          );
          setState(() {
            messages = [message, ...messages];
            isLoading = false;
          });
        }
      }).onError((error) {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(msg: "An error occurred: $error");
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: "An error occurred: $e");
    }
  }

  void _sendMediaMessage() async {
    ImagePicker picker = ImagePicker();
    XFile? file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      ChatMessage chatMessage = ChatMessage(
        user: currentUser,
        createdAt: DateTime.now(),
        text: "Describe this image?",
        medias: [ChatMedia(url: file.path, fileName: "", type: MediaType.image)],
      );
      _sendMessage(chatMessage);
    }
  }
}

