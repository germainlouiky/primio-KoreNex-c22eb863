import 'dart:math';
import 'package:flutter/material.dart';
import '../../theme/theme.dart';

// ── Data model ────────────────────────────────────────────────────────────────

class _Category {
  final String label;
  final IconData icon;
  final Color color;

  const _Category(this.label, this.icon, this.color);
}

const _categories = [
  _Category('Cars',      Icons.directions_car_rounded,   Color(0xFF3B82F6)),
  _Category('Trees',     Icons.park_rounded,              Color(0xFF22C55E)),
  _Category('Buildings', Icons.business_rounded,          Color(0xFFF59E0B)),
  _Category('Animals',   Icons.pets_rounded,              Color(0xFFA855F7)),
  _Category('Planes',    Icons.flight_rounded,            Color(0xFF06B6D4)),
  _Category('Ships',     Icons.directions_boat_rounded,   Color(0xFFEC4899)),
];

// ── Public widget ─────────────────────────────────────────────────────────────

/// Shows a 3×3 image-grid CAPTCHA challenge.
/// Calls [onVerified] with `true` once the user selects the correct tiles and
/// taps Verify, or `false` if they fail and the challenge resets.
class CaptchaWidget extends StatefulWidget {
  final ValueChanged<bool> onVerified;

  const CaptchaWidget({super.key, required this.onVerified});

  @override
  State<CaptchaWidget> createState() => _CaptchaWidgetState();
}

