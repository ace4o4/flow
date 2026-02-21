import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:forgeflow/core/config/app_theme.dart';
import 'package:forgeflow/domain/entities/block_entity.dart';
import 'package:forgeflow/presentation/blocs/routine_provider.dart';
import 'package:forgeflow/presentation/blocs/track_provider.dart';
import 'package:forgeflow/presentation/widgets/glass_card.dart';

class TrackScreen extends ConsumerWidget {
  const TrackScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final routineState = ref.watch(routineListProvider);
    final trackState = ref.watch(todayTrackRecordsProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
          child: routineState.when(
        data: (routines) {
          final pending = <_TI>[];
          final done = <_TI>[];
          for (final r in routines) {
            if (!r.isActive) continue;
            for (final b in r.blocks) {
              final c =
                  trackState.value?.any((t) => t.blockId == b.id) ?? false;
              (c ? done : pending)
                  .add(_TI(block: b, routineId: r.id, routineName: r.name));
            }
          }
          final total = pending.length + done.length;
          final pct = total > 0 ? done.length / total : 0.0;
          final minRemain =
              pending.fold<int>(0, (s, t) => s + t.block.duration.inMinutes);

          return ListView(
              padding: const EdgeInsets.fromLTRB(18, 14, 18, 100),
              children: [
                // Header
                Text('Track',
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: cs.onSurface,
                        letterSpacing: -1.2)),
                const SizedBox(height: 2),
                Text(DateFormat('EEEE, MMMM d').format(DateTime.now()),
                    style: TextStyle(
                        fontSize: 13,
                        color:
                            isDark ? AppTheme.darkText3 : AppTheme.lightText3)),
                const SizedBox(height: 20),

                // Stat cards row
                Row(children: [
                  Expanded(
                      child: GlassCard(
                    glowColor: AppTheme.accent,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('📊', style: TextStyle(fontSize: 22)),
                          const SizedBox(height: 8),
                          Text('${(pct * 100).toInt()}%',
                              style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w800,
                                  color: cs.onSurface,
                                  letterSpacing: -1)),
                          const SizedBox(height: 2),
                          Text('completed',
                              style: TextStyle(
                                  fontSize: 11,
                                  color:
                                      AppTheme.accent.withValues(alpha: 0.5))),
                          const SizedBox(height: 10),
                          _GlowBar(
                              value: pct,
                              color: pct == 1.0
                                  ? AppTheme.success
                                  : AppTheme.accent),
                        ]),
                  )),
                  const SizedBox(width: 12),
                  Expanded(
                      child: GlassCard(
                    glowColor: AppTheme.accentAlt,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('⏱️', style: TextStyle(fontSize: 22)),
                          const SizedBox(height: 8),
                          Text('$minRemain',
                              style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w800,
                                  color: cs.onSurface,
                                  letterSpacing: -1)),
                          const SizedBox(height: 2),
                          Text('min remaining',
                              style: TextStyle(
                                  fontSize: 11,
                                  color: AppTheme.accentAlt
                                      .withValues(alpha: 0.5))),
                          const SizedBox(height: 10),
                          Row(children: [
                            Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    color: (pct == 1
                                            ? AppTheme.success
                                            : AppTheme.accentAlt)
                                        .withValues(alpha: 0.1)),
                                child: Text(
                                    pct == 1
                                        ? '🎉 Done!'
                                        : '${pending.length} left',
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: pct == 1
                                            ? AppTheme.success
                                            : AppTheme.accentAlt))),
                          ]),
                        ]),
                  )),
                ])
                    .animate()
                    .fadeIn(duration: 350.ms)
                    .slideY(begin: 0.04, end: 0),
                const SizedBox(height: 22),

                // Pending
                if (pending.isNotEmpty) ...[
                  _Section('PENDING', pending.length, isDark),
                  const SizedBox(height: 8),
                  ...pending.asMap().entries.map((e) =>
                      _BlockTile(item: e.value, idx: e.key, isDone: false)),
                ],
                if (done.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _Section('COMPLETED', done.length, isDark),
                  const SizedBox(height: 8),
                  ...done.asMap().entries.map((e) => _BlockTile(
                      item: e.value,
                      idx: pending.length + e.key,
                      isDone: true)),
                ],
                if (total == 0)
                  Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: Center(
                          child: Text('No blocks to track',
                              style: TextStyle(
                                  color: isDark
                                      ? AppTheme.darkText3
                                      : AppTheme.lightText3)))),
              ]);
        },
        loading: () => Center(
            child: CircularProgressIndicator(
                color: AppTheme.accent, strokeWidth: 2)),
        error: (e, _) => Center(child: Text('$e')),
      )),
    );
  }
}

