import 'package:audio_session/audio_session.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

enum AppPlayerState { playing, init, ready, pause, stop }

class HomeController extends GetxController {
  AudioPlayer? _audioPlayer;
  AndroidEnvironmentalReverb? _reverb;
  late AppPlayerState _playerState = AppPlayerState.init;
  AppPlayerState get playerState => _playerState;
  @override
  void onInit() async {
    super.onInit();
    _reverb = AndroidEnvironmentalReverb();
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
    _reverb!.setEnabled(true);
    _audioPlayer = AudioPlayer(
      audioPipeline: AudioPipeline(
        androidAudioEffects: [_reverb!],
      ),
    );
    await _audioPlayer!.setAudioSource(AudioSource.uri(Uri.parse(
        'https://s3-sgn09.fptcloud.com/tts-plus/banmai.0.02d4844b-63b3-40cd-9960-f9b0b1fef0de.mp3')));
    _audioPlayer!.playerStateStream.listen((playerState) {
      if (playerState.processingState == ProcessingState.ready) {
        if (playerState.playing) {
          _playerState = AppPlayerState.playing;
        }
        if (!playerState.playing) {
          _playerState = AppPlayerState.pause;
        }
      }
      if (playerState.processingState == ProcessingState.completed) {
        _playerState = AppPlayerState.stop;
      }
      update();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _audioPlayer!.dispose();
  }

  play() {
    _audioPlayer!.play();
  }

  pause() {
    _audioPlayer!.pause();
  }

  reload() {
    _audioPlayer!.seek(Duration.zero);
  }

  Stream<double> getVolumeStream() {
    return _audioPlayer!.volumeStream;
  }

  void setVolume(double volume) {
    _audioPlayer!.setVolume(volume);
  }

  double getVolume() {
    return _audioPlayer!.volume;
  }

  Future<AndroidEnvironmentalReverbParameters> getReverb() {
    return _reverb!.parameters;
  }
}
