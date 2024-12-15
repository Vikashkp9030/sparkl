import 'package:another_dashed_container/another_dashed_container.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sparkl/feature/splace_screen/enum/bubble_type.dart';
import 'package:sparkl/feature/splace_screen/widgets/chat_bubble.dart';
import 'package:sparkl/feature/splace_screen/widgets/chat_bubble_clipper.dart';
import 'package:sparkl/feature/splace_screen/widgets/dashed_circlePainter.dart';
import 'package:video_player/video_player.dart';

class SparklUIScreen extends StatefulWidget {
  const SparklUIScreen({super.key});

  @override
  _SparklUIScreenState createState() => _SparklUIScreenState();
}

class _SparklUIScreenState extends State<SparklUIScreen> {
  late VideoPlayerController _videoController;
  late VideoPlayerController _teacherVideoController;

  late CameraController _cameraController;
  bool _isCameraInitialized = false;
  bool _isPermissionGranted = false;
  int index = 0;

  @override
  void initState() {
    super.initState();
    _checkPermissionsAndInitializeCamera();
    _videoController = VideoPlayerController.asset('assets/studentvideo.mp4')
      ..initialize().then((_) {
        setState(() {});
      })
      ..setLooping(true)
      ..play();
    _teacherVideoController =
        VideoPlayerController.asset('assets/teachervideo.mp4')
          ..initialize().then((_) {
            setState(() {});
          });
    _teacherVideoController.setLooping(true);
    _teacherVideoController.play();
  }