class _CaptchaWidgetState extends State<CaptchaWidget>
    with SingleTickerProviderStateMixin {
  // ── State ────────────────────────────────────────────────────────────────

  late _Category _target;
  late List<_Category> _grid; // 9 tiles
  late Set<int> _correct;      // indices that are the target category
  final Set<int> _selected = {};
  bool _verified = false;
  bool _failed = false;

  late AnimationController _shakeController;
  late Animation<double> _shakeAnim;

  final _rng = Random();

  // ── Lifecycle ────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _shakeAnim = Tween<double>(begin: 0, end: 8).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    )..addStatusListener((s) {
        if (s == AnimationStatus.completed) _shakeController.reverse();
      });
    _buildChallenge();
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  // ── Challenge builder ────────────────────────────────────────────────────

  void _buildChallenge() {
    // Pick a random target category
    _target = _categories[_rng.nextInt(_categories.length)];

    // Pick 3 unique positions for correct tiles
    final positions = List.generate(9, (i) => i)..shuffle(_rng);
    _correct = positions.take(3).toSet();

    // Build decoy pool (all categories except target, repeated enough)
    final decoys = _categories.where((c) => c.label != _target.label).toList()
      ..shuffle(_rng);

    _grid = List.generate(9, (i) {
      if (_correct.contains(i)) return _target;
      return decoys[(i % decoys.length)];
    });

    _selected.clear();
    _failed = false;
  }

  // ── Verification ──────────────────────────────────────────────────────────

  void _verify() {
    final isCorrect =
        _selected.length == _correct.length &&
        _selected.every((i) => _correct.contains(i));

    if (isCorrect) {
      setState(() => _verified = true);
      widget.onVerified(true);
    } else {
      setState(() => _failed = true);
      _shakeController.forward();
      Future.delayed(const Duration(milliseconds: 900), () {
        if (mounted) {
          setState(() {
            _buildChallenge();
          });
        }
      });
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    if (_verified) return _VerifiedBadge(colors: colors, text: text);

    return AnimatedBuilder(
      animation: _shakeAnim,
      builder: (context, child) {
        final dx = _failed
            ? _shakeAnim.value * (_shakeController.status == AnimationStatus.forward ? 1 : -1)
            : 0.0;
        return Transform.translate(offset: Offset(dx, 0), child: child);
      },
      child: Container(
        decoration: BoxDecoration(
          color: colors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          border: Border.all(
            color: _failed ? colors.error : colors.outlineVariant,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Header ───────────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacingMd,
                vertical: AppTheme.spacingSm,
              ),
              decoration: BoxDecoration(
                color: colors.surfaceContainer,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppTheme.radiusMedium - 1),
                  topRight: Radius.circular(AppTheme.radiusMedium - 1),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.security_rounded,
                    size: AppTheme.iconSm,
                    color: colors.primary,
                  ),
                  const SizedBox(width: AppTheme.spacingSm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'I\'m not a robot',
                          style: text.labelMedium?.copyWith(
                            color: colors.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Select all images containing: ${_target.label}',
                          style: text.labelSmall?.copyWith(
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Target icon preview
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: _target.color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                      border: Border.all(
                        color: _target.color.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Icon(_target.icon, size: 18, color: _target.color),
                  ),
                ],
              ),
            ),

            // ── Failure message ───────────────────────────────────────────
            if (_failed)
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppTheme.spacingMd, AppTheme.spacingSm, AppTheme.spacingMd, 0,
                ),
                child: Text(
                  'Please try again — select only the ${_target.label.toLowerCase()} images.',
                  style: text.labelSmall?.copyWith(color: colors.error),
                  textAlign: TextAlign.center,
                ),
              ),

            // ── Grid ─────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(AppTheme.spacingSm),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: AppTheme.spacingXs,
                  mainAxisSpacing: AppTheme.spacingXs,
                ),
                itemCount: 9,
                itemBuilder: (_, i) => _Tile(
                  category: _grid[i],
                  isSelected: _selected.contains(i),
                  onTap: () => setState(() {
                    if (_selected.contains(i)) {
                      _selected.remove(i);
                    } else {
                      _selected.add(i);
                    }
                  }),
                ),
              ),
            ),

            // ── Footer ───────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppTheme.spacingMd, 0, AppTheme.spacingMd, AppTheme.spacingMd,
              ),
              child: Row(
                children: [
                  TextButton.icon(
                    onPressed: () => setState(_buildChallenge),
                    icon: Icon(
                      Icons.refresh_rounded,
                      size: AppTheme.iconSm,
                      color: colors.onSurfaceVariant,
                    ),
                    label: Text(
                      'New challenge',
                      style: text.labelSmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                  const Spacer(),
                  FilledButton(
                    onPressed: _selected.isEmpty ? null : _verify,
                    style: FilledButton.styleFrom(
                      minimumSize: Size.zero,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacingMd,
                        vertical: AppTheme.spacingSm,
                      ),
                    ),
                    child: Text('Verify', style: text.labelMedium),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Tile ──────────────────────────────────────────────────────────────────────

class _Tile extends StatelessWidget {
  final _Category category;
  final bool isSelected;
  final VoidCallback onTap;

  const _Tile({
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: isSelected
              ? category.color.withValues(alpha: 0.18)
              : colors.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
          border: Border.all(
            color: isSelected ? category.color : colors.outlineVariant,
            width: isSelected ? 2.0 : 1.0,
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    category.icon,
                    size: AppTheme.iconLg,
                    color: isSelected
                        ? category.color
                        : colors.onSurfaceVariant,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    category.label,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: isSelected
                              ? category.color
                              : colors.onSurfaceVariant,
                          fontSize: 9,
                        ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Positioned(
                top: 4,
                right: 4,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: category.color,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, size: 10, color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ── Verified badge ────────────────────────────────────────────────────────────

class _VerifiedBadge extends StatelessWidget {
  final ColorScheme colors;
  final TextTheme text;

  const _VerifiedBadge({required this.colors, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingMd,
        vertical: AppTheme.spacingMd,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF22C55E).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        border: Border.all(color: const Color(0xFF22C55E).withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle_rounded, color: Color(0xFF22C55E), size: 20),
          const SizedBox(width: AppTheme.spacingSm),
          Text(
            'Verification complete — you\'re not a robot! ✓',
            style: text.labelMedium?.copyWith(color: const Color(0xFF22C55E)),
          ),
        ],
      ),
    );
  }
}
