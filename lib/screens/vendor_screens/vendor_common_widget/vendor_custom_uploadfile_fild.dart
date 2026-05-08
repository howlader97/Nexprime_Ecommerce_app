import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nexprime/constant/app_colors.dart';
import 'package:nexprime/utils/app_size.dart';
import 'package:nexprime/utils/gap.dart';
import 'package:nexprime/widgets/texts/app_text.dart';

class VendorCustomUploadfileFild extends StatefulWidget {
  final String hintText;

  const VendorCustomUploadfileFild({
    super.key,
    this.hintText = "Fast food",
  });

  @override
  State<VendorCustomUploadfileFild> createState() =>
      _VendorCustomUploadfileFildState();
}

class _VendorCustomUploadfileFildState
    extends State<VendorCustomUploadfileFild> {
  File? selectedFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickFile() async {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo),
                title: const AppText( text: 'Upload Image'),
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? image =
                  await _picker.pickImage(source: ImageSource.gallery);
                  if (image != null) {
                    setState(() {
                      selectedFile = File(image.path);
                    });
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.video_collection),
                title: const AppText( text: 'Upload Video'),
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? video =
                  await _picker.pickVideo(source: ImageSource.gallery);
                  if (video != null) {
                    setState(() {
                      selectedFile = File(video.path);
                    });
                  }
                },
              ),

            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: AppSize.size.height * 0.02,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(text: "Add product photo & video",fontSize: 16,fontWeight: FontWeight.w600,),
          Gap(height: 10,),
          GestureDetector(
            onTap: _pickFile,
            child: Container(
              height: AppSize.height(value: 50),
              width: double.infinity,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(
                horizontal: AppSize.width(value: 12),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  AppSize.width(value: 4),
                ),
                border: Border.all(
                  color: AppColors.instance.black900,
                ),
              ),
              child: selectedFile == null
                  ? AppText( text: 
                widget.hintText,
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.instance.gray50,
                ),
              )
                  : Row(
                children: [
                  Icon(Icons.check_circle, color: AppColors.instance.green),
                  SizedBox(width: AppSize.width(value: 8)),
                  Expanded(
                    child: AppText( text: 
                      selectedFile!.path.split('/').last,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

            ),

          ),
        ],
      ),
    );
  }
}