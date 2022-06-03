import 'package:flutter/material.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

PreferredSizeWidget CustomAppBar({
  required String title,
  required VoidCallback filterFunction,
  required VoidCallback menuFunction,
}) {
  return PreferredSize(
    preferredSize: Size(200, 200),
    child: Builder(builder: (context) {
      return Container(
        //color: Theme.of(context).primaryColor,
        width: MediaQuery.of(context).size.width,
        height: 110,
        child: Stack(
          children: [
            RotatedBox(
              quarterTurns: 2,
              child: WaveWidget(
                config: CustomConfig(
                  colors: [const Color(0xff205375)],
                  durations: [22000],
                  heightPercentages: [-0.05],
                ),
                size: const Size(double.infinity, double.infinity),
                waveAmplitude: 1,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: menuFunction,
                  icon: const Icon(
                    Icons.menu,
                    color: Colors.white,
                  ),
                ),
                Center(
                  child: Text(
                    title,
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
                IconButton(
                  onPressed: filterFunction,
                  icon: const Icon(
                    Icons.filter_alt_outlined,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }),
  );
}
