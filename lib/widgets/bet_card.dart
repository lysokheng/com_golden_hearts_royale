import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poker/controllers/controller.dart';

class BetCard extends StatelessWidget {
  const BetCard({
    super.key,
    required this.credit,
    required this.name,
    required this.point,
    required this.colorName,
  });

  final int credit;
  final String name;
  final Color colorName;

  final int point;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.only(top: Get.height * 0.01, bottom: 0),
      child: Obx(
        () => Container(
          width: width * 0.17,
          height: height * 0.15,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(name == 'High Card'
                      ? gameController.isHighCard.value
                          ? 'assets/images/high card win.png'
                          : 'assets/images/high card.png'
                      : name == 'One Pair'
                          ? gameController.isPair.value
                              ? 'assets/images/Pair win.png'
                              : 'assets/images/Pair.png'
                          : name == 'Two Pair'
                              ? gameController.isTwoPair.value
                                  ? 'assets/images/two pairs win.png'
                                  : 'assets/images/two pairs.png'
                              : name == 'Three of a kind'
                                  ? gameController.isThreeOfAKind.value
                                      ? 'assets/images/Three of a kind win.png'
                                      : 'assets/images/Three of a kind.png'
                                  : name == 'Four of a kind'
                                      ? gameController.isFourOfAKind.value
                                          ? 'assets/images/Four of a kind win.png'
                                          : 'assets/images/Four of a kind.png'
                                      : name == 'Flush'
                                          ? gameController.isFlush.value
                                              ? 'assets/images/Flush win.png'
                                              : 'assets/images/Flush.png'
                                          : name == 'Full House'
                                              ? gameController.isFullHouse.value
                                                  ? 'assets/images/Full House win.png'
                                                  : 'assets/images/Full House.png'
                                              : name == 'Straight'
                                                  ? gameController
                                                          .isStraight.value
                                                      ? 'assets/images/Straight win.png'
                                                      : 'assets/images/Straight.png'
                                                  : name == 'Straight Flush'
                                                      ? gameController
                                                              .isStraightFlush
                                                              .value
                                                          ? 'assets/images/Straight Flush win.png'
                                                          : 'assets/images/Straight Flush.png'
                                                      : name == 'Royal Flush'
                                                          ? gameController
                                                                  .isRoyalStraightFlush
                                                                  .value
                                                              ? 'assets/images/Royal Flush win.png'
                                                              : 'assets/images/Royal Flush.png'
                                                          : 'assets/pannel.png'),
                  fit: BoxFit.fill)),
        ),
      ),
    );
  }
}
