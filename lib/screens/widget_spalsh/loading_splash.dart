import 'package:flutter/material.dart';

class LoadingSplash extends StatelessWidget {
  const LoadingSplash({super.key, required this.loadingMessage});

  final String loadingMessage;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              height: MediaQuery.of(context).size.width * 0.6,
              child: const CircularProgressIndicator(
                strokeWidth: 0.6,
                color: Colors.black,
              )),
        ),
        Center(
          child: Text(
            loadingMessage,
            style: const TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }
}
