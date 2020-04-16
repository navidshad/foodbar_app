import 'dart:async';

import 'package:foodbar_user/settings/settings.dart';
import 'package:foodbar_user/widgets/table_type_slider.dart';
import 'package:flutter/material.dart';

import 'package:foodbar_user/bloc/bloc.dart';
import 'package:foodbar_user/widgets/widgets.dart';

class ReservationPageDetail {
  Function(BuildContext context) builder;
  String lable;
  String nextbuttonlable;
  String previusbuttonlable;
  Function(Completer compeleter) onTapNextButton;
  Function(Completer compeleter) onTapPreviusButton;
  Function onPageLoaded;
  bool Function() isActive;

  ReservationPageDetail({
    this.lable,
    this.builder,
    this.nextbuttonlable,
    this.previusbuttonlable,
    this.onTapNextButton,
    this.onTapPreviusButton,
    this.onPageLoaded,
    this.isActive,
  });
}

class ReservationTab extends StatefulWidget {
  ReservationTab({Key key}) : super(key: key);

  @override
  _ReservationTabState createState() => _ReservationTabState();
}

class _ReservationTabState extends State<ReservationTab> {
  ReservationBloc bloc;
  ConfirmState confirmState;
  Key personSliderKey;

  double totalHeight;
  double totalWidth;

  int initialPage = 0;
  int currentPage = 0;
  PageController _pageController;
  Duration pageTransitionDuration;
  Curve transitionCurve = Curves.easeInOut;
  ReservationPageDetail pageDetail;
  List<ReservationPageDetail> pages;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    bloc = BlocProvider.of<ReservationBloc>(context);

