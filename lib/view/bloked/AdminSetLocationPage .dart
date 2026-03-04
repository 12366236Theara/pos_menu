import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:pos_menu/controller/ShopLocationProvider.dart';

class AdminSetLocationPage extends StatefulWidget {
  const AdminSetLocationPage({super.key});

  @override
  State<AdminSetLocationPage> createState() => _AdminSetLocationPageState();
}

class _AdminSetLocationPageState extends State<AdminSetLocationPage> {
  final _formKey = GlobalKey<FormState>();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();
  final _radiusController = TextEditingController(text: '50');

  @override
  void initState() {
    super.initState();
    // Load existing location if available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<ShopLocationProvider>();
      if (provider.location != null) {
        _latitudeController.text = provider.location!.latitude.toString();
        _longitudeController.text = provider.location!.longitude.toString();
        _radiusController.text = provider.location!.radiusInMeters.toString();
      }
    });
  }

  @override
  void dispose() {
    _latitudeController.dispose();
    _longitudeController.dispose();
    _radiusController.dispose();
    super.dispose();
  }

  String? _validateLatitude(String? value) {
    if (value == null || value.isEmpty) {
      return 'Latitude is required';
    }
    final number = double.tryParse(value);
    if (number == null) {
      return 'Please enter a valid number';
    }
    if (number < -90 || number > 90) {
      return 'Latitude must be between -90 and 90';
    }
    return null;
  }

  String? _validateLongitude(String? value) {
    if (value == null || value.isEmpty) {
      return 'Longitude is required';
    }
    final number = double.tryParse(value);
    if (number == null) {
      return 'Please enter a valid number';
    }
    if (number < -180 || number > 180) {
      return 'Longitude must be between -180 and 180';
    }
    return null;
  }

  String? _validateRadius(String? value) {
    if (value == null || value.isEmpty) {
      return 'Radius is required';
    }
    final number = double.tryParse(value);
    if (number == null) {
      return 'Please enter a valid number';
    }
    if (number <= 0) {
      return 'Radius must be greater than 0';
    }
    if (number > 10000) {
      return 'Radius must not exceed 10,000 meters';
    }
    return null;
  }

  Future<void> _handleSave() async {
    if (_formKey.currentState!.validate()) {
      final latitude = double.parse(_latitudeController.text);
      final longitude = double.parse(_longitudeController.text);
      final radius = double.parse(_radiusController.text);

      final provider = context.read<ShopLocationProvider>();
      final success = await provider.saveLocation(latitude, longitude, radius);

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Location saved successfully'), backgroundColor: Colors.green, duration: Duration(seconds: 2)));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(provider.errorMessage ?? 'Failed to save location'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Set Shop Location'), backgroundColor: Theme.of(context).colorScheme.inversePrimary),
      body: Consumer<ShopLocationProvider>(
        builder: (context, provider, child) {
          return Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header card
                      Card(
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.location_on, color: Theme.of(context).colorScheme.primary, size: 28),
                                  const SizedBox(width: 12),
                                  const Text('Shop Location Settings', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Set the geographical coordinates and radius for your shop location. Customers will only be able to access the menu within this radius.',
                                style: TextStyle(color: Colors.grey[600], fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Latitude field
                      TextFormField(
                        controller: _latitudeController,
                        decoration: InputDecoration(
                          labelText: 'Latitude',
                          hintText: 'e.g., 11.5564',
                          prefixIcon: const Icon(Icons.north),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          helperText: 'Range: -90 to 90',
                        ),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^-?\d*\.?\d*'))],
                        validator: _validateLatitude,
                      ),
                      const SizedBox(height: 20),

                      // Longitude field
                      TextFormField(
                        controller: _longitudeController,
                        decoration: InputDecoration(
                          labelText: 'Longitude',
                          hintText: 'e.g., 104.9282',
                          prefixIcon: const Icon(Icons.east),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          helperText: 'Range: -180 to 180',
                        ),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^-?\d*\.?\d*'))],
                        validator: _validateLongitude,
                      ),
                      const SizedBox(height: 20),

                      // Radius field
                      TextFormField(
                        controller: _radiusController,
                        decoration: InputDecoration(
                          labelText: 'Radius (meters)',
                          hintText: 'e.g., 50',
                          prefixIcon: const Icon(Icons.radio_button_checked),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          helperText: 'Maximum distance customers can be from shop',
                        ),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                        validator: _validateRadius,
                      ),
                      const SizedBox(height: 32),

                      // Current location info card
                      if (provider.hasLocation)
                        Card(
                          color: Colors.blue[50],
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.info_outline, color: Colors.blue[700], size: 20),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Current Location',
                                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[700]),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text('Lat: ${provider.location!.latitude}', style: const TextStyle(fontSize: 13)),
                                Text('Lng: ${provider.location!.longitude}', style: const TextStyle(fontSize: 13)),
                                Text('Radius: ${provider.location!.radiusInMeters}m', style: const TextStyle(fontSize: 13)),
                              ],
                            ),
                          ),
                        ),
                      const SizedBox(height: 16),

                      // Save button
                      ElevatedButton(
                        onPressed: provider.isLoading ? null : _handleSave,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: provider.isLoading
                            ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                            : const Text('Save Location', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              ),

              // Loading overlay
              if (provider.isLoading)
                Container(
                  color: Colors.black26,
                  child: const Center(child: CircularProgressIndicator()),
                ),
            ],
          );
        },
      ),
    );
  }
}
