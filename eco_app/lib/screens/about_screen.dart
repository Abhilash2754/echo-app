import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5FAF7),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0B3D2E),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'About Eco App',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            const SizedBox(height: 20),

            // App Icon
            Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                color: Color(0xFF168A55),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.eco,
                color: Colors.white,
                size: 60,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Eco App',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0B3D2E),
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Report. Protect. Improve.',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 30),

            // About Card
            _AboutCard(
              icon: Icons.info_outline,
              title: 'About the App',
              description:
                  'Eco App is an environmental complaint platform '
                  'that allows users to report environmental problems '
                  'in their community and track their complaints.',
            ),

            // Purpose Card
            _AboutCard(
              icon: Icons.public,
              title: 'Our Purpose',
              description:
                  'The purpose of Eco App is to encourage citizens '
                  'to report environmental issues and contribute '
                  'towards a cleaner and healthier environment.',
            ),

            // Features Card
            _AboutCard(
              icon: Icons.star_outline,
              title: 'Key Features',
              description:
                  '• Submit environmental complaints\n'
                  '• Track complaint status\n'
                  '• View submitted complaints\n'
                  '• Receive notifications\n'
                  '• Manage your profile',
            ),

            const SizedBox(height: 15),

            const Text(
              'Version 1.0.0',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 13,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Together for a cleaner environment 🌱',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF168A55),
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}


// About Card
class _AboutCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _AboutCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Container(
            width: 45,
            height: 45,
            decoration: const BoxDecoration(
              color: Color(0xFFE4F4EC),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: const Color(0xFF168A55),
              size: 25,
            ),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [

                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0B3D2E),
                  ),
                ),

                const SizedBox(height: 7),

                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}