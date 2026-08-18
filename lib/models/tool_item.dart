import 'package:flutter/material.dart';

class ToolFeature {
  final IconData icon;
  final String title;
  final String description;

  const ToolFeature({
    required this.icon,
    required this.title,
    required this.description,
  });
}

class ToolItem {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final Color accentColor;
  final bool isAvailable;
  final String tagline;
  final List<ToolFeature> features;
  final List<String> useCases;

  const ToolItem({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.accentColor,
    this.isAvailable = true,
    this.tagline = '',
    this.features = const [],
    this.useCases = const [],
  });
}

class PricingTier {
  final String name;
  final String price;
  final String period;
  final List<String> features;
  final bool isPopular;
  final String ctaLabel;
  final String subtitle;
  final String annualPrice;
  final String description;
  final Color? badgeColor;

  const PricingTier({
    required this.name,
    required this.price,
    required this.period,
    required this.features,
    this.isPopular = false,
    required this.ctaLabel,
    this.subtitle = '',
    this.annualPrice = '',
    this.description = '',
    this.badgeColor,
  });
}
