import 'package:flutter/material.dart';
import '../models/contract_result.dart';

enum ContractSortOption { dueDate, winScore, value, postedDate }

enum ContractTab { search, saved, alerts }

class ContractsProvider extends ChangeNotifier {
  String _query = '';
  String _selectedAgency = 'All Agencies';
  String _selectedSetAside = 'All Types';
  String _selectedValue = 'Any Value';
  ContractSortOption _sortOption = ContractSortOption.winScore;
  ContractTab _activeTab = ContractTab.search;
  bool _isLoading = false;
  bool _hasSearched = false;

  final List<ContractResult> _allContracts = _mockContracts();
  List<ContractResult> _results = [];

  // Getters
  String get query => _query;
  String get selectedAgency => _selectedAgency;
  String get selectedSetAside => _selectedSetAside;
  String get selectedValue => _selectedValue;
  ContractSortOption get sortOption => _sortOption;
  ContractTab get activeTab => _activeTab;
  bool get isLoading => _isLoading;
  bool get hasSearched => _hasSearched;
  List<ContractResult> get results => _results;
  List<ContractResult> get savedContracts =>
      _allContracts.where((c) => c.isSaved).toList();

  int get alertCount => 3;

  final List<String> agencies = [
    'All Agencies',
    'Department of Defense',
    'Department of Homeland Security',
    'Department of Veterans Affairs',
    'General Services Administration',
    'Department of Health & Human Services',
    'NASA',
    'Department of Energy',
    'Army Corps of Engineers',
  ];

  final List<String> setAsideTypes = [
    'All Types',
    'Small Business',
    'Service-Disabled Veteran',
    '8(a) Program',
    'Woman-Owned Small Business',
    'HUBZone',
    'Full & Open',
  ];

  final List<String> valueRanges = [
    'Any Value',
    'Under \$100K',
    '\$100K – \$500K',
    '\$500K – \$2M',
    '\$2M – \$10M',
    'Over \$10M',
  ];

  void setQuery(String value) {
    _query = value;
    notifyListeners();
  }

  void setAgency(String value) {
    _selectedAgency = value;
    if (_hasSearched) _applyFilters();
    notifyListeners();
  }

  void setSetAside(String value) {
    _selectedSetAside = value;
    if (_hasSearched) _applyFilters();
    notifyListeners();
  }

  void setValue(String value) {
    _selectedValue = value;
    if (_hasSearched) _applyFilters();
    notifyListeners();
  }

  void setSortOption(ContractSortOption option) {
    _sortOption = option;
    _sortResults();
    notifyListeners();
  }

  void setActiveTab(ContractTab tab) {
    _activeTab = tab;
    notifyListeners();
  }

  void toggleSaved(ContractResult contract) {
    contract.isSaved = !contract.isSaved;
    notifyListeners();
  }

