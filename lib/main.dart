import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'feature/splace_screen/splace_screen.dart';

void main() async {
  await ScreenUtil.ensureScreenSize();
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ScreenUtilInit(child: SparklUIScreen()),
  ));
}
