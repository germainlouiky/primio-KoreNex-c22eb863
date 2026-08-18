import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/tool_item.dart';
import '../services/procurement_service.dart';

class DashboardProvider extends ChangeNotifier {
  final ProcurementService _service;

  DashboardProvider({required ProcurementService service}) : _service = service;

  List<ToolItem> _tools = [];
  List<ToolItem> get tools => _tools;

  String get userName {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return 'there';
    final email = user.email ?? '';
    // Use the part before @ as a friendly name
    final name = email.split('@').first;
    if (name.isEmpty) return 'there';
    return name[0].toUpperCase() + name.substring(1);
  }

  int _activeProposals = 12;
  int get activeProposals => _activeProposals;

  int _upcomingDeadlines = 5;
  int get upcomingDeadlines => _upcomingDeadlines;

  double _winRate = 68.0;
  double get winRate => _winRate;

  void loadDashboard() {
    _tools = _service.getTools();
    _activeProposals = 12;
    _upcomingDeadlines = 5;
    _winRate = 68.0;
    notifyListeners();
  }
}
