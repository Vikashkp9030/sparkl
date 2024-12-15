import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'feature/splace_screen/splace_screen.dart';

void main() async {
  await ScreenUtil.ensureScreenSize();
  runApp(const MaterialApp(
    home: ScreenUtilInit(child: SparklUIScreen()),
  ));
}
// import 'package:flutter/material.dart';
//
// void main() {
//   runApp(ChatApp());
// }
//
// class ChatApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: ChatScreen(),
//     );
//   }
// }
//
// class ChatScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.yellow[50],
//       appBar: AppBar(
//         title: Text('Sparkl', style: TextStyle(color: Colors.teal)),
//         backgroundColor: Colors.white,
//         elevation: 0,
//         centerTitle: true,
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView(
//               padding: EdgeInsets.all(16),
//               children: [
//                 // Teacher Message
//                 ChatBubble(
//                   message:
//                       "Do you want to go over how to apply the quadratic formula?",
//                   isTeacher: true,
//                 ),
//                 SizedBox(height: 16),
//                 // Student Message
//                 ChatBubble(
//                   message: "Yes, I’m confused about when to use it.",
//                   isTeacher: false,
//                 ),
//                 SizedBox(height: 16),
//                 // Teacher Message
//                 ChatBubble(
//                   message:
//                       "You use it when the equation is in the form ax² + bx + c = 0. Let me show you a quick example to clarify.",
//                   isTeacher: true,
//                 ),
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: SizedBox(
//               width: double.infinity,
//               height: 50,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.amber,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 onPressed: () {
//                   // Add navigation or action
//                 },
//                 child: Text(
//                   'Get Started',
//                   style: TextStyle(fontSize: 18, color: Colors.black),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class ChatBubble extends StatelessWidget {
//   final String message;
//   final bool isTeacher;
//
//   ChatBubble({required this.message, required this.isTeacher});
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment:
//           isTeacher ? MainAxisAlignment.start : MainAxisAlignment.end,
//       children: [
//         if (isTeacher)
//           CircleAvatar(
//             backgroundImage: AssetImage('assets/teacher_avatar.png'),
//             radius: 20,
//           ),
//         SizedBox(width: 10),
//         Flexible(
//           child: Container(
//             padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//             decoration: BoxDecoration(
//               color: isTeacher ? Colors.yellow[200] : Colors.white,
//               borderRadius: BorderRadius.circular(12),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.shade300,
//                   blurRadius: 4,
//                   offset: Offset(0, 2),
//                 ),
//               ],
//             ),
//             child: Text(
//               message,
//               style: TextStyle(fontSize: 16, color: Colors.black87),
//             ),
//           ),
//         ),
//         if (!isTeacher) SizedBox(width: 10),
//         if (!isTeacher)
//           const CircleAvatar(
//             backgroundImage: AssetImage('assets/student_avatar.png'),
//             radius: 20,
//           ),
//       ],
//     );
//   }
// }
