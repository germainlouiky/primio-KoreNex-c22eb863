import 'package:flutter/foundation.dart';
import '../models/tool_item.dart';
import '../services/procurement_service.dart';

class DashboardProvider extends ChangeNotifier {
  final ProcurementService _service;

  DashboardProvider({required ProcurementService service}) : _service = service;

  List<ToolItem> _tools = [];
  List<ToolItem> get tools => _tools;

  String _userName = 'Alex';
  String get userName => _userName;

  int _activeProposals = 12;
  int get activeProposals => _activeProposals;

  int _upcomingDeadlines = 5;
  int get upcomingDeadlines => _upcomingDeadlines;

  double _winRate = 68.0;
  double get winRate => _winRate;

  void loadDashboard() {
    _tools = _service.getTools();
    _userName = 'Alex';
    _activeProposals = 12;
    _upcomingDeadlines = 5;
    _winRate = 68.0;
    notifyListeners();
  }
}