  Future<void> search() async {
    _isLoading = true;
    _hasSearched = true;
    notifyListeners();

    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 900));

    _applyFilters();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadInitialContracts() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 700));

    _results = List.from(_allContracts);
    _sortResults();
    _hasSearched = true;
    _isLoading = false;
    notifyListeners();
  }

  void _applyFilters() {
    _results = _allContracts.where((c) {
      final matchesQuery = _query.isEmpty ||
          c.title.toLowerCase().contains(_query.toLowerCase()) ||
          c.agency.toLowerCase().contains(_query.toLowerCase()) ||
          c.naicsCode.contains(_query) ||
          c.synopsis.toLowerCase().contains(_query.toLowerCase());

      final matchesAgency =
          _selectedAgency == 'All Agencies' || c.agency == _selectedAgency;

      final matchesSetAside =
          _selectedSetAside == 'All Types' || c.setAside == _selectedSetAside;

      final matchesValue = _matchesValueRange(c.valueRaw);

      return matchesQuery && matchesAgency && matchesSetAside && matchesValue;
    }).toList();

    _sortResults();
  }

  bool _matchesValueRange(double value) {
    switch (_selectedValue) {
      case 'Under \$100K':
        return value < 100000;
      case '\$100K – \$500K':
        return value >= 100000 && value < 500000;
      case '\$500K – \$2M':
        return value >= 500000 && value < 2000000;
      case '\$2M – \$10M':
        return value >= 2000000 && value < 10000000;
      case 'Over \$10M':
        return value >= 10000000;
      default:
        return true;
    }
  }

  void _sortResults() {
    switch (_sortOption) {
      case ContractSortOption.winScore:
        _results.sort((a, b) => b.winScore.compareTo(a.winScore));
        break;
      case ContractSortOption.value:
        _results.sort((a, b) => b.valueRaw.compareTo(a.valueRaw));
        break;
      case ContractSortOption.dueDate:
        _results.sort((a, b) => a.dueDate.compareTo(b.dueDate));
        break;
      case ContractSortOption.postedDate:
        _results.sort((a, b) => b.postedDate.compareTo(a.postedDate));
        break;
    }
  }

  static List<ContractResult> _mockContracts() {
    return [
      ContractResult(
        id: 'c001',
        title: 'Cybersecurity Operations Support Services',
        agency: 'Department of Homeland Security',
        value: '\$4.2M',
        valueRaw: 4200000,
        naicsCode: '541519',
        setAside: 'Small Business',
        dueDate: 'Jul 14, 2026',
        postedDate: 'Jun 20, 2026',
        winScore: 87,
        synopsis:
            'DHS seeks a contractor to provide 24/7 SOC operations, threat intelligence, vulnerability assessment, and incident response support for critical infrastructure protection.',
        type: 'Solicitation',
      ),
      ContractResult(
        id: 'c002',
        title: 'IT Infrastructure Modernization — Cloud Migration',
        agency: 'General Services Administration',
        value: '\$12.8M',
        valueRaw: 12800000,
        naicsCode: '541512',
        setAside: 'Full & Open',
        dueDate: 'Jul 22, 2026',
        postedDate: 'Jun 18, 2026',
        winScore: 72,
        synopsis:
            'GSA requires migration of legacy on-premise systems to FedRAMP-authorized cloud platforms including AWS GovCloud and Azure Government. Includes zero-trust architecture implementation.',
        type: 'Solicitation',
      ),
      ContractResult(
        id: 'c003',
        title: 'Veteran Benefits Management System — Phase III',
        agency: 'Department of Veterans Affairs',
        value: '\$890K',
        valueRaw: 890000,
        naicsCode: '541511',
        setAside: 'Service-Disabled Veteran',
        dueDate: 'Jul 8, 2026',
        postedDate: 'Jun 25, 2026',
        winScore: 91,
        synopsis:
            'VA seeks SDVOSB contractor for continued development and maintenance of the Veterans Benefits Management System, including API integrations with DoD records systems.',
        type: 'Solicitation',
      ),
      ContractResult(
        id: 'c004',
        title: 'Professional Training & Development Services',
        agency: 'Department of Defense',
        value: '\$2.1M',
        valueRaw: 2100000,
        naicsCode: '611430',
        setAside: '8(a) Program',
        dueDate: 'Aug 1, 2026',
        postedDate: 'Jun 22, 2026',
        winScore: 65,
        synopsis:
            'DoD requires comprehensive workforce development services including leadership training, technical skills development, and certification preparation programs for civilian personnel.',
        type: 'Sources Sought',
      ),
      ContractResult(
        id: 'c005',
        title: 'Medical Supplies & Equipment Procurement',
        agency: 'Department of Health & Human Services',
        value: '\$6.5M',
        valueRaw: 6500000,
        naicsCode: '423450',
        setAside: 'Woman-Owned Small Business',
        dueDate: 'Jul 30, 2026',
        postedDate: 'Jun 15, 2026',
        winScore: 78,
        synopsis:
            'HHS seeks a WOSB supplier for federally qualified health centers. Scope includes surgical instruments, diagnostic equipment, PPE, and medical consumables with 48-hour delivery SLA.',
        type: 'Solicitation',
      ),
      ContractResult(
        id: 'c006',
        title: 'Facility Management & Maintenance Services',
        agency: 'Army Corps of Engineers',
        value: '\$3.4M',
        valueRaw: 3400000,
        naicsCode: '561210',
        setAside: 'HUBZone',
        dueDate: 'Aug 10, 2026',
        postedDate: 'Jun 12, 2026',
        winScore: 58,
        synopsis:
            'USACE requires comprehensive facility management for 14 district offices including HVAC, electrical, plumbing, janitorial, and grounds maintenance across the southwestern region.',
        type: 'Solicitation',
      ),
      ContractResult(
        id: 'c007',
        title: 'Satellite Data Analytics Platform',
        agency: 'NASA',
        value: '\$18.7M',
        valueRaw: 18700000,
        naicsCode: '541715',
        setAside: 'Small Business',
        dueDate: 'Aug 15, 2026',
        postedDate: 'Jun 10, 2026',
        winScore: 61,
        synopsis:
            'NASA Goddard seeks an advanced data analytics platform for processing and visualizing terabyte-scale satellite imagery datasets, supporting climate research and Earth observation missions.',
        type: 'RFP',
      ),
      ContractResult(
        id: 'c008',
        title: 'Environmental Remediation Services — Site 12',
        agency: 'Department of Energy',
        value: '\$430K',
        valueRaw: 430000,
        naicsCode: '562910',
        setAside: 'Small Business',
        dueDate: 'Jul 18, 2026',
        postedDate: 'Jun 27, 2026',
        winScore: 83,
        synopsis:
            'DOE requires environmental remediation at a legacy nuclear site including soil sampling, groundwater monitoring, hazardous waste removal, and EPA reporting compliance.',
        type: 'Solicitation',
      ),
    ];
  }
}
