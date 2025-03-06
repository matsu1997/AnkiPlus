import 'package:flutter/material.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:ndialog/ndialog.dart';
import 'constants.dart';
import 'countdown_timer.dart';

class HomePage extends StatefulWidget {
  final List<Icon> timesCompleted = [];

  HomePage({String? videoId}) {
    // Initialize times completed dot icons
    for (var i = 0; i < 3; i++) {
      timesCompleted.add(
        Icon(
          Icons.brightness_1_rounded,
          color: Colors.blueGrey,
          size: 5.0,
        ),
      );
    }
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CountDownController _clockController = CountDownController();
  var Duration = 1;
  Icon _clockButton = kPlayClockButton; // Initial value
  bool _isClockStarted = false; // Conditional flag
  late Function onComplete;
  // Change Clock button icon and controller
  void switchClockActionButton() {
    if (_clockButton == kPlayClockButton) {
      _clockButton = kPauseClockButton;

      if (!_isClockStarted) {
        // Processed on init
        _isClockStarted = true;
        _clockController.start();
      } else {
        // Processed on play
        _clockController.resume();
      }
    } else {
      // Processed on pause
      _clockButton = kPlayClockButton;
      _clockController.pause();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Half Screen Dimensions
    final double height = MediaQuery.of(context).size.height / 2;
    final double width = MediaQuery.of(context).size.width / 2;
    int indexTimesCompleted = 0;

    CountDownTimer _countDownTimer = CountDownTimer(
      duration: Duration,
      fillColor: Colors.blueGrey.shade100,
      onComplete: () {
        setState(() async {
          widget.timesCompleted[indexTimesCompleted] = Icon(
            Icons.brightness_1_rounded,
            color: Colors.blueGrey.shade100,
            size: 5.0,
          );
          indexTimesCompleted++;
          await NDialog(
            dialogStyle: DialogStyle(titleDivider: true),
            title: Text("Timer Completed"),
            content: Text("Time to break."),
            actions: <Widget>[
              ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith(
                            (states) => Colors.green),
                  ),
                  child: Text("Start a short break"),
                  onPressed: () {}),
            ],
          ).show(context);
        });
      },
    );

    CircularCountDownTimer clock = CircularCountDownTimer(
      controller: _clockController,
      isReverseAnimation: true,
      ringColor: Color(0xff0B0C19),
      height: height,
      width: width,
      autoStart: false,
      duration: _countDownTimer.duration * 60,
      isReverse: true,
      textStyle: TextStyle(color: Colors.white),
      fillColor: _countDownTimer.fillColor,
      backgroundColor: Color(0xFF2A2B4D),
      strokeCap: StrokeCap.round,

    );

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.headset_off),
        ),
        title: Text('Pomodoro'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.alarm_off),
          ),
        ],
      ),
      body: Container(
        child: Padding(
          padding:  EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              Text(
                Duration.toString(),
                style: TextStyle(
                  color: Colors.blueGrey,
                ),
              ),
              Center(
                child: clock,
              ),
              Text(
                kWorkLabel,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: widget.timesCompleted,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      switchClockActionButton();
                    });
                  },
                  child: Container(
                    width: width / 2.5,
                    height: height / 8,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: _clockButton,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CountDownTimer {
  final int duration;
  final Color fillColor;
  final Function onComplete;

  CountDownTimer({
    required this.duration,
    required this.fillColor,
    required this.onComplete,
  });
}