    bloc.stateStream.listen((state) {
      if (state is ConfirmState) {
        confirmState = state;
        if (this.mounted) setState(() {});
      }
    });
  }

  @override
  void initState() {
    _pageController = PageController(
      viewportFraction: 1,
      initialPage: initialPage - 1,
    );

    pageTransitionDuration = Duration(milliseconds: 200);

    pages = [
      // Table Picker
      ReservationPageDetail(
        lable: 'What type of table do you want?',
        nextbuttonlable: 'Next',
        isActive: () {
          if (ReservationBloc.selectedTable != null)
            return true;
          else
            return false;
        },
        onPageLoaded: () {
          ReservationBloc.selectedTable = null;
          ReservationBloc.selectedDate = null;
          ReservationBloc.selectedTime = null;
          ReservationBloc.selectedPersons = 0;
        },
        onTapNextButton: (completer) {
          _pageController
              .nextPage(
            duration: pageTransitionDuration,
            curve: transitionCurve,
          )
              .whenComplete(() {
            completer.complete();
          });
        },
        builder: (context) {
          return TableSlider(
            bloc: bloc,
            onPicked: (table) {
              ReservationBloc.selectedTable = table;
              if (mounted) setState(() {});
            },
          );
        },
      ),

      // Date Picker
      ReservationPageDetail(
        lable: 'When do you want to come here?',
        nextbuttonlable: 'Submit Date',
        isActive: () {
          if (ReservationBloc.selectedTime != null)
            return true;
          else
            return false;
        },
        onPageLoaded: () {
          Future.doWhile(() async {
            await Future.delayed(Duration(milliseconds: 200));
            return (ReservationBloc.selectedDate == null) ? true : false;
          }).whenComplete(() {
            bloc.eventSink.add(GetReservedTimes());
          });
        },
        onTapNextButton: (completer) {
          _pageController
              .nextPage(
            duration: pageTransitionDuration,
            curve: transitionCurve,
          )
              .whenComplete(() {
            completer.complete();
          });
        },
        builder: (context) {
          return CustomDatePicker(
            dateTitle: 'Pick a date',
            timeTitle: 'Pick a time',
            bloc: bloc,
            onPickedTime: (time) {
              if (this.mounted) setState(() {});
            },
          );
        },
      ),

      // person selector
      ReservationPageDetail(
        nextbuttonlable: 'Confirm',
        lable: 'How many people are you?',
        isActive: () {
          if (ReservationBloc.selectedPersons > 0)
            return true;
          else
            return false;
        },
        onTapNextButton: (completer) {
          bloc.eventSink.add(ReserveTable());
          _pageController
              .nextPage(
            duration: pageTransitionDuration,
            curve: transitionCurve,
          )
              .whenComplete(() {
            completer.complete();
          });
        },
        onPageLoaded: () {
          bloc.eventSink.add(GetTotalPerson());
        },
        builder: (context) {
          return PersonSelector(
            bloc: bloc,
            onSelectPerson: (value) {
              if (this.mounted) setState(() {});
            },
          );
        },
      ),

      // confirm page
      ReservationPageDetail(
        lable: '',
        nextbuttonlable: 'Main Menu',
        previusbuttonlable: 'New Reservation',
        onTapNextButton: (completer) {
          AppFrameBloc menuBloc = BlocProvider.of<AppFrameBloc>(context);
          menuBloc.eventSink.add(AppFrameEvent(
            //switchFrom: FrameTabType.Reserve,
            switchTo: FrameTabType.MENU,
          ));
        },
        onTapPreviusButton: (compeleter) {
          _pageController.jumpToPage(0);
          compeleter.complete();
        },
        builder: (context) {
          Widget stateWidget;

          if (confirmState.waitingForResult) {
            stateWidget = Center(
              child: CircularProgressIndicator(),
            );
          } else {
            //stateWidget = Text('Thank You');
            stateWidget = ConfirmStateViewer(
              isSucceed: confirmState?.result?.succeed,
              subtitle: confirmState?.result?.message,
              processID: confirmState?.result?.reservationId,
              backGroundUrl: ReservationBloc.selectedTable.image.getUrl(),
            );
          }

          return stateWidget;
        },
      )
    ];

    pageDetail = pages[initialPage];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    totalHeight = MediaQuery.of(context).size.height;
    totalWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: <Widget>[
        Positioned(
          top: 0,
          bottom: (pageDetail?.lable != null) 
            ? (totalHeight / 100) * 80
            : (totalHeight / 100) * 100,
          left: 0,
          right: 0,
          child: Container(
            child: Container(
              padding: EdgeInsets.only(left: 50, right: 50),
              child: FittedBox(
                child: Center(
                  child: Text(
                    pageDetail?.lable ?? '',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSecondary,
                        fontSize: 18),
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: (totalHeight / 100) * 10,
          bottom: (totalHeight / 100) * 15,
          left: 0,
          right: 0,
          child: Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: (totalHeight / 100) * 75,
              width: totalWidth,
              child: PageView.builder(
                itemCount: pages.length,
                controller: _pageController,
                physics: NeverScrollableScrollPhysics(),
                onPageChanged: (index) {
                  currentPage = index;
                  pageDetail = pages[currentPage];

                  if (pageDetail.onPageLoaded != null)
                    pageDetail.onPageLoaded();

                  if (this.mounted) setState(() {});
                },
                itemBuilder: (BuildContext context, int index) {
                  return pages[index].builder(context);
                },
              ),
            ),
          ),
        ),
        Positioned.fill(
          top: (totalHeight / 100) * 75,
          bottom: (totalHeight / 100) * 5,
          left: 0,
          right: 0,
          child: Container(
            width: 300,
            //padding: EdgeInsets.only(left: 100, right: 100),
            child: ReservationFooterButtons(
              currentPage: currentPage,
              totalWidth: totalWidth,
              pageController: _pageController,
              pageTransitionDuration: pageTransitionDuration,
              transitionCurve: transitionCurve,
              pageDetail: pageDetail,
            ),
          ),
        )
      ],
    );
  }

  void onConfirm() {
    ReserveTable event = ReserveTable();

    setState(() {
      ReservationBloc.selectedDate = null;
      ReservationBloc.selectedPersons = 0;

      bloc.eventSink.add(event);
    });
  }
}
