import 'dart:math';
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
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 100),
          children: [
            // ── Header ──
            Row(children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('ForgeFlow',
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
                            isDark ? AppTheme.darkText3 : AppTheme.lightText3,
                        fontWeight: FontWeight.w500)),
              ]),
              const Spacer(),
              _GlowIconBtn(
                icon:
                    isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                onTap: () => ref.read(themeModeProvider.notifier).toggle(),
                color: AppTheme.accent,
              ),
            ]).animate().fadeIn(duration: 300.ms),
            const SizedBox(height: 22),

            // ── Progress Ring + Stats Row ──
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // Ring card
              Expanded(
                  flex: 5,
                  child: GlassCard(
                    glowColor: AppTheme.accent,
                    child: Column(children: [
                      const SizedBox(height: 6),
                      SizedBox(
                          width: 110,
                          height: 110,
                          child: CustomPaint(
                            painter: _RingPainter(
                                pct,
                                AppTheme.accent,
                                isDark
                                    ? AppTheme.darkBorder
                                    : AppTheme.lightBorder),
                            child: Center(
                                child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                  Text('${(pct * 100).toInt()}%',
                                      style: TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.w800,
                                          color: cs.onSurface,
                                          letterSpacing: -1)),
                                  Text('$doneBlocks/$totalBlocks',
                                      style: TextStyle(
                                          fontSize: 11,
                                          color: isDark
                                              ? AppTheme.darkText3
                                              : AppTheme.lightText3)),
                                ])),
                          )),
                      const SizedBox(height: 10),
                      Text('TODAY',
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.5,
                              color: AppTheme.accent.withValues(alpha: 0.6))),
                    ]),
                  )),
              const SizedBox(width: 12),

              // Stats column
              Expanded(
                  flex: 4,
                  child: profileState.when(
                    data: (p) => Column(children: [
                      _StatChip(
                          emoji: '🔥',
                          value: '${p.currentStreak}',
                          label: 'streak',
                          glowColor: AppTheme.orange),
                      const SizedBox(height: 10),
                      _StatChip(
                          emoji: '⚡',
                          value: '${p.totalXP}',
                          label: 'XP',
                          glowColor: AppTheme.accentAlt),
                      const SizedBox(height: 10),
                      _StatChip(
                          emoji: '🎯',
                          value: 'Lv.${p.currentLevel}',
                          label: '${(p.levelProgress * 100).toInt()}%',
                          glowColor: AppTheme.accent),
                    ]),
                    loading: () => const SizedBox(height: 160),
                    error: (_, __) => const SizedBox(height: 160),
                  )),
            ])
                .animate()
                .fadeIn(delay: 100.ms, duration: 400.ms)
                .slideY(begin: 0.04, end: 0),
            const SizedBox(height: 18),

            // ── Level Progress Bar ──
            profileState.when(
              data: (p) => GlassCard(
                compact: true,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        // Glowing level badge
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(colors: [
                              AppTheme.accent.withValues(alpha: 0.2),
                              AppTheme.accentAlt.withValues(alpha: 0.15)
                            ]),
                            border: Border.all(
                                color: AppTheme.accent.withValues(alpha: 0.3)),
                            boxShadow: [
                              BoxShadow(
                                  color: AppTheme.accent.withValues(alpha: 0.1),
                                  blurRadius: 12)
                            ],
                          ),
                          child: Center(
                              child: Text('${p.currentLevel}',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w800,
                                      color: AppTheme.accent))),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                              Text('Level ${p.currentLevel}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                      color: cs.onSurface)),
                              Text(
                                  '${p.xpForNextLevel - p.totalXP} XP to level ${p.currentLevel + 1}',
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: isDark
                                          ? AppTheme.darkText3
                                          : AppTheme.lightText3)),
                            ])),
                      ]),
                      const SizedBox(height: 12),
                      // Glowing progress bar
                      Container(
                        height: 6,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            color: isDark
                                ? AppTheme.darkBorder
                                : AppTheme.lightBorder),
                        child: FractionallySizedBox(
                          widthFactor: p.levelProgress.clamp(0, 1),
                          alignment: Alignment.centerLeft,
                          child: Container(
                              decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            gradient: const LinearGradient(
                                colors: [AppTheme.accent, AppTheme.accentAlt]),
                            boxShadow: [
                              BoxShadow(
                                  color: AppTheme.accent.withValues(alpha: 0.3),
                                  blurRadius: 8)
                            ],
                          )),
                        ),
                      ),
                    ]),
              ).animate().fadeIn(delay: 200.ms, duration: 350.ms),
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),
            const SizedBox(height: 22),

            // ── Schedule Section ──
            Row(children: [
              Text('Schedule',
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: cs.onSurface,
                      letterSpacing: -0.3)),
              const SizedBox(width: 8),
              Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppTheme.accent.withValues(alpha: 0.1)),
                  child: Text('${allBlocks.length}',
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.accent))),
              const Spacer(),
            ]),
            const SizedBox(height: 12),

            if (allBlocks.isEmpty)
              GlassCard(
                child: Center(
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.add_circle_outline_rounded,
                      size: 36,
                      color: isDark ? AppTheme.darkText3 : AppTheme.lightText3),
                  const SizedBox(height: 8),
                  Text('No routines yet',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppTheme.darkText3
                              : AppTheme.lightText3)),
                ])),
              ).animate().fadeIn(duration: 400.ms),

            ...allBlocks.asMap().entries.map((e) {
              final item = e.value;
              final i = e.key;
              final blockColor = Color(item.block.colorValue);
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: GlassCard(
                  compact: true,
                  glowColor: item.done ? null : blockColor,
                  onTap: item.done
                      ? null
                      : () async {
                          final xp = await ref
                              .read(todayTrackRecordsProvider.notifier)
                              .checkIn(
                                  block: item.block, routineId: item.routineId);
                          ref
                              .read(routineListProvider.notifier)
                              .toggleAndSaveBlock(
                                  item.routineId, item.block.id);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: AppTheme.darkCard,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14)),
                              content: Row(children: [
                                Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppTheme.accent
                                            .withValues(alpha: 0.15)),
                                    child: Icon(Icons.bolt_rounded,
                                        color: AppTheme.accent, size: 16)),
                                const SizedBox(width: 8),
                                Text('+$xp XP',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15)),
                              ]),
                              duration: const Duration(milliseconds: 1200),
                            ));
                          }
                        },
                  child: Row(children: [
                    // Time
                    SizedBox(
                        width: 44,
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
                              fontFeatures: [
                                const FontFeature.tabularFigures()
                              ]),
                        )),
                    // Glowing dot
                    Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: item.done ? AppTheme.success : blockColor,
                          boxShadow: item.done
                              ? []
                              : [
                                  BoxShadow(
                                      color: blockColor.withValues(alpha: 0.4),
                                      blurRadius: 6)
                                ],
                        )),
                    const SizedBox(width: 12),
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          Text(item.block.title,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: item.done
                                      ? (isDark
                                          ? AppTheme.darkText3
                                          : AppTheme.lightText3)
                                      : cs.onSurface,
                                  decoration: item.done
                                      ? TextDecoration.lineThrough
                                      : null)),
                          Text(
                              '${item.block.duration.inMinutes}m · ${item.block.category}',
                              style: TextStyle(
                                  fontSize: 11,
                                  color: isDark
                                      ? AppTheme.darkText3
                                      : AppTheme.lightText3)),
                        ])),
                    if (item.done)
                      Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppTheme.success.withValues(alpha: 0.15)),
                          child: Icon(Icons.check_rounded,
                              color: AppTheme.success, size: 16))
                    else
                      Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: isDark
                                      ? AppTheme.darkBorder
                                      : AppTheme.lightBorder,
                                  width: 2))),
                  ]),
                ),
              )
                  .animate()
                  .fadeIn(delay: (250 + 40 * i).ms, duration: 300.ms)
                  .slideY(begin: 0.03, end: 0);
            }),
          ],
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
                color: AppTheme.accent.withValues(alpha: 0.25),
                blurRadius: 16,
                spreadRadius: -2)
          ],
        ),
        child: FloatingActionButton(
          backgroundColor: AppTheme.accent,
          foregroundColor: Colors.white,
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          onPressed: () => context.push('/build'),
          child: const Icon(Icons.add_rounded, size: 28),
        ),
      ),
    );
  }
}

