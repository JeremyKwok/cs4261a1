import 'package:flutter/material.dart';
import 'package:cs4261a1/services/authentication.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.params, this.auth, this.userId, this.onSignedOut})
      : super(key: key);

  final Map params;
  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool _isEmailVerified = false;
  var _curIndex = 0;
  var contents = "Home";

  @override
  initState() {
    super.initState();

    _checkEmailVerification().whenComplete(() {
      if (!_isEmailVerified && !widget.params['homePageUnverified']) {
        // sign out if email not verified and the parameter is set to not show to unverified user
        _signOut();
      }
    });
  }

  Future<void> _checkEmailVerification() async {
    _isEmailVerified = await widget.auth.isEmailVerified();
    if (!_isEmailVerified) {
      _showVerifyEmailDialog();
    }
  }

  void _resendVerifyEmail() {
    widget.auth.sendEmailVerification();
    _showVerifyEmailSentDialog();
  }

  void _showVerifyEmailDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Verify your account"),
          content: new Text("Please verify account in the link sent to email"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Resend verification email"),
              onPressed: () {
                Navigator.of(context).pop();
                _resendVerifyEmail();
              },
            ),
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showVerifyEmailSentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Verify your account"),
          content:
          new Text("Link to verify account has been sent to your email"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  _signOut() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e);
    }
  }

  Future navigateToSubPage(context) async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => SubPage()));
  }

  Future navigateToQueuePage(context) async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => QueuePage()));
  }

  Future navigateToSymptomPage(context) async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => SymptomPage()));
  }

  _queue() async {
    try {

    } catch (e) {
      print(e);
    }
  }

  Widget _mainScreen() {
    return Center(
        child: Text(
          "Welcome.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 30.0),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(length: 3, child: Scaffold(
        appBar: new AppBar(
          title: new Text(widget.params['appName']),
          actions: <Widget>[
            new FlatButton(
                child: new Text('Logout',
                    style: new TextStyle(fontSize: 17.0, color: Colors.white)),
                onPressed: _signOut)
          ],
        ),
        body: 
          new TabBarView(
            children: <Widget>[
              new Image.asset('assets/coronavirus_us.png'),

              new Text(
              " Ongoing",
                style: new TextStyle(fontSize:30.0,
                color: const Color(0xFF000000),
                fontWeight: FontWeight.w200,
                fontFamily: "Roboto"),
              ),
    
              new Text(
              " Symptoms",
                style: new TextStyle(fontSize:30.0,
                color: const Color(0xFF000000),
                fontWeight: FontWeight.w200,
                fontFamily: "Roboto"),
              ),

            ]
    
          ),

        bottomNavigationBar: new BottomNavigationBar(
          currentIndex: _curIndex,
          items: [
            new BottomNavigationBarItem(
              icon: const Icon(Icons.access_time),
              title: new Text('My Symptoms'),
            ),
    
            new BottomNavigationBarItem(
              icon: const Icon(Icons.list),
              title: new Text('Symptom Tracker'),
            )
          ],
          onTap: (index) {
            setState(() {
              _curIndex = index;
              switch (_curIndex) {
                case 0:
                  contents = "Ongoing";
                  navigateToSubPage(context);
                  break;
                case 1:
                  contents = "Symptom Tracker";
                  navigateToSymptomPage(context);
                  break;
              }
            });
          }
        ),
      ));
  }
}


class SubPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Symptoms'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text('Your reported symptoms from the past 14 days'),


          ],
        ),
      ),
    );
  }
}

class QueuePage extends StatefulWidget {
  QueuePage({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _QueuePage();
  }
}

class SymptomPage extends StatefulWidget {
  SymptomPage({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _SymptomPage();
  }
}

String dropdownValue = "select";
class _QueuePage extends State<QueuePage> {
  String dropdownValue = 'select';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: DropdownButton<String>(
            value: dropdownValue,
            icon: Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(
                color: Colors.black
            ),
            underline: Container(
              height: 2,
              color: Colors.black,
            ),
            onChanged: (String newValue) {
              setState(() {
                dropdownValue = newValue;
              });
            },
            items: <String>['select', 'Placeholder_activity1', 'Placeholder_activity2', 'Placeholder_activity3']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            // source: https://api.flutter.dev/flutter/material/DropdownButton-class.html
          ),
        ),
      ),
    );
  }
}

class _SymptomPage extends State<SymptomPage> {

  @override

  bool hasCough = false;
  bool hasFever = false;
  bool hasDifficultyBreathing = false;
  bool hasChills = false;
  bool hasMusclePain = false;
  bool hasHeadache = false;
  bool hasSoreThroat = false;
  bool hasLossofSense = false;

  var _curIndex = 0;
  var contents = "Home";


  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: Text('Check all Symptoms you have'),
          ),
            body: Container(
              child: Column(
                  children: <Widget> [
                    CheckboxListTile(
                      title: Text('Dry Cough'),
                      value: hasCough,
                      onChanged: (value){
                        setState(() {
                          hasCough = value;
                        });
                      },
                      activeColor: Colors.pink,
                      checkColor: Colors.white,
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    CheckboxListTile(
                      title: Text('Fever'),
                      value: hasFever,
                      onChanged: (value){
                        setState(() {
                          hasFever = value;
                        });
                      },
                      activeColor: Colors.pink,
                      checkColor: Colors.white,
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    CheckboxListTile(
                      title: Text('Difficulty Breathing or Shortness of Breath'),
                      value: hasDifficultyBreathing,
                      onChanged: (bool value){
                        setState(() {
                          hasDifficultyBreathing = value;
                        });
                      },
                      activeColor: Colors.pink,
                      checkColor: Colors.white,
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    CheckboxListTile(
                      title: Text('Chills'),
                      value: hasChills,
                      onChanged: (value){
                        setState(() {
                          hasChills = value;
                        });
                      },
                      activeColor: Colors.pink,
                      checkColor: Colors.white,
                      controlAffinity: ListTileControlAffinity.leading,
                    ),

                    CheckboxListTile(
                      title: Text('Muscle Pain'),
                      value: hasMusclePain,
                      onChanged: (value){
                        setState(() {
                          hasMusclePain = value;
                        });
                      },
                      activeColor: Colors.pink,
                      checkColor: Colors.white,
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    CheckboxListTile(
                      title: Text('Headache'),
                      value: hasHeadache,
                      onChanged: (value){
                        setState(() {
                          hasHeadache = value;
                        });
                      },
                      activeColor: Colors.pink,
                      checkColor: Colors.white,
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    CheckboxListTile(
                      title: Text('Sore Throat'),
                      value: hasSoreThroat,
                      onChanged: (value){
                        setState(() {
                          hasSoreThroat = value;
                        });
                      },
                      activeColor: Colors.pink,
                      checkColor: Colors.white,
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    CheckboxListTile(
                      title: Text('New Loss of Taste or Smell'),
                      value: hasLossofSense,
                      onChanged: (value){
                        setState(() {
                          hasLossofSense = value;
                        });
                      },
                      activeColor: Colors.pink,
                      checkColor: Colors.white,
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    RaisedButton (
                      onPressed: () {

                      },
                      child: Text('Submit'),
                    )

                  ]

              ),
            )
        ));
  }
}





