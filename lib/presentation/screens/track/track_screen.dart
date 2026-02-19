import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forgeflow/presentation/blocs/routine_provider.dart';
import 'package:forgeflow/presentation/widgets/liquid_glass_card.dart';
import 'package:forgeflow/core/utils/gamification_service.dart';

class TrackScreen extends ConsumerWidget {
  const TrackScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routineState = ref.watch(routineListProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Track Progress'),
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF0F0F0F), Color(0xFF1E1E1E)],
              ),
            ),
          ),
          routineState.when(
            data: (routines) {
              // Flatten blocks for demo purposes
              final allBlocks = routines.expand((r) => r.blocks).toList();

              if (allBlocks.isEmpty) {
                return const Center(
                    child: Text("No active blocks today.",
                        style: TextStyle(color: Colors.white)));
              }

              return ListView.builder(
                padding: const EdgeInsets.only(top: 100, bottom: 100),
                itemCount: allBlocks.length,
                itemBuilder: (context, index) {
                  final block = allBlocks[index];
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: LiquidGlassCard(
                      child: ListTile(
                        title: Text(block.title,
                            style: const TextStyle(color: Colors.white)),
                        subtitle: Text('${block.duration.inMinutes} mins',
                            style: const TextStyle(color: Colors.white70)),
                        trailing: Checkbox(
                          value: block.isCompleted,
                          onChanged: (bool? value) {
                            if (value == true) {
                              // Calculate XP
                              final xp = GamificationService()
                                  .calculateXP(block.duration.inMinutes, false);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text('Block Completed! +$xp XP')),
                              );
                              // TODO: Update block status in provider
                            }
                          },
                          fillColor: WidgetStateProperty.all(Colors.cyanAccent),
                          checkColor: Colors.black,
                        ),
                      ),
                    ),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, s) => Center(child: Text('Error: $e')),
          ),
        ],
      ),
    );
  }
}
