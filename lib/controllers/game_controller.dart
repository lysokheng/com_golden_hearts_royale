import 'package:flame_audio/flame_audio.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:get/get.dart';
import 'package:poker/controllers/controller.dart';

class GameController extends GetxController {
  RxBool isSound = true.obs;

  RxBool isRoyalStraightFlush = false.obs;
  RxBool isStraightFlush = false.obs;
  RxBool isFourOfAKind = false.obs;
  RxBool isFullHouse = false.obs;
  RxBool isFlush = false.obs;
  RxBool isStraight = false.obs;
  RxBool isThreeOfAKind = false.obs;
  RxBool isTwoPair = false.obs;
  RxBool isPair = false.obs;
  RxBool isHighCard = false.obs;

  RxBool isGame = false.obs;
  RxBool isPlaying = true.obs;
  RxBool isDraw = false.obs;
  RxList<bool> isCardShow = [false, false, false, false, false].obs;
  RxInt drawCount = 0.obs;
  late FlipCardController flipCard0Controller;
  late FlipCardController flipCard1Controller;
  late FlipCardController flipCard2Controller;
  late FlipCardController flipCard3Controller;
  late FlipCardController flipCard4Controller;
  RxString title = ''.obs;
  RxInt totalCredit = 1000.obs;
  RxInt creditRoyalStraightFlush = 0.obs;
  RxInt creditStraightFlush = 0.obs;
  RxInt creditFourOfAKind = 0.obs;
  RxInt creditFullHouse = 0.obs;
  RxInt creditFlush = 0.obs;
  RxInt creditStraight = 0.obs;
  RxInt creditThreeOfAKind = 0.obs;
  RxInt creditTwoPair = 0.obs;
  RxInt creditPair = 0.obs;
  RxInt creditHighCard = 0.obs;
  @override
  void onInit() {
    FlameAudio.bgm.initialize();
    FlameAudio.bgm.play('bgm.mp3', volume: 0.4);
    super.onInit();
  }

  @override
  void dispose() {
    isSound.value = false;
    super.dispose();
  }

  void cardDraw() {
    drawCount++;
    Future.delayed(const Duration(milliseconds: 500), () {
      isCardShow[drawCount.value - 1] = true;
      switch (drawCount.value - 1) {
        case 0:
          gameController.flipCard0Controller.toggleCard();
          if (gameController.isSound.value) {
            FlameAudio.play('flip card.mp3');
          }
          break;
        case 1:
          if (gameController.isSound.value) {
            FlameAudio.play('flip card.mp3');
          }
          gameController.flipCard1Controller.toggleCard();
          break;
        case 2:
          if (gameController.isSound.value) {
            FlameAudio.play('flip card.mp3');
          }
          gameController.flipCard2Controller.toggleCard();
          break;
        case 3:
          if (gameController.isSound.value) {
            FlameAudio.play('flip card.mp3');
          }
          gameController.flipCard3Controller.toggleCard();
          break;
        case 4:
          if (gameController.isSound.value) {
            FlameAudio.play('flip card.mp3');
          }
          gameController.flipCard4Controller.toggleCard();
          break;
      }
    });
  }
}
