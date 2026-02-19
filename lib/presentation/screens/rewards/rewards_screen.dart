import 'package:flutter/material.dart';
import 'package:forgeflow/presentation/widgets/liquid_glass_card.dart';

class RewardsScreen extends StatelessWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Container(color: Colors.black),
          const Center(
              child: LiquidGlassCard(
                  child: Text("Rewards Screen (Coming Soon)",
                      style: TextStyle(color: Colors.white)))),
        ],
      ),
    );
  }
}
