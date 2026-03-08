import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class AppProvider extends ChangeNotifier {
  // 1. On récupère l'instance unique du service de stockage
  final StorageService _storageService = StorageService.instance;

  // 2. Propriétés privées (l'état interne)
  bool _isOnboardingComplete = false;
  bool _isInitialized = false;
  bool _isLoading = false;

  // 3. Getters publics (pour que les écrans puissent lire les données)
  bool get isOnboardingComplete => _isOnboardingComplete;
  bool get isInitialized => _isInitialized;
  bool get isLoading => _isLoading;

  // 4. TA MÉTHODE INIT (C'est ici qu'elle doit être)
  Future<void> init() async {
    _isLoading = true;
    notifyListeners(); // On prévient l'UI qu'on commence à charger

    // On attend que le service SharedPreferences s'initialise
    await _storageService.init();

    // On récupère la valeur stockée via le getter du service
    _isOnboardingComplete = _storageService.isOnboardingComplete;

    _isInitialized = true;
    _isLoading = false;
    notifyListeners(); // On prévient l'UI que tout est prêt
  }

  // 5. Autres méthodes demandées par le projet
  Future<void> completeOnboarding() async {
    _isOnboardingComplete = true;
    await _storageService.setOnboardingComplete(true);
    notifyListeners();
  }

  Future<void> resetOnboarding() async {
    _isOnboardingComplete = false;
    await _storageService.setOnboardingComplete(false);
    notifyListeners();
  }
}