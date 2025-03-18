import 'package:flutter/material.dart';

class BasketballRulesScreen extends StatelessWidget {
  const BasketballRulesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('กฎการนับคะแนนบาสเก็ตบอล',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.orange,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.orange, Colors.orange],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header image
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                
              ),
              const SizedBox(height: 24),
              
              // Title
              const Center(
                child: Text(
                  'กฎการนับคะแนน',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              // Scoring rules cards
              _buildScoringRuleCard(
                '1. ลูกโทษ (Free Throw)',
                'การยิงลูกโทษสำเร็จจะได้ 1 คะแนน เกิดจากการถูกฟาวล์ขณะยิงหรือทีมคู่แข่งทำฟาวล์เกินโควต้า',
                'assets/images/free_throw.jpg',
              ),
              
              _buildScoringRuleCard(
                '2. การยิงในเขต 2 คะแนน (2-Point Field Goal)',
                'การยิงประตูสำเร็จภายในเส้นโค้ง 3 คะแนนจะได้รับ 2 คะแนน',
                                'assets/images/free_throw.jpg',

                
              ),
              
              _buildScoringRuleCard(
                '3. การยิงนอกเขต 3 คะแนน (3-Point Field Goal)',
                'การยิงประตูสำเร็จจากนอกเส้นโค้ง 3 คะแนนจะได้รับ 3 คะแนน ระยะห่างจากห่วงประมาณ 6.75 เมตร (FIBA) หรือ 7.24 เมตร (NBA)',
                                'assets/images/free_throw.jpg',

              ),
              
              const SizedBox(height: 30),
              
              // Court diagram
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'แผนผังสนามบาสเก็ตบอลและเขตคะแนน',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrange,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        'assets/images/basketball_court_diagram.webp',
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '• เส้นสีแดง: เส้นเขต 3 คะแนน\n• พื้นที่สีฟ้า: เขต 2 คะแนน\n• เส้นลูกโทษ: ระยะห่างจากเส้นหลัง 4.6 เมตร',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 30),
              
              // Additional rules
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'กฎเพิ่มเติมเกี่ยวกับการนับคะแนน',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrange,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      '• ผู้เล่นต้องปล่อยลูกออกจากมือก่อนที่นาฬิกาแข่งขันจะหมดเวลาเพื่อให้คะแนนนั้นนับ\n'
                      '• หากผู้เล่นยิงลูกแล้วถูกฝ่ายตรงข้ามกระทบลูกหลังจากลูกสัมผัสแป้นแล้ว จะถือว่าเป็นการยิงสำเร็จ (Goaltending)\n'
                      '• ในกรณีที่ผู้เล่นทำแต้มให้ฝ่ายตรงข้ามโดยไม่ได้ตั้งใจ (Own Goal) จะนับคะแนนให้กับผู้เล่นฝ่ายตรงข้ามที่ถือลูกล่าสุด\n'
                      '• การยิงประตูในช่วงต่อเวลาพิเศษ (Overtime) ใช้กฎเดียวกับเวลาปกติ',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScoringRuleCard(String title, String description, String imagePath) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),

          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}