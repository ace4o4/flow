import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:forgeflow/core/config/app_theme.dart';
import 'package:forgeflow/presentation/blocs/user_profile_provider.dart';
import 'package:forgeflow/presentation/widgets/glass_card.dart';

class RewardsScreen extends ConsumerWidget {
  const RewardsScreen({super.key});

  static const _items = [
    _R('Focus Mode', '🎯', 200, AppTheme.accent),
    _R('Dark Aura', '🌑', 350, AppTheme.accentAlt),
    _R('Custom Icons', '✨', 250, AppTheme.warning),
    _R('Zen Mode', '🧘', 400, AppTheme.success),
    _R('Aurora', '🌈', 500, AppTheme.orange),
    _R('Diamond', '💎', 150, AppTheme.accent),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final profileState = ref.watch(userProfileProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
          child: ListView(
        padding: const EdgeInsets.fromLTRB(18, 14, 18, 100),
        children: [
          Text('Rewards',
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: cs.onSurface,
                  letterSpacing: -1.2)),
          const SizedBox(height: 20),

          // XP + Level bento
          profileState.when(
            data: (p) => Column(children: [
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                // Level ring
                Expanded(
                    flex: 5,
                    child: GlassCard(
                      glowColor: AppTheme.accent,
                      child: Column(children: [
                        const SizedBox(height: 4),
                        SizedBox(
                            width: 90,
                            height: 90,
                            child: CustomPaint(
                              painter: _LevelRing(
                                  p.levelProgress,
                                  AppTheme.accent,
                                  isDark
                                      ? AppTheme.darkBorder
                                      : AppTheme.lightBorder),
                              child: Center(
                                  child: Text('${p.currentLevel}',
                                      style: TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.w800,
                                          color: cs.onSurface))),
                            )),
                        const SizedBox(height: 8),
                        Text('LEVEL',
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.5,
                                color: AppTheme.accent.withValues(alpha: 0.5))),
                        const SizedBox(height: 2),
                        Text('${p.xpForNextLevel - p.totalXP} XP to next',
                            style: TextStyle(
                                fontSize: 11,
                                color: isDark
                                    ? AppTheme.darkText3
                                    : AppTheme.lightText3)),
                      ]),
                    )),
                const SizedBox(width: 12),
                Expanded(
                    flex: 4,
                    child: Column(children: [
                      GlassCard(
                          compact: true,
                          glowColor: AppTheme.accentAlt,
                          child: Row(children: [
                            Text('⚡', style: TextStyle(fontSize: 20)),
                            const SizedBox(width: 10),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${p.totalXP}',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w800,
                                          color: cs.onSurface,
                                          letterSpacing: -0.5)),
                                  Text('total XP',
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: AppTheme.accentAlt
                                              .withValues(alpha: 0.5))),
                                ]),
                          ])),
                      const SizedBox(height: 10),
                      GlassCard(
                          compact: true,
                          glowColor: AppTheme.orange,
                          child: Row(children: [
                            Text('🔥', style: TextStyle(fontSize: 20)),
                            const SizedBox(width: 10),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${p.currentStreak}',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w800,
                                          color: cs.onSurface,
                                          letterSpacing: -0.5)),
                                  Text('streak',
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: AppTheme.orange
                                              .withValues(alpha: 0.5))),
                                ]),
                          ])),
                    ])),
              ]).animate().fadeIn(duration: 350.ms).slideY(begin: 0.04, end: 0),

              // Badges
              if (p.badges.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: GlassCard(
                      compact: true,
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: p.badges
                            .map((b) => Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: AppTheme.glowButton(
                                      color: AppTheme.accent, radius: 8),
                                  child: Text(_badgeLabel(b),
                                      style: TextStyle(
                                          fontSize: 11,
                                          color: AppTheme.accent,
                                          fontWeight: FontWeight.w600)),
                                ))
                            .toList(),
                      )).animate().fadeIn(delay: 100.ms, duration: 300.ms),
                ),
            ]),
            loading: () => const SizedBox(height: 160),
            error: (_, __) => const SizedBox(height: 160),
          ),
          const SizedBox(height: 22),

          // Vault
          Row(children: [
            Text('Vault',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: cs.onSurface)),
            const SizedBox(width: 8),
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: AppTheme.accent.withValues(alpha: 0.1)),
                child: Text('${_items.length}',
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.accent))),
          ]),
          const SizedBox(height: 12),

          ...List.generate((_items.length / 2).ceil(), (row) {
            final i1 = row * 2;
            final i2 = i1 + 1;
            return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(children: [
                  Expanded(child: _VaultItem(item: _items[i1], idx: i1)),
                  const SizedBox(width: 12),
                  if (i2 < _items.length)
                    Expanded(child: _VaultItem(item: _items[i2], idx: i2))
                  else
                    const Expanded(child: SizedBox()),
                ]));
          }),
        ],
      )),
    );
  }

  String _badgeLabel(String b) => switch (b) {
        'streak_3' => '🔥 3-Day',
        'streak_7' => '🔥 7-Day',
        'streak_30' => '🔥 30-Day',
        'punctual_pro' => '⏰ Punctual',
        _ => b,
      };
}

