import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:forgeflow/core/config/app_theme.dart';
import 'package:forgeflow/domain/entities/block_entity.dart';
import 'package:forgeflow/domain/entities/routine_entity.dart';
import 'package:forgeflow/presentation/blocs/routine_provider.dart';
import 'package:forgeflow/presentation/widgets/glass_card.dart';

const _uuid = Uuid();
const _cats = ['Work', 'Health', 'Rest', 'Study', 'Social', 'Other'];
const _catEmoji = ['💼', '❤️', '😴', '📚', '👥', '📦'];
const _catIcons = [
  Icons.work_outline,
  Icons.favorite_border,
  Icons.night_shelter_outlined,
  Icons.menu_book_outlined,
  Icons.people_outline,
  Icons.category_outlined
];
const _catColors = [
  0xFF6C63FF,
  0xFFEF4444,
  0xFF34D399,
  0xFFa855f6,
  0xFFFBBF24,
  0xFF64748b
];

class BuildRoutineScreen extends ConsumerStatefulWidget {
  const BuildRoutineScreen({super.key});
  @override
  ConsumerState<BuildRoutineScreen> createState() => _State();
}

class _State extends ConsumerState<BuildRoutineScreen> {
  final _name = TextEditingController();
  final List<BlockEntity> _blocks = [];

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 0),
          child: Column(children: [
            // Header
            Row(children: [
              GestureDetector(
                  onTap: () => context.pop(),
                  child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: AppTheme.accent.withValues(alpha: 0.06),
                          border: Border.all(
                              color: AppTheme.accent.withValues(alpha: 0.12)),
                          boxShadow: [
                            BoxShadow(
                                color: AppTheme.accent.withValues(alpha: 0.05),
                                blurRadius: 8)
                          ]),
                      child: Icon(Icons.arrow_back_rounded,
                          size: 20,
                          color: AppTheme.accent.withValues(alpha: 0.7)))),
              const SizedBox(width: 14),
              Text('New Routine',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: cs.onSurface,
                      letterSpacing: -0.5)),
            ]).animate().fadeIn(duration: 250.ms),
            const SizedBox(height: 22),

            // Name input
            GlassCard(
              padding: EdgeInsets.zero,
              child: TextField(
                controller: _name,
                style: TextStyle(
                    color: cs.onSurface,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
                decoration: InputDecoration(
                  hintText: 'Routine name',
                  hintStyle: TextStyle(
                      color: isDark ? AppTheme.darkText3 : AppTheme.lightText3),
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                ),
              ),
            ).animate().fadeIn(delay: 50.ms, duration: 250.ms),
            const SizedBox(height: 18),

            // Blocks header
            Row(children: [
              Text('Blocks',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: cs.onSurface)),
              const SizedBox(width: 8),
              Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppTheme.accent.withValues(alpha: 0.1)),
                  child: Text('${_blocks.length}',
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.accent))),
            ]),
            const SizedBox(height: 8),

            // Block list
            Expanded(
              child: _blocks.isEmpty
                  ? Center(
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Text('✏️', style: TextStyle(fontSize: 30)),
                      const SizedBox(height: 8),
                      Text('Add blocks to build your routine',
                          style: TextStyle(
                              color: isDark
                                  ? AppTheme.darkText3
                                  : AppTheme.lightText3,
                              fontSize: 13)),
                    ]))
                  : ReorderableListView.builder(
                      itemCount: _blocks.length,
                      onReorder: (o, n) {
                        setState(() {
                          if (n > o) n--;
                          _blocks.insert(n, _blocks.removeAt(o));
                        });
                      },
                      proxyDecorator: (child, _, __) =>
                          Material(color: Colors.transparent, child: child),
                      itemBuilder: (_, i) {
                        final b = _blocks[i];
                        final bColor = Color(b.colorValue);
                        return Padding(
                          key: ValueKey(b.id),
                          padding: const EdgeInsets.only(bottom: 8),
                          child: GlassCard(
                              compact: true,
                              glowColor: bColor,
                              child: Row(children: [
                                Icon(Icons.drag_indicator_rounded,
                                    color: isDark
                                        ? AppTheme.darkText3
                                        : AppTheme.lightText3,
                                    size: 16),
                                const SizedBox(width: 8),
                                Container(
                                    width: 34,
                                    height: 34,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: bColor.withValues(alpha: 0.08),
                                        border: Border.all(
                                            color:
                                                bColor.withValues(alpha: 0.15)),
                                        boxShadow: [
                                          BoxShadow(
                                              color: bColor.withValues(
                                                  alpha: 0.08),
                                              blurRadius: 6)
                                        ]),
                                    child: Center(
                                        child: Text(
                                            _catEmoji[_cats
                                                .indexOf(b.category)
                                                .clamp(0, _cats.length - 1)],
                                            style: TextStyle(fontSize: 15)))),
                                const SizedBox(width: 10),
                                Expanded(
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                      Text(b.title,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                              color: cs.onSurface)),
                                      Text(
                                          '${b.duration.inMinutes}m · ${b.category}',
                                          style: TextStyle(
                                              fontSize: 11,
                                              color: isDark
                                                  ? AppTheme.darkText3
                                                  : AppTheme.lightText3)),
                                    ])),
                                IconButton(
                                    icon: Icon(Icons.close_rounded,
                                        size: 16,
                                        color: isDark
                                            ? AppTheme.darkText3
                                            : AppTheme.lightText3),
                                    onPressed: () =>
                                        setState(() => _blocks.removeAt(i))),
                              ])),
                        );
                      }),
            ),

            // Bottom actions
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(children: [
                Expanded(
                    child: GestureDetector(
                        onTap: () => _addSheet(context),
                        child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: cs.onSurface.withValues(alpha: 0.04),
                                border: Border.all(
                                    color:
                                        cs.onSurface.withValues(alpha: 0.06))),
                            child: Center(
                                child: Text('+ Add Block',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        color: cs.onSurface
                                            .withValues(alpha: 0.5))))))),
                const SizedBox(width: 12),
                Expanded(
                    child: GestureDetector(
                        onTap: _save,
                        child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                gradient: const LinearGradient(colors: [
                                  AppTheme.accent,
                                  AppTheme.accentAlt
                                ]),
                                boxShadow: [
                                  BoxShadow(
                                      color: AppTheme.accent
                                          .withValues(alpha: 0.2),
                                      blurRadius: 12)
                                ]),
                            child: const Center(
                                child: Text('Save',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                        color: Colors.white)))))),
              ]),
            ),
            const SizedBox(height: 8),
          ]),
        ),
      ),
    );
  }

  void _save() {
    if (_name.text.trim().isEmpty) {
      _snack('Enter a routine name');
      return;
    }
    if (_blocks.isEmpty) {
      _snack('Add at least one block');
      return;
    }
    ref.read(routineListProvider.notifier).addRoutine(RoutineEntity(
        id: _uuid.v4(), name: _name.text.trim(), blocks: _blocks));
    context.pop();
  }

  void _snack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(msg),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppTheme.darkCard,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))));

  void _addSheet(BuildContext ctx) {
    final cs = Theme.of(ctx).colorScheme;
    final isDark = Theme.of(ctx).brightness == Brightness.dark;
    final titleC = TextEditingController();
    final durC = TextEditingController(text: '30');
    var type = BlockType.timed;
    var catIdx = 0;
    TimeOfDay? time;

    showModalBottomSheet(
        context: ctx,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (c) => StatefulBuilder(builder: (c, setBS) {
              return Container(
                margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                padding: EdgeInsets.fromLTRB(
                    22, 22, 22, MediaQuery.of(c).viewInsets.bottom + 22),
                decoration: BoxDecoration(
                  color: isDark ? AppTheme.darkCard : Colors.white,
                  borderRadius: BorderRadius.circular(26),
                  border: isDark
                      ? Border.all(
                          color: AppTheme.darkBorder.withValues(alpha: 0.5))
                      : null,
                  boxShadow: [
                    BoxShadow(
                        color: AppTheme.accent.withValues(alpha: 0.04),
                        blurRadius: 30,
                        spreadRadius: -4),
                    BoxShadow(
                        color: Colors.black.withValues(alpha: 0.4),
                        blurRadius: 20),
                  ],
                ),
                child: SingleChildScrollView(
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Center(
                          child: Container(
                              width: 36,
                              height: 4,
                              decoration: BoxDecoration(
                                  color: cs.onSurface.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(2)))),
                      const SizedBox(height: 18),
                      Text('Add Block',
                          style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 18,
                              color: cs.onSurface)),
                      const SizedBox(height: 18),
                      _input(titleC, 'Block title', cs, isDark),
                      const SizedBox(height: 14),
                      Text('Type',
                          style: TextStyle(
                              color: isDark
                                  ? AppTheme.darkText3
                                  : AppTheme.lightText3,
                              fontSize: 12,
                              fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      Row(
                          children: BlockType.values.map((t) {
                        final sel = t == type;
                        final label = t == BlockType.timed
                            ? 'Timed'
                            : t == BlockType.scheduled
                                ? 'Scheduled'
                                : 'Both';
                        return Expanded(
                            child: Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: GestureDetector(
                                    onTap: () => setBS(() => type = t),
                                    child: AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 200),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 11),
                                        decoration: sel
                                            ? AppTheme.glowButton(
                                                color: AppTheme.accent,
                                                radius: 12)
                                            : BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                color: cs.onSurface
                                                    .withValues(alpha: 0.03),
                                                border: Border.all(
                                                    color: cs.onSurface.withValues(
                                                        alpha: 0.05))),
                                        child: Center(
                                            child: Text(label,
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: sel ? FontWeight.w700 : FontWeight.w400,
                                                    color: sel ? AppTheme.accent : cs.onSurface.withValues(alpha: 0.4))))))));
                      }).toList()),
                      const SizedBox(height: 14),
                      Row(children: [
                        Expanded(
                            child: _input(durC, 'Duration (min)', cs, isDark,
                                isNumber: true)),
                        if (type != BlockType.timed) ...[
                          const SizedBox(width: 12),
                          Expanded(
                              child: GestureDetector(
                                  onTap: () async {
                                    final t = await showTimePicker(
                                        context: c,
                                        initialTime: TimeOfDay.now());
                                    if (t != null) setBS(() => time = t);
                                  },
                                  child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15, horizontal: 14),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(14),
                                          color: isDark
                                              ? Colors.white
                                                  .withValues(alpha: 0.03)
                                              : cs.onSurface
                                                  .withValues(alpha: 0.03),
                                          border: Border.all(
                                              color: cs.onSurface
                                                  .withValues(alpha: 0.05))),
                                      child: Text(
                                          time != null
                                              ? '${time!.hour.toString().padLeft(2, '0')}:${time!.minute.toString().padLeft(2, '0')}'
                                              : 'Set time',
                                          style: TextStyle(
                                              color: time != null
                                                  ? cs.onSurface
                                                  : cs.onSurface
                                                      .withValues(alpha: 0.25),
                                              fontSize: 14))))),
                        ],
                      ]),
                      const SizedBox(height: 14),
                      Text('Category',
                          style: TextStyle(
                              color: isDark
                                  ? AppTheme.darkText3
                                  : AppTheme.lightText3,
                              fontSize: 12,
                              fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: List.generate(_cats.length, (i) {
                            final sel = i == catIdx;
                            final catColor = Color(_catColors[i]);
                            return GestureDetector(
                                onTap: () => setBS(() => catIdx = i),
                                child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 9),
                                    decoration: sel
                                        ? AppTheme.glowButton(
                                            color: catColor, radius: 12)
                                        : BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            color: cs.onSurface
                                                .withValues(alpha: 0.03),
                                            border: Border.all(
                                                color: cs.onSurface
                                                    .withValues(alpha: 0.05))),
                                    child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(_catEmoji[i],
                                              style: TextStyle(fontSize: 14)),
                                          const SizedBox(width: 6),
                                          Text(_cats[i],
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: sel
                                                      ? catColor
                                                      : cs.onSurface.withValues(
                                                          alpha: 0.4),
                                                  fontWeight: sel
                                                      ? FontWeight.w600
                                                      : FontWeight.w400)),
                                        ])));
                          })),
                      const SizedBox(height: 22),
                      SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: GestureDetector(
                            onTap: () {
                              final t = titleC.text.trim();
                              if (t.isEmpty) return;
                              setState(() => _blocks.add(BlockEntity(
                                  id: _uuid.v4(),
                                  title: t,
                                  type: type,
                                  duration: Duration(
                                      minutes: int.tryParse(durC.text) ?? 30),
                                  startTime: time,
                                  category: _cats[catIdx],
                                  colorValue: _catColors[catIdx],
                                  iconCodePoint: _catIcons[catIdx].codePoint)));
                              Navigator.pop(c);
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    gradient: const LinearGradient(colors: [
                                      AppTheme.accent,
                                      AppTheme.accentAlt
                                    ]),
                                    boxShadow: [
                                      BoxShadow(
                                          color: AppTheme.accent
                                              .withValues(alpha: 0.2),
                                          blurRadius: 12)
                                    ]),
                                child: const Center(
                                    child: Text('Add Block',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 15,
                                            color: Colors.white)))),
                          )),
                    ])),
              );
            }));
  }

  Widget _input(
          TextEditingController c, String hint, ColorScheme cs, bool isDark,
          {bool isNumber = false}) =>
      TextField(
          controller: c,
          keyboardType: isNumber ? TextInputType.number : null,
          style: TextStyle(color: cs.onSurface, fontSize: 14),
          decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                  color: isDark ? AppTheme.darkText3 : AppTheme.lightText3),
              filled: true,
              fillColor: isDark
                  ? Colors.white.withValues(alpha: 0.03)
                  : cs.onSurface.withValues(alpha: 0.03),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide:
                      BorderSide(color: cs.onSurface.withValues(alpha: 0.05))),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                      color: AppTheme.accent.withValues(alpha: 0.35))),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14)));
}
