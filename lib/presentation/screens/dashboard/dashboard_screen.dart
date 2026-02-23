import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:forgeflow/core/config/app_theme.dart';
import 'package:forgeflow/presentation/blocs/routine_provider.dart';
import 'package:forgeflow/presentation/blocs/track_provider.dart';
import 'package:forgeflow/presentation/blocs/user_profile_provider.dart';
import 'package:forgeflow/presentation/blocs/theme_provider.dart';
import 'package:forgeflow/presentation/widgets/glass_card.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final routineState = ref.watch(routineListProvider);
    final profileState = ref.watch(userProfileProvider);
    final trackState = ref.watch(todayTrackRecordsProvider);

    final screenWidth = MediaQuery.of(context).size.width;
    final scale = (screenWidth / 375).clamp(0.9, 1.1);

    int totalBlocks = 0, doneBlocks = 0;
    final allBlocks = <_BI>[];
    routineState.whenData((routines) {
      for (final r in routines) {
        if (!r.isActive) continue;
        for (final b in r.blocks) {
          totalBlocks++;
          final checked =
              trackState.value?.any((t) => t.blockId == b.id) ?? false;
          if (checked) doneBlocks++;
          allBlocks.add(_BI(
              block: b, routineId: r.id, routineName: r.name, done: checked));
        }
      }
    });

    allBlocks.sort((a, b) {
      if (a.block.startTime == null && b.block.startTime == null) return 0;
      if (a.block.startTime == null) return 1;
      if (b.block.startTime == null) return -1;
      return (a.block.startTime!.hour * 60 + a.block.startTime!.minute)
          .compareTo(b.block.startTime!.hour * 60 + b.block.startTime!.minute);
    });

    final pct = totalBlocks > 0 ? doneBlocks / totalBlocks : 0.0;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
              children: [
                // ── Top Bar ──
                Row(
                  children: [
                    Text(
                      'ForgeFlow',
                      style: TextStyle(
                        fontSize: 24 * scale,
                        fontWeight: FontWeight.w800,
                        color: cs.onSurface,
                        letterSpacing: -1.0,
                      ),
                    ),
                    const Spacer(),
                    _GlowIconBtn(
                      icon: Icons.phonelink_lock_rounded,
                      onTap: () => context.push('/detox'),
                      color: isDark ? AppTheme.darkText2 : AppTheme.lightText2,
                    ),
                    const SizedBox(width: 8),
                    _GlowIconBtn(
                      icon: isDark
                          ? Icons.light_mode_rounded
                          : Icons.dark_mode_rounded,
                      onTap: () =>
                          ref.read(themeModeProvider.notifier).toggle(),
                      color: isDark ? AppTheme.darkText2 : AppTheme.lightText2,
                    ),
                  ],
                ).animate().fadeIn(duration: 300.ms),
                const SizedBox(height: 16),

                // ── Bento Grid Top Row ──
                Row(
                  children: [
                    // Card 1: Date Block
                    Expanded(
                      child: GlassCard(
                        padding: const EdgeInsets.symmetric(
                            vertical: 18, horizontal: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              DateFormat('E MMM')
                                  .format(DateTime.now())
                                  .toUpperCase(),
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.0,
                                color: isDark
                                    ? AppTheme.darkText2
                                    : AppTheme.lightText2,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              DateFormat('d').format(DateTime.now()),
                              style: TextStyle(
                                fontSize: 44 * scale,
                                fontWeight: FontWeight.w800,
                                height: 1.0,
                                color: cs.onSurface,
                                letterSpacing: -1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Card 2: Progress/Stats Block
                    Expanded(
                      child: GlassCard(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Day',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: cs.onSurface,
                                  ),
                                ),
                                Text(
                                  '${(pct * 100).toInt()}%',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: isDark
                                        ? AppTheme.darkText2
                                        : AppTheme.lightText2,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Container(
                              height: 10,
                              width: double.infinity,
                              decoration: AppTheme.neoCard(
                                isDark: isDark,
                                isInset: true,
                                radius: 5,
                              ),
                              child: FractionallySizedBox(
                                alignment: Alignment.centerLeft,
                                widthFactor: pct.clamp(0.0, 1.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: isDark
                                        ? AppTheme.darkText1
                                        : AppTheme.lightText1,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            profileState.when(
                              data: (p) => Row(
                                children: [
                                  const Icon(
                                      Icons.local_fire_department_rounded,
                                      size: 14,
                                      color: AppTheme.orange),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${p.currentStreak} Streak',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: isDark
                                          ? AppTheme.darkText2
                                          : AppTheme.lightText2,
                                    ),
                                  ),
                                ],
                              ),
                              loading: () => const SizedBox(height: 14),
                              error: (_, __) => const SizedBox(height: 14),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                )
                    .animate()
                    .fadeIn(delay: 100.ms, duration: 400.ms)
                    .slideY(begin: 0.04, end: 0),

                const SizedBox(height: 12),

                // Card 3: Level Progress
                profileState.when(
                  data: (p) => GlassCard(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          width: 44 * scale,
                          height: 44 * scale,
                          decoration: AppTheme.neoCard(
                            isDark: isDark,
                            radius: 22 * scale,
                          ),
                          child: Center(
                            child: Text(
                              '${p.currentLevel}',
                              style: TextStyle(
                                fontSize: 16 * scale,
                                fontWeight: FontWeight.w800,
                                color: cs.onSurface,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Level Progress',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                      color: cs.onSurface,
                                    ),
                                  ),
                                  Text(
                                    '${(p.levelProgress * 100).toInt()}%',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: isDark
                                          ? AppTheme.darkText2
                                          : AppTheme.lightText2,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Container(
                                height: 8,
                                width: double.infinity,
                                decoration: AppTheme.neoCard(
                                  isDark: isDark,
                                  isInset: true,
                                  radius: 4,
                                ),
                                child: FractionallySizedBox(
                                  alignment: Alignment.centerLeft,
                                  widthFactor: p.levelProgress.clamp(0.0, 1.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      color: AppTheme.accent,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 200.ms, duration: 350.ms),
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                ),

                const SizedBox(height: 24),

                // ── Schedule Section ──
                Row(
                  children: [
                    Text(
                      'Schedule',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: cs.onSurface,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: AppTheme.accent.withValues(alpha: 0.1),
                      ),
                      child: Text(
                        '${allBlocks.length}',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.accent,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                if (allBlocks.isEmpty)
                  GlassCard(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.add_circle_outline_rounded,
                            size: 32,
                            color: isDark
                                ? AppTheme.darkText3
                                : AppTheme.lightText3,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'No routines yet',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? AppTheme.darkText3
                                  : AppTheme.lightText3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ).animate().fadeIn(duration: 400.ms),

                ...allBlocks.asMap().entries.map((e) {
                  final item = e.value;
                  final i = e.key;
                  final blockColor = Color(item.block.colorValue);

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Dismissible(
                      key: ValueKey('${item.routineId}_${item.block.id}'),
                      direction: item.done
                          ? DismissDirection.none
                          : DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 16),
                        decoration: BoxDecoration(
                          color: AppTheme.error.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppTheme.error.withValues(alpha: 0.3),
                          ),
                        ),
                        child: const Icon(
                          Icons.delete_outline_rounded,
                          color: AppTheme.error,
                          size: 24,
                        ),
                      ),
                      onDismissed: (_) {
                        ref
                            .read(routineListProvider.notifier)
                            .deleteBlock(item.routineId, item.block.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor:
                                isDark ? AppTheme.darkCard : AppTheme.lightCard,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            content: Text(
                              'Task removed',
                              style: TextStyle(
                                color: cs.onSurface,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      child: GlassCard(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 12),
                        glowColor: item.done ? null : blockColor,
                        onTap: () async {
                          if (item.done) {
                            await ref
                                .read(todayTrackRecordsProvider.notifier)
                                .undoCheckIn(blockId: item.block.id);
                            ref
                                .read(routineListProvider.notifier)
                                .toggleAndSaveBlock(
                                    item.routineId, item.block.id);
                          } else {
                            final xp = await ref
                                .read(todayTrackRecordsProvider.notifier)
                                .checkIn(
                                    block: item.block,
                                    routineId: item.routineId);
                            ref
                                .read(routineListProvider.notifier)
                                .toggleAndSaveBlock(
                                    item.routineId, item.block.id);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: AppTheme.darkCard,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  content: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppTheme.accent
                                              .withValues(alpha: 0.15),
                                        ),
                                        child: const Icon(
                                          Icons.bolt_rounded,
                                          color: AppTheme.accent,
                                          size: 16,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        '+$xp XP',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                  duration: const Duration(milliseconds: 1200),
                                ),
                              );
                            }
                          }
                        },
                        child: Row(
                          children: [
                            // Time
                            SizedBox(
                              width: 38,
                              child: Text(
                                item.block.startTime != null
                                    ? '${item.block.startTime!.hour.toString().padLeft(2, '0')}:${item.block.startTime!.minute.toString().padLeft(2, '0')}'
                                    : '—',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? AppTheme.darkText3
                                      : AppTheme.lightText3,
                                  fontFeatures: const [
                                    FontFeature.tabularFigures()
                                  ],
                                ),
                              ),
                            ),
                            // Glowing dot
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color:
                                    item.done ? AppTheme.success : blockColor,
                                boxShadow: item.done
                                    ? []
                                    : [
                                        BoxShadow(
                                          color:
                                              blockColor.withValues(alpha: 0.4),
                                          blurRadius: 6,
                                        ),
                                      ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.block.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                      color: item.done
                                          ? (isDark
                                              ? AppTheme.darkText3
                                              : AppTheme.lightText3)
                                          : cs.onSurface,
                                      decoration: item.done
                                          ? TextDecoration.lineThrough
                                          : null,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${item.block.duration.inMinutes}m · ${item.block.category}',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: isDark
                                          ? AppTheme.darkText3
                                          : AppTheme.lightText3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (!item.done)
                              IconButton(
                                onPressed: () {
                                  ref
                                      .read(routineListProvider.notifier)
                                      .deleteBlock(
                                          item.routineId, item.block.id);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: isDark
                                          ? AppTheme.darkCard
                                          : AppTheme.lightCard,
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      content: Text(
                                        'Task removed',
                                        style: TextStyle(
                                          color: cs.onSurface,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.close_rounded,
                                    color: AppTheme.error, size: 16),
                                style: IconButton.styleFrom(
                                  backgroundColor:
                                      AppTheme.error.withValues(alpha: 0.1),
                                  padding: const EdgeInsets.all(4),
                                  minimumSize: const Size(32, 32),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                              ),
                            if (item.done)
                              Container(
                                margin: const EdgeInsets.only(left: 8),
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color:
                                      AppTheme.success.withValues(alpha: 0.15),
                                ),
                                child: const Icon(
                                  Icons.check_rounded,
                                  color: AppTheme.success,
                                  size: 14,
                                ),
                              )
                            else
                              Container(
                                margin: const EdgeInsets.only(left: 8),
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isDark
                                        ? AppTheme.darkBorder
                                        : AppTheme.lightBorder,
                                    width: 2,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  )
                      .animate()
                      .fadeIn(delay: (250 + 40 * i).ms, duration: 300.ms)
                      .slideY(begin: 0.03, end: 0);
                }),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: SizedBox(
        width: 56,
        height: 56,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppTheme.accent.withValues(alpha: 0.25),
                blurRadius: 16,
                spreadRadius: -2,
              )
            ],
          ),
          child: FloatingActionButton(
            backgroundColor: AppTheme.accent,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            onPressed: () => context.push('/build'),
            child: const Icon(Icons.add_rounded, size: 24),
          ),
        ),
      ),
    );
  }
}

// ── Glow icon button ──
class _GlowIconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color color;

  const _GlowIconBtn({
    required this.icon,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: color.withValues(alpha: 0.08),
          border: Border.all(color: color.withValues(alpha: 0.15)),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.08),
              blurRadius: 12,
            )
          ],
        ),
        child: Icon(icon, color: color.withValues(alpha: 0.7), size: 18),
      ),
    );
  }
}

class _BI {
  final dynamic block;
  final String routineId, routineName;
  final bool done;

  _BI({
    required this.block,
    required this.routineId,
    required this.routineName,
    required this.done,
  });
}
