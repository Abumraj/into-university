import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:uniapp/Services/uapi.dart';

class ScorePage extends StatelessWidget {
  final double score;
  final double status;

  ScorePage(this.score, this.status);
  @override
  Widget build(BuildContext context) {
    return new Material(
        color: status > 89.9
            ? Colors.green
            : status > 69.9
                ? Colors.purple
                : status > 59.9
                    ? Colors.blue
                    : Colors.red,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: CircleAvatar(
                child: Image.asset("images/uniappLogo.png"),
                backgroundColor: Colors.white,
              ),
            ),
            status > 89.9
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Image.asset(
                      "images/worldCup.png",
                      width: 200,
                      height: 220,
                    ),
                  )
                : status > 79.9
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Image.asset(
                          "images/silverWorldCup.png",
                          width: 200,
                          height: 220,
                        ),
                      )
                    : Text(""),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Text("Your CGPA is: ",
                  style: new TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 40.0)),
            ),
            new Text(
                score
                    .toStringAsFixed(score.truncateToDouble() == score ? 1 : 2),
                style: new TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 50.0)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Badge(
                  toAnimate: true,
                  shape: BadgeShape.square,
                  badgeColor: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  badgeContent: Text(
                      status > 89.9
                          ? "FIRST CLASS HONOURS"
                          : status > 69.9
                              ? "SECOND CLASS UPPER"
                              : status > 49.8
                                  ? "SECOND CLASS LOWER"
                                  : status > 29.9
                                      ? "THIRD CLASS"
                                      : "PASS",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: status > 89.9
                            ? Colors.green
                            : status > 69.9
                                ? Colors.purple
                                : status > 59.9
                                    ? Colors.blue
                                    : Colors.red,
                      )),
                ),
              ),
            ),
            AnimatedTextKit(repeatForever: true, animatedTexts: [
              TyperAnimatedText(
                status > 89.9
                    ? "Excellent Result!"
                    : status > 69.9
                        ? "Very Good Result."
                        : status > 49.8
                            ? "Good Result."
                            : "Poor Performance.",
                textStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 32.0),
                speed: const Duration(milliseconds: 100),

                // duration: Duration(seconds: 10),
              ),
            ]),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                status > 89.9
                    ? "This is impressive! You are officially amongst the 1% at the top. We want you to keep up with this excellent work as many limits are breakable. At this point, consistency is key. Congratulations from all of us at UniApp"
                    : status > 69.9
                        ? "You've really tried and we appreciate your efforts. However, you are just a brink from making the top position. Don't relent. Remember where there is best, there is no room for better. Just a little bit of work could make the difference. We look forward to seeing you at the top next time. Congratulations!!!"
                        : status > 49.8
                            ? "You've tried and we acknowledge that. We will love to see you rise up to the summit of your academic career. We want you to dedicate more time to study and reach out to us for support on your weak courses. Remeber we are here to have you excel and will gladly assist you with your work. Speak to us at UniApp to achieve better Academic career"
                            : "This is bad but no worries. UniApp got you covered. Contact us at UniApp to build better academic career",
                style:
                    TextStyle(color: Colors.white, fontStyle: FontStyle.italic),
              ),
            ),
            if (status < 69.9)
              ElevatedButton(
                onPressed: () {
                  String whatsappMessage =
                      "Hello UniApp, My name is ________. Ineed your mentorship on my academics. I am a student of __________ university from the department of __________ and I am currently in __________ level.";

                  Uapi.joinTelegramGroupChat(
                      "https://wa.me/+2349025265463?text=$whatsappMessage",
                      true);
                },
                child: const Text('Contact UniApp'),
              ),
          ],
        ));
  }
}
