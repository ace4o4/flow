import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:forgeflow/domain/entities/routine_entity.dart';
import 'package:forgeflow/presentation/blocs/routine_provider.dart';
import 'package:forgeflow/presentation/widgets/liquid_glass_card.dart';

class BuildRoutineScreen extends ConsumerStatefulWidget {
  const BuildRoutineScreen({super.key});

  @override
  ConsumerState<BuildRoutineScreen> createState() => _BuildRoutineScreenState();
}

class _BuildRoutineScreenState extends ConsumerState<BuildRoutineScreen> {
  final _textController = TextEditingController();
  final _uuid = const Uuid();

  void _saveRoutine() {
    if (_textController.text.isEmpty) return;

    final newRoutine = RoutineEntity(
      id: _uuid.v4(),
      name: _textController.text,
      blocks: [], // Empty blocks for now
      isActive: true,
    );

    ref.read(routineListProvider.notifier).addRoutine(newRoutine);
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Build Routine'),
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Color(0xFF000000), Color(0xFF1A1A1A)],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LiquidGlassCard(
                  child: TextField(
                    controller: _textController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'Routine Name (e.g., Morning Drill)',
                      hintStyle: TextStyle(color: Colors.white54),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _saveRoutine,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyanAccent,
                    foregroundColor: Colors.black,
                  ),
                  child: const Text('Create Routine'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
