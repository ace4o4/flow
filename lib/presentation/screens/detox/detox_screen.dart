import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:forgeflow/core/config/app_theme.dart';
import 'package:forgeflow/presentation/widgets/glass_card.dart';

class _AppConfig {
  final String name;
  final IconData icon;
  final Color color;
  bool isLocked = false;
  bool limitEnabled = false;
  int lockAfterMinutes = 0;
  int lockForMinutes = 60;
  bool isExpanded = false;

  _AppConfig({
    required this.name,
    required this.icon,
    required this.color,
  });
}

class DetoxScreen extends StatefulWidget {
  const DetoxScreen({super.key});

  @override
  State<DetoxScreen> createState() => _DetoxScreenState();
}

class _DetoxScreenState extends State<DetoxScreen> {
  bool _detoxModeActive = false;
  int _globalLockAfterMinutes = 0;
  int _globalLockForMinutes = 120;

  final List<_AppConfig> _apps = [
    _AppConfig(
        name: 'Instagram',
        icon: Icons.camera_alt_rounded,
        color: Colors.pinkAccent),
    _AppConfig(
        name: 'YouTube',
        icon: Icons.play_circle_filled_rounded,
        color: Colors.redAccent),
    _AppConfig(
        name: 'TikTok',
        icon: Icons.music_note_rounded,
        color: Colors.cyanAccent),
    _AppConfig(
        name: 'WhatsApp', icon: Icons.chat_rounded, color: AppTheme.success),
  ];

