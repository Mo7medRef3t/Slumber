import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutAppCard extends StatefulWidget {
  const AboutAppCard({super.key});

  @override
  State<AboutAppCard> createState() => _AboutAppCardState();
}

class _AboutAppCardState extends State<AboutAppCard> {
  String version = "";

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      setState(() => version = info.version);
    } catch (_) {
      setState(() => version = "1.0.0");
    }
  }

  Future<void> _openLink(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "About App",
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.h),
            ListTile(
              leading: Icon(Icons.info_outline, color: scheme.primary),
              title: const Text("Version"),
              trailing: Text(version),
            ),
            ListTile(
              leading: Icon(Icons.privacy_tip_outlined, color: scheme.primary),
              title: const Text("Privacy Policy"),
              onTap: () => _openLink("https://your-privacy-policy-link.com"),
            ),
            ListTile(
              leading: Icon(Icons.star_border, color: scheme.primary),
              title: const Text("Rate Us"),
              onTap:
                  () =>
                      _openLink("https://your-appstore-or-playstore-link.com"),
            ),
            ListTile(
              leading: Icon(Icons.mail_outline, color: scheme.primary),
              title: const Text("Contact Support"),
              onTap: () => _openLink("mailto:support@yourapp.com"),
            ),
          ],
        ),
      ),
    );
  }
}
