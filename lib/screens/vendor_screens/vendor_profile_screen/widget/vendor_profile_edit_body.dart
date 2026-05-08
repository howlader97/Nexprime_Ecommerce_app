import 'package:flutter/material.dart';

import 'package:nexprime/models/vendor_store_model.dart';
import 'package:nexprime/widgets/texts/app_text.dart';

import '../../../../utils/app_size.dart';
import '../../../../utils/gap.dart';
import '../../../../widgets/inputs/app_input_widget_tow.dart';

class VendorProfileEditBody extends StatefulWidget {
  final VoidCallback onSave;
  final VendorStoreModel? vendorStore;

  const VendorProfileEditBody({
    super.key,
    required this.onSave,
    this.vendorStore,
  });

  @override
  State<VendorProfileEditBody> createState() => _VendorProfileEditBodyState();
}

class _VendorProfileEditBodyState extends State<VendorProfileEditBody> {
  late TextEditingController _nameController;
  late TextEditingController _bioController;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.vendorStore?.name ?? "");
    _bioController = TextEditingController(text: widget.vendorStore?.bio ?? "");
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppInputWidgetTwo(
          controller: _nameController,
          isDense: true,
          isCollapsed: true,
          contentPadding: EdgeInsets.symmetric(
            vertical: AppSize.size.height * 0.012,
          ),
          title: "Store owner name",
          titleFontSize: 16,
          titleFontWeight: FontWeight.w600,
        ),
        AppInputWidgetTwo(
          isDense: true,
          isCollapsed: true,
          contentPadding: EdgeInsets.symmetric(
            vertical: AppSize.size.height * 0.012,
          ),
          title: "Store Type",
          titleFontSize: 16,
          titleFontWeight: FontWeight.w600,
        ),
        AppInputWidgetTwo(
          controller: _bioController,
          isDense: true,
          isCollapsed: true,
          contentPadding: EdgeInsets.symmetric(
            vertical: AppSize.size.height * 0.012,
          ),
          title: "Store bio",
          titleFontSize: 16,
          titleFontWeight: FontWeight.w600,
          maxLines: 3,
          minLines: 3,
        ),
        Gap(height: 16),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSize.size.width * 0.05),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: widget.onSave,
              child: const AppText( text: "Save Changes"),
            ),
          ),
        ),
      ],
    );
  }
}
