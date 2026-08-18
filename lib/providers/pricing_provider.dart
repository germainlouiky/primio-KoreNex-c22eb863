import 'package:flutter/foundation.dart';
import '../models/tool_item.dart';
import '../services/procurement_service.dart';

class PricingProvider extends ChangeNotifier {
  final ProcurementService _service;

  PricingProvider({required ProcurementService service}) : _service = service;

  List<PricingTier> _tiers = [];
  List<PricingTier> get tiers => _tiers;

  bool _isAnnual = false;
  bool get isAnnual => _isAnnual;

  void loadTiers() {
    _tiers = _service.getPricingTiers();
    notifyListeners();
  }

  void toggleBilling() {
    _isAnnual = !_isAnnual;
    notifyListeners();
  }
}
