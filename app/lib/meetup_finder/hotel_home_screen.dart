import 'dart:collection';
import 'dart:ffi';
import 'dart:math';

import 'package:best_flutter_ui_templates/meetup_finder/calendar_popup_view.dart';
import 'package:best_flutter_ui_templates/meetup_finder/hotel_list_view.dart';
import 'package:best_flutter_ui_templates/meetup_finder/model/meetup.dart';
import 'package:best_flutter_ui_templates/meetup_finder/model/popular_filter_list.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'backend/meetupsDb.dart';
import 'filters_screen.dart';
import 'map_screen.dart';
import 'hotel_app_theme.dart';
import 'package:geolocator/geolocator.dart';

//NOTE: this is the main explore page

class HotelHomeScreen extends StatefulWidget {
  @override
  _HotelHomeScreenState createState() => _HotelHomeScreenState();
}

class _HotelHomeScreenState
    extends State<HotelHomeScreen> //where getData is called
    with
        TickerProviderStateMixin {
  AnimationController? animationController;
  final ScrollController _scrollController = ScrollController();

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(const Duration(days: 5));

  List<Meetup>? meetupsData;
  List<SortableMeetup>? sortedMeetupsData;
  List<SortableMeetup>? filteredSortedMeetupsData;
  List<Object>? filterState;
  bool? locationPermissionProvided;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    super.initState();
    //Request permissions
    Geolocator.checkPermission().then((permission) async {
      print(permission);
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Permissions are denied, next time you could try
          // requesting permissions again (this is also where
          // Android's shouldShowRequestPermissionRationale
          // returned true. According to Android guidelines
          // your App should show an explanatory UI now.
          locationPermissionProvided = false;
          // return Future.error('Location permissions are denied');
          return showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                  title: Text("Location not provided"),
                  content: Text("Because you have not provided access to your" +
                      " location, we will be unable to find ones which are close by."));
            },
          ); //showDialog
        }
      }
      locationPermissionProvided = true;
    });
  }

  Future<bool> getData() async {
    // Meetups data and current location
    meetupsData ??= await meetups(); //if not yet init collected, receive it.
    if (sortedMeetupsData == null) {
      sortedMeetupsData = List.empty(growable: true);
      var currentPos = await Geolocator.getCurrentPosition();
      for (int i = 0; i < meetupsData!.length; i++) {
        //calculate distances of meetups from user
        if (locationPermissionProvided!) {
          sortedMeetupsData!.add(SortableMeetup(
              distanceFromUser: Geolocator.distanceBetween(
                  currentPos.latitude,
                  currentPos.longitude,
                  meetupsData![i].lat,
                  meetupsData![i].lng),
              meetup: meetupsData![i]));
        } else {
          sortedMeetupsData!.add(
              SortableMeetup(distanceFromUser: -1.0, meetup: meetupsData![i]));
        }
        sortedMeetupsData!
            .sort((a, b) => a.distanceFromUser.compareTo(b.distanceFromUser));
      }
    }
    if (filterState != null) {
      filteredSortedMeetupsData = List.empty();
      DistanceFilterState maxDistanceAway =
          filterState![0] as DistanceFilterState;
      double correctedMaxDistance = maxDistanceAway.distanceAlongSlider / 5.0;
      print('corrected max distance: ' + correctedMaxDistance.toString());
      List<FilterListData> mustHaves = filterState![1] as List<FilterListData>;
      List<FilterListData> locationType =
          filterState![2] as List<FilterListData>;
      int farthestMeetupToIncludeIndex = meetupsData!.length - 1;
      for (int i = 0; i < sortedMeetupsData!.length; i++) {
        // filter by distance
        if (correctedMaxDistance < sortedMeetupsData![i].distanceFromUser) {
          farthestMeetupToIncludeIndex = max(0, i - 1);
          print(farthestMeetupToIncludeIndex);
          break;
        }
      }
      for (int i = 0; i <= farthestMeetupToIncludeIndex; i++) {
        filteredSortedMeetupsData!.add(sortedMeetupsData![i]);
      }
      // for (FilterListData mustHave in mustHaves) {
      //   for (int i = 0; i < filteredSortedMeetupsData!.length; i++) {
      //     if (filteredSortedMeetupsData![i].meetup.bagDrop == 1) {
      //       filter
      //     }
      //   }
      // }
    } else {
      filteredSortedMeetupsData = sortedMeetupsData!;
    }
    // Sort the meetups by distance from a user
    for (int i = 0; i < sortedMeetupsData!.length; i++) {
      print("Distance from user of meetup " +
          sortedMeetupsData![i].meetup.groupName +
          ": " +
          sortedMeetupsData![i].distanceFromUser.toString());
    }
    return true;
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  Future<void> showOnGoogleMaps(double lat, double lng) async {
    final gmapsUri = Uri(
        scheme: 'https',
        host: 'google.com',
        path: '/maps/search/',
        queryParameters: {
          'api': '1',
          'query': lat.toString() + ', ' + lng.toString()
        });
    //example url: https://www.google.com/maps/search/?api=1&query=47.5951518%2C-122.3316393
    if (!await launchUrl(gmapsUri)) {
      throw Exception('Could not launch $gmapsUri');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: HotelAppTheme.buildLightTheme(),
      child: Container(
        child: Scaffold(
          body: Stack(
            children: <Widget>[
              InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: Column(
                  children: <Widget>[
                    getAppBarUI(),
                    Expanded(
                      child: NestedScrollView(
                        controller: _scrollController,
                        headerSliverBuilder:
                            (BuildContext context, bool innerBoxIsScrolled) {
                          return <Widget>[
                            SliverList(
                              delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                                return Column(
                                  children: <Widget>[
                                    // getSearchBarUI(), //TODO: search bar
                                    getTimeDateUI(),
                                  ],
                                );
                              }, childCount: 1),
                            ),
                            SliverPersistentHeader(
                              pinned: true,
                              floating: true,
                              delegate: ContestTabHeader(
                                getFilterBarUI(),
                              ),
                            ),
                          ];
                        },
                        body: Container(
                          color: HotelAppTheme.buildLightTheme()
                              .colorScheme
                              .background,
                          child: FutureBuilder<bool>(
                            future: getData(),
                            builder: (BuildContext context,
                                AsyncSnapshot<bool> snapshot) {
                              if (!snapshot.hasData) {
                                return const SizedBox();
                              } else if (!(locationPermissionProvided!)) {
                                // Meetups unsorted by location
                                return ListView.builder(
                                  itemCount: meetupsData!.length,
                                  padding: const EdgeInsets.only(top: 8),
                                  scrollDirection: Axis.vertical,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final int count = meetupsData!.length > 10
                                        ? 10
                                        : meetupsData!.length;
                                    final Animation<double> animation =
                                        Tween<double>(begin: 0.0, end: 1.0)
                                            .animate(CurvedAnimation(
                                                parent: animationController!,
                                                curve: Interval(
                                                    (1 / count) * index, 1.0,
                                                    curve:
                                                        Curves.fastOutSlowIn)));
                                    animationController?.forward();
                                    return HotelListView(
                                      callback: () {
                                        showOnGoogleMaps(
                                            filteredSortedMeetupsData![index]
                                                .meetup
                                                .lat,
                                            filteredSortedMeetupsData![index]
                                                .meetup
                                                .lng);
                                      }, //still can be viewed on map
                                      meetupData:
                                          filteredSortedMeetupsData![index],
                                      animation: animation,
                                      animationController: animationController!,
                                    );
                                  },
                                );
                              } else {
                                // Meetups sorted by location
                                return ListView.builder(
                                  itemCount: filteredSortedMeetupsData!.length,
                                  padding: const EdgeInsets.only(top: 8),
                                  scrollDirection: Axis.vertical,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final int count =
                                        filteredSortedMeetupsData!.length > 10
                                            ? 10
                                            : filteredSortedMeetupsData!.length;
                                    final Animation<double> animation =
                                        Tween<double>(begin: 0.0, end: 1.0)
                                            .animate(CurvedAnimation(
                                                parent: animationController!,
                                                curve: Interval(
                                                    (1 / count) * index, 1.0,
                                                    curve:
                                                        Curves.fastOutSlowIn)));
                                    animationController?.forward();
                                    return HotelListView(
                                      callback: () {
                                        showOnGoogleMaps(
                                            filteredSortedMeetupsData![index]
                                                .meetup
                                                .lat,
                                            filteredSortedMeetupsData![index]
                                                .meetup
                                                .lng);
                                      },
                                      meetupData:
                                          filteredSortedMeetupsData![index],
                                      animation: animation,
                                      animationController: animationController!,
                                    );
                                  },
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getListUI() {
    //where data is gotten
    return Container(
      decoration: BoxDecoration(
        color: HotelAppTheme.buildLightTheme().colorScheme.background,
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              offset: const Offset(0, -2),
              blurRadius: 8.0),
        ],
      ),
      child: Column(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height - 156 - 50,
            child: FutureBuilder<bool>(
              future: getData(),
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                if (!snapshot.hasData) {
                  return const SizedBox();
                } else {
                  return ListView.builder(
                    itemCount: meetupsData!.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index) {
                      final int count =
                          meetupsData!.length > 10 ? 10 : meetupsData!.length;
                      final Animation<double> animation =
                          Tween<double>(begin: 0.0, end: 1.0).animate(
                              CurvedAnimation(
                                  parent: animationController!,
                                  curve: Interval((1 / count) * index, 1.0,
                                      curve: Curves.fastOutSlowIn)));
                      animationController?.forward();

                      return HotelListView(
                        callback: () {
                          showOnGoogleMaps(
                              filteredSortedMeetupsData![index].meetup.lat,
                              filteredSortedMeetupsData![index].meetup.lng);
                        },
                        meetupData: filteredSortedMeetupsData![index],
                        animation: animation,
                        animationController: animationController!,
                      );
                    },
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }

  /// NOT CURRENTLY USED
  // Widget getHotelViewList() {
  //   final List<Widget> hotelListViews = <Widget>[];
  //   for (int i = 0; i < meetupsData!.length; i++) {
  //     final int count = meetupsData!.length;
  //     final Animation<double> animation =
  //         Tween<double>(begin: 0.0, end: 1.0).animate(
  //       CurvedAnimation(
  //         parent: animationController!,
  //         curve: Interval((1 / count) * i, 1.0, curve: Curves.fastOutSlowIn),
  //       ),
  //     );
  //     hotelListViews.add(
  //       HotelListView(
  //         callback: showOnGoogleMaps(filteredSortedMeetupsData![i].meetup.lat,
  //             filteredSortedMeetupsData![i].meetup.lng),
  //         meetupData: filteredSortedMeetupsData![i],
  //         animation: animation,
  //         animationController: animationController!,
  //       ),
  //     );
  //   }
  //   animationController?.forward();
  //   return Column(
  //     children: hotelListViews,
  //   );
  // }

  Widget getTimeDateUI() {
    return Padding(
      padding: const EdgeInsets.only(left: 18, bottom: 16),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    focusColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    splashColor: Colors.grey.withOpacity(0.2),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(4.0),
                    ),
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      // setState(() {
                      //   isDatePopupOpen = true;
                      // });
                      showDemoDialog(context: context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 8, right: 8, top: 4, bottom: 4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Choose date',
                            style: TextStyle(
                                fontWeight: FontWeight.w100,
                                fontSize: 16,
                                color: Colors.grey.withOpacity(0.8)),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            '${DateFormat("dd, MMM").format(startDate)} - ${DateFormat("dd, MMM").format(endDate)}',
                            style: TextStyle(
                              fontWeight: FontWeight.w100,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Container(
              width: 1,
              height: 42,
              color: Colors.grey.withOpacity(0.8),
            ),
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    focusColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    splashColor: Colors.grey.withOpacity(0.2),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(4.0),
                    ),
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 8, right: 8, top: 4, bottom: 4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Choose times',
                            style: TextStyle(
                                fontWeight: FontWeight.w100,
                                fontSize: 16,
                                color: Colors.grey.withOpacity(0.8)),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            'All day',
                            style: TextStyle(
                              fontWeight: FontWeight.w100,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget getSearchBarUI() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: HotelAppTheme.buildLightTheme().backgroundColor,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(38.0),
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        offset: const Offset(0, 2),
                        blurRadius: 8.0),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 4, bottom: 4),
                  child: TextField(
                    onChanged: (String txt) {},
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                    cursorColor: HotelAppTheme.buildLightTheme().primaryColor,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'London...',
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: HotelAppTheme.buildLightTheme().primaryColor,
              borderRadius: const BorderRadius.all(
                Radius.circular(38.0),
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey.withOpacity(0.4),
                    offset: const Offset(0, 2),
                    blurRadius: 8.0),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: const BorderRadius.all(
                  Radius.circular(32.0),
                ),
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Icon(FontAwesomeIcons.magnifyingGlass,
                      size: 20,
                      color: HotelAppTheme.buildLightTheme().backgroundColor),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getFilterBarUI() {
    return Stack(
      children: <Widget>[
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 24,
            decoration: BoxDecoration(
              color: HotelAppTheme.buildLightTheme().colorScheme.background,
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    offset: const Offset(0, -2),
                    blurRadius: 8.0),
              ],
            ),
          ),
        ),
        Container(
          color: HotelAppTheme.buildLightTheme().colorScheme.background,
          child: Padding(
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 4),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Meetups sorted by proximity',
                      style: TextStyle(
                        fontWeight: FontWeight.w100,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    focusColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    splashColor: Colors.grey.withOpacity(0.2),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(4.0),
                    ),
                    onTap: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      filterState = await Navigator.push<dynamic>(
                        context,
                        MaterialPageRoute<dynamic>(
                            builder: (BuildContext context) => FiltersScreen(),
                            fullscreenDialog: true),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Row(
                        children: <Widget>[
                          Text(
                            'Filter',
                            style: TextStyle(
                              fontWeight: FontWeight.w100,
                              fontSize: 16,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.sort,
                                color: HotelAppTheme.buildLightTheme()
                                    .primaryColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Divider(
            height: 1,
          ),
        )
      ],
    );
  }

  void showDemoDialog({BuildContext? context}) {
    showDialog<dynamic>(
      context: context!,
      builder: (BuildContext context) => CalendarPopupView(
        barrierDismissible: true,
        minimumDate: DateTime.now(),
        //  maximumDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 10),
        initialEndDate: endDate,
        initialStartDate: startDate,
        onApplyClick: (DateTime startData, DateTime endData) {
          setState(() {
            startDate = startData;
            endDate = endData;
          });
        },
        onCancelClick: () {},
      ),
    );
  }

  Widget getAppBarUI() {
    return Container(
      decoration: BoxDecoration(
        color: HotelAppTheme.buildLightTheme().backgroundColor,
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              offset: const Offset(0, 2),
              blurRadius: 8.0),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top, left: 8, right: 8),
        child: Row(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              width: AppBar().preferredSize.height + 40,
              height: AppBar().preferredSize.height,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(32.0),
                  ),
                  // onTap: () {
                  //   Navigator.pop(context);
                  // },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    // child: Icon(Icons.arrow_back),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  'GroupRun',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                  ),
                ),
              ),
            ),
            Container(
              width: AppBar().preferredSize.height + 40,
              height: AppBar().preferredSize.height,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(32.0),
                      ),
                      onTap: () {}, //TODO: favorite
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.favorite_border),
                      ),
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(32.0),
                      ),
                      onTap: () {
                        Navigator.push<dynamic>(
                          context,
                          MaterialPageRoute<dynamic>(
                              builder: (BuildContext context) => MapScreen(),
                              fullscreenDialog: true),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(FontAwesomeIcons.locationDot),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ContestTabHeader extends SliverPersistentHeaderDelegate {
  ContestTabHeader(
    this.searchUI,
  );
  final Widget searchUI;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return searchUI;
  }

  @override
  double get maxExtent => 52.0;

  @override
  double get minExtent => 52.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
