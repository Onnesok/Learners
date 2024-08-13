import 'dart:io';
import 'dart:typed_data';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

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
  ChatUser geminiUser = ChatUser(id: "1", firstName: "gemini", profileImage: "https://mir-s3-cdn-cf.behance.net/project_modules/1400/15873842040529.5c5d98aa0bbf8.jpg");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Learners AI assistant",
          style: TextStyle(
            color: Colors.black87,
            fontFamily: "shadow",
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
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
              child: CircularProgressIndicator(
                color: Colors.amber[800],
              ),
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
      inputOptions: InputOptions(trailing: [
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
        ChatMessage? lastMessage = messages.firstOrNull;
        if (lastMessage != null && lastMessage.user == geminiUser) {
          lastMessage = messages.removeAt(0);
          String response = event.content?.parts?.fold("", (previous, current) => "$previous ${current.text}") ?? "";
          lastMessage.text += response;
          setState(() {
            messages = [lastMessage!, ...messages];
            isLoading = false;
          });
        } else {
          String response = event.content?.parts?.fold("", (previous, current) => "$previous ${current.text}") ?? "";
          ChatMessage message = ChatMessage(user: geminiUser, createdAt: DateTime.now(), text: response);
          setState(() {
            messages = [message, ...messages];
            isLoading = false;
          });
        }
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: "error");
      print(e);
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
