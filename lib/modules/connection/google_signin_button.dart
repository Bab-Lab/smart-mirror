import 'package:flutter/material.dart';
import 'package:smart_mirror/core/model/connection/google_connection.dart';
import 'package:smart_mirror/core/model/user.dart';
import 'package:smart_mirror/modules/smart_mirror_controller.dart';

class GoogleSignInButton extends StatefulWidget {
  final User user;

  GoogleSignInButton({required this.user});

  @override
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  bool _isSigningIn = false;

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.only(bottom: 16.0),
      child: _isSigningIn ? CircularProgressIndicator() : OutlinedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.white),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
          ),
        ),
        onPressed: () async {
          setState(() {
            _isSigningIn = true;
          });

          var connection = GoogleConnection(user: widget.user);
          var canConnect = await connection.connect();

          setState(() {
            _isSigningIn = false;
          });

          if (canConnect) {
            widget.user.setGoogle(connection);
            Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            SmartMirrorController.pushTaskView(context, widget.user,
                startingSelection: connection);
          }
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(
                image: AssetImage("assets/google_logo.png"),
                height: 35.0,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  'Connect to Google',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black54,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}