  Widget _timeSpinnerWidget(int value, String suffix, Function(int) onChanged,
      Color color, bool isDark,
      {int max = 59}) {
    return Container(
        decoration: AppTheme.neoCard(
          isDark: isDark,
          isInset: true,
          radius: 12,
        ),
        child: Row(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => value > 0 ? onChanged(value - 1) : null,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Icon(Icons.remove,
                    size: 14, color: value > 0 ? color : Colors.grey),
              ),
            ),
            SizedBox(
              width: 32,
              child: Text('$value$suffix',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 13, color: color)),
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => value < max ? onChanged(value + 1) : null,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Icon(Icons.add,
                    size: 14, color: value < max ? color : Colors.grey),
              ),
            ),
          ],
        ));
  }

  Widget _buildTimePickerRow(String label, int totalMinutes,
      Function(int) onChanged, Color color, ColorScheme cs, bool isDark) {
    final int h = totalMinutes ~/ 60;
    final int m = totalMinutes % 60;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: cs.onSurface)),
          Row(
            children: [
              _timeSpinnerWidget(
                  h, 'h', (newH) => onChanged((newH * 60) + m), color, isDark,
                  max: 23),
              const SizedBox(width: 8),
              _timeSpinnerWidget(
                  m, 'm', (newM) => onChanged((h * 60) + newM), color, isDark,
                  max: 59),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
          children: [
            Row(children: [
              IconButton(
                icon: Icon(Icons.arrow_back_ios_new_rounded,
                    color: isDark ? AppTheme.darkText3 : AppTheme.lightText3,
                    size: 20),
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(width: 8),
              Text('Digital Detox',
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: cs.onSurface,
                      letterSpacing: -1.2)),
            ]).animate().fadeIn(duration: 300.ms),
            const SizedBox(height: 24),

            // Focus Lock Card
            GlassCard(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(children: [
                            const Icon(Icons.lock_clock_rounded,
                                size: 24, color: AppTheme.accentAlt),
                            const SizedBox(width: 12),
                            Text('Focus Lock',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                    color: cs.onSurface)),
                          ]),
                          Switch(
                            value: _detoxModeActive,
                            activeTrackColor:
                                AppTheme.accentAlt.withValues(alpha: 0.5),
                            activeThumbColor: AppTheme.accentAlt,
                            onChanged: (v) {
                              setState(() => _detoxModeActive = v);
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                backgroundColor: isDark
                                    ? AppTheme.darkCard
                                    : AppTheme.lightCard,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14)),
                                content: Text(
                                    v
                                        ? 'Focus lock enabled!'
                                        : 'Focus lock disabled.',
                                    style: TextStyle(
                                        color: cs.onSurface,
                                        fontWeight: FontWeight.w600)),
                              ));
                            },
                          ),
                        ]),
                    const SizedBox(height: 12),
                    Text(
                        'Strictly locks distracting apps during scheduled blocks. Bypass requires solving a 60-second math puzzle.',
                        style: TextStyle(
                            fontSize: 13,
                            height: 1.4,
                            color: isDark
                                ? AppTheme.darkText2
                                : AppTheme.lightText2)),
                  ]),
            ).animate().fadeIn(delay: 100.ms),
            const SizedBox(height: 24),

            // Custom Global Lock
            Text('Quick Global Lock',
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: cs.onSurface))
                .animate()
                .fadeIn(delay: 150.ms),
            const SizedBox(height: 12),
            GlassCard(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Custom Time Lock',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: AppTheme.accent)),
                          Icon(Icons.timer_rounded,
                              size: 18, color: AppTheme.accent),
                        ]),
                    const SizedBox(height: 12),
                    _buildTimePickerRow(
                        'Lock Starts In',
                        _globalLockAfterMinutes,
                        (v) => setState(() => _globalLockAfterMinutes = v),
                        AppTheme.accent,
                        cs,
                        isDark),
                    _buildTimePickerRow(
                        'Lock Duration',
                        _globalLockForMinutes,
                        (v) => setState(() => _globalLockForMinutes = v),
                        AppTheme.accentAlt,
                        cs,
                        isDark),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor:
                                isDark ? AppTheme.darkCard : AppTheme.lightCard,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14)),
                            content: Text(
                                'Global lock set to start in $_globalLockAfterMinutes mins!',
                                style: TextStyle(
                                    color: cs.onSurface,
                                    fontWeight: FontWeight.w600)),
                          ));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              AppTheme.accent.withValues(alpha: 0.15),
                          foregroundColor: AppTheme.accent,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Start Global App Lock',
                            style: TextStyle(fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ]),
            ).animate().fadeIn(delay: 200.ms),
            const SizedBox(height: 24),

            // Specific App Configurations
            Text('App Customization',
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: cs.onSurface))
                .animate()
                .fadeIn(delay: 250.ms),
            const SizedBox(height: 12),

            ..._apps.asMap().entries.map((e) {
              final idx = e.key;
              final app = e.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: GlassCard(
                  child: Column(
                    children: [
                      // Header Row
                      InkWell(
                        onTap: () =>
                            setState(() => app.isExpanded = !app.isExpanded),
                        child: Row(children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: app.color.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(app.icon, size: 20, color: app.color),
                          ),
                          const SizedBox(width: 12),
                          Text(app.name,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: cs.onSurface)),
                          const Spacer(),
                          Switch(
                            value: app.isLocked,
                            activeTrackColor: app.color.withValues(alpha: 0.4),
                            activeThumbColor: app.color,
                            onChanged: (v) => setState(() => app.isLocked = v),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                              app.isExpanded
                                  ? Icons.keyboard_arrow_up_rounded
                                  : Icons.keyboard_arrow_down_rounded,
                              color: isDark
                                  ? AppTheme.darkText3
                                  : AppTheme.lightText3),
                        ]),
                      ),

                      // Expandable Settings
                      AnimatedSize(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOutCubic,
                        child: app.isExpanded
                            ? Column(
                                children: [
                                  Divider(
                                      color: isDark
                                          ? AppTheme.darkBorder
                                          : AppTheme.lightBorder,
                                      height: 24),

                                  // Specific App Time Limit
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Custom App Limit',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: cs.onSurface)),
                                        Switch(
                                          value: app.limitEnabled,
                                          activeTrackColor:
                                              app.color.withValues(alpha: 0.4),
                                          activeThumbColor: app.color,
                                          onChanged: (v) => setState(
                                              () => app.limitEnabled = v),
                                        ),
                                      ]),
                                  if (app.limitEnabled) ...[
                                    const SizedBox(height: 8),
                                    _buildTimePickerRow(
                                        'Lock Starts In',
                                        app.lockAfterMinutes,
                                        (v) => setState(
                                            () => app.lockAfterMinutes = v),
                                        app.color,
                                        cs,
                                        isDark),
                                    _buildTimePickerRow(
                                        'Lock Duration',
                                        app.lockForMinutes,
                                        (v) => setState(
                                            () => app.lockForMinutes = v),
                                        app.color,
                                        cs,
                                        isDark),
                                  ],
                                  const SizedBox(height: 8),
                                ],
                              )
                            : const SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),
              ).animate().fadeIn(delay: (300 + (idx * 50)).ms);
            }),
          ],
        ),
      ),
    );
  }
}
