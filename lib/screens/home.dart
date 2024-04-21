import 'package:flutter/material.dart';
import 'package:camara_dos_deputados/routes/router.dart' as routes;

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  Widget _buildOption(
      BuildContext context, String title, IconData icon, Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 200,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.blue,
              size: 80,
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: const TextStyle(
                color: Colors.blue,
                fontSize: 28,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Câmara dos Deputados',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildOption(
            context,
            'Deputados',
            Icons.people,
            () {
              Navigator.pushNamed(context, routes.parliamentarians);
            },
          ),
          _buildOption(
            context,
            'Comissões',
            Icons.leaderboard,
            () {
              Navigator.pushNamed(context, routes.commissions);
            },
          ),
        ],
      ),
    );
  }
}
