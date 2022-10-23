import 'package:flutter/material.dart';
import 'widgets.dart';
import 'package:foodbar_user/screens/tab_reservation.dart';

class ReservationFooterButtons extends StatelessWidget {
  const ReservationFooterButtons({
    Key? key,
    @required this.currentPage,
    @required this.totalWidth,
    @required PageController pageController,
    @required this.pageTransitionDuration,
    @required this.transitionCurve,
    @required this.pageDetail,
  })  : _pageController = pageController,
        super(key: key);

  final int currentPage;
  final double totalWidth;
  final PageController _pageController;
  final Duration pageTransitionDuration;
  final Curve transitionCurve;
  final ReservationPageDetail pageDetail;

  bool returnTrue() {
    return true;
  }

  @override
  Widget build(BuildContext context) {
    Widget previusBtn;
    Widget nextBtn;
    double marginSide = 5;

    bool isNextActive = pageDetail.isActive != null ? pageDetail.isActive() : true;

    // previus Button
    if (pageDetail.onTapPreviusButton != null) {
      previusBtn = StatusButton(
        width: totalWidth / 2 - 50,
        margine: EdgeInsets.only(left: marginSide, right: marginSide),
        title: pageDetail.previusbuttonlable,
        onTap: pageDetail.onTapPreviusButton,
        isActive: true
      );
    } else if (currentPage > 0) {
      previusBtn = StatusButton(
        width: totalWidth / 2 - 50,
        margine: EdgeInsets.only(left: marginSide, right: marginSide),
        title: 'Back',
        isActive: true,
        onTap: (completer) {
          _pageController
              .previousPage(
                duration: pageTransitionDuration,
                curve: transitionCurve,
              )
              .then((_) => completer.complete());
        },
      );
    }

    // Next Button
    if (pageDetail.onTapNextButton != null) {
      nextBtn = StatusButton(
        width: totalWidth / 2 - 50,
        margine: EdgeInsets.only(left: 5, right: 5),
        title: pageDetail?.nextbuttonlable ?? '',
        onTap: pageDetail?.onTapNextButton,
        isActive: isNextActive,
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        if (previusBtn != null) previusBtn,
        if (nextBtn != null) nextBtn
      ],
    );
  }
}
