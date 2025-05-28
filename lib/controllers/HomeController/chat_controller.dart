// ignore_for_file: avoid_print, prefer_interpolation_to_compose_strings, body_might_complete_normally_catch_error

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:astrowaypartner/models/chat_history_model.dart';
import 'package:http/http.dart' as http;
import 'package:astrowaypartner/models/call_history_model.dart';
import 'package:astrowaypartner/models/chat_model.dart';
import 'package:astrowaypartner/services/apiHelper.dart';
import 'package:astrowaypartner/views/HomeScreen/chat/chat_screen.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astrowaypartner/utils/global.dart' as global;

import '../../models/chat_message_model.dart';
import '../../models/message_model.dart';
import '../../utils/config.dart';

class ChatController extends GetxController {
  String screen = 'chat_controller.dart';
  String? enteredMessage = '';
  APIHelper apiHelper = APIHelper();
  List<ChatModel> chatList = [];
  //customer agorachat userId
  String agorapeerUserId = "";
  //astrologer agorachat userId
  String agoraUserId = "";
  //chatId from database
  int? chatId;
  String chatusersId = "";
  String firebaseChatId = "";
  ChatMessageModel? replymessage = ChatMessageModel();

  int chatDurationis = 0;
  setchatduration(int value) {
    chatDurationis = value;
    update();
  }

  // bool chatTracker = false;

  int? userId;
  CollectionReference userChatCollectionRef =
      FirebaseFirestore.instance.collection("chats");
  CollectionReference userChatCollectionRefRTM =
      FirebaseFirestore.instance.collection("LiveChats");
  ScrollController scrollController = ScrollController();
  int fetchRecord = 5;
  int startIndex = 0;
  bool isDataLoaded = false;
  bool isAllDataLoaded = false;
  bool isMoreDataAvailable = false;
  bool isInChatScreen = false;
  updateChatScreen(bool value) {
    isInChatScreen = value;
    log('chat change isInChatScreen is $isInChatScreen');

    update();
  }

  @override
  // ignore: unnecessary_overrides
  void onInit() async {
    super.onInit();
  }

  final AudioPlayer audioPlayer = AudioPlayer();

  getChatList(bool isLazyLoading, {int? isLoading = 1}) async {
    try {
      print(
          "getChatList called with isLazyLoading: $isLazyLoading, isLoading: $isLoading");

      // Always clear chat list before fetching new data
      chatList.clear();
      update();
      print("Chat list cleared.");

      startIndex = 0;

      if (!isLazyLoading) {
        isDataLoaded = false;
      }

      await global.checkBody().then(
        (result) async {
          if (result) {
            isLoading == 0 ? '' : global.showOnlyLoaderDialog();
            int id = global.user.id ?? 0;

            print(
                "Fetching chat list for user ID: $id, startIndex: $startIndex, fetchRecord: $fetchRecord");

            await apiHelper
                .getchatRequest(id, startIndex, fetchRecord)
                .then((result) {
              isLoading == 0 ? '' : global.hideLoader();

              print(
                  "API Response: Status - ${result.status}, Record List Length - ${result.recordList.length}");

              if (result.status == "200" && result.recordList.isNotEmpty) {
                // Track existing chat IDs to remove duplicates
                Set<int> uniqueIds = chatList.map((chat) => chat.id!).toSet();
                print("Existing Unique Chat IDs: $uniqueIds");

                List<ChatModel> newChats = result.recordList
                    .where((chat) =>
                        chat.id != null && !uniqueIds.contains(chat.id))
                    .cast<ChatModel>()
                    .toList();

                print(
                    "New Chats to Add: ${newChats.map((chat) => chat.id).toList()}");

                chatList.addAll(newChats);
                print("Updated Chat List Length: ${chatList.length}");

                update();

                isMoreDataAvailable = chatList.isNotEmpty;
                isAllDataLoaded = chatList.isEmpty;

                print(
                    "isMoreDataAvailable: $isMoreDataAvailable, isAllDataLoaded: $isAllDataLoaded");
              } else {
                print("No new chats available.");
              }
              update();
            });
          } else {
            print("checkBody() returned false.");
          }
        },
      );
    } catch (e) {
      print('Exception in getChatList(): $e');
    }
  }



