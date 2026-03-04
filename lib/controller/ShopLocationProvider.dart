import 'package:flutter/foundation.dart';
import 'package:pos_menu/model/location/shop_location_model.dart';

class ShopLocationProvider extends ChangeNotifier {
  ShopLocationModel? _location;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  ShopLocationModel? get location => _location;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasLocation => _location != null;

  // Save location
  Future<bool> saveLocation(double latitude, double longitude, double radius) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Create location model
      final newLocation = ShopLocationModel(latitude: latitude, longitude: longitude, radiusInMeters: radius);

      // TODO: Call your API here to save to backend
      // Example:
      // final response = await apiService.saveShopLocation(newLocation.toJson());
      // if (!response.success) throw Exception(response.message);

      // Simulate API delay
      await Future.delayed(const Duration(milliseconds: 500));

      _location = newLocation;
      _isLoading = false;
      notifyListeners();

      return true;
    } catch (e) {
      _errorMessage = 'Failed to save location: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Load location from backend
  Future<void> loadLocation() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // TODO: Call your API here to load from backend
      // Example:
      // final response = await apiService.getShopLocation();
      // _location = ShopLocationModel.fromJson(response.data);

      // Simulate API delay
      await Future.delayed(const Duration(milliseconds: 500));

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load location: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Clear location
  void clearLocation() {
    _location = null;
    _errorMessage = null;
    notifyListeners();
  }

  // Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