  Future<void> _checkPermissionsAndInitializeCamera() async {
    final isPermissionGranted = await Permission.camera.isGranted;
    if (isPermissionGranted) {
      _initializeCamera();
    } else {
      final cameraPermission = await Permission.camera.request();
      if (cameraPermission.isGranted) {
        _initializeCamera();
      } else {
        setState(() {
          _isPermissionGranted = false; // Handle denied permission
        });
      }
    }
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final frontCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
    );
    _cameraController = CameraController(
      frontCamera,
      ResolutionPreset.high,
    );
    await _cameraController.initialize();
    setState(() {
      _isCameraInitialized = true;
      _isPermissionGranted = true;
    });
  }

  @override
  void dispose() {
    _cameraController.dispose();
    _videoController.dispose();
    _teacherVideoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFFFFDEF),
        body: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [studentContent(), const Spacer(), getStart()],
            ),
            logo(),
            pageOneTitle(),
            pageTwoTitle(),
            pageTreeTitle(),
            emoji(),
            teacherFirstChatAndVideo(),
            teacherSecondChatWidget(),
          ],
        ),
      ),
    );
  }

  /// navigation button
  Widget getStart() => Row(
        children: [
          if (index != 0)
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: InkWell(
                onTap: () {
                  if (index > 0) {
                    setState(() {
                      index = index - 1;
                    });
                  }
                },
                child: CustomDashedCircle(
                  size: 100,
                  dashColors: [
                    const Color(0xFFFBC02D), // First dash
                    index == 1
                        ? Colors.black12
                        : const Color(0xFFFBC02D), // Second dash
                    const Color(0xFFFBC02D), // Third dash
                  ],
                ),
              ),
            ),
          Expanded(
            child: IgnorePointer(
              ignoring: index == 2,
              child: GestureDetector(
                onTap: () {
                  if (index < 2) {
                    setState(() {
                      index = index + 1;
                    });
                  }
                },
                child: Container(
                  margin: const EdgeInsets.all(8),
                  height: 60, // Adjust height as needed
                  decoration: BoxDecoration(
                    color: const Color(0xFFFBC02D), // Background color
                    borderRadius: BorderRadius.circular(8.0), // Rounded corners
                  ),
                  alignment: Alignment.center, // Center the text
                  child: Text(
                    index == 2 ? 'Get Started' : 'Next',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );

  /// logo
  Widget logo() => AnimatedPositioned(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        left:
            index == 0 ? ((MediaQuery.of(context).size.width - 232.w) / 2) : 0,
        child: AnimatedContainer(
          margin: const EdgeInsets.symmetric(vertical: 8),
          alignment: Alignment.center,
          duration: const Duration(milliseconds: 500),
          width: index == 0 ? 200.w : 140.w,
          height: index == 0 ? 60.h : 40.h,
          child: Image.asset(
            'assets/sparkl_logo.png',
            fit: BoxFit.contain,
          ),
        ),
      );

  ///page one title
  Widget pageOneTitle() => AnimatedPositioned(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        left: index == 0
            ? (MediaQuery.of(context).size.width - 400) / 2 // Center
            : index == 1 || index == 2
                ? -200 // Move Left
                : MediaQuery.of(context).size.width, // Start Right
        top: 80.0,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: index == 0 ? 1 : 0,
          child: const SizedBox(
            width: 400,
            child: Column(
              children: [
                Text(
                  'Learning Made\n Personal',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'A Program designed just for YOU!',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  ///page two title
  Widget pageTwoTitle() => AnimatedPositioned(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,

        left: index == 1
            ? 16 // Center
            : index == 2
                ? -200 // Move Left
                : MediaQuery.of(context).size.width, // Start Right
        top: 60.0,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: index == 1 ? 1 : 0,
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '1-on-1 Live Classes',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                ' Learning customized for every student',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      );

  ///page tree title
  Widget pageTreeTitle() => AnimatedPositioned(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        left: index == 2
            ? 16 // Center
            : MediaQuery.of(context).size.width + 200, // Move Left
        top: 60.0,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: index == 2 ? 1 : 0,
          child: const Text(
            'Doubt Resolution\nWith Teachers',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.left,
          ),
        ),
      );

  ///teacher video and first chat
  Widget teacherFirstChatAndVideo() {
    _teacherVideoController.play();
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      top: index == 1
          ? 150
          : index == 2
              ? 180
              : -200,
      left: index == 1 ? (MediaQuery.of(context).size.width - 232) / 2 : 0,
      child: AnimatedContainer(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        duration: const Duration(milliseconds: 500),
        width: index == 1
            ? 200
            : index == 2
                ? MediaQuery.of(context).size.width * 0.75
                : 0,
        height: index == 1
            ? 80
            : index == 2
                ? 400
                : 0,
        alignment: Alignment.center,
        decoration: index == 2
            ? const BoxDecoration(
                shape: BoxShape.circle,
              )
            : null,
        child: _teacherVideoController.value.isInitialized
            ? index == 1
                ? AspectRatio(
                    aspectRatio: _teacherVideoController.value.aspectRatio,
                    child: VideoPlayer(_teacherVideoController),
                  )
                : Stack(
                    children: [
                      ChatBubble(
                        clipper:
                            ChatBubbleClipper(type: BubbleType.receiverBubble),
                        alignment: Alignment.topRight,
                        margin: const EdgeInsets.only(top: 43, left: 12),
                        backGroundColor: const Color(0xFFFBC02D),
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.9,
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Do you want to go over how to apply the quadratic formula ?",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                          top: 0,
                          left: 0,
                          child: CircleAvatar(
                            radius: 30,
                            child: ClipOval(
                              child: _teacherVideoController.value.isInitialized
                                  ? AspectRatio(
                                      aspectRatio: 1,
                                      child:
                                          VideoPlayer(_teacherVideoController),
                                    )
                                  : const Center(
                                      child: CircularProgressIndicator()),
                            ),
                          ))
                    ],
                  )
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  /// student video and content with chat
  Widget studentContent() {
    _videoController.play();
    return Padding(
      padding: EdgeInsets.only(top: index == 0 ? 200 : 160),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (index == 0)
            Lottie.asset(
              'assets/sparkl_shape_shift_lottie.json',
              width: 400,
              height: 400,
              fit: BoxFit.fitWidth,
            ),
          if (index != 0)
            const SizedBox(
              height: 500,
              width: double.infinity,
            ),
          AnimatedPositioned(
              duration: const Duration(milliseconds: 500),
              right: index == 1 ? 0 : -1000,
              top: 80,
              height: 500,
              child: Stack(
                children: [
                  Image.asset(
                    'assets/stack_card.png',
                    height: 180,
                    width: MediaQuery.of(context).size.width,
                  ),
                  Positioned(
                      top: 10,
                      child: Image.asset(
                        'assets/stack_card.png',
                        height: 220,
                        width: MediaQuery.of(context).size.width,
                      )),
                  Positioned(
                      top: 20,
                      child: Image.asset(
                        'assets/stack_card.png',
                        height: 260,
                        width: MediaQuery.of(context).size.width,
                      )),
                  Positioned(
                      top: 30,
                      child: Image.asset(
                        'assets/stack_card.png',
                        height: 300,
                        width: MediaQuery.of(context).size.width,
                      ))
                ],
              )),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 500),
            top: index == 0
                ? 36
                : index == 1
                    ? 300
                    : 140,
            right: index == 2 ? -30 : null,
            curve: Curves.ease,
            child: Align(
              alignment: Alignment.center,
              child: Stack(
                children: [
                  Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: AnimatedContainer(
                          width: index == 0
                              ? 260
                              : index == 2
                                  ? MediaQuery.of(context).size.width * 0.75
                                  : 100,
                          height: index == 0
                              ? 260
                              : index == 2
                                  ? 260
                                  : 100,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.transparent,
                            border: index == 0
                                ? Border.all(
                                    color: const Color(0xFFFBC02D),
                                    width: 1,
                                  )
                                : null,
                          ),
                          duration: const Duration(milliseconds: 500),
                          child: index == 2
                              ? Stack(
                                  children: [
                                    ChatBubble(
                                      clipper: ChatBubbleClipper(
                                          type: BubbleType.sendBubble),
                                      alignment: Alignment.topRight,
                                      margin: const EdgeInsets.only(
                                          top: 30, right: 12),
                                      backGroundColor: Colors.white,
                                      child: Container(
                                        constraints: BoxConstraints(
                                          maxWidth: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.9,
                                        ),
                                        child: const Text(
                                          "Yes, I'm confused about when to use it",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                        top: 5,
                                        right: 5,
                                        child: CircleAvatar(
                                          radius: 30,
                                          child: ClipOval(
                                            child: _isPermissionGranted &&
                                                    _isCameraInitialized
                                                ? AspectRatio(
                                                    aspectRatio: 1,
                                                    child: CameraPreview(
                                                        _cameraController),
                                                  )
                                                : _videoController
                                                        .value.isInitialized
                                                    ? AspectRatio(
                                                        aspectRatio: 1,
                                                        child: VideoPlayer(
                                                            _videoController),
                                                      )
                                                    : const Center(
                                                        child:
                                                            CircularProgressIndicator()),
                                          ),
                                        ))
                                  ],
                                )
                              : ClipOval(
                                  child: _isPermissionGranted &&
                                          _isCameraInitialized
                                      ? CameraPreview(_cameraController)
                                      : _videoController.value.isInitialized
                                          ? AspectRatio(
                                              aspectRatio: _videoController
                                                  .value.aspectRatio,
                                              child:
                                                  VideoPlayer(_videoController),
                                            )
                                          : const Center(
                                              child:
                                                  CircularProgressIndicator()),
                                ),
                        ),
                      ),
                    ],
                  ),
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 500),
                    top: 36,
                    left: index != 0 ? -200 : 40,
                    child: DashedContainer(
                      dashColor: const Color(0xFFFBC02D),
                      borderRadius: 50.0,
                      dashedLength: 4,
                      blankLength: 4,
                      strokeWidth: 3.0,
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/blue_book.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 500),
                    top: 160,
                    left: index != 0 ? -200 : 8,
                    child: DashedContainer(
                      dashColor: const Color(0xFFFBC02D),
                      borderRadius: 50.0,
                      dashedLength: 4,
                      blankLength: 4,
                      strokeWidth: 3.0,
                      child: Container(
                        width: 45,
                        height: 45,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/pre_read_selected.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 500),
                    top: 50,
                    right: index != 0 ? -200 : 0,
                    child: DashedContainer(
                      dashColor: const Color(0xFFFBC02D),
                      borderRadius: 40.0,
                      dashedLength: 4,
                      blankLength: 4,
                      strokeWidth: 3.0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 8),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(40.0)),
                        child: const Text(
                          'Holistic well-Being',
                          style: TextStyle(
                              fontSize: 16, fontStyle: FontStyle.italic),
                        ),
                      ),
                    ),
                  ),
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 500),
                    bottom: 50,
                    left: index == 0 ? 0 : -200,
                    child: DashedContainer(
                      dashColor: const Color(0xFFFBC02D),
                      borderRadius: 40.0,
                      dashedLength: 4,
                      blankLength: 4,
                      strokeWidth: 3.0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 8),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(40.0)),
                        child: const Text(
                          'Doubt Clarification',
                          style: TextStyle(
                              fontSize: 16, fontStyle: FontStyle.italic),
                        ),
                      ),
                    ),
                  ),
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 500),
                    bottom: 80,
                    right: index == 0 ? 0 : -200,
                    child: DashedContainer(
                      dashColor: const Color(0xFFFBC02D),
                      borderRadius: 40.0,
                      dashedLength: 4,
                      blankLength: 4,
                      strokeWidth: 3.0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 8),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(40.0)),
                        child: const Text(
                          '𝒫𝑒𝓇𝓈𝑜𝓃𝒶𝓁𝒾𝓈𝑒𝒹',
                          style: TextStyle(
                              fontSize: 16, fontStyle: FontStyle.italic),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// teacher second chat
  Widget teacherSecondChatWidget() {
    return AnimatedPositioned(
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOut,
      bottom: -80,
      left: index == 2 ? 0 : -100, // Fixed right value for animation
      child: AnimatedContainer(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        duration: const Duration(seconds: 1),
        width: index == 2 ? MediaQuery.of(context).size.width * 0.75 : 0,
        height: index == 1 ? 80 : 400,
        alignment: Alignment.center,
        decoration: index == 2
            ? const BoxDecoration(
                shape: BoxShape.circle,
              )
            : null,
        child: Stack(
          children: [
            ChatBubble(
              clipper: ChatBubbleClipper(type: BubbleType.receiverBubble),
              alignment: Alignment.topRight,
              margin: const EdgeInsets.only(top: 43, left: 12),
              backGroundColor: const Color(0xFFFBC02D),
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.9,
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "You use it when the equation is in the form ax² + bx + c = 0. Let me show you a quick example to clarify.",
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                ),
              ),
            ),
            Positioned(
                top: 0,
                left: 0,
                child: CircleAvatar(
                  radius: 30,
                  child: ClipOval(
                      child: _teacherVideoController.value.isInitialized
                          ? AspectRatio(
                              aspectRatio: 1,
                              child: VideoPlayer(_teacherVideoController),
                            )
                          : const Center(child: CircularProgressIndicator())),
                ))
          ],
        ),
      ),
    );
  }

  ///emoji

  Widget emoji() => AnimatedPositioned(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        bottom: 180,
        right: index == 0
            ? MediaQuery.of(context).size.width / 4
            : 0, // Fixed right value for animation
        child: AnimatedContainer(
          height: index == 0 ? 45 : 0,
          duration: const Duration(milliseconds: 500),
          child: AnimatedOpacity(
            opacity: index == 0 ? 1.0 : 0.0, // Visibility control
            duration: const Duration(milliseconds: 500),
            child: DashedContainer(
              dashColor: const Color(0xFFFBC02D),
              borderRadius: 45.0,
              dashedLength: 4,
              blankLength: 4,
              strokeWidth: 3.0,
              child: Container(
                width: 45,
                height: 45,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/emoji.png',
                      height: 16,
                      width: 16,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}
