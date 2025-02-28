import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/foundation.dart';
import 'package:poker/controllers/controller.dart';
import 'package:poker/screen/widget/card.dart';

const payout_names = [
  /* 0 */ "Royal Flush",
  /* 1 */ "Straight Flush",
  /* 2 */ "Four of a Kind",
  /* 3 */ "Full House",
  /* 4 */ "Flush",
  /* 5 */ "Straight",
  /* 6 */ "Three of a Kind",
  /* 7 */ "Two Pair",
  /* 8 */ "One Pair",
];
const payout_rate_1x = [250, 50, 25, 9, 6, 4, 3, 2, 1];
const payout_rate_5x = [4000, 250, 125, 45, 30, 20, 15, 10, 5];

ValueNotifier<int> wager = ValueNotifier(2); // current wager
ValueNotifier<dynamic> credits = ValueNotifier(200); // total credits

List calcPayout(List<PlayCard> hand) {
  int type = getPayoutType(hand);
  if (type == -1) {
    if (gameController.isSound.value) {
      FlameAudio.play('High Card win.mp3');
    }
    gameController.creditHighCard.value =
        gameController.creditHighCard.value * 2;
    gameController.totalCredit.value += gameController.creditHighCard.value;
    gameController.isHighCard.value = true;
    return ["High Card", 0];
  }
  String name = payout_names[type];
  int value = payout_rate_1x[type] * wager.value;
  if (wager.value == 5) {
    value = payout_rate_5x[type];
  }
  return [name, value];
}

int getPayoutType(List<PlayCard> hand) {
  bool straight = isStraight(hand);
  bool flush = isFlush(hand);
  if (straight) {
    if (flush) {
      if (getSortedString(hand) == 'ajkqt') {
        if (gameController.isSound.value) {
          FlameAudio.play('Royal Flush win.mp3');
        }
        gameController.creditRoyalStraightFlush.value =
            gameController.creditRoyalStraightFlush.value * 250;
        gameController.totalCredit.value +=
            gameController.creditRoyalStraightFlush.value;
        gameController.isRoyalStraightFlush.value = true;
        return 0;
      }
      if (gameController.isSound.value) {
        FlameAudio.play('Straight Flush win.mp3');
      }
      gameController.creditStraightFlush.value =
          gameController.creditStraightFlush.value * 50;
      gameController.totalCredit.value +=
          gameController.creditStraightFlush.value;
      gameController.isStraightFlush.value = true;
      return 1;
    }
  }
  if (isFourOfAKind(hand)) {
    if (gameController.isSound.value) {
      FlameAudio.play('Four of a Kind win.mp3');
    }
    gameController.creditFourOfAKind.value =
        gameController.creditFourOfAKind.value * 10;
    gameController.totalCredit.value += gameController.creditFourOfAKind.value;
    gameController.isFourOfAKind.value = true;
    return 2;
  }
  if (isFullHouse(hand)) {
    if (gameController.isSound.value) {
      FlameAudio.play('Full House win.mp3');
    }
    gameController.creditFullHouse.value =
        gameController.creditFullHouse.value * 8;
    gameController.totalCredit.value += gameController.creditFullHouse.value;
    gameController.isFullHouse.value = true;

    return 3;
  }
  if (isFlush(hand)) {
    if (gameController.isSound.value) {
      FlameAudio.play('Flush win.mp3');
    }
    gameController.creditFlush.value = gameController.creditFlush.value * 6;
    gameController.totalCredit.value += gameController.creditFlush.value;
    gameController.isFlush.value = true;

    return 4;
  }
  if (straight) {
    if (gameController.isSound.value) {
      FlameAudio.play('Straight win.mp3');
    }
    gameController.creditStraight.value =
        gameController.creditStraight.value * 5;
    gameController.totalCredit.value += gameController.creditStraight.value;
    gameController.isStraight.value = true;

    return 5;
  }
  if (isThreeOfAKind(hand)) {
    if (gameController.isSound.value) {
      FlameAudio.play('Three of a Kind win.mp3');
    }
    gameController.creditThreeOfAKind.value =
        gameController.creditThreeOfAKind.value * 4;
    gameController.totalCredit.value += gameController.creditThreeOfAKind.value;
    gameController.isThreeOfAKind.value = true;
    return 6;
  }
  if (isTwoPair(hand)) {
    if (gameController.isSound.value) {
      FlameAudio.play('Two Pair win.mp3');
    }
    gameController.creditTwoPair.value = gameController.creditTwoPair.value * 3;
    gameController.totalCredit.value += gameController.creditTwoPair.value;
    gameController.isTwoPair.value = true;

    return 7;
  }
  if (isOnePair(hand)) {
    if (gameController.isSound.value) {
      FlameAudio.play('One Pair win.mp3');
    }
    gameController.creditPair.value = gameController.creditPair.value * 2;
    gameController.totalCredit.value += gameController.creditPair.value;
    gameController.isPair.value = true;
    return 8;
  }
  return -1;
}

String getSortedString(List<PlayCard> hand) {
  List<String> str = hand.map((card) => card.letterRank).toList();
  str.sort();
  return str.join();
}

bool isFourOfAKind(hand) => RegExp("(.)\\1{3}").hasMatch(getSortedString(hand));

bool isFullHouse(hand) =>
    RegExp("(.)\\1{2}(.)\\2").hasMatch(getSortedString(hand)) ||
    RegExp("(.)\\1(.)\\2{2}").hasMatch(getSortedString(hand));

bool isThreeOfAKind(hand) =>
    RegExp("(.)\\1{2}").hasMatch(getSortedString(hand));

bool isTwoPair(hand) =>
    RegExp("(.)\\1.?(.)\\2").hasMatch(getSortedString(hand));

bool isOnePair(hand) => RegExp("([jqka])\\1").hasMatch(getSortedString(hand));

bool isStraight(List<PlayCard> hand) {
  List<int> list = hand.map((card) => card.rank).toList();
  list.sort();
  if (list.contains(1) && list.contains(13)) {
    list.remove(1);
    list.add(14);
  }
  for (int i = 1; i < 5; i++) {
    if (list[i] != list[i - 1] + 1) {
      return false;
    }
  }
  return true;
}

bool isFlush(List<PlayCard> hand) {
  for (int i = 1; i < 5; i++) {
    if (hand[i].suit != hand[0].suit) {
      return false;
    }
  }
  return true;
}
