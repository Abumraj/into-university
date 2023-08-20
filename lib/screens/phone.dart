import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uniapp/Services/uapi.dart';
import 'package:uniapp/widgets/info.dart';

class PhoneSecurity extends StatefulWidget {
  const PhoneSecurity({Key? key}) : super(key: key);

  @override
  State<PhoneSecurity> createState() => _PhoneSecurityState();
}

class _PhoneSecurityState extends State<PhoneSecurity> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Become A Tutor"),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      tutorsRequirements.logoBase64,
                      width: 50,
                      height: 80,
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              tutorsRequirements.name,
                              style: context.textTheme.headline5,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        tutorsRequirements.description,
                        style: context.textTheme.bodyText2,
                      ),
                      const Divider(height: 6),
                      Text(
                        tutorsRequirements.criteria,
                        style: context.textTheme.bodyText2,
                      ),
                      const Divider(height: 6),
                      Text(
                        "*Must be a graduate or an undergraduate (300 level and above) of the university in which he/she will be serving as a tutor(University courses only).",
                        style: context.textTheme.bodyText2,
                      ),
                      const Divider(height: 3),
                      Text(
                        "*Must have at least two years of experience tutoring A-level courses(A-level courses).",
                        style: context.textTheme.bodyText2,
                      ),
                      const Divider(height: 3),
                      Text(
                        "*Must at least be ATS certified(ICAN only). ",
                        style: context.textTheme.bodyText2,
                      ),
                      const Divider(height: 3),
                      Text(
                        "*bMust have a laptop with minimum specification(4gig RAM, 500GB HDD/256GB SSD Windows 10).",
                        style: context.textTheme.bodyText2,
                      ),
                      const Divider(height: 3),
                      Text(
                        "* Must be able to speak the English language fluently.",
                        style: context.textTheme.bodyText2,
                      ),
                      const Divider(height: 3),
                      Text(
                        "* Must have at least a CGPA of 3.9(on a scale of 5).",
                        style: context.textTheme.bodyText2,
                      ),
                      const Divider(height: 3),
                      Text(
                        tutorsRequirements.note,
                        style: context.textTheme.bodyText2,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Uapi.joinTelegramGroupChat(
                                  tutorsRequirements.url, false);
                            },
                            child: const Text('Become A Tutor'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
