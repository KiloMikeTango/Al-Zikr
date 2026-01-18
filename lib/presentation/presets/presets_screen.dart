// lib/presentation/presets/presets_screen.dart
import 'package:al_zikr/models/presnt_model.dart';
import 'package:flutter/material.dart';
import '../../controllers/preset_controller.dart';
import '../../widgets/zikr_card.dart';
import '../../core/constants/colors.dart';

class PresetsScreen extends StatefulWidget {
  const PresetsScreen({super.key});

  @override
  State<PresetsScreen> createState() => _PresetsScreenState();
}

class _PresetsScreenState extends State<PresetsScreen> {
  final PresetController _controller = PresetController();

  @override
  void initState() {
    super.initState();
    _loadPresets();
  }

  Future<void> _loadPresets() async {
    final presets = await _controller.loadPresets();
    setState(() {});
  }

  void _createPreset() {
    // Simplified: create preset name input then add zikrs similar to custom
    // For full impl, use multi-step dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Preset creation dialog would go here')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: AppBar(
        title: const Text('MY PRESETS', style: TextStyle(color: AppColors.textWhite)),
        backgroundColor: Colors.transparent,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createPreset,
        backgroundColor: AppColors.accentGreen,
        child: const Icon(Icons.add, color: AppColors.primaryBlack),
      ),
      body: FutureBuilder<List<PresetModel>>(
        future: _controller.loadPresets(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final presets = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: presets.length,
            itemBuilder: (context, index) {
              final preset = presets[index];
              return ZikrCard(
                title: preset.name,
                icon: Icons.play_arrow,
                isDesktop: MediaQuery.of(context).size.width > 800,
                onTap: () {
                  // Navigate to preset counter
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Play preset: ${preset.name}')),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
