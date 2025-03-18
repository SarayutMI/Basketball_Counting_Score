import 'package:flutter/material.dart';
import 'db_helper.dart'; // import DatabaseHelper

class GameRecordsScreen extends StatefulWidget {
  @override
  _GameRecordsScreenState createState() => _GameRecordsScreenState();
}

class _GameRecordsScreenState extends State<GameRecordsScreen> {
  late Future<List<Map<String, dynamic>>> _gameRecords;
  final ScrollController _scrollController = ScrollController();
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _refreshRecords();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  
  // ฟังก์ชันสำหรับรีเฟรชข้อมูล
  void _refreshRecords() {
    setState(() {
      _gameRecords = _dbHelper.getAllGameRecords();
    });
  }
  
  // ฟังก์ชันสำหรับลบรายการ
  Future<void> _deleteRecord(int id) async {
    // แสดงไดอะล็อกยืนยัน
    bool confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("ยืนยันการลบ"),
          content: Text("คุณต้องการลบข้อมูลเกมนี้ใช่หรือไม่?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text("ยกเลิก"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text("ลบ", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    ) ?? false;
    
    if (confirmDelete) {
      // ลบข้อมูลจากฐานข้อมูล
      int result = await _dbHelper.deleteGameRecord(id);
      
      if (result > 0) {
        // แสดงข้อความแจ้งเตือนว่าลบสำเร็จ
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("ลบข้อมูลเกมสำเร็จ"),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
        // รีเฟรชข้อมูล
        _refreshRecords();
      } else {
        // แสดงข้อความแจ้งเตือนว่าลบไม่สำเร็จ
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("ไม่สามารถลบข้อมูลได้"),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Game Records"),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: () async {
              // แสดงไดอะล็อกยืนยันการลบข้อมูลทั้งหมด
              bool confirmDelete = await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("ลบข้อมูลทั้งหมด"),
                    content: Text("คุณต้องการลบข้อมูลเกมทั้งหมดใช่หรือไม่? การกระทำนี้ไม่สามารถย้อนกลับได้"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: Text("ยกเลิก"),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: Text("ลบทั้งหมด", style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  );
                },
              ) ?? false;
              
              if (confirmDelete) {
                int result = await _dbHelper.deleteAllGameRecords();
                if (result > 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("ลบข้อมูลเกมทั้งหมดสำเร็จ: $result รายการ"),
                      backgroundColor: Colors.green,
                    ),
                  );
                  _refreshRecords();
                }
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _gameRecords,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No records found"));
          }

          final gameRecords = snapshot.data!;

          return RefreshIndicator(
            onRefresh: () async {
              _refreshRecords();
            },
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: gameRecords.length,
                    itemBuilder: (context, index) {
                      final record = gameRecords[index];
                      final recordId = record['id']; // ดึง ID ของรายการ
                      final bool homeWon = record['home_score'] > record['guest_score'];
                      final bool tie = record['home_score'] == record['guest_score'];

                      return Card(
                        margin: EdgeInsets.all(10),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Container(
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Home Team: ${record['home_team']}",
                                          style: TextStyle(
                                            fontSize: 18, 
                                            fontWeight: FontWeight.bold,
                                            color: homeWon ? Colors.green : (tie ? Colors.blue : Colors.black),
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          "Guest Team: ${record['guest_team']}",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: !homeWon && !tie ? Colors.green : Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.orange.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      "${record['home_score']} - ${record['guest_score']}",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.deepOrange,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Divider(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Quarter: ${record['quater_number'] + 1}/${record['total_quarters']}",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    "Quarter Length: ${record['quater_minutes']} min",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Date: ${record['formatted_date']}",
                                style: TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton.icon(
                                    onPressed: () => _deleteRecord(recordId),
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    label: Text("Delete", style: TextStyle(color: Colors.red)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 20), // For some bottom padding
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Scroll to top when pressed
          _scrollController.animateTo(
            0,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        },
        child: Icon(Icons.arrow_upward),
        backgroundColor: Colors.orange,
      ),
    );
  }
}