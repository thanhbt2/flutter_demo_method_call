import 'dart:io';

import 'package:demo/platform_services.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _version = '';

  @override
  void initState() {
    PlatformServices.getOsVersion().then((value) {
      if (value != null) {
        setState(() {
          _version = value;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Run on ${isPlatform()}: $_version'),
            // const SizedBox(
            //   height: 20,
            // ),
            // StreamBuilder<String>(
            //   stream: PlatformServices.listenConnection(),
            //   builder: (context, snapshot) =>
            //       Text('Internet connected by: ${snapshot.data}'),
            // ),
          ],
        ),
      )),
    );
  }

  String isPlatform() {
    if (Platform.isIOS) {
      return "IOS";
    } else {
      return "Android";
    }
  }
}