  storeChatId(int partnerId, int chatId) async {
    try {
      await global.checkBody().then(
        (result) async {
          if (result) {
            await apiHelper
                .addChatId(global.currentUserId!, partnerId, chatId)
                .then(
              (result) {
                if (result.status == "200") {
                  firebaseChatId = result.recordList['recordList'];
                  update();
                  print('chat id genrated:- $firebaseChatId');
                } else {
                  global.showToast(message: "there are some problem");
                }
              },
            );
          }
        },
      );
      update();
    } catch (e) {
      print('Exception: $screen - storeChatId(): ' + e.toString());
    }
  }

//Reject a chat by id
  Future rejectChatRequest(int chatId) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          global.showOnlyLoaderDialog();
          await apiHelper.chatReject(chatId).then((result) async {
            global.hideLoader();
            if (result.status == "200") {
              global.showToast(message: "Reject chat request sucessfully");
              chatList.clear();
              isAllDataLoaded = false;
              update();
              await getChatList(false);
              Get.back();
            } else {
              global.showToast(message: result.message.toString());
            }
          });
        }
      });
      update();
    } catch (e) {
      print("Exception: $screen - rejectChatRequest():" + e.toString());
    }
  }

  //accept chat request
  Future acceptChatRequest(
    int chatId,
    String customerName,
    String customerProfile,
    int customerId,
    String fcmToken,
    String chatduration,
  ) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          global.showOnlyLoaderDialog();
          await apiHelper.acceptChatRequest(chatId).then((result) async {
            global.hideLoader();
            if (result.status == "200") {
              global.showToast(message: "This chat is  accepted");
              await storeChatId(customerId, chatId);
              updateChatScreen(true);
              int duration = int.parse(chatduration);
              log('sending id is $chatId');
              log('sending id firebase ${customerId}_${global.currentUserId}');

              Get.to(() => ChatScreen(
                    flagId: 1,
                    astrologerId: global.currentUserId,
                    customerName: customerName,
                    customerProfile: customerProfile,
                    customerId: customerId,
                    fcmToken: fcmToken,
                    chatduration: duration,
                    fireBasechatId: '${global.currentUserId}_${customerId}'
                    // fireBasechatId: '${customerId}_${global.currentUserId}'
                    ,
                  ));
              chatList.clear();
              isAllDataLoaded = false;
              update();
              await getChatList(false);
            } else {
              global.showToast(message: "This chat is not rejected");
            }
            update();
          });
        }
      });
    } catch (e) {
      print("Exception: $screen - acceptChatRequest():" + e.toString());
    }
  }

  bool isMe = true;
  // Stream<QuerySnapshot<Map<String, dynamic>>>? getChatMessages(
  //     String firebaseChatId1, int? currentUserId) {
  //   print('Check Messages');  // This will confirm if the method is called.
  //   print('firebase collection:  ${firebaseChatId1}');
  //   try {
  //     Stream<QuerySnapshot<Map<String, dynamic>>> data = FirebaseFirestore
  //         .instance
  //         .collection('chats/$firebaseChatId1/userschat')
  //         .doc('$currentUserId')
  //         .collection('messages')
  //         .snapshots();  // Remove the orderBy for testing
  //
  //     print('Check Firebase Message This');
  //     // This will confirm that the stream is set up.
  //
  //     print('Check Data ${data.toList()}');
  //
  //     data.listen((snapshot) {
  //       print('==== Data Length: ${snapshot.docs.length}');
  //       if (snapshot.docs.isEmpty) {
  //         print('No messages found.');
  //       } else {
  //         for (var message in snapshot.docs) {
  //           print('Message Check Firebase: ${message.data()}');
  //         }
  //       }
  //     });
  //
  //     return data;
  //   } catch (err) {
  //     print("Exception - apiHelper.dart - getChatMessages()" + err.toString());
  //     return null;
  //   }
  // }

  Future<void> printFirestoreDetails() async {
    try {
      // Fetch Firebase App details
      FirebaseApp app = Firebase.app();
      print('Firebase app name : ${app.name}');
      print('Firebase Project ID: ${app.options.projectId}');
      print('Firebase App Name: ${app.name}');
      print('Database apiKey: ${app.options.apiKey}');

      // Firestore instance
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Print top-level collections
      print('Top-level Collections:');
      await firestore.collectionGroup('__name__').get().then((snapshot) {
        for (var doc in snapshot.docs) {
          print('Collection Path: ${doc.reference.parent.path}');
          print('Document ID: ${doc.id}');
        }
      });

      print('Firestore details printed successfully.');
    } catch (e) {
      print('Error fetching Firestore details: $e');
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>? getChatMessages(
      String firebaseChatId1, int? currentUserId) {
    try {
      print('Firebase Chat Id: $firebaseChatId1');
      print('currentUserId: $currentUserId');

      // Set up the stream to fetch messages in descending order
      Stream<QuerySnapshot<Map<String, dynamic>>> data = FirebaseFirestore
          .instance
          .collection('chats/$firebaseChatId1/userschat')
          .doc('$currentUserId')
          .collection('messages')
          .orderBy("createdAt", descending: true)
          .snapshots();

      print(data.last);
      printFirestoreDetails();
      data.listen((snapshot) {
        printFirestoreDetails();
        if (snapshot.docs.isEmpty) {
          print('No messages found.');
        } else {
          snapshot.docs.forEach((doc) {
            // print('Message: ${doc.data()}');
          });
        }
      });

      return data;
    } catch (err) {
      // print("Exception - apiHelper.dart - getChatMessages()" + err.toString());
      return null;
    }
  }

  Future<void> sendReplyMessage(
      String message, int partnerId, bool isEndMessage, String replymsg) async {
    // log('chatID $chatId partnerId $partnerId');
    log('message $message replymsg $replymsg');
    log('reply hit');

    try {
      if (message.trim() != '') {
        ChatMessageModel chatMessage = ChatMessageModel(
          message: message,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          isDelete: false,
          isRead: true,
          userId1: '${global.currentUserId}',
          userId2: '$partnerId',
          isEndMessage: isEndMessage,
          replymsg: replymsg,
        );
        update();
        await uploadMessage(firebaseChatId, '$partnerId', chatMessage);
      } else {}
    } catch (e) {
      print('Exception in sendMessage ${e.toString()}');
    }
  }

  Future<void> sendMessage(
      String message, int partnerId, bool isEndMessage) async {
    log('custoer id is $partnerId');
    log('send message hit');
    // if (chatId != null) {
    try {
      if (message.trim() != '') {
        ChatMessageModel chaMessage = ChatMessageModel(
          message: message,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          isDelete: false,
          isRead: true,
          userId1: '${global.currentUserId}',
          userId2: '$partnerId',
          isEndMessage: isEndMessage,
          replymsg: '',
        );
        update();
        await uploadMessage(firebaseChatId, '$partnerId', chaMessage);
      } else {}
    } catch (e) {
      print('Exception in sendMessage ${e.toString()}');
    }
  }

  Future uploadMessage(
      String idUser, String partnerId, ChatMessageModel anonymous) async {
    try {
      final String globalId = global.currentUserId.toString();
      final refMessages = userChatCollectionRef //SEND BY CURRENT USER
          .doc(idUser)
          .collection('userschat')
          .doc(globalId)
          .collection('messages');
      final refMessages1 = userChatCollectionRef //SEND BY PRTNER USER
          .doc(idUser)
          .collection('userschat')
          .doc(partnerId)
          .collection('messages');
      final newMessage1 = anonymous;

      final newMessage2 = anonymous;
      newMessage2.messageId = refMessages1.id;

      var messageResult =
          await refMessages.add(newMessage1.toJson()).catchError((e) {
        print('send mess exception' + e);
      });
      newMessage1.messageId = messageResult.id;
      await userChatCollectionRef //ADD USER AND PARTNER IN THIS
          .doc(idUser)
          .collection('userschat')
          .doc(globalId)
          .collection('messages')
          .doc(newMessage1.messageId)
          .update({"messageId": newMessage1.messageId});

      newMessage2.isRead = false;
      var message1Result =
          await refMessages1.add(newMessage2.toJson()).catchError((e) {
        print('send mess exception' + e);
      });
      newMessage2.messageId = message1Result.id;
      await userChatCollectionRef
          .doc(idUser)
          .collection('userschat')
          .doc(partnerId)
          .collection('messages')
          .doc(newMessage1.messageId)
          .update({"messageId": newMessage1.messageId});
      return {
        'user1': messageResult.id,
        'user2': message1Result.id,
      };
    } catch (err) {
      print('uploadMessage err $err');
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>? getMessageRTMWeb(
      String channelID) {
    log('firebase  channelID $channelID');
    try {
      Stream<QuerySnapshot<Map<String, dynamic>>> data =
          userChatCollectionRefRTM
              .doc(channelID)
              .collection('messages')
              .where('isFromWeb', isEqualTo: true)
              .orderBy('createdAt')
              .snapshots();

      return data;
    } catch (err) {
      print("Exception - chatcontroller.dart - firebase" + err.toString());
      return null;
    }
  }

  Future uploadMessageRTM(
      String idUser, MessageModel anonymous, bool isdeleted) async {
    debugPrint('saving to $idUser firebase');
    log('messga sending ${anonymous.toJson()}');
    try {
      final refMessages =
          userChatCollectionRefRTM.doc(idUser).collection('messages');

      final newMessage1 = anonymous;

      final refMessages1 =
          userChatCollectionRefRTM.doc(idUser).collection('isDeleted');

      var alreadyisSnapshot = await refMessages1.get();
      if (alreadyisSnapshot.docs.isEmpty) {
        debugPrint('no field found added');
        await refMessages1.add({'isdeleted': isdeleted}).catchError((e) {
          log('creating deled field error ' + e);
        });
      } else {
        log('field isdelete already found not adding in firbase');
      }

      var messageResult =
          await refMessages.add(newMessage1.toJson()).catchError((e) {
        log('creating message in firbase exception' + e);
      });

      return {
        'user1': messageResult.id,
      };
    } catch (err) {
      log('uploadMessage err $err');
    }
  }

  Future<void> deleteBatches(String docid, bool isdeleted) async {
    final instance = FirebaseFirestore.instance;
    final batch = instance.batch();
    var collection =
        instance.collection('LiveChats').doc(docid).collection('messages');
    var snapshots = await collection.get();

    if (snapshots.docs.isNotEmpty) {
      for (var doc in snapshots.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();

      var collection =
          instance.collection('LiveChats').doc(docid).collection('isDeleted');
      var updatesnapshot = await collection.get();

      if (updatesnapshot.docs.isNotEmpty) {
        // Iterate through the documents and update the isdeleted field
        for (var doc in updatesnapshot.docs) {
          await collection.doc(doc.id).update({'isdeleted': isdeleted});
        }
      } else {
        log('No documents found in the isDeleted collection.');
      }
    } else {
      log('No documents to delete in the subcollection');
    }
  }

//UPload Files to firebase
  Future<void> sendFiletoFirebase(
    // String message,
    String chatId,
    int partnerId,
    File? file,
    BuildContext context,
  ) async {
    try {
      log('sending room_chatid $chatId customerid $partnerId');
      if (file != null) {
        // global.showOnlyLoaderDialog();
        uploadImage(file, partnerId.toString(), chatId);
      } else {
        debugPrint('no file to upload on firebase');
      }
    } catch (e) {
      print('Exception in sendMessage ${e.toString()}');
    }
  }

  Future<void> uploadImage(
      File imageFile, String partnerId, String chatId) async {
    Reference storageReference = FirebaseStorage.instance.ref().child(
        '$chatId/${DateTime.now().millisecondsSinceEpoch}_${imageFile.path.split('/').last}');
    final uploadTask = await storageReference.putFile(imageFile);
    if (uploadTask.state == TaskState.success) {
      debugPrint('image uploaded');
    }
    String downloadURL = await storageReference.getDownloadURL();
    debugPrint('File Uploaded: $downloadURL');
    updateProfileImage(partnerId, chatId, downloadURL);
  }

  Future<void> updateProfileImage(
      String partnerId, String chatId, String imageUrl) async {
    ChatMessageModel chatMessageModel = ChatMessageModel(
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isDelete: false,
      isRead: true,
      userId1: '${global.currentUserId}',
      userId2: partnerId,
      attachementPath: imageUrl,
      isEndMessage: false,
    );
    await uploadMessage(chatId, partnerId, chatMessageModel);
  }

  List<CalltSession>? _callHistoryList;
  List<CalltSession>? get callHistoryList => _callHistoryList;

  Future<void> fetchUserCallRequest() async {
    global.showOnlyLoaderDialog(); // Show loader
    update();

    try {
      var headers = await global.getApiHeaders(true);
      var request = http.Request(
          'POST',
          Uri.parse(
              'https://lab7.invoidea.in/goldenheart/api/get-astrologer-call-request?id=${global.currentUserId.toString()}'));

      print('API URL: ${request.url}');
      print('Request Headers fetchUserCallRequest : $headers');

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      print(
          'Response Status Code fetchUserCallRequest: ${response.statusCode}');
      print('Response Headers fetchUserCallRequest: ${response.headers}');

      String responseBody = await response.stream.bytesToString();
      print('Response Body fetchUserCallRequest: $responseBody');

      var jsonData = json.decode(responseBody);

      if (jsonData['recordList'] != null && jsonData['recordList'] is List) {
        _callHistoryList = (jsonData['recordList'] as List)
            .map((item) => CalltSession.fromJson(item))
            .toList();
      } else {
        _callHistoryList = []; // Ensure it's an empty list if null
      }

      print(
          'Chat History Length fetchUserCallRequest: ${_callHistoryList!.length}');
    } catch (e) {
      print('Exception fetchUserCallRequest: $e');
    } finally {
      global.hideLoader();
      update();
    }
  }

  List<ChatSession>? _chatHistoryList;
  List<ChatSession>? get chatHistoryList => _chatHistoryList;

  Future<void> fetchUserChatRequest() async {
    global.showOnlyLoaderDialog(); // Show loader
    update();

    try {
      var headers = await global.getApiHeaders(true);
      var request = http.Request(
          'POST',
          Uri.parse(
              'https://lab7.invoidea.in/goldenheart/api/get-astrologer-chat-request?id=${global.currentUserId.toString()}'));
      print(
          'API User Id fetchUserChatRequest : ${global.currentUserId.toString()}');
      print('API URL fetchUserChatRequest: ${request.url}');
      print('Request Headers fetchUserChatRequest: $headers');

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      print(
          'Response Status Code fetchUserChatRequest: ${response.statusCode}');
      print('Response Headers fetchUserChatRequest: ${response.headers}');

      String responseBody = await response.stream.bytesToString();
      print('Response Body fetchUserChatRequest: $responseBody');

      var jsonData = json.decode(responseBody);

      if (jsonData['recordList'] != null && jsonData['recordList'] is List) {
        _chatHistoryList = (jsonData['recordList'] as List)
            .map((item) => ChatSession.fromJson(item))
            .toList();
      } else {
        _chatHistoryList = []; // Ensure it's an empty list if null
      }

      print(
          'Chat History Length fetchUserChatRequest: ${_chatHistoryList!.length}');
    } catch (e) {
      print('Chat History Exception fetchUserChatRequest: $e');
    } finally {
      global.hideLoader();
      update();
    }
  }

  Map<String, dynamic>? _checkCallExtend;
  Map<String, dynamic>? get checkCallExtend => _checkCallExtend;

  Future<void> getChatExtend({required String callId}) async {
    print("callId ${callId}");
    try {
      var headers = await global.getApiHeaders(true);
      headers['Content-Type'] = 'application/json'; // Ensure proper header

      var request = http.Request(
        'POST',
        Uri.parse('$baseUrl/check-chat-extend'),
      );

      // Add body with callrequestId
      request.body = json.encode({
        "chatrequestId": callId // Replace 123 with your actual call request ID
      });

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();

        print('Response Body getChatExtend: $responseBody');

        var jsonData = json.decode(responseBody);
        _checkCallExtend = jsonData;
        print('Stored getChatExtend: $_checkCallExtend');
        print('Status: ${_checkCallExtend?["status"]}');
        print('Message: ${_checkCallExtend?["message"]}');
        print('Call Extend: ${_checkCallExtend?["chat_extend"]}');
      } else {
        print('Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Exception: $e');
    }
  }

}
