import 'package:flutter/material.dart';
import '../theme/theme.dart';

class TeamScreen extends StatefulWidget {
  const TeamScreen({super.key});

  @override
  State<TeamScreen> createState() => _TeamScreenState();
}

class _TeamScreenState extends State<TeamScreen> {
  final List<_Member> _members = [
    _Member('Jane Doe', 'jane.doe@acme-corp.com', 'Admin', true),
    _Member('Marcus Johnson', 'marcus.j@acme-corp.com', 'Editor', false),
    _Member('Sarah Kim', 'sarah.k@acme-corp.com', 'Viewer', false),
    _Member('David Ruiz', 'david.r@acme-corp.com', 'Editor', false),
  ];

  void _showInviteSheet() {
    final emailController = TextEditingController();
    String selectedRole = 'Viewer';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final colors = Theme.of(ctx).colorScheme;
        final text = Theme.of(ctx).textTheme;
        final appColors = Theme.of(ctx).extension<AppColorsExtension>()!;

        return StatefulBuilder(builder: (ctx, setModalState) {
          return Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
            child: Container(
              margin: const EdgeInsets.all(AppTheme.spacingMd),
              padding: const EdgeInsets.all(AppTheme.spacingLg),
              decoration: BoxDecoration(
                color: appColors.toolCardBg,
                borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                border: Border.all(color: colors.outlineVariant.withOpacity(AppTheme.opacityOverlay)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Invite Team Member', style: text.titleLarge),
                  const SizedBox(height: AppTheme.spacingXs),
                  Text('They\'ll receive an email invitation to join.', style: text.bodySmall?.copyWith(color: appColors.subtleText)),
                  const SizedBox(height: AppTheme.spacingLg),
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email Address',
                      hintText: 'colleague@company.com',
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingMd),
                  Text('Role', style: text.labelMedium),
                  const SizedBox(height: AppTheme.spacingSm),
                  for (final role in ['Admin', 'Editor', 'Viewer'])
                    InkWell(
                      onTap: () => setModalState(() => selectedRole = role),
                      borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingSm),
                        child: Row(
                          children: [
                            Icon(
                              selectedRole == role ? Icons.radio_button_checked_rounded : Icons.radio_button_unchecked_rounded,
                              color: selectedRole == role ? colors.primary : appColors.subtleText,
                              size: AppTheme.iconMd,
                            ),
                            const SizedBox(width: AppTheme.spacingMd),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(role, style: text.bodyMedium),
                                  Text(
                                    role == 'Admin' ? 'Full access to all features' : role == 'Editor' ? 'Can create and edit contracts' : 'Can view only',
                                    style: text.bodySmall?.copyWith(color: appColors.subtleText),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: AppTheme.spacingLg),
                  SizedBox(
                    width: double.infinity,
                    height: AppTheme.buttonHeight,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Invitation sent to ${emailController.text.isEmpty ? 'team member' : emailController.text}')),
                        );
                      },
                      child: const Text('Send Invitation'),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final appColors = Theme.of(context).extension<AppColorsExtension>()!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Team Members'),
        leading: const BackButton(),
        actions: [
          TextButton.icon(
            onPressed: _showInviteSheet,
            icon: Icon(Icons.person_add_outlined, size: AppTheme.iconSm, color: colors.primary),
            label: Text('Invite', style: text.labelMedium?.copyWith(color: colors.primary)),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppTheme.spacingMd),
        children: [
          // Usage indicator
          Container(
            padding: const EdgeInsets.all(AppTheme.spacingMd),
            decoration: BoxDecoration(
              color: colors.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              border: Border.all(color: colors.primary.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                Icon(Icons.group_rounded, color: colors.primary, size: AppTheme.iconMd),
                const SizedBox(width: AppTheme.spacingMd),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${_members.length} of 10 seats used', style: text.bodyMedium),
                      const SizedBox(height: AppTheme.spacingXs),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: _members.length / 10,
                          backgroundColor: colors.primary.withOpacity(0.15),
                          color: colors.primary,
                          minHeight: 6,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.spacingLg),
          Text(
            'MEMBERS',
            style: text.labelSmall?.copyWith(color: appColors.subtleText, letterSpacing: 1.2),
          ),
          const SizedBox(height: AppTheme.spacingMd),
          Container(
            decoration: BoxDecoration(
              color: appColors.toolCardBg,
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              border: Border.all(color: colors.outlineVariant.withOpacity(AppTheme.opacityOverlay)),
            ),
            child: Column(
              children: List.generate(_members.length, (i) {
                final member = _members[i];
                final isLast = i == _members.length - 1;
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(AppTheme.spacingMd),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: colors.primary.withOpacity(0.15),
                            child: Text(
                              member.name.split(' ').map((p) => p[0]).take(2).join(),
                              style: text.labelMedium?.copyWith(color: colors.primary),
                            ),
                          ),
                          const SizedBox(width: AppTheme.spacingMd),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Flexible(child: Text(member.name, style: text.bodyMedium, maxLines: 1, overflow: TextOverflow.ellipsis)),
                                    if (member.isCurrentUser) ...[
                                      const SizedBox(width: AppTheme.spacingXs),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: colors.primary.withOpacity(0.15),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text('You', style: text.labelSmall?.copyWith(color: colors.primary)),
                                      ),
                                    ],
                                  ],
                                ),
                                Text(member.email, style: text.bodySmall?.copyWith(color: appColors.subtleText), maxLines: 1, overflow: TextOverflow.ellipsis),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingSm, vertical: 4),
                            decoration: BoxDecoration(
                              color: colors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                            ),
                            child: Text(member.role, style: text.labelSmall?.copyWith(color: colors.primary)),
                          ),
                          if (!member.isCurrentUser) ...[
                            const SizedBox(width: AppTheme.spacingXs),
                            IconButton(
                              icon: Icon(Icons.more_vert_rounded, size: AppTheme.iconSm, color: appColors.subtleText),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Member options for ${member.name} coming soon')),
                                );
                              },
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (!isLast)
                      Divider(
                        height: 1,
                        indent: AppTheme.spacingMd,
                        color: colors.outlineVariant.withOpacity(AppTheme.opacityOverlay),
                      ),
                  ],
                );
              }),
            ),
          ),
          const SizedBox(height: AppTheme.spacingLg),
          SizedBox(
            width: double.infinity,
            height: AppTheme.buttonHeight,
            child: ElevatedButton.icon(
              onPressed: _showInviteSheet,
              icon: const Icon(Icons.person_add_outlined),
              label: const Text('Invite New Member'),
            ),
          ),
          const SizedBox(height: AppTheme.spacingLg),
        ],
      ),
    );
  }
}

class _Member {
  final String name;
  final String email;
  final String role;
  final bool isCurrentUser;

  const _Member(this.name, this.email, this.role, this.isCurrentUser);
}