// ── Glowing stat chip ──
class _StatChip extends StatelessWidget {
  final String emoji, value, label;
  final Color glowColor;
  const _StatChip(
      {required this.emoji,
      required this.value,
      required this.label,
      required this.glowColor});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      compact: true,
      glowColor: glowColor,
      child: Row(children: [
        Text(emoji, style: const TextStyle(fontSize: 18)),
        const SizedBox(width: 10),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(value,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Theme.of(context).colorScheme.onSurface,
                  letterSpacing: -0.5)),
          Text(label,
              style: TextStyle(
                  fontSize: 10, color: glowColor.withValues(alpha: 0.6))),
        ]),
      ]),
    );
  }
}

// ── Glow icon button ──
class _GlowIconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color color;
  const _GlowIconBtn(
      {required this.icon, required this.onTap, required this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13),
            color: color.withValues(alpha: 0.08),
            border: Border.all(color: color.withValues(alpha: 0.15)),
            boxShadow: [
              BoxShadow(color: color.withValues(alpha: 0.08), blurRadius: 12)
            ],
          ),
          child: Icon(icon, color: color.withValues(alpha: 0.7), size: 20),
        ));
  }
}

class _BI {
  final dynamic block;
  final String routineId, routineName;
  final bool done;
  _BI(
      {required this.block,
      required this.routineId,
      required this.routineName,
      required this.done});
}

class _RingPainter extends CustomPainter {
  final double pct;
  final Color activeColor, trackColor;
  _RingPainter(this.pct, this.activeColor, this.trackColor);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 6;

    canvas.drawCircle(
        center,
        radius,
        Paint()
          ..color = trackColor.withValues(alpha: 0.3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 7
          ..strokeCap = StrokeCap.round);

    if (pct > 0) {
      final arcPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 7
        ..strokeCap = StrokeCap.round
        ..shader = SweepGradient(
          startAngle: -pi / 2,
          endAngle: 3 * pi / 2,
          colors: [activeColor, AppTheme.accentAlt, activeColor],
        ).createShader(Rect.fromCircle(center: center, radius: radius));
      canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2,
          2 * pi * pct, false, arcPaint);

      // Glow
      canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          -pi / 2,
          2 * pi * pct,
          false,
          Paint()
            ..color = activeColor.withValues(alpha: 0.15)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 14
            ..strokeCap = StrokeCap.round
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6));
    }
  }

  @override
  bool shouldRepaint(covariant _RingPainter old) => old.pct != pct;
}
