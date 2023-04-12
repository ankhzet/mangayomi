import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }

  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
    installerStore: 'Unknown',
  );

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    if (mounted) {
      setState(() {
        _packageInfo = info;
      });
    }
  }

  @override
  void initState() {
    _initPackageInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 150, child: Center(child: Text("LOGO"))),
          Flexible(
            flex: 3,
            child: Column(
              children: [
                const Divider(
                  color: Colors.grey,
                ),
                ListTile(
                  onTap: () {},
                  title: const Text('Version'),
                  subtitle: Text(
                    'Beta (${_packageInfo.version})',
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
                ListTile(
                  onTap: () {},
                  title: const Text('Check for update'),
                ),
                // ListTile(
                //   onTap: () {},
                //   title: const Text("What's news"),
                // ),
                // ListTile(
                //   onTap: () {},
                //   title: const Text('Help translation'),
                // ),
                // ListTile(
                //   onTap: () {},
                //   title: const Text('Privacy policy'),
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        onPressed: () {
                          _launchInBrowser(Uri.parse(
                              'https://github.com/kodjodevf/mangayomi'));
                        },
                        icon: const Icon(FontAwesomeIcons.github))
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
