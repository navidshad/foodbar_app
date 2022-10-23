import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import './vertical_swip_detector.dart';

class FlexibleTab {
  String title;
  Widget content;
  double minHeight;
  Color color;

  GlobalKey key = GlobalKey();
  double height;
  AnimationController animator;
  Animation<double> opacity;

  void updateHeight() {
    RenderBox ro = key.currentContext.findRenderObject();
    this.height = ro.size.height;
  }

  FlexibleTab({this.content, this.title, this.minHeight = 100, this.color});
}

class FlexibleVerticalTabs extends StatefulWidget {
  FlexibleVerticalTabs({
    Key? key,
    @required this.tabs,
    this.openedTabHeightPercent = 70,
  }) : super(key: key);

  final List<FlexibleTab> tabs;
  double openedTabHeightPercent;

  @override
  _FlexibleVerticalTabsState createState() => _FlexibleVerticalTabsState(tabs);
}

class _FlexibleVerticalTabsState extends State<FlexibleVerticalTabs>
    with AfterLayoutMixin, TickerProviderStateMixin {
  _FlexibleVerticalTabsState(this.tabs) {
    tabs.forEach((tab) {
      tab.animator = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 200),
      );

      tab.animator.addListener(() => setState(() {}));

      tab.opacity = Tween<double>(begin: 0.3, end: 1).animate(tab.animator);
    });
  }

  int currentTab = 0;
  List<FlexibleTab> tabs;

  double getTopMargin(int tabIndex, double totalHeight) {
    double topMargin = 0;
    double currentTabHeght = tabs[currentTab].height;
    double closedTabHeight =
        (totalHeight - currentTabHeght) / (tabs.length - 0);

    int totalTabsBeforThisTab = tabIndex;
    if (totalTabsBeforThisTab < 0) totalTabsBeforThisTab = 0;

    // befor opened tab or opened tab
    if (currentTab >= tabIndex) {
      topMargin += closedTabHeight * totalTabsBeforThisTab / 2;
    }
    // after opened tab
    else if (currentTab < tabIndex) {
      topMargin +=
          closedTabHeight * totalTabsBeforThisTab - 1 + currentTabHeght;
    }

    print(tabIndex.toString() + '-' + topMargin.toString());
    return topMargin;
  }

  @override
  void afterFirstLayout(BuildContext context) {
    for (var i = 0; i < tabs.length; i++) tabs[i].updateHeight();

    setState(() {});
  }

  void showCurrentContent() {
    for (var i = 0; i < tabs.length; i++) {
      if (currentTab == i)
        tabs[i].animator.forward();
      else
        tabs[i].animator.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        List<Widget> stackWigets = [];

        for (var i = 0; i < tabs.length; i++) {
          FlexibleTab tab = tabs[i];
        
          Widget tabWidget = AnimatedPositioned(
            top: (tab.height == null)
                ? 0
                : getTopMargin(i, constraints.maxHeight),
            bottom: 0,
            left: currentTab == i ? 10 : 20,
            right: currentTab == i ? 10 : 20,
            duration: Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            child: GestureDetector(
              onTap: () {
                currentTab = i;
                setState(() {});
              },
              child: PhysicalModel(
                color: tab.color ?? Theme.of(context).backgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: i == currentTab
                      ? Radius.circular(25)
                      : Radius.circular(0),
                  topRight: i == currentTab
                      ? Radius.circular(25)
                      : Radius.circular(0),
                ),
                elevation: 20,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                shadowColor: Colors.black,
                shape: BoxShape.rectangle,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    key: tab.key,
                    child: FadeTransition(
                      opacity: tab.opacity,
                      child: tab.content,
                    ),
                  ),
                ),
              ),
            ),
          );

          stackWigets.add(tabWidget);
        }

        showCurrentContent();

        return VerticalSwipDetector(
          child: Container(
            color: Theme.of(context).backgroundColor,
            child: Stack(children: stackWigets),
          ),
          onDownSwip: () {
            if (currentTab < tabs.length - 1) currentTab++;
          },
          onUpSwip: () {
            if (currentTab > 0) currentTab--;
          },
          onDone: () => setState(() {
            print('currentTab $currentTab');
          }),
        );
      },
    );
  }
}
