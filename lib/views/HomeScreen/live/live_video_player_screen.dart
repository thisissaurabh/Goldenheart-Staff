import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../controllers/HomeController/home_controller.dart';
import '../../../utils/dimensions.dart';
import '../../../utils/images.dart';
import '../../../utils/textstyles.dart';
import '../../../widgets/confirmation_dialog.dart';

class LiveYouTubePlayer extends StatefulWidget {
  final String id;
  final String title;
  final String youtubeUrl;

  LiveYouTubePlayer({required this.youtubeUrl, required this.id, required this.title});

  @override
  _LiveYouTubePlayerState createState() => _LiveYouTubePlayerState();
}

class _LiveYouTubePlayerState extends State<LiveYouTubePlayer> with WidgetsBindingObserver {
  late String videoId;
  late Timer? _timer;
  late Future<void> liveChatFuture;
  List<String> liveChatMessages = [];
  String? liveChatId;
  YoutubePlayerController? _youtubePlayerController;
  final homeController = Get.find<HomeController>();

  String extractVideoId(String url) {
    final regex = RegExp(r"(?:youtube\.com\/(?:watch\?v=|live\/)|youtu\.be\/)([a-zA-Z0-9_-]{11})");
    final match = regex.firstMatch(url);
    return match?.group(1) ?? '';
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    videoId = extractVideoId(widget.youtubeUrl);

    if (videoId.isNotEmpty) {
      _youtubePlayerController = YoutubePlayerController(
        initialVideoId: videoId,
        flags: YoutubePlayerFlags(
          isLive: true,
          autoPlay: true,
          enableCaption: true,
          disableDragSeek: true,
        ),
      );
      fetchLiveChatId(videoId);
    } else {
      print("Invalid YouTube URL");
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    if (_timer?.isActive ?? false) {
      _timer?.cancel();
    }

    if (_youtubePlayerController != null) {
      _youtubePlayerController!.pause();
      _youtubePlayerController!.dispose();
      _youtubePlayerController = null;
    }

    homeController.endLiveStream(widget.id);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_youtubePlayerController != null) {
      if (state == AppLifecycleState.paused) {
        _youtubePlayerController?.pause();
      } else if (state == AppLifecycleState.resumed) {
        _youtubePlayerController?.play();
      }
    }
  }

  Future<void> fetchLiveChatId(String videoId) async {
    final url = Uri.parse(
      'https://www.googleapis.com/youtube/v3/videos?part=liveStreamingDetails&id=$videoId&key=AIzaSyC9J9kBrPuU7Nb-1X88eSsxgbBRnACsV2I',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['items'].isNotEmpty) {
          final liveChatId = data['items'][0]['liveStreamingDetails']['activeLiveChatId'];
          setState(() {
            this.liveChatId = liveChatId;
          });
          fetchLiveChatMessages(liveChatId);
          startPollingNewMessages(liveChatId);
        } else {
          throw Exception('Live stream not found');
        }
      } else {
        throw Exception('Failed to fetch live stream details. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching live chat ID: $e');
    }
  }

  Future<void> fetchLiveChatMessages(String liveChatId) async {
    final url = Uri.parse(
      'https://www.googleapis.com/youtube/v3/liveChat/messages?liveChatId=$liveChatId&part=snippet,authorDetails&key=AIzaSyC9J9kBrPuU7Nb-1X88eSsxgbBRnACsV2I',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List items = data['items'];
        if (items.isNotEmpty) {
          for (var message in items) {
            final author = message['authorDetails']['displayName'];
            final text = message['snippet']['displayMessage'];
            String messageText = '$author: $text';

            setState(() {
              liveChatMessages.insert(0, messageText);
            });
          }
        }
      }
    } catch (e) {
      print('Error fetching live chat messages: $e');
    }
  }

  void startPollingNewMessages(String liveChatId) {
    _timer = Timer.periodic(Duration(milliseconds: 2078), (_) {
      fetchLiveChatMessages(liveChatId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Theme.of(context).dividerColor,
        centerTitle: true,
        title: Text(
          'Live Video',
          style: openSansRegular.copyWith(fontSize: Dimensions.fontSize18, color: Theme.of(context).primaryColor),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Theme.of(context).primaryColor,
          onPressed: () {
            Get.dialog(
              ConfirmationDialog(
                yesTap: () {
                  homeController.endLiveStream(widget.id);
                  if (_youtubePlayerController != null) {
                    _youtubePlayerController!.pause();
                    _youtubePlayerController!.dispose();
                    _youtubePlayerController = null;
                  }
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                title: 'Are you sure to exit from live video?',
              ),
            );
          },
        ),
      ),
      body: Column(
        children: [
          if (_youtubePlayerController != null)
            Container(
              height: 200,
              child: YoutubePlayer(
                controller: _youtubePlayerController!,
                showVideoProgressIndicator: true,
              ),
            )
          else
            Container(
              height: 200,
              color: Colors.black,
              child: Center(child: Text('Loading video...', style: openSansRegular.copyWith(color: Colors.white))),
            ),
          Expanded(
            child: liveChatMessages.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView.separated(
                    padding: EdgeInsets.all(16),
                    reverse: true,
                    itemCount: liveChatMessages.length,
                    itemBuilder: (context, index) {
                      return Row(
                        children: [
                          Container(
                            clipBehavior: Clip.hardEdge,
                            height: 24,
                            width: 24,
                            decoration: BoxDecoration(shape: BoxShape.circle),
                            child: Image.asset(Images.icProfilePlaceholder),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              liveChatMessages[index],
                              style: openSansRegular,
                            ),
                          ),
                        ],
                      );
                    },
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                  ),
          ),
        ],
      ),
    );
  }
}
