// ignore_for_file: deprecated_member_use
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slumber/core/utils/app_theme.dart';
import 'package:slumber/features/auth/data/models/slumber_user.dart';

class ProfileHeader extends StatefulWidget {
  final SlumberUser user;
  const ProfileHeader({super.key, required this.user});

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    final prefs = await SharedPreferences.getInstance();
    final imagePath = prefs.getString('profile_image_${widget.user.email}');

    if (imagePath != null) {
      final file = File(imagePath);
      if (await file.exists()) {
        setState(() {
          _profileImage = file;
        });
      }
    }
  }

  Future<void> _pickAndSaveImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        final directory = await getApplicationDocumentsDirectory();
        final fileName =
            'profile_${widget.user.email}_${DateTime.now().millisecondsSinceEpoch}.png';
        final savedImagePath = '${directory.path}/$fileName';

        final savedFile = await File(pickedFile.path).copy(savedImagePath);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
          'profile_image_${widget.user.email}',
          savedImagePath,
        );

        setState(() {
          _profileImage = savedFile;
        });
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder:
          (context) => SafeArea(
            child: Wrap(
              children: [
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickAndSaveImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Gallery'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickAndSaveImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final extra = theme.extension<ExtraColors>()!;
    final brightness = theme.brightness;
    final textColor =
        brightness == Brightness.dark ? scheme.onSurface : scheme.onBackground;

    return Column(
      children: [
        GestureDetector(
          onTap: () => _showImageSourceActionSheet(context),
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 50.r,
                backgroundColor: scheme.primary.withValues(alpha: 0.15),
                backgroundImage:
                    _profileImage != null ? FileImage(_profileImage!) : null,
                child:
                    _profileImage == null
                        ? Icon(Icons.person, size: 60.r, color: scheme.primary)
                        : null,
              ),
              Container(
                padding: EdgeInsets.all(6.r),
                decoration: BoxDecoration(
                  color: scheme.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: scheme.surface, width: 2.w),
                ),
                child: Icon(
                  Icons.camera_alt,
                  size: 16.r,
                  color: scheme.onPrimary,
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 14.h),
        Text(
          widget.user.name,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          widget.user.email,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: extra.secondaryText,
          ),
        ),
      ],
    );
  }
}
