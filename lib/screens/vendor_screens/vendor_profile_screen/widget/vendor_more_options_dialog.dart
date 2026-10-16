import 'package:flutter/material.dart';
import 'package:nexprime/constant/app_colors.dart';
import 'package:nexprime/routes/app_routes.dart';
import 'package:nexprime/routes/app_routes_key.dart';
import 'package:nexprime/screens/customer_screens/customer_profile_screen/provider/delete_account_provider.dart';
import 'package:nexprime/services/storage/storage_services.dart';
import 'package:nexprime/utils/gap.dart';
import 'package:nexprime/widgets/texts/app_text.dart';

void showVendorMoreOptionsDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (dialogContext) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: AppColors.instance.white,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.instance.green50,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.settings_outlined,
                      color: AppColors.instance.green,
                      size: 22,
                    ),
                  ),
                  const Gap(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          text: "More Options",
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.instance.black500,
                        ),
                        const Gap(height: 2),
                        AppText(
                          text: "Account & preferences",
                          fontSize: 12,
                          color: AppColors.instance.gray400,
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(dialogContext).pop(),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.instance.grayEE,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close_rounded,
                        color: AppColors.instance.gray400,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
              const Gap(height: 16),
              const Divider(height: 1, color: Color(0xFFEEEEEE)),
              const Gap(height: 16),

              // Logout Tile
              _buildOptionTile(
                icon: Icons.logout_rounded,
                iconColor: const Color(0xFFE53935),
                iconBgColor: const Color(0xFFFFEBEE),
                title: "Logout",
                subtitle: "Sign out of your vendor account",
                onTap: () {
                  Navigator.of(dialogContext).pop();
                  _showLogoutConfirmDialog(context);
                },
              ),

              const Gap(height: 12),

              // Delete Account Tile
              _buildOptionTile(
                icon: Icons.delete_outline_rounded,
                iconColor: AppColors.instance.redF7,
                iconBgColor: AppColors.instance.red50,
                title: "Delete Account",
                subtitle: "Permanently remove your account",
                isDestructive: true,
                onTap: () {
                  Navigator.of(dialogContext).pop();
                  _showDeleteAccountConfirmDialog(context);
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}

Widget _buildOptionTile({
  required IconData icon,
  required Color iconColor,
  required Color iconBgColor,
  required String title,
  required String subtitle,
  required VoidCallback onTap,
  bool isDestructive = false,
}) {
  return Material(
    color: isDestructive
        ? AppColors.instance.red50.withValues(alpha: 0.35)
        : AppColors.instance.grayEE.withValues(alpha: 0.5),
    borderRadius: BorderRadius.circular(14),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDestructive ? AppColors.instance.red100 : AppColors.instance.grayE5,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const Gap(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text: title,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: isDestructive ? AppColors.instance.redF7 : AppColors.instance.black500,
                  ),
                  const Gap(height: 2),
                  AppText(
                    text: subtitle,
                    fontSize: 12,
                    color: AppColors.instance.gray400,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: isDestructive ? AppColors.instance.red300 : AppColors.instance.gray300,
            ),
          ],
        ),
      ),
    ),
  );
}

void _showLogoutConfirmDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (confirmContext) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: AppColors.instance.white,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFFFEBEE),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.logout_rounded, color: Color(0xFFE53935), size: 20),
            ),
            const Gap(width: 10),
            const AppText(
              text: "Logout",
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ],
        ),
        content: const AppText(
          text: "Are you sure you want to logout from your account?",
          fontSize: 14,
          color: Color(0xff5a5a5a),
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(confirmContext).pop(),
            child: AppText(
              text: "Cancel",
              style: TextStyle(color: AppColors.instance.gray400, fontWeight: FontWeight.w600),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(confirmContext).pop();
              await StorageServices.instance.logout();
              AppRoutes.instance.pushReplacementNamed(AppRoutesKey.instance.signInScreen);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE53935),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 0,
            ),
            child: const AppText(
              text: "Logout",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      );
    },
  );
}

void _showDeleteAccountConfirmDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (deleteContext) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: AppColors.instance.white,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 26, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Glowing Icon Badge
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppColors.instance.red50,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Container(
                    width: 54,
                    height: 54,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFEBEE),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.instance.redF7,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.instance.redF7.withValues(alpha: 0.35),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.delete_outline_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const Gap(height: 18),

              // Title
              AppText(
                text: "Delete Account?",
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.instance.black500,
              ),
              const Gap(height: 8),

              // Subtitle
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: AppText(
                  text: "Are you sure you want to permanently delete your account? All your personal details, order history, and data will be permanently removed.",
                  fontSize: 13,
                  color: const Color(0xFF6B7280),
                  textAlign: TextAlign.center,
                  maxLines: 4,
                ),
              ),
              const Gap(height: 16),

              // Warning Banner
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF2F2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFFECACA), width: 1),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded, color: Color(0xFFDC2626), size: 18),
                    const Gap(width: 8),
                    Expanded(
                      child: AppText(
                        text: "This action is permanent and cannot be undone.",
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFB91C1C),
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(height: 22),

              // Action Buttons
              Row(
                children: [
                  // Cancel Button
                  Expanded(
                    child: InkWell(
                      onTap: () => Navigator.of(deleteContext).pop(),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        height: 46,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: const AppText(
                          text: "Cancel",
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF4B5563),
                        ),
                      ),
                    ),
                  ),
                  const Gap(width: 12),

                  // Delete Button
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.of(deleteContext).pop();
                        executeDeleteAccount();
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        height: 46,
                        decoration: BoxDecoration(
                          color: AppColors.instance.redF7,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.instance.redF7.withValues(alpha: 0.35),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.delete_forever_rounded, color: Colors.white, size: 18),
                            Gap(width: 6),
                            AppText(
                              text: "Delete",
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
