import 'dart:ui';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foodbar_user/settings/settings.dart';

class PageWithScalableHeader extends StatefulWidget {
  PageWithScalableHeader({
    Key? key,
    this.headerColor = Colors.grey,
    this.heroTag,
    this.headerDescription,
    this.headerTitle,
    this.dontShowBigTitle = false,
    this.headerBackImageUrl,
    this.actionButtons = const [],
    this.headerButtonSize = 25,
    this.borderRaduis = 40,
    this.headerHeight = 300,
    this.leftSideBorder = true,
    this.rightSideBorder = true,
    this.bodyColor = Colors.white,
    this.body,
    this.paddingBodyFromTop,
    this.isFlexible = true,
    this.isHeaderExtendWhenPageOpened = true,
  }) : super(key: key);

  final String heroTag;
  final String headerTitle;
  final String headerDescription;
  final Color headerColor;
  final String headerBackImageUrl;
  final List<Widget> actionButtons;
  final double headerButtonSize;

  Color bodyColor;
  final Widget body;
  final double borderRaduis;
  final double headerHeight;
  final double paddingBodyFromTop;
  final bool leftSideBorder;
  final bool rightSideBorder;
  final bool dontShowBigTitle;
  final bool isFlexible;
  final bool isHeaderExtendWhenPageOpened;

  @override
  _PageWithScalableHeaderState createState() => _PageWithScalableHeaderState();
}