class _VaultItem extends ConsumerWidget {
  final _R item;
  final int idx;
  const _VaultItem({required this.item, required this.idx});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final xp = ref.watch(userProfileProvider).value?.totalXP ?? 0;
    final can = xp >= item.cost;

    return GlassCard(
      glowColor: can ? item.color : null,
      onTap: can ? () => _buy(context, ref) : null,
      child: Column(children: [
        const SizedBox(height: 4),
        Text(item.emoji, style: TextStyle(fontSize: 30)),
        const SizedBox(height: 10),
        Text(item.name,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: can
                    ? cs.onSurface
                    : (isDark ? AppTheme.darkText3 : AppTheme.lightText3))),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: AppTheme.glowButton(
              color: can
                  ? item.color
                  : (isDark ? AppTheme.darkBorder : AppTheme.lightBorder),
              radius: 8),
          child: Text('${item.cost} XP',
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: can
                      ? item.color
                      : (isDark ? AppTheme.darkText3 : AppTheme.lightText3))),
        ),
      ]),
    )
        .animate()
        .fadeIn(delay: (70 * idx).ms, duration: 300.ms)
        .slideY(begin: 0.04, end: 0);
  }

  void _buy(BuildContext ctx, WidgetRef ref) {
    final cs = Theme.of(ctx).colorScheme;
    showDialog(
        context: ctx,
        builder: (c) => AlertDialog(
              backgroundColor: AppTheme.darkCard,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22)),
              title: Text('${item.emoji} ${item.name}',
                  style: TextStyle(
                      color: cs.onSurface, fontWeight: FontWeight.w700)),
              content: Text('Unlock for ${item.cost} XP?',
                  style: TextStyle(color: AppTheme.darkText2)),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(c),
                    child: Text('Cancel',
                        style: TextStyle(color: AppTheme.darkText3))),
                TextButton(
                    onPressed: () {
                      Navigator.pop(c);
                      ref.read(userProfileProvider.notifier).addXP(-item.cost);
                      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
                          backgroundColor: AppTheme.darkCard,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                          content: Text('${item.emoji} ${item.name} unlocked!',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600)),
                          duration: const Duration(seconds: 2)));
                    },
                    child: Text('Unlock',
                        style: TextStyle(
                            color: AppTheme.accent,
                            fontWeight: FontWeight.w700))),
              ],
            ));
  }
}

class _R {
  final String name, emoji;
  final int cost;
  final Color color;
  const _R(this.name, this.emoji, this.cost, this.color);
}

class _LevelRing extends CustomPainter {
  final double pct;
  final Color active, track;
  _LevelRing(this.pct, this.active, this.track);
  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2 - 5;
    canvas.drawCircle(
        c,
        r,
        Paint()
          ..color = track.withValues(alpha: 0.3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 6
          ..strokeCap = StrokeCap.round);
    if (pct > 0) {
      canvas.drawArc(
          Rect.fromCircle(center: c, radius: r),
          -pi / 2,
          2 * pi * pct,
          false,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 6
            ..strokeCap = StrokeCap.round
            ..shader = SweepGradient(
                    startAngle: -pi / 2,
                    endAngle: 3 * pi / 2,
                    colors: [active, AppTheme.accentAlt, active])
                .createShader(Rect.fromCircle(center: c, radius: r)));
      canvas.drawArc(
          Rect.fromCircle(center: c, radius: r),
          -pi / 2,
          2 * pi * pct,
          false,
          Paint()
            ..color = active.withValues(alpha: 0.12)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 14
            ..strokeCap = StrokeCap.round
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5));
    }
  }

  @override
  bool shouldRepaint(covariant _LevelRing old) => old.pct != pct;
}
