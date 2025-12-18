import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  void onNavTap(int index) {
    setState(() {
      selectedIndex = index;
    });

    switch (index) {
      case 0:
        // Home tetap di Home
        break;
      case 1:
        // Calendar
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Calendar belum dibuat")));
        break;
      case 2:
        // Attendance
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Attendance belum dibuat")),
        );
        break;
      case 3:
        // Leave Request
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Leave Request belum dibuat")),
        );
        break;
      case 4:
        context.push('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    const brownColor = Color(0xFF623B00); // Sesuai Figma

    return Scaffold(
      backgroundColor: Colors.white,

      /// ================================
      /// APPBAR SESUAI Figma
      /// ================================
      appBar: AppBar(
        backgroundColor: brownColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 55,
      ),

      /// ================================
      /// BODY – Masih Kosong Placeholder
      /// ================================
      body: const Center(
        child: Text(
          "Home Placeholder",
          style: TextStyle(fontSize: 20, color: Colors.grey),
        ),
      ),

      /// ================================
      /// BOTTOM NAVIGATION BAR
      /// ================================
      bottomNavigationBar: Container(
        // height: 70,
        decoration: const BoxDecoration(
          color: brownColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: onNavTap,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: true,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: "Calendar",
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.mail),
              label: "Attendance",
            ),

            /// Leave Request + Badge
            BottomNavigationBarItem(
              icon: Stack(
                clipBehavior: Clip.none,
                children: const [
                  Icon(Icons.favorite),
                  Positioned(
                    right: -6,
                    top: -4,
                    child: CircleAvatar(
                      radius: 9,
                      backgroundColor: Colors.red,
                      child: Text(
                        "2",
                        style: TextStyle(fontSize: 11, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              label: "Leave\nRequest",
            ),

            const BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }
}