class _PageWithScalableHeaderState extends State<PageWithScalableHeader>
    with TickerProviderStateMixin, AfterLayoutMixin<PageWithScalableHeader> {
  double minHeaderHeight;
  double maxHeaderExtendedHeight;
  double headerExtendedHeight;
  GlobalKey _headerKey = GlobalKey();

  double verticalDragStartPoint = 0;
  double verticalDragEndPoint = 0;
  BorderRadiusGeometry bodyBorder;

  AnimationController headerFlexibleController;
  Animation<double> headerFlexibleAnimation;
  AnimationController buttonsAnimController;
  Animation<Offset> buttonOffsetAnim;
  Animation<double> buttonFadeAnim;
  Animation<double> smallTitleFadeAnim;

  AnimationController headerContentFadeController;
  Animation<double> headerContentFadeAnim;

  @override
  void initState() {
    minHeaderHeight = 100 + widget.borderRaduis;
    maxHeaderExtendedHeight = widget.headerHeight;
    headerExtendedHeight = maxHeaderExtendedHeight;

    bodyBorder = BorderRadius.only(
      topLeft: widget.leftSideBorder
          ? Radius.circular(widget.borderRaduis)
          : Radius.circular(0),
      topRight: widget.rightSideBorder
          ? Radius.circular(widget.borderRaduis)
          : Radius.circular(0),
    );

    buttonsAnimController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));

    buttonOffsetAnim = Tween<Offset>(begin: Offset(-5, 0), end: Offset.zero)
        .animate(CurvedAnimation(
            parent: buttonsAnimController, curve: Curves.easeInQuad))
          ..addListener(() => setState(() {}))
          ..addStatusListener((status) {
            if (status == AnimationStatus.dismissed)
              Navigator.of(context).pop();
          });

    buttonFadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: buttonsAnimController, curve: Curves.easeInQuad))
      ..addListener(() => setState(() {}));

    buttonsAnimController.forward();

    headerFlexibleController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    )..addListener(() => setState(() {}));

    smallTitleFadeAnim =
        Tween<double>(begin: 1, end: 0).animate(headerFlexibleController);

    headerContentFadeController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    )..addListener(() => setState(() {}));

    headerContentFadeAnim =
        Tween<double>(begin: 0, end: 1).animate(headerContentFadeController);

    headerContentFadeController.forward();

    super.initState();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    RenderBox headerRenderBox = _headerKey.currentContext.findRenderObject();
    maxHeaderExtendedHeight =
        headerRenderBox.size.height < maxHeaderExtendedHeight
            ? maxHeaderExtendedHeight
            : headerRenderBox.size.height;

    headerFlexibleAnimation = Tween<double>(
      begin: minHeaderHeight,
      end: maxHeaderExtendedHeight,
    ).animate(CurvedAnimation(
      parent: headerFlexibleController,
      curve: Curves.fastOutSlowIn,
    ));

    if (widget.isHeaderExtendWhenPageOpened) {
      headerFlexibleController.forward();
    }
  }

  void onLeadButtonTap() {
    buttonsAnimController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    if (headerFlexibleAnimation?.value != null)
      headerExtendedHeight = headerFlexibleAnimation?.value;

    var page = SafeArea(
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Column(
              children: <Widget>[
                Container(
                  key: _headerKey,
                  height: headerExtendedHeight,
                  width: double.infinity,
                  color: widget.headerColor,
                  child: Stack(
                    children: <Widget>[
                      //background image
                      if (widget.headerBackImageUrl != null)
                        Positioned.fill(
                          child: Hero(
                            tag: widget.heroTag ?? '',
                            child: Image.network(
                              widget.headerBackImageUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                      // background filter
                      if (widget.headerBackImageUrl != null)
                        Positioned.fill(
                          child: FadeTransition(
                            opacity: smallTitleFadeAnim,
                            child: BackdropFilter(
                              filter: ImageFilter.blur(
                                sigmaX: 3,
                                sigmaY: 3,
                              ),
                              child: Container(
                                color: Colors.transparent,
                              ),
                            ),
                          ),
                        ),

                      // header gradient for behind appbar
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            height: 100,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Theme.of(context).colorScheme.secondaryVariant,
                                Colors.transparent,
                              ],
                            )),
                          ),
                        ),
                      ),

                      // header contents
                      Positioned.fill(
                        bottom: 20 + widget.borderRaduis,
                        top: 20,
                        left: 15,
                        right: 15,
                        child: Container(
                          //color: Colors.red,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              // appbar
                              Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    // lead button
                                    SlideTransition(
                                      position: buttonOffsetAnim,
                                      child: FadeTransition(
                                        opacity: buttonFadeAnim,
                                        child: GestureDetector(
                                          child: Icon(
                                            FontAwesomeIcons.chevronLeft,
                                            color: Colors.white,
                                            size: widget.headerButtonSize,
                                          ),
                                          onTap: onLeadButtonTap,
                                        ),
                                      ),
                                    ),

                                    // title
                                    if (widget.headerTitle != null)
                                      FadeTransition(
                                        opacity: smallTitleFadeAnim,
                                        child: Text(
                                          widget.headerTitle,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              shadows: [
                                                Shadow(
                                                    color: Colors.black,
                                                    blurRadius: 20),
                                                Shadow(
                                                    color: Colors.black,
                                                    blurRadius: 5),
                                              ]),
                                        ),
                                      ),

                                    // actions
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: <Widget>[
                                        for (var action in widget.actionButtons)
                                          FadeTransition(
                                            opacity: buttonFadeAnim,
                                            child: action,
                                          )
                                      ],
                                    )
                                  ],
                                ),
                              ),

                              // header Content
                              if (headerContentFadeAnim.value > 0)
                                FadeTransition(
                                  opacity: buttonFadeAnim,
                                  child: FadeTransition(
                                    opacity: headerContentFadeAnim,
                                    child: Padding(
                                      padding:
                                          EdgeInsets.only(left: 20, right: 20),
                                      child: Column(
                                        children: <Widget>[
                                          //big header
                                          if (!widget.dontShowBigTitle ??
                                              widget.headerTitle != null)
                                            Container(
                                              width: double.infinity,
                                              child: Text(
                                                widget.headerTitle,
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    fontSize: AppProperties.h1,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                    shadows: [
                                                      Shadow(
                                                          color: Colors.black,
                                                          blurRadius: 20),
                                                      Shadow(
                                                          color: Colors.black,
                                                          blurRadius: 10),
                                                      //Shadow(color: Colors.black, blurRadius: 10),
                                                    ]),
                                              ),
                                            ),
                                          // description
                                          if (widget.headerDescription != null)
                                            Container(
                                              width: double.infinity,
                                              child: Text(
                                                widget.headerDescription,
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  fontSize: AppProperties.h5,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                  shadows: [
                                                    Shadow(
                                                        color: Colors.black,
                                                        blurRadius: 20),
                                                    Shadow(
                                                        color: Colors.black,
                                                        blurRadius: 10),
                                                    //Shadow(color: Colors.black, blurRadius: 10),
                                                  ],
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),

          // body background
          Positioned(
            top: headerExtendedHeight - widget.borderRaduis,
            bottom: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: double.infinity,
              decoration: BoxDecoration(
                boxShadow: [BoxShadow(blurRadius: 20, color: Colors.grey)],
                color: widget.bodyColor,
                borderRadius: bodyBorder,
              ),
            ),
          ),

          // body content
          Positioned(
            top: headerExtendedHeight -
                ((widget.paddingBodyFromTop != null)
                    ? widget.paddingBodyFromTop
                    : widget.borderRaduis),
            bottom: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: double.infinity,
              child: widget.body,
            ),
          ),
        ],
      ),
    );

    return GestureDetector(
      child: page,
      onVerticalDragStart: (dragStartDetails) {
        verticalDragStartPoint = dragStartDetails.localPosition.dy;
      },
      onVerticalDragUpdate: (dragUpdateDetails) {
        verticalDragEndPoint = dragUpdateDetails.localPosition.dy;
      },
      onVerticalDragEnd: (drageEndDetail) {
        bool isDownDrag = (verticalDragStartPoint > verticalDragEndPoint);

        verticalDragStartPoint = 0;
        verticalDragEndPoint = 0;

        if (!widget.isFlexible) return;

        if (isDownDrag) {
          headerFlexibleController.reverse();
          headerContentFadeController.reverse();
        } else {
          headerFlexibleController.forward();
          headerContentFadeController.forward();
        }
      },
    );
  }
}
