import 'package:al_zikr/models/presnt_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/preset_controller.dart';
import '../../controllers/counter_controller.dart';
import '../../widgets/zikr_card.dart';
import '../../widgets/add_zikr_dialog.dart';
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
        onPressed: () async {
          final name = await _askName(context);
          if (name == null || name.isEmpty) return;

          final zikrs = <PresetModel>[];
          // For brevity use single dialog; you can extend to multi-zikr builder
          final items = <PresetModel>[];
        },
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: c.presets.length,
        itemBuilder: (_, i) {
          final preset = c.presets[i];
          return ZikrCard(
            title: preset.name,
            icon: Icons.play_arrow,
            onTap: () {
              final counter = CounterController()..setZikrs(preset.zikrs);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CustomCounterScreen(counter: counter),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<String?> _askName(BuildContext context) async {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Preset name'),
        content: TextField(controller: controller),
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
}
