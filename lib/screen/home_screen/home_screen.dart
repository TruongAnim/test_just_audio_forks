import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:test_project/screen/home_screen/home_controller.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  Widget getIcon(HomeController controller) {
    if (controller.playerState == AppPlayerState.init) {
      return CircularProgressIndicator();
    } else if (controller.playerState == AppPlayerState.pause) {
      return IconButton(
          icon: Icon(Icons.play_arrow), onPressed: controller.play);
    } else if (controller.playerState == AppPlayerState.playing) {
      return IconButton(icon: Icon(Icons.pause), onPressed: controller.pause);
    } else {
      return IconButton(
          icon: Icon(Icons.replay_outlined), onPressed: controller.reload);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Audio Player'),
      ),
      body: GetBuilder<HomeController>(builder: (controller) {
        return Center(
            child: Column(
          children: [
            getIcon(controller),
            StreamBuilder<double>(
              stream: controller.getVolumeStream(),
              builder: (context, snapshot) => SizedBox(
                height: 100.0,
                child: Column(
                  children: [
                    Text('${snapshot.data?.toStringAsFixed(1)}',
                        style: const TextStyle(
                            fontFamily: 'Fixed',
                            fontWeight: FontWeight.bold,
                            fontSize: 24.0)),
                    Slider(
                      divisions: 10,
                      min: 0,
                      max: 1,
                      value: snapshot.data ?? controller.getVolume(),
                      onChanged: controller.setVolume,
                    ),
                  ],
                ),
              ),
            ),
            FutureBuilder<AndroidEnvironmentalReverbParameters>(
              future: controller.getReverb(),
              builder: (context, snapshot) {
                final parameters = snapshot.data;
                if (parameters == null) return const SizedBox();
                return SingleChildScrollView(
                    child: Column(
                  children: [
                    for (var param in parameters.params)
                      Column(
                        children: [
                          StreamBuilder<int>(
                            stream: param.valueStream,
                            builder: (context, snapshot) {
                              return Slider(
                                divisions: 10,
                                min: param.minVal.toDouble(),
                                max: param.maxVal.toDouble(),
                                value: param.value.toDouble(),
                                onChanged: (value) {
                                  print(value);
                                  param.setValue(value.toInt());
                                },
                              );
                            },
                          ),
                        ],
                      ),
                  ],
                ));
              },
            )
          ],
        ));
      }),
    );
  }
}
