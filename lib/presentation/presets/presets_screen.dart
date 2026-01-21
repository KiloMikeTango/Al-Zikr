// lib/presentation/presets/presets_screen.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../controllers/preset_controller.dart';
import '../../controllers/counter_controller.dart';
import '../custom/custom_counter_screen.dart';
import '../../models/preset_model.dart';
import '../../models/zikr_items.dart';

// --- Helper Classes ---
class _EditableZikr {
  String text;
  int target;
  late TextEditingController textController;
  late TextEditingController countController;

  _EditableZikr({required this.text, required this.target}) {
    textController = TextEditingController(text: text);
    countController = TextEditingController(text: target.toString());
  }
}

class _PresetEditResult {
  final String name;
  final List<ZikrItem> zikrs;
  _PresetEditResult({required this.name, required this.zikrs});
}

// --- Main Screen ---
class PresetsScreen extends StatelessWidget {
  const PresetsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PresetController()..load(),
      child: const _PresetsBody(),
    );
  }
}

class _PresetsBody extends StatelessWidget {
  const _PresetsBody();

  @override
  Widget build(BuildContext context) {
    final c = context.watch<PresetController>();

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: const BorderSide(color: Colors.white10),
        ),
        onPressed: () => _openPresetEditor(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1E1E1E), Color(0xFF121212)],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final scale = math.min(
                constraints.maxWidth / 1440.0,
                constraints.maxHeight / 2880.0,
              );
              double pxW(double v) => v * scale;
              double pxH(double v) => v * scale;

              return Stack(
                children: [
                  // HEADER
                  Positioned(
                    left: pxW(100),
                    top: pxH(150),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Colors.white,
                            size: pxH(100),
                          ),
                        ),
                        SizedBox(width: pxW(60)),
                        Text(
                          'MY PRESETS',
                          style: GoogleFonts.philosopher(
                            fontSize: pxH(90),
                            fontWeight: FontWeight.w700,
                            letterSpacing: 4,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // LIST
                  Positioned.fill(
                    top: pxH(400),
                    child: c.presets.isEmpty
                        ? Center(
                            child: Text(
                              'No presets saved',
                              style: TextStyle(
                                color: Colors.white30,
                                fontSize: pxH(60),
                              ),
                            ),
                          )
                        : ListView.builder(
                            padding: EdgeInsets.symmetric(
                              horizontal: pxW(100),
                              vertical: pxH(50),
                            ),
                            itemCount: c.presets.length,
                            itemBuilder: (_, i) {
                              final p = c.presets[i];
                              return _PresetSmallCard(
                                title: p.name,
                                subtitle: '${p.zikrs.length} Items',
                                pxH: pxH,
                                pxW: pxW,
                                onEdit: () => _openPresetEditor(
                                  context,
                                  index: i,
                                  existing: p,
                                ),
                                onTap: () async {
                                  final counter = CounterController()
                                    ..setZikrs(p.zikrs);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => CustomCounterScreen(
                                        counter: counter,
                                        title: p.name,
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _openPresetEditor(
    BuildContext context, {
    int? index,
    PresetModel? existing,
  }) async {
    final result = await Navigator.push<_PresetEditResult?>(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => _PresetEditPage(
          name: existing?.name ?? '',
          items: (existing?.zikrs ?? [])
              .map((z) => _EditableZikr(text: z.text, target: z.target))
              .toList(),
          isEditing: index != null,
        ),
      ),
    );

    if (result != null && result.name.isNotEmpty) {
      final pc = context.read<PresetController>();
      final preset = PresetModel(name: result.name, zikrs: result.zikrs);
      index == null
          ? await pc.addPreset(preset)
          : await pc.updatePreset(index, preset);
    }
  }
}

// --- Card Component ---
class _PresetSmallCard extends StatelessWidget {
  final String title, subtitle;
  final double Function(double) pxH, pxW;
  final VoidCallback onEdit, onTap;

  const _PresetSmallCard({
    required this.title,
    required this.subtitle,
    required this.pxH,
    required this.pxW,
    required this.onEdit,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: pxH(40)),
        padding: EdgeInsets.all(pxH(60)),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(pxH(40)),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.philosopher(
                      color: Colors.white,
                      fontSize: pxH(75),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.philosopher(
                      color: Colors.white24,
                      fontSize: pxH(45),
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: onEdit,
              icon: Icon(Icons.edit_note_rounded),
              color: Colors.white38,
              iconSize: pxH(90),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Edit Screen ---
class _PresetEditPage extends StatefulWidget {
  final String name;
  final List<_EditableZikr> items;
  final bool isEditing;

  const _PresetEditPage({
    required this.name,
    required this.items,
    required this.isEditing,
  });

  @override
  State<_PresetEditPage> createState() => _PresetEditPageState();
}

class _PresetEditPageState extends State<_PresetEditPage> {
  late List<_EditableZikr> _items;
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _items = widget.items;
    _nameController = TextEditingController(text: widget.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1E1E1E), Color(0xFF121212)],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final scale = math.min(
                constraints.maxWidth / 1440.0,
                constraints.maxHeight / 2880.0,
              );
              double pxW(double v) => v * scale;
              double pxH(double v) => v * scale;

              return Stack(
                children: [
                  // TOP BAR (Monochrome Save/Cancel)
                  Positioned(
                    left: pxW(100),
                    top: pxH(150),
                    right: pxW(100),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Text(
                            'CANCEL',
                            style: GoogleFonts.philosopher(
                              color: Colors.white38,
                              fontSize: pxH(50),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          widget.isEditing ? 'EDIT PRESET' : 'NEW PRESET',
                          style: GoogleFonts.philosopher(
                            fontSize: pxH(70),
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 2,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            final zikrs = _items
                                .where((e) => e.textController.text.isNotEmpty)
                                .map(
                                  (e) => ZikrItem(
                                    text: e.textController.text,
                                    target:
                                        int.tryParse(e.countController.text) ??
                                        33,
                                  ),
                                )
                                .toList();
                            Navigator.pop(
                              context,
                              _PresetEditResult(
                                name: _nameController.text,
                                zikrs: zikrs,
                              ),
                            );
                          },
                          child: Text(
                            'SAVE',
                            style: GoogleFonts.philosopher(
                              color: Colors.white,
                              fontSize: pxH(50),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // FORM CONTENT
                  Positioned.fill(
                    top: pxH(400),
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: pxW(100)),
                      child: Column(
                        children: [
                          TextField(
                            controller: _nameController,
                            style: GoogleFonts.philosopher(
                              color: Colors.white,
                              fontSize: pxH(80),
                            ),
                            decoration: InputDecoration(
                              labelText: 'PRESET NAME',
                              labelStyle: TextStyle(
                                color: Colors.white30,
                                fontSize: pxH(40),
                              ),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white10),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white70),
                              ),
                            ),
                          ),
                          SizedBox(height: pxH(80)),
                          ...List.generate(_items.length, (i) {
                            final item = _items[i];
                            return Container(
                              margin: EdgeInsets.only(bottom: pxH(30)),
                              padding: EdgeInsets.all(pxH(40)),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.03),
                                borderRadius: BorderRadius.circular(pxH(30)),
                                border: Border.all(color: Colors.white10),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: TextField(
                                      controller: item.textController,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                      decoration: const InputDecoration(
                                        hintText: 'Zikr',
                                        border: InputBorder.none,
                                        hintStyle: TextStyle(
                                          color: Colors.white24,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 1,
                                    height: pxH(60),
                                    color: Colors.white10,
                                  ),
                                  Expanded(
                                    child: TextField(
                                      controller: item.countController,
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.number,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () =>
                                        setState(() => _items.removeAt(i)),
                                    child: Icon(
                                      Icons.close_rounded,
                                      color: Colors.white24,
                                      size: pxH(70),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                          SizedBox(height: pxH(40)),
                          TextButton.icon(
                            onPressed: () => setState(
                              () => _items.add(
                                _EditableZikr(text: '', target: 33),
                              ),
                            ),
                            icon: Icon(
                              Icons.add_circle_outline,
                              color: Colors.white38,
                              size: pxH(60),
                            ),
                            label: Text(
                              'ADD NEW LINE',
                              style: GoogleFonts.philosopher(
                                color: Colors.white38,
                                fontSize: pxH(45),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
