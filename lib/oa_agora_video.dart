import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class VideoPackage extends StatefulWidget {
  const VideoPackage({Key? key}) : super(key: key);

  @override
  State<VideoPackage> createState() => _VideoPackageState();
}

const appId = "Your app id";
const gettoken =
    "Your token";
const channelname = "Your channel name";

class _VideoPackageState extends State<VideoPackage> {
  int? _remoteUid;
  bool _localUserJoined = false;
  bool _muteLocalAudio = false;
  bool _muteLocalVideo = false;
  late RtcEngine _engine;

  @override
  void initState() {
    super.initState();
    initAgora();
  }

  Future<void> initAgora() async {
    await [Permission.microphone, Permission.camera].request();

    _engine = createAgoraRtcEngine();
    await _engine.initialize(const RtcEngineContext(
      appId: appId,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));

    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint("Host ${connection.localUid} joined");
          setState(() {
            _localUserJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          debugPrint("New user $remoteUid joined");
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          debugPrint("New user $remoteUid left channel");
          setState(() {
            _remoteUid = null;
          });
        },
        onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
          debugPrint(
              '[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: ${gettoken}');
        },
      ),
    );

    await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await _engine.enableVideo();
    await _engine.startPreview();

    await _engine.joinChannel(
      token: gettoken,
      channelId: channelname,
      uid: 0,
      options: const ChannelMediaOptions(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _dispose();
  }

  Future<void> _dispose() async {
    await _engine.leaveChannel();
    await _engine.release();
  }

  void _toggleMuteLocalAudio() {
    setState(() {
      _muteLocalAudio = !_muteLocalAudio;
    });
    _engine.muteLocalAudioStream(_muteLocalAudio);
  }

  void _toggleMuteLocalVideo() {
    setState(() {
      _muteLocalVideo = !_muteLocalVideo;
    });

    if (_muteLocalVideo) {
      _engine.enableLocalVideo(false);
    } else {
      _engine.enableLocalVideo(true);
    }
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('OASolutions Video Call'),
      backgroundColor: Colors.blue, // Change background color
      
    ),
    body: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Stack(
            children: [
              Center(
                child: _remoteVideo(),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: SizedBox(
                  width: 100,
                  height: 150,
                  child: Center(
                    child: _localUserJoined
                        ? AgoraVideoView(
                            controller: VideoViewController(
                              rtcEngine: _engine,
                              canvas: const VideoCanvas(uid: 0),
                            ),
                          )
                        : CircularProgressIndicator(),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [

              // Viewing participants details 
              IconButton(
                icon: Icon(Icons.person), 
                onPressed: () {
                  // Add functionality for the professional button
                },
              ),

              // Adding new participant to the call 
              IconButton(
                icon: Icon(Icons.add_box),
                onPressed: () {
                  // Add functionality for the professional button
                },
              ),

              IconButton(
              icon: Icon(_muteLocalAudio ? Icons.mic_off : Icons.mic),
              onPressed: _toggleMuteLocalAudio,
            ),
            IconButton(
              icon: Icon(_muteLocalVideo ? Icons.pause : Icons.play_arrow), // Change icon
              onPressed: _toggleMuteLocalVideo,
            ),
            ],
          ),
        ),
      ],
    ),
  );
}


  Widget _remoteVideo() {
    if (_remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _engine,
          canvas: VideoCanvas(uid: _remoteUid),
          connection: RtcConnection(channelId: channelname),
        ),
      );
    } else {
      return const Center(
        child: Text(
          'Waiting for other user to join',
          textAlign: TextAlign.center,
        ),
      );
    }
  }
}
