// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_final_fields
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:whisper/screens/settings/google_auth_api.dart';
import 'package:whisper/utils/colors.dart';
import 'package:whisper/widgets/app_bar.dart';
import 'package:whisper/widgets/custom_button2.dart';
import 'package:whisper/widgets/custom_text_area.dart';
import 'package:whisper/widgets/custom_text_field.dart';
import 'package:whisper/widgets/error_message.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  TextEditingController _subject = TextEditingController();
  TextEditingController _name = TextEditingController();
  TextEditingController _message = TextEditingController();
  String subjectError = "";
  String nameError = "";
  String messageError = "";
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, 'Contact us'),
      body: ListView(children: [
        Padding(
          padding: const EdgeInsets.only(left: 25, right: 25, top: 10),
          child: Text(
            "Get in touch",
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontFamily: 'Poppins',
              fontSize: 20,
              fontWeight: FontWeight.w600
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 25, right: 25, top: 5),
          child: Text(
            "If you have any ideas, want to start a buisness with us or anything that pops up to your mind we're ready to answer any and all your questions. Please fill all the fields below.",
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontFamily: 'Poppins',
              fontSize: 16,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 35, right: 25, top: 10),
          child: Text(
            'Subject:',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
              fontSize: 14,
            ),
          ),
        ),
        CustomTextField(_subject, 'Subject'),
        Padding(
          padding: const EdgeInsets.only(left: 40, top: 5),
          child: Text(
            subjectError,
            style: TextStyle(
              color: kred,
              fontSize: 12,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 35, right: 25),
          child: Text(
            'Name:',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
              fontSize: 14,
            ),
          ),
        ),
        CustomTextField(_name, 'Name'),
        Padding(
          padding: const EdgeInsets.only(left: 40, top: 5),
          child: Text(
            nameError,
            style: TextStyle(
              color: kred,
              fontSize: 12,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 35, right: 25),
          child: Text(
            'Message:',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
              fontSize: 14,
            ),
          ),
        ),
        CustomTextArea(_message, 'Message'),
        Padding(
          padding: const EdgeInsets.only(left: 40, top: 5),
          child: Text(
            messageError,
            style: TextStyle(
              color: kred,
              fontSize: 12,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CustomButton2(isLoading, 'Send', sendInfo),
              SizedBox(width: 25),
            ],
          ),
        )
      ]),
    );
  }

  sendInfo() async {
    if (_subject.text.isEmpty) {
      setState(() {
        subjectError = "the subject should not be empty";
        nameError = "";
        messageError = "";
      });
    } else if (_name.text.isEmpty) {
      setState(() {
        subjectError = "";
        nameError = "the name should not be empty";
        messageError = "";
      });
    } else if (_message.text.isEmpty) {
      setState(() {
        subjectError = "";
        nameError = "";
        messageError = "the message should not be empty";
      });
    } else {
      setState(() {
        subjectError = "";
        nameError = "";
        messageError = "";
        // isLoading = true;
      });
      showDialog(
          context: context,
          builder: ((context) {
            return ErrorMessage('Error',
                'We are facing a problem with the eamil implementation for the moment, maybe try another time,Thanks');
          }));
      // final user = await GoogleAuthApi.SignIn();
      // if(user== null) return;
      // final auth = await user.authentication;
      // final token = auth.accessToken!;
      // final email = user.email;
      // print("Authenticated: $email");
      // final smtpServer = gmailSaslXoauth2(email, token);
      // final messageToSent = Message()
      //   ..from = Address(email, _name.text)
      //   ..recipients = ['helmi.br1999@gmail.com']
      //   ..subject = _subject.text
      //   ..text = _message.text;
      // try {
      //   await send(messageToSent,smtpServer);
      //   showDialog(
      //       context: context,
      //       builder: ((context) {
      //         return ErrorMessage('Success',
      //             'Your message has been sent successfuly, we appreciate your feedback adn we will take consider of');
      //       }));
      // } on MailerException catch (e) {
      //   print(e);
      // }

      setState(() {
        isLoading = false;
      });
    }
  }
}
