import 'package:al_zikr/models/preset_model.dart';
import 'package:al_zikr/models/zikr_items.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/preset_controller.dart';
import '../../controllers/counter_controller.dart';
import '../../widgets/zikr_card.dart';
import '../custom/custom_counter_screen.dart';

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
      appBar: AppBar(title: const Text('MY PRESETS')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createPresetFlow(context),
        child: const Icon(Icons.add),
      ),
      body: c.presets.isEmpty
          ? const Center(child: Text('No presets yet'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: c.presets.length,
              itemBuilder: (_, i) {
                final preset = c.presets[i];
                return ZikrCard(
                  icon: Icons.play_arrow,
                  title: preset.name,
                  onTap: () {
                    final counter = CounterController()..setZikrs(preset.zikrs);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CustomCounterScreen(
                          counter: counter,
                          title: preset.name, // <-- pass name here
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }

  Future<void> _createPresetFlow(BuildContext context) async {
    final presetController = context.read<PresetController>();

    // 1) ask for preset name
    final name = await _askPresetName(context);
    if (name == null || name.trim().isEmpty) return;

    // 2) build zikr list in a bottom sheet
    final zikrs = await _buildZikrList(context);
    if (zikrs == null || zikrs.isEmpty) return;

    // 3) save
    final preset = PresetModel(name: name.trim(), zikrs: zikrs);
    await presetController.addPreset(preset);
  }

  Future<String?> _askPresetName(BuildContext context) async {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Preset name'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'After Fajr'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<List<ZikrItem>?> _buildZikrList(BuildContext context) async {
    final items = <ZikrItem>[];
    final textController = TextEditingController();
    final countController = TextEditingController();

    return showModalBottomSheet<List<ZikrItem>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: 16 + MediaQuery.of(ctx).viewInsets.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Add Zikr to preset'),
                  const SizedBox(height: 12),
                  TextField(
                    controller: textController,
                    decoration: const InputDecoration(
                      labelText: 'Zikr text (Arabic)',
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: countController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Target count',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          final text = textController.text.trim();
                          final target =
                              int.tryParse(countController.text.trim()) ?? 0;
                          if (text.isEmpty || target <= 0) return;

                          items.add(ZikrItem(text: text, target: target));
                          textController.clear();
                          countController.clear();
                          setState(() {});
                        },
                        child: const Text('Add Zikr'),
                      ),
                      const SizedBox(width: 16),
                      Text('${items.length} added'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 200,
                    child: items.isEmpty
                        ? const Center(child: Text('No items yet'))
                        : ListView.builder(
                            itemCount: items.length,
                            itemBuilder: (_, i) {
                              final z = items[i];
                              return ListTile(
                                title: Text(z.text),
                                subtitle: Text('${z.target}x'),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    items.removeAt(i);
                                    setState(() {});
                                  },
                                ),
                              );
                            },
                          ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: items.isEmpty
                            ? null
                            : () => Navigator.pop(ctx, items),
                        child: const Text('Save preset'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
