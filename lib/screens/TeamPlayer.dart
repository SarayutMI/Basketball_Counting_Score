import 'package:flutter/material.dart';

class PlayerPositionInfoPage extends StatelessWidget {
  const PlayerPositionInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ข้อมูลตำแหน่งผู้เล่น'),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle('ตำแหน่งผู้เล่นในบาสเกตบอล'),
            _buildDescription(
              'บาสเกตบอลมี 5 ตำแหน่งหลัก โดยแต่ละตำแหน่งมีบทบาทและหน้าที่แตกต่างกันออกไป',
            ),
            const SizedBox(height: 16.0),
            _buildPositionCard(
              'ตำแหน่งในสนาม',
              'Position',
              'assets/images/PLACEHOLDER.png',
            ),
            _buildPositionCard(
              'พอยต์การ์ด (Point Guard - PG)',
              'ทำหน้าที่ควบคุมเกม, จ่ายบอล และสร้างโอกาสให้เพื่อนร่วมทีม',
              'assets/images/POINT_GARD.png',
            ),
            _buildPositionCard(
              'ชูตติ้งการ์ด (Shooting Guard - SG)',
              'เน้นการทำแต้ม โดยเฉพาะการยิงจากระยะไกล',
              'assets/images/SHOOTING.png',
            ),
            _buildPositionCard(
              'สมอลฟอร์เวิร์ด (Small Forward - SF)',
              'มีบทบาททั้งเกมรุกและรับ สามารถทำแต้มและป้องกันได้ดี',
              'assets/images/SMALLFORWARD.png',
            ),
            _buildPositionCard(
              'พาวเวอร์ฟอร์เวิร์ด (Power Forward - PF)',
              'เน้นการเล่นใกล้ห่วง ป้องกันและดึงรีบาวด์',
              'assets/images/POWERFORWARD.png',
            ),
            _buildPositionCard(
              'เซ็นเตอร์ (Center - C)',
              'เป็นผู้เล่นที่ตัวใหญ่ที่สุด คุมพื้นที่ใต้แป้น',
              'assets/images/CENTER.png',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildDescription(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 16, color: Colors.black87),
    );
  }

  Widget _buildPositionCard(
    String title,
    String description,
    String imagePath,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(12.0),
            ),
            child: Image.asset(
              imagePath,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 180,
                  width: double.infinity,
                  color: Colors.grey[300],
                  child: const Icon(
                    Icons.image_not_supported,
                    size: 50,
                    color: Colors.grey,
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  description,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