class _GlowBar extends StatelessWidget {
  final double value;
  final Color color;
  const _GlowBar({required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: 5,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder),
      child: FractionallySizedBox(
        widthFactor: value.clamp(0, 1),
        alignment: Alignment.centerLeft,
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: color,
                boxShadow: [
              BoxShadow(color: color.withValues(alpha: 0.3), blurRadius: 6)
            ])),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final int count;
  final bool isDark;
  const _Section(this.title, this.count, this.isDark);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(left: 2),
        child: Row(children: [
          Text(title,
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                  color: isDark ? AppTheme.darkText3 : AppTheme.lightText3)),
          const SizedBox(width: 6),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: AppTheme.accent.withValues(alpha: 0.08)),
              child: Text('$count',
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.accent))),
        ]),
      );
}

class _TI {
  final BlockEntity block;
  final String routineId, routineName;
  _TI(
      {required this.block,
      required this.routineId,
      required this.routineName});
}

class _BlockTile extends ConsumerWidget {
  final _TI item;
  final int idx;
  final bool isDone;
  const _BlockTile(
      {required this.item, required this.idx, required this.isDone});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final blockColor = Color(item.block.colorValue);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GlassCard(
        compact: true,
        glowColor: isDone ? null : blockColor,
        onTap: isDone
            ? null
            : () async {
                final xp = await ref
                    .read(todayTrackRecordsProvider.notifier)
                    .checkIn(block: item.block, routineId: item.routineId);
                ref
                    .read(routineListProvider.notifier)
                    .toggleAndSaveBlock(item.routineId, item.block.id);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: AppTheme.darkCard,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      content: Row(children: [
                        Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppTheme.accent.withValues(alpha: 0.15)),
                            child: Icon(Icons.bolt_rounded,
                                color: AppTheme.accent, size: 14)),
                        const SizedBox(width: 8),
                        Text('+$xp XP',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700)),
                      ]),
                      duration: const Duration(milliseconds: 1200)));
                }
              },
        child: Row(children: [
          // Icon box
          Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(11),
                color: blockColor.withValues(alpha: isDone ? 0.04 : 0.08),
                border: Border.all(
                    color: blockColor.withValues(alpha: isDone ? 0.05 : 0.15)),
                boxShadow: isDone
                    ? []
                    : [
                        BoxShadow(
                            color: blockColor.withValues(alpha: 0.08),
                            blurRadius: 8)
                      ],
              ),
              child: Icon(
                  item.block.iconCodePoint != null
                      ? IconData(item.block.iconCodePoint!,
                          fontFamily: 'MaterialIcons')
                      : Icons.check_circle_outline,
                  color: blockColor.withValues(alpha: isDone ? 0.15 : 0.5),
                  size: 18)),
          const SizedBox(width: 12),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(item.block.title,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: isDone
                            ? (isDark
                                ? AppTheme.darkText3
                                : AppTheme.lightText3)
                            : cs.onSurface,
                        decoration:
                            isDone ? TextDecoration.lineThrough : null)),
                Text('${item.block.duration.inMinutes}m · ${item.routineName}',
                    style: TextStyle(
                        fontSize: 11,
                        color:
                            isDark ? AppTheme.darkText3 : AppTheme.lightText3)),
              ])),
          if (isDone)
            Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.success.withValues(alpha: 0.12)),
                child: Icon(Icons.check_rounded,
                    color: AppTheme.success, size: 14))
          else
            Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color:
                            isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
                        width: 2))),
        ]),
      ),
    ).animate().fadeIn(delay: (35 * idx).ms, duration: 250.ms);
  }
}
