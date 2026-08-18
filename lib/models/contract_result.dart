import 'package:flutter/material.dart';

class ContractResult {
  final String id;
  final String title;
  final String agency;
  final String value;
  final double valueRaw;
  final String naicsCode;
  final String setAside;
  final String dueDate;
  final String postedDate;
  final int winScore;
  final String synopsis;
  final String type;
  bool isSaved;

  ContractResult({
    required this.id,
    required this.title,
    required this.agency,
    required this.value,
    required this.valueRaw,
    required this.naicsCode,
    required this.setAside,
    required this.dueDate,
    required this.postedDate,
    required this.winScore,
    required this.synopsis,
    required this.type,
    this.isSaved = false,
  });

  Color get winScoreColor {
    if (winScore >= 75) return const Color(0xFF10B981);
    if (winScore >= 50) return const Color(0xFFF59E0B);
    return const Color(0xFFEF4444);
  }

  String get winScoreLabel {
    if (winScore >= 75) return 'High';
    if (winScore >= 50) return 'Medium';
    return 'Low';
  }

  String get setAsideShort {
    switch (setAside) {
      case 'Small Business':
        return 'SB';
      case 'Service-Disabled Veteran':
        return 'SDVOSB';
      case '8(a) Program':
        return '8(a)';
      case 'Woman-Owned Small Business':
        return 'WOSB';
      case 'HUBZone':
        return 'HUBZone';
      default:
        return 'Full & Open';
    }
  }
}
