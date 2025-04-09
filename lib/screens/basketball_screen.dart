import 'dart:async'; // Import for Timer
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart'; // Import for audio
import 'Setting_Basketballscore.dart';
import 'db_helper.dart';

class BasketballScreen extends StatefulWidget {
  const BasketballScreen({super.key});

  @override
  _BasketballScreenState createState() => _BasketballScreenState();
}

class _BasketballScreenState extends State<BasketballScreen> {
  final SpringType = 'basketball';
  int homeScore = 0;
  int guestScore = 0;
  int quarter = 0;
  int minutes = 0;
  int seconds = 0;
  int milliseconds = 0;
  bool isRunning = false;
  late Timer _timer;
  final AudioPlayer _audioPlayer = AudioPlayer(); // Create AudioPlayer instance
  final DatabaseHelper _dbHelper = DatabaseHelper(); // สร้าง DatabaseHelper instance

  final TextEditingController _homeTeamController = TextEditingController();
  final TextEditingController _guestTeamController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _timer = Timer(Duration.zero, () {});
    _loadAudio();
  }

  // Load audio file
  Future<void> _loadAudio() async {
    // This is necessary for some platforms
    await _audioPlayer.setSource(AssetSource('sounds/goodresult-82807.mp3'));
    await _audioPlayer.setVolume(1.0);
  }

  // Play sound alert
  Future<void> _playAlertSound() async {
    try {
      await _audioPlayer.play(AssetSource('sounds/goodresult-82807.mp3'));
    } catch (e) {
      print('Error playing sound: $e');
    }
  }

  void toggleTimer() {
    if (isRunning) {
      _timer.cancel();
    } else {
      _startTimer();
    }
    setState(() {
      isRunning = !isRunning;
    });
  }

  void incrementHome() {
    setState(() {
      homeScore += 1;
    });
  }

  void setzeroscore() {
    setState(() {
      guestScore = 0;
      homeScore = 0;
      quarter = 0;
    });
  }

  void incrementGuest() {
    setState(() {
      guestScore += 1;
    });
  }

  void resetTimer() {
    if (isRunning) {
      _timer.cancel();
      setState(() {
        isRunning = false;
        minutes = 0;
        seconds = 0;
        milliseconds = 0;
      });
    } else {
      setState(() {
        minutes = 0;
        seconds = 0;
        milliseconds = 0;
      });
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(milliseconds: 10), (timer) {
      if (milliseconds < 99) {
        setState(() {
          milliseconds++;
        });
      } else if (seconds < 59) {
        setState(() {
          milliseconds = 0;
          seconds++;
        });
      } else if (minutes < 59) {
        setState(() {
          milliseconds = 0;
          seconds = 0;
          minutes++;
        });
      } else {
        _timer.cancel();
        // Timer reaches 59:59:99, you can handle what happens when the timer ends
      }

      // Check if the quarter time is reached
      if (minutes >= GameSettings.quarterMinutes.value &&
          seconds == 0 &&
          milliseconds == 0) {
        _handleQuarterEnd();
      }
    });
  }

  void _handleQuarterEnd() {
    _timer.cancel();
    setState(() {
      isRunning = false;
    });
    
    // Play alert sound when quarter ends
    _playAlertSound();

    // Check if all quarters are completed
    if (quarter >= GameSettings.totalQuarters.value - 1) {
      _showGameEndDialog();
    } else {
      _showQuarterEndDialog();
    }
  }

  // ฟังก์ชันเพิ่มข้อมูลลง SQLite
  Future<void> _insertDataToDb() async {
    String homeTeam = _homeTeamController.text.isEmpty ? "Home Team" : _homeTeamController.text;
    String guestTeam = _guestTeamController.text.isEmpty ? "Guest Team" : _guestTeamController.text;
    print("✅ กำลังนำข้อมูลลงฐานข้อมูล...");

    if (homeTeam.isNotEmpty && guestTeam.isNotEmpty) {
      print("📌 เริ่มการบันทึกข้อมูลจาก main.dart");
      await _dbHelper.insertGameRecord(
        homeTeam,
        guestTeam,
        homeScore,
        guestScore,
        quarter,
        GameSettings.quarterMinutes.value,
        GameSettings.totalQuarters.value,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Game record saved successfully!")),
      );
    }
  }

  void _showQuarterEndDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Quarter ${quarter + 1} Completed"),
          content: Text("Quarter ${quarter + 1} has ended."),
          actions: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  quarter++;
                  minutes = 0;
                  seconds = 0;
                  milliseconds = 0;
                  isRunning = true;
                });
                Navigator.of(context).pop();
                _startTimer();
              },
              child: Text("Resume Next Quarter"),
            ),
          ],
        );
      },
    );
  }

  void _showGameEndDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Game Completed"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("All quarters have been completed."),
              SizedBox(height: 10),
              Text(
                "Final Score: HOME $homeScore - GUEST $guestScore",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                homeScore > guestScore
                    ? "HOME team wins!"
                    : homeScore < guestScore
                    ? "GUEST team wins!"
                    : "It's a tie!",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                // เรียกใช้ _insertDataToDb() และรอให้มันเสร็จสิ้นก่อน
                await _insertDataToDb(); // ฟังก์ชันที่ไม่ต้องการค่า result

                setState(() {
                  quarter = 0;
                  homeScore = 0;
                  guestScore = 0;
                  minutes = 0;
                  seconds = 0;
                  milliseconds = 0;
                });

                // ปิดหน้าต่าง
                Navigator.of(context).pop();

                // แสดงข้อความ
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Game record saved successfully!")),
                );
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    _audioPlayer.dispose(); // Dispose audio player
    _homeTeamController.dispose();
    _guestTeamController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(251, 140, 0, 1),
      body: SafeArea(
        child: Column(
          children: [
            // Header Bar with back button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () {
                      Navigator.pop(
                        context,
                      ); // Navigate back to the home screen
                    },
                  ),
                  Row(
                    children: [
                      Icon(Icons.sports_basketball, color: Colors.black),
                      SizedBox(width: 5),
                      Text("Basketball Counting Score", style: TextStyle(color: Colors.black)),
                    ],
                  ),
                ],
              ),
            ),
            Divider(color: Colors.black),

            // Timer และ Settings
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(width: 30), // ตัวเว้นที่ด้านซ้าย
                  ElevatedButton(
                    onPressed: () {
                      resetTimer();
                      setzeroscore();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text("RESET", style: TextStyle(color: Colors.white)),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SettingBasketballScore(),
                        ), // เปิดหน้า Setting
                      );
                    },
                    child: Icon(Icons.settings, color: Colors.white, size: 30),
                  ),
                ],
              ),
            ),

            // Timer
            Text(
              "TIMER",
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            ValueListenableBuilder<int>(
              valueListenable: GameSettings.quarterMinutes,
              builder: (context, quarterMinutes, _) {
                return Column(
                  children: [
                    Text(
                      "$minutes : ${seconds.toString().padLeft(2, '0')} : ${milliseconds.toString().padLeft(2, '0')}",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Quarter Time: $quarterMinutes minutes",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14,
                      ),
                    ),
                  ],
                );
              },
            ),
            SizedBox(height: 20),

            // Home - Guest
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text("HOME", style: _labelStyle()),
                    Text("$homeScore", style: _scoreStyle()),
                  ],
                ),
                Column(
                  children: [
                    Text("GUEST", style: _labelStyle()),
                    Text("$guestScore", style: _scoreStyle()),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),

            // Quarter
            ValueListenableBuilder<int>(
              valueListenable: GameSettings.totalQuarters,
              builder: (context, totalQuarters, _) {
                return Column(
                  children: [
                    Text("QUARTER", style: _labelStyle()),
                    Text(
                      "${quarter + 1} / $totalQuarters",
                      style: _scoreStyle(),
                    ),
                  ],
                );
              },
            ),
            SizedBox(height: 20),

            // ปุ่มเพิ่มคะแนน
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _scoreButton("HOME +1", incrementHome),
                _scoreButton("GUEST +1", incrementGuest),
              ],
            ),
            SizedBox(height: 20),

            // Start/Stop Button
            _scoreButton(
              isRunning ? "STOP" : "START",
              toggleTimer,
              fullWidth: true,
            ),
            Spacer(),

            // Bottom Navigation
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Icon(Icons.fingerprint, color: Colors.black, size: 30),
                  Icon(Icons.sports, color: Colors.black, size: 30),
                  Icon(Icons.sports_basketball, color: Colors.black, size: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextStyle _labelStyle() {
    return TextStyle(
      color: Colors.white.withOpacity(0.8),
      fontSize: 18,
      fontWeight: FontWeight.bold,
    );
  }

  TextStyle _scoreStyle() {
    return TextStyle(
      color: Colors.white,
      fontSize: 40,
      fontWeight: FontWeight.bold,
    );
  }

  Widget _scoreButton(
    String text,
    VoidCallback onPressed, {
    bool fullWidth = false,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white.withOpacity(0.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        minimumSize: fullWidth ? Size(260, 50) : Size(120, 50),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}