import 'dart:async';

import 'package:flame_audio/flame_audio.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:poker/controllers/controller.dart';
import 'package:poker/screen/widget/card.dart';
import 'package:poker/screen/widget/global.dart';
import 'package:poker/widgets/bet_card.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  Deck deck = Deck();
  late List<PlayCard> _hand;
  double cardY = 0.0;
  double ax = 0, ay = 0;
  double count = 0;

  int winAmount = 0;
  int creditTurn = 5;
  int turn = 5;
  bool vsShow = false;
  bool showin = false;

  @override
  void initState() {
    _hand = [
      PlayCard.back(),
      PlayCard.back(),
      PlayCard.back(),
      PlayCard.back(),
      PlayCard.back(),
    ];
    WidgetsBinding.instance.addObserver(this);
    gameController.flipCard0Controller = FlipCardController();
    gameController.flipCard1Controller = FlipCardController();
    gameController.flipCard2Controller = FlipCardController();
    gameController.flipCard3Controller = FlipCardController();
    gameController.flipCard4Controller = FlipCardController();

    setTimer();
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    gameController.flipCard0Controller.toggleCard();
    gameController.flipCard1Controller.toggleCard();
    gameController.flipCard2Controller.toggleCard();
    gameController.flipCard3Controller.toggleCard();
    gameController.flipCard4Controller.toggleCard();
    gameController.drawCount.value = 0;
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // The app is going into the background, pause the audio
      gameController.isSound.value = false;
      Get.back();
      FlameAudio.bgm.stop();
      gameController.drawCount.value = 0;
    } else if (state == AppLifecycleState.resumed) {
      // The app is coming back from the background, resume the audio
      gameController.isSound.value = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
        body: Stack(alignment: Alignment.center, children: [
      //bg
      Container(
        width: width,
        height: height,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/bg.png'), fit: BoxFit.fill)),
      ),

      //table
      Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
              top: height * 0.13,
              child: Image.asset(
                'assets/images/table.png',
                height: height * 0.55,
              )), //cards

          //cards
          AnimatedPositioned(
              duration: const Duration(seconds: 1),
              top: cardY,
              child: _buildCardsArea()),
        ],
      ), //repeat

      //controller
      Stack(
        alignment: Alignment.center,
        children: [
          //timer
          Positioned(
            top: height * 0.17,
            right: width * 0.15,
            child: CircularPercentIndicator(
              radius: height * 0.08,
              backgroundColor: Colors.grey,
              progressColor: Colors.greenAccent,
              animateFromLastPercent: true,
              reverse: true,
              lineWidth: height * 0.02,
              percent: count,
              center: Text(
                'Time',
                style: TextStyle(
                    fontSize: height * 0.04,
                    fontWeight: FontWeight.bold,
                    color: Colors.yellow),
              ),
              animation: true,
            ),
          ),
          //Back
          Positioned(
              top: Get.height * 0.05,
              left: Get.width * 0.01,
              child: GestureDetector(
                onTap: () {
                  if (gameController.isSound.value) {
                    FlameAudio.play('tap.mp3');
                  }
                  Get.back();
                },
                child: SafeArea(
                  child: Image.asset(
                    'assets/images/back.png',
                    height: height * 0.15,
                  ),
                ),
              )), //Sound

          //replay
          Positioned(
              top: Get.height * 0.25,
              right: Get.width * 0.01,
              child: GestureDetector(
                onTap: () {
                  if (gameController.isSound.value) {
                    FlameAudio.play('tap.mp3');
                  }
                  setState(() {
                    gameController.totalCredit.value = 1000;
                    gameController.creditRoyalStraightFlush.value = 0;
                    gameController.creditStraightFlush.value = 0;
                    gameController.creditFourOfAKind.value = 0;
                    gameController.creditFullHouse.value = 0;
                    gameController.creditFlush.value = 0;
                    gameController.creditStraight.value = 0;
                    gameController.creditThreeOfAKind.value = 0;
                    gameController.creditTwoPair.value = 0;
                    gameController.creditPair.value = 0;
                    gameController.creditHighCard.value = 0;
                    vsShow = false;
                    setTimer();
                  });
                },
                child: SafeArea(
                  child: Image.asset(
                    'assets/images/replay.png',
                    height: height * 0.15,
                  ),
                ),
              )), //hand ranking
          Positioned(
              top: Get.height * 0.45,
              left: Get.width * 0.01,
              child: GestureDetector(
                onTap: () {
                  if (gameController.isSound.value) {
                    FlameAudio.play('tap.mp3');
                  }
                  Get.to(() => Material(
                        color: Colors.transparent,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.asset(
                              'assets/images/home.png',
                              width: width,
                              height: height,
                              fit: BoxFit.cover,
                            ),
                            GestureDetector(
                              onTap: () => Get.back(),
                              child: Image.asset(
                                'assets/images/Rules.png',
                                width: width,
                                height: height,
                              ),
                            ),
                            Positioned(
                                bottom: 0,
                                child: Text(
                                  'TAP TO PLAY',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: height * 0.1),
                                ))
                          ],
                        ),
                      ));
                },
                child: SafeArea(
                  child: Image.asset(
                    'assets/images/!.png',
                    height: height * 0.15,
                  ),
                ),
              )),
          //sound imagesn
          Positioned(
              top: Get.height * 0.05,
              right: Get.width * 0.01,
              child: GestureDetector(
                onTap: () {
                  if (gameController.isSound.value) {
                    FlameAudio.play('tap.mp3');
                  }
                  if (gameController.isSound.value) {
                    FlameAudio.bgm.stop();
                    gameController.isSound.value = false;
                  } else {
                    FlameAudio.bgm.play('bgm.mp3', volume: 0.4);
                    gameController.isSound.value = true;
                  }
                },
                child: SafeArea(
                  child: Obx(
                    () => Image.asset(
                      gameController.isSound.value
                          ? 'assets/images/volume.png'
                          : 'assets/images/sound-off.png',
                      height: height * 0.15,
                    ),
                  ),
                ),
              )),

          //Blanace
          Positioned(
              top: height * 0.25,
              left: width * 0.03,
              child: Container(
                width: width * 0.2,
                height: height * 0.12,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/table.png'),
                        fit: BoxFit.fill)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Image.asset(
                      'assets/coin/coins.png',
                      width: width * 0.06,
                      height: width * 0.05,
                      fit: BoxFit.fill,
                    ),
                    Obx(
                      () => Text(
                        "${gameController.totalCredit.value}",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: height * 0.05,
                        ),
                      ),
                    ),
                  ],
                ),
              )),

          //coins
          Positioned(
              top: Get.height * 0.01,
              child: Row(
                children: [
                  //coin5
                  coinWidget(width, 5),
                  SizedBox(
                    width: Get.width * 0.01,
                  ),
                  coinWidget(width, 10),
                  SizedBox(
                    width: Get.width * 0.01,
                  ),

                  // coin 50
                  coinWidget(width, 50),
                  SizedBox(
                    width: Get.width * 0.01,
                  ),
                  //coin 100
                  coinWidget(width, 100),
                ],
              )),
        ],
      ), //BET

      //bet option
      Positioned(
          bottom: 0,
          child: SizedBox(
            width: width * 1,
            child: Padding(
              padding: EdgeInsets.only(
                left: Get.width * 0.05,
                right: Get.width * 0.05,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          betRoyalStraightFlush();
                        },
                        child: BetCard(
                          credit: gameController.creditRoyalStraightFlush.value,
                          name: 'Royal Flush',
                          point: 250,
                          colorName: Colors.white,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          betStraightFlush();
                        },
                        child: BetCard(
                          credit: gameController.creditStraightFlush.value,
                          name: 'Straight Flush',
                          point: 50,
                          colorName: Colors.white,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          betFourOfAKind();
                        },
                        child: BetCard(
                          credit: gameController.creditFourOfAKind.value,
                          name: 'Four of a kind',
                          point: 10,
                          colorName: Colors.white,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          betFullHouse();
                        },
                        child: BetCard(
                          credit: gameController.creditFullHouse.value,
                          name: 'Full House',
                          point: 8,
                          colorName: Colors.white,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          betFlush();
                        },
                        child: BetCard(
                          credit: gameController.creditFlush.value,
                          name: 'Flush',
                          point: 6,
                          colorName: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          betStraight();
                        },
                        child: BetCard(
                          credit: gameController.creditStraight.value,
                          name: 'Straight',
                          point: 5,
                          colorName: Colors.white,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          betThreeOfAKind();
                        },
                        child: BetCard(
                          credit: gameController.creditThreeOfAKind.value,
                          name: 'Three of a kind',
                          point: 4,
                          colorName: Colors.white,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          betTwoPair();
                        },
                        child: BetCard(
                          credit: gameController.creditTwoPair.value,
                          name: 'Two Pair',
                          point: 3,
                          colorName: Colors.white,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          betPair();
                        },
                        child: BetCard(
                          credit: gameController.creditPair.value,
                          name: 'One Pair',
                          point: 2,
                          colorName: Colors.white,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          betHighCard();
                        },
                        child: BetCard(
                          credit: gameController.creditHighCard.value,
                          name: 'High Card',
                          point: 2,
                          colorName: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )),

      Obx(() {
        if (gameController.creditRoyalStraightFlush.value > 0) {
          return AnimatedPositioned(
              left: gameController.isRoyalStraightFlush.value
                  ? width * 0.05
                  : width * 0.1,
              top: gameController.isRoyalStraightFlush.value
                  ? height * 0.25
                  : height * 0.7,
              duration: const Duration(milliseconds: 500),
              child: GestureDetector(
                onTap: () {
                  betRoyalStraightFlush();
                },
                child: Obx(() => betCoin(width, height,
                    gameController.creditRoyalStraightFlush.value)),
              ));
        } else {
          return const SizedBox();
        }
      }),

      Obx(() {
        if (gameController.creditStraightFlush.value > 0) {
          return AnimatedPositioned(
              left: gameController.isStraightFlush.value
                  ? width * 0.05
                  : width * 0.3,
              top: gameController.isStraightFlush.value
                  ? height * 0.25
                  : height * 0.7,
              duration: const Duration(milliseconds: 500),
              child: GestureDetector(
                onTap: () {
                  betStraightFlush();
                },
                child: Obx(() => betCoin(
                    width, height, gameController.creditStraightFlush.value)),
              ));
        } else {
          return const SizedBox();
        }
      }),

      Obx(() {
        if (gameController.creditFourOfAKind.value > 0) {
          return AnimatedPositioned(
              left: gameController.isFourOfAKind.value
                  ? width * 0.05
                  : width * 0.47,
              top: gameController.isFourOfAKind.value
                  ? height * 0.25
                  : height * 0.7,
              duration: const Duration(milliseconds: 500),
              child: GestureDetector(
                onTap: () {
                  betFourOfAKind();
                },
                child: Obx(() => betCoin(
                    width, height, gameController.creditFourOfAKind.value)),
              ));
        } else {
          return const SizedBox();
        }
      }),

      Obx(() {
        if (gameController.creditFullHouse.value > 0) {
          return AnimatedPositioned(
              left: gameController.isFullHouse.value
                  ? width * 0.05
                  : width * 0.65,
              top: gameController.isFullHouse.value
                  ? height * 0.25
                  : height * 0.7,
              duration: const Duration(milliseconds: 500),
              child: GestureDetector(
                onTap: () {
                  betFullHouse();
                },
                child: Obx(() => betCoin(
                    width, height, gameController.creditFullHouse.value)),
              ));
        } else {
          return const SizedBox();
        }
      }),

      Obx(() {
        if (gameController.creditFlush.value > 0) {
          return AnimatedPositioned(
              left: gameController.isFlush.value ? width * 0.05 : width * 0.85,
              top: gameController.isFlush.value ? height * 0.25 : height * 0.7,
              duration: const Duration(milliseconds: 500),
              child: GestureDetector(
                onTap: () {
                  betFlush();
                },
                child: Obx(() =>
                    betCoin(width, height, gameController.creditFlush.value)),
              ));
        } else {
          return const SizedBox();
        }
      }),

      Obx(() {
        if (gameController.creditStraight.value > 0) {
          return AnimatedPositioned(
              left:
                  gameController.isStraight.value ? width * 0.05 : width * 0.1,
              top: gameController.isStraight.value
                  ? height * 0.25
                  : height * 0.85,
              duration: const Duration(milliseconds: 500),
              child: GestureDetector(
                onTap: () {
                  betStraight();
                },
                child: Obx(() => betCoin(
                    width, height, gameController.creditStraight.value)),
              ));
        } else {
          return const SizedBox();
        }
      }),

      Obx(() {
        if (gameController.creditThreeOfAKind.value > 0) {
          return AnimatedPositioned(
              left: gameController.isThreeOfAKind.value
                  ? width * 0.05
                  : width * 0.3,
              top: gameController.isThreeOfAKind.value
                  ? height * 0.25
                  : height * 0.85,
              duration: const Duration(milliseconds: 500),
              child: GestureDetector(
                onTap: () {
                  betThreeOfAKind();
                },
                child: Obx(() => betCoin(
                    width, height, gameController.creditThreeOfAKind.value)),
              ));
        } else {
          return const SizedBox();
        }
      }),

      Obx(() {
        if (gameController.creditTwoPair.value > 0) {
          return AnimatedPositioned(
              left:
                  gameController.isTwoPair.value ? width * 0.05 : width * 0.47,
              top: gameController.isTwoPair.value
                  ? height * 0.25
                  : height * 0.85,
              duration: const Duration(milliseconds: 500),
              child: GestureDetector(
                onTap: () {
                  betTwoPair();
                },
                child: Obx(() =>
                    betCoin(width, height, gameController.creditTwoPair.value)),
              ));
        } else {
          return const SizedBox();
        }
      }),

      Obx(() {
        if (gameController.creditPair.value > 0) {
          return AnimatedPositioned(
              left: gameController.isPair.value ? width * 0.05 : width * 0.65,
              top: gameController.isPair.value ? height * 0.25 : height * 0.85,
              duration: const Duration(milliseconds: 500),
              child: GestureDetector(
                onTap: () {
                  betPair();
                },
                child: Obx(() =>
                    betCoin(width, height, gameController.creditPair.value)),
              ));
        } else {
          return const SizedBox();
        }
      }),

      Obx(() {
        if (gameController.creditHighCard.value > 0) {
          return AnimatedPositioned(
              left:
                  gameController.isHighCard.value ? width * 0.05 : width * 0.85,
              top: gameController.isHighCard.value
                  ? height * 0.25
                  : height * 0.85,
              duration: const Duration(milliseconds: 500),
              child: GestureDetector(
                onTap: () {
                  betHighCard();
                },
                child: Obx(() => betCoin(
                    width, height, gameController.creditHighCard.value)),
              ));
        } else {
          return const SizedBox();
        }
      }),
    ]));
  }

  Container betCoin(double width, double height, int value) {
    return Container(
      width: width * 0.06,
      height: width * 0.06,
      decoration: const BoxDecoration(
          image: DecorationImage(
        image: AssetImage(
          'assets/coin/coin.png',
        ),
        fit: BoxFit.fill,
      )),
      child: Center(
          child: Text(
        '$value',
        style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: height * 0.04),
      )),
    );
  }

  GestureDetector coinWidget(double width, int value) {
    return GestureDetector(
      onTap: () {
        if (gameController.isSound.value) {
          FlameAudio.play('bet option.mp3');
        }
        setState(() {
          turn = value;
          creditTurn = value;
        });
      },
      child: Container(
        width: width * 0.06,
        height: width * 0.06,
        decoration: const BoxDecoration(shape: BoxShape.circle),
        child: Stack(
          children: [
            Image.asset(
              'assets/coin/$value.png',
              width: width * 0.06,
              height: width * 0.06,
              fit: BoxFit.fill,
            ),
            Container(
              width: width * 0.06,
              height: width * 0.06,
              decoration: BoxDecoration(
                  color: turn == value
                      ? Colors.black.withOpacity(0)
                      : Colors.black38,
                  shape: BoxShape.circle),
            ),
          ],
        ),
      ),
    );
  }

  void animateCards() {
    setState(() {
      cardY = Get.height * 0.3; // New Y position for the animation
    });
  }

  void resetAnimateCards() {
    setState(() {
      cardY = -Get.height * 0.3; // New Y position for the animation
    });
  }

  Future<void> setTimer() async {
    Timer(const Duration(seconds: 2), () {
      setState(() {
        vsShow = true;
      });
    });
  }

  void startTimer() {
    Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {
        if (vsShow == true) {
          if (!gameController.isCardShow[0] && !showin) {
            if (count == 0.9999999999999999) {
              dealCard();
              count = 0;
            } else {
              count += 0.10;
            }
          } else if (!gameController.isCardShow[1] && !showin) {
            if (count == 0.9999999999999999) {
              dealCard();
              count = 0;
            } else {
              count += 0.10;
            }
          } else if (!gameController.isCardShow[2] && !showin) {
            if (count == 0.9999999999999999) {
              dealCard();
              count = 0;
            } else {
              count += 0.10;
            }
          } else if (!gameController.isCardShow[3] && !showin) {
            if (count == 0.9999999999999999) {
              dealCard();
              count = 0;
            } else {
              count += 0.10;
            }
          } else if (!gameController.isCardShow[4] && !showin) {
            if (count == 0.9999999999999999) {
              dealCard();
              count = 0;
            } else {
              count += 0.10;
            }
          } else if (gameController.isCardShow[0] &&
              gameController.isCardShow[1] &&
              gameController.isCardShow[2] &&
              gameController.isCardShow[3] &&
              gameController.isCardShow[4]) {
            if (!showin) {
              showin = true;

              count = 0;
              showin = false;
              gameController.drawCount.value = 0;
              gameController.isCardShow =
                  [false, false, false, false, false].obs;
            }
          }
        }
      });
    });
  }

  void dealCard() {
    animateCards(); // Trigger the card animation
    if (gameController.drawCount.value == 0) {
      gameController.cardDraw();
      _hand[0] = deck.pop();
      Future.delayed(const Duration(milliseconds: 500), () {
        gameController.cardDraw();
        _hand[1] = deck.pop();
        Future.delayed(const Duration(milliseconds: 500), () {
          gameController.cardDraw();
          _hand[2] = deck.pop();
        });
      });
    }
    if (gameController.drawCount.value == 3) {
      gameController.cardDraw();
      _hand[3] = deck.pop();
    } else if (gameController.drawCount.value == 4) {
      gameController.cardDraw();
      _hand[4] = deck.pop();
      var result = calcPayout(_hand);
      gameController.title.value = '${result[0]}';
      gameController.isPlaying.value = false;
      Future.delayed(const Duration(seconds: 5), () {
        resetAnimateCards();
        if (gameController.isSound.value) {
          FlameAudio.play('flip close card.mp3');
        }
        gameController.title.value = '';
        gameController.flipCard0Controller.toggleCard();
        gameController.flipCard1Controller.toggleCard();
        gameController.flipCard2Controller.toggleCard();
        gameController.flipCard3Controller.toggleCard();
        gameController.flipCard4Controller.toggleCard();
        gameController.isHighCard.value = false;
        gameController.isPair.value = false;
        gameController.isTwoPair.value = false;
        gameController.isThreeOfAKind.value = false;
        gameController.isStraight.value = false;
        gameController.isFourOfAKind.value = false;
        gameController.isFlush.value = false;
        gameController.isStraightFlush.value = false;
        gameController.isRoyalStraightFlush.value = false;
        gameController.isFullHouse.value = false;
        gameController.creditRoyalStraightFlush.value = 0;
        gameController.creditStraightFlush.value = 0;
        gameController.creditFourOfAKind.value = 0;
        gameController.creditFullHouse.value = 0;
        gameController.creditFlush.value = 0;
        gameController.creditStraight.value = 0;
        gameController.creditThreeOfAKind.value = 0;
        gameController.creditTwoPair.value = 0;
        gameController.creditPair.value = 0;
        gameController.creditHighCard.value = 0;
        gameController.isPlaying.value = true;
      });
    }
  }

  Widget _buildCardsArea() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        FlipCard(
          flipOnTouch: false,
          controller: gameController.flipCard0Controller,
          fill: Fill.fillBack,
          direction: FlipDirection.HORIZONTAL,
          side: CardSide.BACK,
          front: _buildSingleCard(
            _hand.elementAt(0),
          ),
          back: Image.asset(
            'assets/back.png',
            height: Get.height * 0.2,
            width: Get.height * 0.15,
            fit: BoxFit.fill,
          ),
        ),
        SizedBox(
          width: Get.width * 0.01,
        ),
        FlipCard(
          flipOnTouch: false,
          controller: gameController.flipCard1Controller,
          fill: Fill.fillBack,
          direction: FlipDirection.HORIZONTAL,
          side: CardSide.BACK,
          front: _buildSingleCard(
            _hand.elementAt(1),
          ),
          back: Image.asset(
            'assets/back.png',
            height: Get.height * 0.2,
            width: Get.height * 0.15,
            fit: BoxFit.fill,
          ),
        ),
        SizedBox(
          width: Get.width * 0.01,
        ),
        FlipCard(
          flipOnTouch: false,
          controller: gameController.flipCard2Controller,
          fill: Fill.fillBack,
          direction: FlipDirection.HORIZONTAL,
          side: CardSide.BACK,
          front: _buildSingleCard(
            _hand.elementAt(2),
          ),
          back: Image.asset(
            'assets/back.png',
            height: Get.height * 0.2,
            width: Get.height * 0.15,
            fit: BoxFit.fill,
          ),
        ),
        SizedBox(
          width: Get.width * 0.01,
        ),
        FlipCard(
          flipOnTouch: false,
          controller: gameController.flipCard3Controller,
          fill: Fill.fillBack,
          direction: FlipDirection.HORIZONTAL,
          side: CardSide.BACK,
          front: _buildSingleCard(
            _hand.elementAt(3),
          ),
          back: Image.asset(
            'assets/back.png',
            height: Get.height * 0.2,
            width: Get.height * 0.15,
            fit: BoxFit.fill,
          ),
        ),
        SizedBox(
          width: Get.width * 0.01,
        ),
        FlipCard(
          flipOnTouch: false,
          controller: gameController.flipCard4Controller,
          fill: Fill.fillBack,
          direction: FlipDirection.HORIZONTAL,
          side: CardSide.BACK,
          front: _buildSingleCard(
            _hand.elementAt(4),
          ),
          back: Image.asset(
            'assets/back.png',
            height: Get.height * 0.2,
            width: Get.height * 0.15,
            fit: BoxFit.fill,
          ),
        ),
      ],
    );
  }

  Widget _buildSingleCard(card) {
    return Image.asset(
      card.src,
      height: Get.height * 0.2,
      width: Get.height * 0.15,
      fit: BoxFit.fill,
    );
  }

  void betHighCard() {
    if (gameController.isSound.value) {
      FlameAudio.play('bet.mp3');
    }
    if (gameController.isPlaying.value) {
      setState(() {
        if (creditTurn <= gameController.totalCredit.value) {
          gameController.creditHighCard.value += creditTurn;
          gameController.totalCredit.value -= creditTurn;
        }
      });
    }
  }

  void betPair() {
    if (gameController.isSound.value) {
      FlameAudio.play('bet.mp3');
    }
    if (gameController.isPlaying.value) {
      setState(() {
        if (creditTurn <= gameController.totalCredit.value) {
          gameController.creditPair.value += creditTurn;
          gameController.totalCredit.value -= creditTurn;
        }
      });
    }
  }

  void betTwoPair() {
    if (gameController.isSound.value) {
      FlameAudio.play('bet.mp3');
    }
    if (gameController.isPlaying.value) {
      setState(() {
        if (creditTurn <= gameController.totalCredit.value) {
          gameController.creditTwoPair.value += creditTurn;
          gameController.totalCredit.value -= creditTurn;
        }
      });
    }
  }

  void betThreeOfAKind() {
    if (gameController.isSound.value) {
      FlameAudio.play('bet.mp3');
    }
    if (gameController.isPlaying.value) {
      setState(() {
        if (creditTurn <= gameController.totalCredit.value) {
          gameController.creditThreeOfAKind.value += creditTurn;
          gameController.totalCredit.value -= creditTurn;
        }
      });
    }
  }

  void betStraight() {
    if (gameController.isSound.value) {
      FlameAudio.play('bet.mp3');
    }
    if (gameController.isPlaying.value) {
      setState(() {
        if (creditTurn <= gameController.totalCredit.value) {
          gameController.creditStraight.value += creditTurn;
          gameController.totalCredit.value -= creditTurn;
        }
      });
    }
  }

  void betFlush() {
    if (gameController.isSound.value) {
      FlameAudio.play('bet.mp3');
    }
    if (gameController.isPlaying.value) {
      setState(() {
        if (creditTurn <= gameController.totalCredit.value) {
          gameController.creditFlush.value += creditTurn;
          gameController.totalCredit.value -= creditTurn;
        }
      });
    }
  }

  void betFullHouse() {
    if (gameController.isSound.value) {
      FlameAudio.play('bet.mp3');
    }
    if (gameController.isPlaying.value) {
      setState(() {
        if (creditTurn <= gameController.totalCredit.value) {
          gameController.creditFullHouse.value += creditTurn;
          gameController.totalCredit.value -= creditTurn;
        }
      });
    }
  }

  void betFourOfAKind() {
    if (gameController.isSound.value) {
      FlameAudio.play('bet.mp3');
    }
    if (gameController.isPlaying.value) {
      setState(() {
        if (creditTurn <= gameController.totalCredit.value) {
          gameController.creditFourOfAKind.value += creditTurn;
          gameController.totalCredit.value -= creditTurn;
        }
      });
    }
  }

  void betStraightFlush() {
    if (gameController.isSound.value) {
      FlameAudio.play('bet.mp3');
    }
    if (gameController.isPlaying.value) {
      setState(() {
        if (creditTurn <= gameController.totalCredit.value) {
          gameController.creditStraightFlush.value += creditTurn;
          gameController.totalCredit.value -= creditTurn;
        }
      });
    }
  }

  void betRoyalStraightFlush() {
    if (gameController.isSound.value) {
      FlameAudio.play('bet.mp3');
    }
    if (gameController.isPlaying.value) {
      setState(() {
        if (creditTurn <= gameController.totalCredit.value) {
          gameController.creditRoyalStraightFlush.value += creditTurn;
          gameController.totalCredit.value -= creditTurn;
        }
      });
    }
  }
}
