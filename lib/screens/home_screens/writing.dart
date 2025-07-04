import 'package:flutter/cupertino.dart';
import 'package:jitsi_meet_flutter_sdk/jitsi_meet_flutter_sdk.dart';

class WritingTestPage extends StatefulWidget {
  const WritingTestPage({super.key});

  @override
  State<WritingTestPage> createState() => _WritingTestPageState();
}

class _WritingTestPageState extends State<WritingTestPage> {
  final TextEditingController _roomController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  bool _isAudioMuted = true;
  bool _isVideoMuted = true;

  // Initialize JitsiMeet instance
  final _jitsiMeet = JitsiMeet();

  void _joinMeeting() async {
    try {
      // Configure Jitsi meeting options
      final options = JitsiMeetConferenceOptions(
        room: _roomController.text.isNotEmpty
            ? _roomController.text
            : "testRoom${DateTime.now().millisecondsSinceEpoch}",
        userInfo: JitsiMeetUserInfo(
          displayName: _nameController.text.isNotEmpty
              ? _nameController.text
              : "User",
        ),
        serverURL: "https://meet.jit.si", // Use Jitsi's public server
        featureFlags: {
          "welcomepage.enabled": false,
          "meeting-password.enabled": false,
          "audio-mute.enabled": _isAudioMuted,
          "video-mute.enabled": _isVideoMuted,
        },
      );

      // Join the meeting
      await _jitsiMeet.join(options);
    } catch (error) {
      debugPrint("Error joining meeting: $error");
      // Show error dialog
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('Error'),
          content: Text('Failed to join meeting: $error'),
          actions: [
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    _roomController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Join Video Meeting'),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CupertinoTextField(
                controller: _roomController,
                placeholder: 'Enter Room Name',
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 16),
              CupertinoTextField(
                controller: _nameController,
                placeholder: 'Enter Your Name',
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  CupertinoSwitch(
                    value: _isAudioMuted,
                    onChanged: (value) {
                      setState(() {
                        _isAudioMuted = value;
                      });
                    },
                  ),
                  const SizedBox(width: 8), // Add spacing
                  Flexible(
                    child: Text(
                      'Mute Audio',
                      style: const TextStyle(fontSize: 14), // Smaller font size
                      overflow: TextOverflow.ellipsis, // Handle long text
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  CupertinoSwitch(
                    value: _isVideoMuted,
                    onChanged: (value) {
                      setState(() {
                        _isVideoMuted = value;
                      });
                    },
                  ),
                  const SizedBox(width: 8), // Add spacing
                  Flexible(
                    child: Text(
                      'Mute Video',
                      style: const TextStyle(fontSize: 14), // Smaller font size
                      overflow: TextOverflow.ellipsis, // Handle long text
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              CupertinoButton.filled(
                onPressed: _joinMeeting,
                child: const Text('Join Meeting'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}