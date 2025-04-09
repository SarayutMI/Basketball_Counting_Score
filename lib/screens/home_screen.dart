import 'package:flutter/material.dart';
import 'basketball_screen.dart';
import 'game_records_screen.dart';
import 'RuleScoring.dart';
import 'News.dart';
import 'TeamPlayer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool _isDarkMode = false; // Variable for tracking dark mode

  // Function to handle navigation
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate to respective screens based on index
    if (index == 0) {
      // Stay on Home Screen
      print("Basketball screen");
    } else if (index == 1) {
      // Toggle Dark Mode instead of navigating
      setState(() {
        _isDarkMode = !_isDarkMode;
      });
    } else if (index == 2) {
      // Navigate to Statistics Screen (GameRecordsScreen)
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => GameRecordsScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: _isDarkMode ? Colors.grey[900] : Colors.white,
          // Title will be aligned to the left
          title: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'SPORT SCORE',
              style: TextStyle(
                color: _isDarkMode ? Colors.white : Colors.black,
                fontSize: 35,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          actions: [
            
          ],
        ),

        body: SafeArea(
          child: SingleChildScrollView( // Added for scrollable layout
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 16),
                
                // Basketball Card
                _buildSportCard(
                  'Basketball', 
                  'assets/images/Basketball.png',
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BasketballScreen()),
                    );
                  }
                ),

                SizedBox(height: 16),

                // Table Tennis Card
                _buildSportCard(
                  'Rules &Scoring', 
                  'assets/images/RulesScoring.png',
                  () {
                      Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BasketballRulesScreen()),
                    );
                  }
                ),

                SizedBox(height: 16),

                // Manual Card
                _buildSportCard(
                  'News', 
                  'assets/images/NEWS.png',
                  () {
                       Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BasketballNews()),
                    );
                  }
                ),
                
                // Add more sport cards here if needed
                SizedBox(height: 16),
                
                _buildSportCard(
                  'Team Player', 
                  'assets/images/TeamPlayer.png',
                  () {
                       Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PlayerPositionInfoPage()),
                    );
                  }
                ),
                
                
                SizedBox(height: 16),
              ],
            ),
          ),
        ),

        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.sports_basketball),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(_isDarkMode ? Icons.light_mode : Icons.dark_mode),
              label: _isDarkMode ? 'Light Mode' : 'Dark Mode',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: 'Statistics',
            ),
          ],
        ),
      ),
    );
  }
  
  // Helper method to build sport cards
  Widget _buildSportCard(String title, String imagePath, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GestureDetector(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                imagePath,
                width: double.infinity,
                height: 100,
                fit: BoxFit.cover,
              ),
              Positioned(
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
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