import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:forgeflow/core/config/app_theme.dart';
import 'package:forgeflow/core/di/injection_container.dart';
import 'package:forgeflow/domain/entities/track_record_entity.dart';
import 'package:forgeflow/domain/usecases/get_track_records_usecase.dart';
import 'package:forgeflow/presentation/widgets/glass_card.dart';

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});
  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;
  List<TrackRecordEntity> _records = [];
  bool _loading = true;
  int _chartStyle = 0; // 0=Bar, 1=Line, 2=Pie

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
    _load();
  }

  Future<void> _load() async {
    final r = await sl<GetTrackRecordsUseCase>()();
    if (mounted) {
      setState(() {
        _records = r;
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: _loading
            ? const Center(
                child: CircularProgressIndicator(
                    color: AppTheme.accent, strokeWidth: 2))
            : Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: ListView(
                      padding: EdgeInsets.fromLTRB(
                        MediaQuery.sizeOf(context).width > 600 ? 32 : 16,
                        MediaQuery.sizeOf(context).width > 600 ? 32 : 20,
                        MediaQuery.sizeOf(context).width > 600 ? 32 : 16,
                        120,
                      ),
                      children: [
                        Text('Reports',
                            style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                color: cs.onSurface,
                                letterSpacing: -1.2)),
                        const SizedBox(height: 18),

                        // Tab selector — pill toggle
                        GlassCard(
                            padding: const EdgeInsets.all(4),
                            child: Row(children: [
                              _tabPill('Weekly', 0),
                              _tabPill('Monthly', 1),
                            ])).animate().fadeIn(duration: 300.ms),
                        const SizedBox(height: 12),

                        // Chart Style Selector
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            _styleBtn(Icons.bar_chart_rounded, 0, isDark),
                            _styleBtn(Icons.show_chart_rounded, 1, isDark),
                            _styleBtn(Icons.pie_chart_rounded, 2, isDark),
                          ],
                        ).animate().fadeIn(delay: 100.ms),
                        const SizedBox(height: 12),

                        AnimatedBuilder(
                            animation: _tab,
                            builder: (_, __) => _tab.index == 0
                                ? _weekly(cs, isDark)
                                : _monthly(cs, isDark)),
                        const SizedBox(height: 12),
                        _punctuality(cs, isDark),
                      ]),
                ),
              ),
      ),
    );
  }

  Widget _tabPill(String label, int idx) {
    final sel = _tab.index == idx;
    return Expanded(
        child: GestureDetector(
      onTap: () => setState(() => _tab.index = idx),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: sel
              ? AppTheme.accent.withValues(alpha: 0.12)
              : Colors.transparent,
          border: sel
              ? Border.all(color: AppTheme.accent.withValues(alpha: 0.2))
              : null,
          boxShadow: sel
              ? [
                  BoxShadow(
                      color: AppTheme.accent.withValues(alpha: 0.06),
                      blurRadius: 8)
                ]
              : [],
        ),
        child: Center(
            child: Text(label,
                style: TextStyle(
                    fontWeight: sel ? FontWeight.w700 : FontWeight.w500,
                    fontSize: 13,
                    color: sel
                        ? AppTheme.accent
                        : Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.35)))),
      ),
    ));
  }

  Widget _styleBtn(IconData icon, int idx, bool isDark) {
    final sel = _chartStyle == idx;
    return GestureDetector(
      onTap: () => setState(() => _chartStyle = idx),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(left: 8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: sel
              ? AppTheme.accent.withValues(alpha: 0.15)
              : (isDark ? AppTheme.darkCard : AppTheme.lightCard),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: sel
                  ? AppTheme.accent.withValues(alpha: 0.3)
                  : Colors.transparent),
        ),
        child: Icon(icon,
            size: 20,
            color: sel
                ? AppTheme.accent
                : (isDark ? AppTheme.darkText3 : AppTheme.lightText3)),
      ),
    );
  }

  Widget _weekly(ColorScheme cs, bool isDark) {
    final now = DateTime.now();
    final days = List.generate(7, (i) => now.subtract(Duration(days: 6 - i)));
    final labels =
        days.map((d) => DateFormat('E').format(d).substring(0, 2)).toList();
    final counts = days.map((d) {
      final ds = DateFormat('yyyy-MM-dd').format(d);
      return _records.where((r) => r.date == ds).length.toDouble();
    }).toList();
    final maxY = counts.fold(0.0, (a, b) => a > b ? a : b);

    return GlassCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.trending_up_rounded,
              size: 20, color: AppTheme.accent),
          const SizedBox(width: 10),
          Text('This Week',
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: cs.onSurface)),
        ]),
        const SizedBox(height: 20),
        SizedBox(
            height: 160,
            child: _chartStyle == 0
                ? _buildBarChart(counts, labels, maxY, isDark)
                : _chartStyle == 1
                    ? _buildLineChart(
                        counts
                            .asMap()
                            .entries
                            .map((e) => FlSpot(e.key.toDouble(), e.value))
                            .toList(),
                        labels,
                        maxY,
                        isDark)
                    : _buildPieChart(counts, labels, isDark)),
      ]),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _monthly(ColorScheme cs, bool isDark) {
    final now = DateTime.now();
    final dim = DateTime(now.year, now.month + 1, 0).day;
    final spots = List.generate(dim, (i) {
      final ds =
          DateFormat('yyyy-MM-dd').format(DateTime(now.year, now.month, i + 1));
      return FlSpot(
          i.toDouble(), _records.where((r) => r.date == ds).length.toDouble());
    });
    final maxY = spots.fold(0.0, (m, s) => s.y > m ? s.y : m);

    return GlassCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.bar_chart_rounded, size: 20, color: AppTheme.accent),
          const SizedBox(width: 10),
          Text(DateFormat('MMMM yyyy').format(now),
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: cs.onSurface)),
        ]),
        const SizedBox(height: 20),
        SizedBox(
            height: 180,
            child: _chartStyle == 0
                ? _buildBarChart(spots.map((s) => s.y).toList(),
                    List.generate(dim, (i) => '${i + 1}'), maxY, isDark)
                : _chartStyle == 1
                    ? _buildLineChart(spots,
                        List.generate(dim, (i) => '${i + 1}'), maxY, isDark)
                    : _buildPieChart(spots.map((s) => s.y).toList(),
                        List.generate(dim, (i) => '${i + 1}'), isDark)),
      ]),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildBarChart(
      List<double> counts, List<String> labels, double maxY, bool isDark) {
    return BarChart(BarChartData(
      alignment: BarChartAlignment.spaceAround,
      maxY: maxY < 1 ? 5 : maxY + 2,
      barTouchData: const BarTouchData(enabled: false),
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
            sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 24,
                interval: labels.length > 7 ? 7 : 1,
                getTitlesWidget: (v, _) => v.toInt() < labels.length
                    ? Text(labels[v.toInt()],
                        style: TextStyle(
                            color: isDark
                                ? AppTheme.darkText3
                                : AppTheme.lightText3,
                            fontSize: 11,
                            fontWeight: FontWeight.w500))
                    : const SizedBox.shrink())),
        leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      gridData: const FlGridData(show: false),
      borderData: FlBorderData(show: false),
      barGroups: counts
          .asMap()
          .entries
          .map((e) => BarChartGroupData(x: e.key, barRods: [
                BarChartRodData(
                    toY: e.value,
                    width: labels.length > 7 ? 6 : 22,
                    borderRadius: BorderRadius.circular(8),
                    gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          AppTheme.accent.withValues(alpha: 0.3),
                          AppTheme.accent.withValues(alpha: 0.7)
                        ])),
              ]))
          .toList(),
    ));
  }

  Widget _buildLineChart(
      List<FlSpot> spots, List<String> labels, double maxY, bool isDark) {
    return LineChart(LineChartData(
      gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 1,
          getDrawingHorizontalLine: (_) => FlLine(
              color: isDark
                  ? AppTheme.darkBorder.withValues(alpha: 0.3)
                  : AppTheme.lightBorder,
              strokeWidth: 1)),
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
            sideTitles: SideTitles(
                showTitles: true,
                interval: labels.length > 7 ? 7 : 1,
                reservedSize: 24,
                getTitlesWidget: (v, _) => v.toInt() < labels.length
                    ? Text(labels[v.toInt()],
                        style: TextStyle(
                            color: isDark
                                ? AppTheme.darkText3
                                : AppTheme.lightText3,
                            fontSize: 10))
                    : const SizedBox.shrink())),
        leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(show: false),
      minY: 0,
      maxY: maxY < 1 ? 5 : maxY + 2,
      lineBarsData: [
        LineChartBarData(
            spots: spots,
            isCurved: true,
            gradient: const LinearGradient(
                colors: [AppTheme.accent, AppTheme.accentAlt]),
            barWidth: 2.5,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppTheme.accent.withValues(alpha: 0.12),
                      Colors.transparent
                    ])))
      ],
    ));
  }

  Widget _buildPieChart(List<double> counts, List<String> labels, bool isDark) {
    if (counts.every((c) => c == 0)) {
      return Center(
          child: Text('No data for pie chart',
              style: TextStyle(
                  color: isDark ? AppTheme.darkText3 : AppTheme.lightText3)));
    }

    final colors = [
      AppTheme.accent,
      AppTheme.success,
      AppTheme.warning,
      AppTheme.error,
      Colors.purpleAccent,
      Colors.blueAccent,
      Colors.tealAccent
    ];

    return PieChart(PieChartData(
      sectionsSpace: 2,
      centerSpaceRadius: 40,
      sections: counts.asMap().entries.where((e) => e.value > 0).map((e) {
        return PieChartSectionData(
          color: colors[e.key % colors.length],
          value: e.value,
          title: '${labels[e.key]}\n${e.value.toInt()}',
          radius: 65,
          titleStyle: const TextStyle(
              fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
        );
      }).toList(),
    ));
  }

  Widget _punctuality(ColorScheme cs, bool isDark) {
    final e = _records.where((r) => r.status == PunctualityStatus.early).length;
    final o =
        _records.where((r) => r.status == PunctualityStatus.onTime).length;
    final l = _records.where((r) => r.status == PunctualityStatus.late).length;
    final t = _records.length;

    return GlassCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.schedule_rounded, size: 20, color: AppTheme.accent),
          const SizedBox(width: 10),
          Text('Punctuality',
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: cs.onSurface)),
        ]),
        const SizedBox(height: 16),
        if (t == 0)
          Text('No data yet',
              style: TextStyle(
                  color: isDark ? AppTheme.darkText3 : AppTheme.lightText3,
                  fontSize: 13))
        else ...[
          _pRow('Early', e, t, AppTheme.success, isDark),
          const SizedBox(height: 8),
          _pRow('On Time', o, t, AppTheme.accent, isDark),
          const SizedBox(height: 8),
          _pRow('Late', l, t, AppTheme.warning, isDark),
        ],
      ]),
    ).animate().fadeIn(delay: 150.ms, duration: 350.ms);
  }

  Widget _pRow(String label, int c, int t, Color col, bool isDark) {
    final p = t > 0 ? c / t : 0.0;
    return Row(children: [
      Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: col,
              boxShadow: [
                BoxShadow(color: col.withValues(alpha: 0.3), blurRadius: 4)
              ])),
      const SizedBox(width: 10),
      SizedBox(
          width: 56,
          child: Text(label,
              style: TextStyle(
                  color: isDark ? AppTheme.darkText2 : AppTheme.lightText2,
                  fontSize: 12,
                  fontWeight: FontWeight.w500))),
      Expanded(
          child: Container(
        height: 5,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder),
        child: FractionallySizedBox(
          widthFactor: p.clamp(0, 1),
          alignment: Alignment.centerLeft,
          child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  color: col,
                  boxShadow: [
                BoxShadow(color: col.withValues(alpha: 0.25), blurRadius: 6)
              ])),
        ),
      )),
      const SizedBox(width: 10),
      Text('${(p * 100).toInt()}%',
          style: TextStyle(
              color: isDark ? AppTheme.darkText2 : AppTheme.lightText2,
              fontSize: 12,
              fontWeight: FontWeight.w700)),
    ]);
  }
}
