import 'package:flutter/material.dart';

class BasketballNews extends StatelessWidget {
  const BasketballNews({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Basketball News'),
        backgroundColor: Colors.orange,
        
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildNewsCard(
            title: 'ทีมชาติไทยคว้าแชมป์การแข่งขัน FIBA Asia Cup 2025 รอบคัดเลือก',
            content: 'ทีมชาติไทยสร้างประวัติศาสตร์คว้าแชมป์รายการ FIBA Asia Cup 2025 รอบคัดเลือก หลังเอาชนะคู่แข่งในรอบชิงชนะเลิศด้วยสกอร์ 78-72 ทำให้ได้สิทธิ์เข้าร่วมการแข่งขันรอบสุดท้ายอย่างเป็นทางการ',
            imagePath: 'assets/images/THwiner.jpg',
            date: '18 มีนาคม 2025',
          ),
          _buildNewsCard(
            title: 'NBA อัปเดต: ฟินิกซ์ ซันส์ ขึ้นนำในตารางฝั่งตะวันตก',
            content: 'ฟินิกซ์ ซันส์ ขึ้นนำในตารางฝั่งตะวันตกของ NBA หลังชนะ 5 เกมติดต่อกัน ล่าสุดเอาชนะ ลอสแองเจลิส เลเกอร์ส 118-105 ทำให้มีสถิติเป็น 45-17 แซงหน้า เดนเวอร์ นักเก็ตส์ ที่มีสถิติ 44-18',
            imagePath: 'assets/images/NBAPHINIX.jpg',
            date: '17 มีนาคม 2025',
          ),
          _buildNewsCard(
            title: 'ดราฟท์ NBA 2025 มีแนวโน้มที่น่าสนใจ',
            content: 'นักวิเคราะห์คาดการณ์ว่า ดราฟท์ NBA ปี 2025 จะมีผู้เล่นที่มีศักยภาพสูงหลายคน โดยเฉพาะตำแหน่งการ์ดและฟอร์เวิร์ด ทีมที่ได้สิทธิ์เลือกอันดับต้นๆ จะมีโอกาสได้ผู้เล่นที่สามารถเปลี่ยนแปลงเกมได้ทันที',
            imagePath: 'assets/images/2025graph.webp',
            date: '16 มีนาคม 2025',
          ),
          _buildNewsCard( 
            title: 'การแข่งขัน FIBA World Cup 2026 จะจัดที่ประเทศญี่ปุ่น',
            content: 'FIBA ประกาศให้ประเทศญี่ปุ่นเป็นเจ้าภาพจัดการแข่งขัน FIBA World Cup 2026 ซึ่งจะจัดขึ้นที่กรุงโตเกียวและโอซาก้า การแข่งขันครั้งนี้จะมีทีมเข้าร่วมทั้งหมด 32 ทีมจากทั่วโลก',
            imagePath: 'assets/images/wordcup.webp',
            date: '15 มีนาคม 2025',
          ),
          _buildNewsCard(
            title: 'ซูเปอร์สตาร์ NBA ประกาศเกษียณหลังจบฤดูกาลนี้',
            content: 'ซูเปอร์สตาร์ระดับตำนานของ NBA ประกาศเกษียณอย่างเป็นทางการหลังจบฤดูกาลนี้ หลังจากค้าแข้งมายาวนานกว่า 18 ปี คว้าแชมป์ 4 สมัย และได้รับรางวัล MVP 2 ครั้ง ถือเป็นการปิดฉากอาชีพที่ยิ่งใหญ่',
            imagePath: 'assets/images/superstart.jpeg',
            date: '14 มีนาคม 2025',
          ),
        ],
      ),
    );
  }

  Widget _buildNewsCard({
    required String title,
    required String content,
    required String imagePath,
    required String date,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12.0)),
            child: Image.asset(
              imagePath,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              // สามารถใช้ NetworkImage แทนได้
              // Image.network(imageUrl, height: 200, width: double.infinity, fit: BoxFit.cover),
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 200,
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
                  content,
                  style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                ),
                const SizedBox(height: 12.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      date,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // นำไปสู่หน้ารายละเอียดข่าว
                      },
                      child: const Text('อ่านเพิ่มเติม'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}