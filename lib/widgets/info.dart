import 'package:flutter/material.dart';
import '../models/infoModel.dart';

const mobileWidth = 650;
const primaryColor = Colors.purple;

ThemeData getThemeData(BuildContext context, Brightness brightness) {
  return ThemeData(
      primarySwatch: primaryColor,
      primaryColor: primaryColor,
      fontFamily: 'Roboto',
      colorScheme: ColorScheme.fromSwatch(
        brightness: brightness,
        primarySwatch: primaryColor,
      ),
      textTheme: TextTheme(),
      indicatorColor: primaryColor,
      navigationRailTheme: NavigationRailThemeData(),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ));
}

final myApp = FTInfo(
    name: 'UniApp Digital Solutions',
    note: "Students No.1 Online Solution.",
    criteria: "https://www.facebook.com/profile.php?id=100089096510773",
    url: 'https://twitter.com/UniAppDigital?t=aMWwu5SXOCquE-shivPzTw&s=03',
    description:
        "UniApp Digital Solution(RC3650411) is a company centered towards making life easier for Students nationwide by providing solutions to both their academic and non academic related problems",
    logoBase64: 'images/uniappLogo.png',
    vision: " To become students' No.1 Online Solution Nationwide",
    mission:
        " To reduce to the barest minimum poor academic performance, eradicate academic under-achievement across campuses nationwide and help students achieve academic excellence wirh little or no stress alongside making campus life less stressful with more flex(Less Stress, More Flex)");

final developerInfos = <FTInfo>[
  FTInfo(
      name: 'ABUMRAJ',
      url: 'https://twitter.com/AbumRaj1?t=4346egBEXdznB-0FI6erkw&s=09',
      description:
          'Founder | Lead Developer | CEO| Chemical Engineer| Al-Qori(Reciter)',
      logoBase64: 'images/uniappLogo.png',
      note: "",
      criteria: "",
      mission: "",
      vision: "")
];
final tutorsRequirements = FTInfo(
    name: 'BECOME UNIAPP TUTOR',
    url:
        'https://docs.google.com/forms/d/e/1FAIpQLSegNEeih7tFRhnv1cQSvzZwtBf_-CSfZ5mqs9y1vu8Q8HPg7g/viewform?usp=pp_',
    description:
        "   Are you a scholar or you have versed experience in tutoring? UniApp is the right platform for you to exhibit your skills. Become a tutor here at UniApp and enjoy credit alerts at the end of each semester or at the end of each month (as the case may be), for life provided we are still making use of your intellectual property.",
    logoBase64: 'images/uniappLogo.png',
    note:
        "Fund disbursement is every month for professional exams (ICAN etc) and A-level(IJMB/ JUPEB) tutors while it is at the end of each semester for university tutors. university tutors may as well receive monthly stipends when they take tutorials for ",
    criteria:
        "To qualify for this position, the following criteria must be met by any applicant: ",
    mission: "CRITETIA",
    vision: "");
