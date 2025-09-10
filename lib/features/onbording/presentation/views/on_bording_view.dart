import 'package:flutter/material.dart';
import 'package:slumber/features/onbording/presentation/views/widgets/on_bording_body.dart';

class OnBordingView extends StatelessWidget {
  const OnBordingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: OnBordingBody(),
      ),
    );
  }
}