import 'package:flutter/material.dart';

class GameSettings {
  // ใช้ ValueNotifier เพื่อให้ค่ามีการติดตาม
  static ValueNotifier<int> quarterMinutes = ValueNotifier<int>(10);
  static ValueNotifier<int> totalQuarters = ValueNotifier<int>(4);
}

class SettingBasketballScore extends StatefulWidget {
  const SettingBasketballScore({super.key});

  @override
  _SettingBasketballScoreState createState() => _SettingBasketballScoreState();
}

class _SettingBasketballScoreState extends State<SettingBasketballScore> {
  // เริ่มต้นด้วยค่าจาก GameSettings
  int _selectedMinutes = GameSettings.quarterMinutes.value;
  int _selectedQuarters = GameSettings.totalQuarters.value;

  void _saveSettings() {
    // อัปเดตค่าใน ValueNotifier
    GameSettings.quarterMinutes.value = _selectedMinutes;
    GameSettings.totalQuarters.value = _selectedQuarters;

    // แสดงข้อความยืนยัน
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Settings Saved!")),
    );

    Navigator.pop(context); // กลับไปยังหน้าหลัก
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange, // สีส้มอ่อนให้กับพื้นหลัง Scaffold
      appBar: AppBar(
        title: Text("Game Settings"),
        backgroundColor: Colors.orange, // สีส้มให้กับ AppBar
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Quarter Duration (Minutes)", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            DropdownButton<int>(
              value: _selectedMinutes,
              items: List.generate(20, (index) => index + 1)
                  .map((value) => DropdownMenuItem(value: value, child: Text("$value min")))
                  .toList(),
              onChanged: (value) => setState(() => _selectedMinutes = value!),
            ),
            SizedBox(height: 20),
            Text("Total Quarters", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            DropdownButton<int>(
              value: _selectedQuarters,
              items: [1, 2, 3, 4, 5, 6]
                  .map((value) => DropdownMenuItem(value: value, child: Text("$value quarters")))
                  .toList(),
              onChanged: (value) => setState(() => _selectedQuarters = value!),
            ),
            SizedBox(height: 40),
            Center(
              child: ElevatedButton(
                onPressed: _saveSettings,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 255, 255, 255), // สีส้มให้กับ ElevatedButton
                  foregroundColor: const Color.fromARGB(255, 0, 0, 0), // สีตัวอักษรสีขาว
                ),
                child: Text("Save Settings"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}