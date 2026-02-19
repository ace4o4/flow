import 'package:flutter/material.dart';
import 'package:forgeflow/presentation/widgets/liquid_glass_card.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Container(color: Colors.black),
          const Center(
              child: LiquidGlassCard(
                  child: Text("Reports Screen (Coming Soon)",
                      style: TextStyle(color: Colors.white)))),
        ],
      ),
    );
  }
}
