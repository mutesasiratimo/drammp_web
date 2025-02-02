import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bootstrap/flutter_bootstrap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather/weather.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/html.dart';
import '../../../config/base.dart';
import '../../../config/constants.dart';
import '../../../config/functions.dart';
import '../../../provider/messageprovider.dart';
import '../../../models/homepagestats.dart';
import 'package:provider/provider.dart';

import 'home/piechart.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends Base<DashboardPage> {
  var today = DateTime.now();
  // IOWebSocketChannel/WebSocketChannel for Mobile
  String salutation = "";
  WeatherFactory wf = WeatherFactory(AppConstants.weatherApiKey);
  Weather? weather;
  Timer? timer;
  List<DashSectorStats>? dashKitooroStats;
  List<DashSectorStats>? dashSectorStats;
  final dateFormat = new DateFormat('dd-MM-yyyy');
  String _selectedFilter = "This Week";
  int faresToday = 0,
      tripsToday = 0,
      activeVehicles = 0,
      inactiveVehicles = 0,
      totalVehicles = 0,
      passengersToday = 0;
  final List<String> _filters = [
    'This Week',
    'This Month',
    'Last Month',
    'This year',
  ];
  late Sink<dynamic> myMessageSink;

  getWeather() async {
    weather = await wf.currentWeatherByCityName("Kampala");
    debugPrint(weather!.humidity.toString() +
        " ++++++++++++++++++++++++++++++++++++++");
    timer = Timer.periodic(
      const Duration(hours: 1),
      (Timer t) async =>
          weather = await wf.currentWeatherByCityName("Kamapala"),
    );

    return weather;
  }

  String greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Morning';
    }
    if (hour < 17) {
      return 'Afternoon';
    }
    return 'Evening';
  }

  void getMobilityStats() async {
    var url = Uri.parse("${AppConstants.baseUrl}dash/stats/mobility");
    String _authToken = "";
    String _username = "";
    String _password = "";
    // debugPrint("++++++++++++++++++++ DAYS OVERDUE ++++++++++++++++++++==");
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    //Get username and password from shared prefs
    _username = prefs.getString("email")!;
    _password = prefs.getString("password")!;

    await AppFunctions.authenticate(_username, _password);
    _authToken = prefs.getString("authToken")!;

    var response = await http.get(
      url,
      headers: {
        "Content-Type": "Application/json",
        'Authorization': 'Bearer $_authToken',
      },
    );
    debugPrint("++++++" + response.body.toString() + "+++++++");
    if (response.statusCode == 200) {
      final items = json.decode(response.body);
      setState(() {
        faresToday = items["fares"];
        tripsToday = items["trips"];
        activeVehicles = items["activevehicles"];
        inactiveVehicles = items["inactivevehicles"];
        totalVehicles = activeVehicles + inactiveVehicles;
        passengersToday = items["passengers"];
      });
    } else {
      debugPrint(response.body.toString());
    }
  }

  @override
  void initState() {
    salutation = greeting();
    getMobilityStats();
    getKitoorTaxiParkStats();
    getDashSectorStats();
    initSocket();
    myMessageSink = context.read<MessageNotifierProvider>().notifyMessageSink;
    // WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  getKitoorTaxiParkStats() async {
    // DashSectorStats returnValue ;
    var url = Uri.parse(AppConstants.baseUrl + "dash/stats/kitoorotaxipark");
    String _authToken = "";
    String _username = "";
    String _password = "";

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    //Get username and password from shared prefs
    _username = prefs.getString("email")!;
    _password = prefs.getString("password")!;

    await AppFunctions.authenticate(_username, _password);
    _authToken = prefs.getString("authToken")!;

    var response = await http.get(
      url,
      headers: {
        "Content-Type": "Application/json",
        'Authorization': 'Bearer $_authToken',
      },
    );
    // print("++++DASH STATS++" + response.body.toString() + "+++++++");
    if (response.statusCode == 200) {
      final items = json.decode(response.body);
      List<DashSectorStats> statsmodel = (items as List)
          .map((data) => DashSectorStats.fromJson(data))
          .toList();

      setState(() {
        dashKitooroStats = statsmodel;
      });
    }
  }

  getDashSectorStats() async {
    // DashSectorStats returnValue ;
    var url = Uri.parse(AppConstants.baseUrl + "dash/stats/sectors");
    String _authToken = "";
    String _username = "";
    String _password = "";

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    //Get username and password from shared prefs
    _username = prefs.getString("email")!;
    _password = prefs.getString("password")!;

    await AppFunctions.authenticate(_username, _password);
    _authToken = prefs.getString("authToken")!;

    var response = await http.get(
      url,
      headers: {
        "Content-Type": "Application/json",
        'Authorization': 'Bearer $_authToken',
      },
    );
    // print("++++DASH STATS++" + response.body.toString() + "+++++++");
    if (response.statusCode == 200) {
      final items = json.decode(response.body);
      List<DashSectorStats> statsmodel = (items as List)
          .map((data) => DashSectorStats.fromJson(data))
          .toList();

      setState(() {
        dashSectorStats = statsmodel;
      });
    }
  }

  @override
  void dispose() {
    // homeChannel.sink.close(status.goingAway);
    super.dispose();
  }

  Future<void> initSocket() async {
    // await homeChannel.ready;

    // homeChannel.stream.listen((message) {
    // homeChannel.sink.add('received!');
    // homeChannel.sink.close(status.goingAway);
    // debugPrint(message);
    // });
    context.read<MessageNotifierProvider>().notifyStream.listen((value) {
      debugPrint("Update Data");
      getDashSectorStats();
      getKitoorTaxiParkStats();
    });
  }

  sendMessage(HtmlWebSocketChannel channel) {
    channel.sink.add("Test Socket");
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final goRouter = GoRouter.of(context);
    // final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // StreamBuilder(
            //   stream: context.read<MessageNotifierProvider>().notifyStream,
            //   builder: (context, snapshot) {
            //     return Text(snapshot.hasData ? '${snapshot.data}' : '');
            //   },
            // ),
            BootstrapContainer(
              fluid: true,
              padding: const EdgeInsets.only(top: 0),
              children: <Widget>[
                BootstrapRow(
                  children: <BootstrapCol>[
                    BootstrapCol(
                      sizes: 'col-lg-6 col-md-8 col-sm-12',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 4),
                          Text(
                            "Good $salutation, Admin.",
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 2),
                          Text(
                            textAlign: TextAlign.start,
                            DateFormat.yMMMEd().format(today),
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    BootstrapCol(
                      sizes: 'col-lg-3 col-md-4 col-sm-4',
                      child: FutureBuilder<dynamic>(
                        future: getWeather(), // async work
                        builder: (BuildContext context,
                            AsyncSnapshot<dynamic> snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return const Text('');
                            default:
                              if (snapshot.hasError) {
                                return const Text('');
                              } else {
                                return Row(
                                  children: [
                                    CachedNetworkImage(
                                      imageUrl:
                                          'https://openweathermap.org/img/w/${snapshot.data!.weatherIcon}.png',
                                    ),
                                    Text(
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                      "${snapshot.data!.temperature.celsius.round()}°C",
                                    ),
                                  ],
                                );
                              }
                          }
                        },
                      ),
                    ),
                  ],
                ),

                //Entire row
                // ElevatedButton(
                //     onPressed: () => AppFunctions.requestToPayMtnMomo(
                //         "2000", "SO008766", "256781780862"),
                //     child: Text("Send Message")),
                BootstrapRow(
                  children: <BootstrapCol>[
                    BootstrapCol(
                      //the 7/12 containing expansion tiles
                      sizes: 'col-lg-7 col-md-12 col-sm-12',
                      child: Column(
                        children: [
                          dashKitooroStats != null
                              ? ExpansionTile(
                                  shape: const Border(),
                                  initiallyExpanded: true,
                                  // tilePadding: EdgeInsets.all(2.0),
                                  title: const Text(
                                    "Kitooro Taxi Park",
                                    style: TextStyle(
                                      color: AppConstants.primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ), //header title
                                  children: [
                                    BootstrapRow(
                                      children: <BootstrapCol>[
                                        BootstrapCol(
                                          sizes: 'col-lg-6 col-md-12 col-sm-12',
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                                bottom: 6.0),
                                            child: Card(
                                              elevation: 8.0,
                                              clipBehavior: Clip.antiAlias,
                                              // color: Colors.white,
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.all(15),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      bottom:
                                                                          16.0),
                                                              child: Text(
                                                                "Lockups",
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      bottom:
                                                                          0),
                                                              child: Text(
                                                                "${dashKitooroStats![0].sectorcategories[0].streamcount}",
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 14,
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      bottom:
                                                                          0),
                                                              child: Text(
                                                                "UGX ${NumberFormat.compactCurrency(
                                                                  decimalDigits:
                                                                      1,
                                                                  symbol: '',
                                                                ).format(dashKitooroStats![0].sectorcategories[0].paidrevenue.round()).toString()}/${NumberFormat.compactCurrency(
                                                                  decimalDigits:
                                                                      1,
                                                                  symbol: '',
                                                                ).format(dashKitooroStats![0].sectorcategories[0].expectedrevenue.round()).toString()}",
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: 12,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        height: 70,
                                                        width: 70,
                                                        child: Image.asset(
                                                          "assets/images/doorlock.png",
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const Divider(),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 12.0,
                                                            left: 8.0,
                                                            right: 8.0,
                                                            top: 4.0),
                                                    child:
                                                        LinearPercentIndicator(
                                                      // width: ((MediaQuery.of(context)
                                                      //             .size
                                                      //             .width) /
                                                      //         5) -
                                                      //     50,
                                                      animation: true,
                                                      lineHeight: 7.0,
                                                      animationDuration: 2000,
                                                      percent: (dashKitooroStats![
                                                                  0]
                                                              .sectorcategories[
                                                                  0]
                                                              .paidrevenue /
                                                          dashKitooroStats![0]
                                                              .sectorcategories[
                                                                  0]
                                                              .expectedrevenue),
                                                      trailing: Text(
                                                        "${((dashKitooroStats![0].sectorcategories[0].paidrevenue / dashKitooroStats![0].sectorcategories[0].expectedrevenue) * 100).round()}%",
                                                      ),
                                                      linearStrokeCap:
                                                          LinearStrokeCap
                                                              .roundAll,
                                                      progressColor: (dashKitooroStats![
                                                                          0]
                                                                      .sectorcategories[
                                                                          0]
                                                                      .paidrevenue /
                                                                  dashKitooroStats![
                                                                          0]
                                                                      .sectorcategories[
                                                                          0]
                                                                      .expectedrevenue) <
                                                              50.0
                                                          ? Colors.red
                                                          : (dashKitooroStats![0]
                                                                              .sectorcategories[
                                                                                  0]
                                                                              .paidrevenue /
                                                                          dashKitooroStats![0]
                                                                              .sectorcategories[
                                                                                  0]
                                                                              .expectedrevenue) >=
                                                                      50 &&
                                                                  (dashKitooroStats![0]
                                                                              .sectorcategories[
                                                                                  0]
                                                                              .paidrevenue /
                                                                          dashKitooroStats![0]
                                                                              .sectorcategories[0]
                                                                              .expectedrevenue) <
                                                                      80
                                                              ? Colors.amber
                                                              : Colors.green,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        BootstrapCol(
                                          sizes: 'col-lg-6 col-md-12 col-sm-12',
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                                bottom: 6.0),
                                            child: Card(
                                              elevation: 8.0,
                                              clipBehavior: Clip.antiAlias,
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.all(15),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      bottom:
                                                                          16.0),
                                                              child: Text(
                                                                "Toll Gate Fee",
                                                                // style: textTheme.labelLarge!.copyWith(
                                                                //   color: textColor,
                                                                // ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      bottom:
                                                                          0),
                                                              child: Text(
                                                                "${dashKitooroStats![0].sectorcategories[1].streamcount}",
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 14,
                                                                ),
                                                                // style: textTheme.headlineMedium!.copyWith(
                                                                //   color: textColor,
                                                                //   fontWeight: FontWeight.w600,
                                                                // ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      bottom:
                                                                          0),
                                                              child: Text(
                                                                "UGX ${NumberFormat.compactCurrency(
                                                                  decimalDigits:
                                                                      1,
                                                                  symbol: '',
                                                                ).format(dashKitooroStats![0].sectorcategories[1].paidrevenue.round()).toString()}",
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: 12,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        height: 80,
                                                        width: 80,
                                                        child: Image.asset(
                                                          "assets/images/tollgate.png",
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const Divider(),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 12.0,
                                                            left: 8.0,
                                                            right: 8.0,
                                                            top: 4.0),
                                                    child:
                                                        LinearPercentIndicator(
                                                      // width: ((MediaQuery.of(context)
                                                      //             .size
                                                      //             .width) /
                                                      //         5) -
                                                      //     50,
                                                      animation: true,
                                                      lineHeight: 7.0,
                                                      animationDuration: 2000,
                                                      percent: (dashSectorStats![
                                                                  0]
                                                              .sectorcategories[
                                                                  2]
                                                              .paidrevenue /
                                                          dashSectorStats![0]
                                                              .sectorcategories[
                                                                  2]
                                                              .expectedrevenue),
                                                      trailing: Text(
                                                        "${(dashKitooroStats![0].sectorcategories[1].paidrevenue / dashKitooroStats![0].sectorcategories[1].expectedrevenue) * 100}%",
                                                      ),
                                                      linearStrokeCap:
                                                          LinearStrokeCap
                                                              .roundAll,
                                                      progressColor:
                                                          Colors.green,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              : CircularProgressIndicator(),
                          dashSectorStats != null
                              ? ExpansionTile(
                                  shape: const Border(),
                                  initiallyExpanded: true,
                                  // tilePadding: EdgeInsets.all(2.0),
                                  title: const Text(
                                    "Transport",
                                    style: TextStyle(
                                      color: AppConstants.primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ), //header title
                                  children: [
                                    BootstrapRow(
                                      children: <BootstrapCol>[
                                        BootstrapCol(
                                          sizes: 'col-lg-6 col-md-12 col-sm-12',
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                                bottom: 6.0),
                                            child: Card(
                                              elevation: 8.0,
                                              clipBehavior: Clip.antiAlias,
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.all(15),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      bottom:
                                                                          16),
                                                              child: Text(
                                                                "Motorbikes",

                                                                // style: textTheme.labelLarge!.copyWith(
                                                                //   color: textColor,
                                                                // ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      bottom:
                                                                          0),
                                                              child: Text(
                                                                dashSectorStats![
                                                                        0]
                                                                    .sectorcategories[
                                                                        2]
                                                                    .streamcount
                                                                    .toString(),
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 14,
                                                                ),
                                                                // style: textTheme.headlineMedium!.copyWith(
                                                                //   color: textColor,
                                                                //   fontWeight: FontWeight.w600,
                                                                // ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      bottom:
                                                                          0),
                                                              child: Text(
                                                                "UGX ${NumberFormat.compactCurrency(
                                                                  decimalDigits:
                                                                      1,
                                                                  symbol: '',
                                                                ).format(dashSectorStats![0].sectorcategories[2].paidrevenue.round()).toString()}/${NumberFormat.compactCurrency(
                                                                  decimalDigits:
                                                                      1,
                                                                  symbol: '',
                                                                ).format(dashSectorStats![0].sectorcategories[2].expectedrevenue.round()).toString()}",
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: 12,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        height: 80,
                                                        width: 80,
                                                        child: Image.asset(
                                                          "assets/images/motorcycle.png",
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const Divider(),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 12.0,
                                                            left: 8.0,
                                                            right: 8.0,
                                                            top: 4.0),
                                                    child:
                                                        LinearPercentIndicator(
                                                      // width: ((MediaQuery.of(context)
                                                      //             .size
                                                      //             .width) /
                                                      //         5) -
                                                      //     50,
                                                      animation: true,
                                                      lineHeight: 7.0,
                                                      animationDuration: 2000,
                                                      percent: (dashSectorStats![
                                                                  0]
                                                              .sectorcategories[
                                                                  2]
                                                              .paidrevenue /
                                                          dashSectorStats![0]
                                                              .sectorcategories[
                                                                  2]
                                                              .expectedrevenue),
                                                      trailing: Text(
                                                        "${(dashSectorStats![0].sectorcategories[2].paidrevenue / dashSectorStats![0].sectorcategories[2].expectedrevenue) * 100}%",
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      linearStrokeCap:
                                                          LinearStrokeCap
                                                              .roundAll,
                                                      progressColor:
                                                          Colors.green,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        BootstrapCol(
                                          sizes: 'col-lg-6 col-md-12 col-sm-12',
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                                bottom: 6.0),
                                            child: Card(
                                              elevation: 8.0,
                                              clipBehavior: Clip.antiAlias,
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.all(15),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      bottom:
                                                                          16.0),
                                                              child: Text(
                                                                "Buses",
                                                                // style: textTheme.labelLarge!.copyWith(
                                                                //   color: textColor,
                                                                // ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      bottom:
                                                                          0),
                                                              child: Text(
                                                                "${dashSectorStats![0].sectorcategories[0].streamcount}",
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 14,
                                                                ),
                                                                // style: textTheme.headlineMedium!.copyWith(
                                                                //   color: textColor,
                                                                //   fontWeight: FontWeight.w600,
                                                                // ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      bottom:
                                                                          0),
                                                              child: Text(
                                                                "UGX ${NumberFormat.compactCurrency(
                                                                  decimalDigits:
                                                                      1,
                                                                  symbol: '',
                                                                ).format(dashSectorStats![0].sectorcategories[0].paidrevenue.round()).toString()}/${NumberFormat.compactCurrency(
                                                                  decimalDigits:
                                                                      1,
                                                                  symbol: '',
                                                                ).format(dashSectorStats![0].sectorcategories[0].expectedrevenue.round()).toString()}",
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: 12,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        // margin:
                                                        //     const EdgeInsets.all(16.0),
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        height: 80,
                                                        width: 80,
                                                        child: Image.asset(
                                                          "assets/images/shuttlebus.png",
                                                        ),
                                                        // decoration: BoxDecoration(
                                                        //   color: Colors.purple.shade100,
                                                        //   borderRadius:
                                                        //       const BorderRadius.all(
                                                        //           Radius.circular(10)),
                                                        // ),
                                                        // child: const Icon(
                                                        //   Icons.local_taxi_outlined,
                                                        //   size: 40.0,
                                                        //   color:
                                                        //       AppConstants.primaryColor,
                                                        // ),
                                                      ),
                                                    ],
                                                  ),
                                                  const Divider(),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 12.0,
                                                            left: 8.0,
                                                            right: 8.0,
                                                            top: 4.0),
                                                    child:
                                                        LinearPercentIndicator(
                                                      // width: ((MediaQuery.of(context)
                                                      //             .size
                                                      //             .width) /
                                                      //         5) -
                                                      //     50,
                                                      animation: true,
                                                      lineHeight: 7.0,
                                                      animationDuration: 2000,
                                                      percent: (dashSectorStats![
                                                                  0]
                                                              .sectorcategories[
                                                                  2]
                                                              .paidrevenue /
                                                          dashSectorStats![0]
                                                              .sectorcategories[
                                                                  2]
                                                              .expectedrevenue),
                                                      trailing: Text(
                                                        "${(dashSectorStats![0].sectorcategories[2].paidrevenue / dashSectorStats![0].sectorcategories[2].expectedrevenue).round() * 100}%",
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      linearStrokeCap:
                                                          LinearStrokeCap
                                                              .roundAll,
                                                      progressColor: Colors.red,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              : Container(),
                          dashSectorStats != null
                              ? ExpansionTile(
                                  shape: const Border(),
                                  initiallyExpanded: true,
                                  // tilePadding: EdgeInsets.all(2.0),
                                  title: const Text(
                                    "Hospitality",
                                    style: TextStyle(
                                      color: AppConstants.primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ), //header title
                                  children: [
                                    BootstrapRow(
                                      children: <BootstrapCol>[
                                        BootstrapCol(
                                          sizes: 'col-lg-6 col-md-12 col-sm-12',
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                                bottom: 6.0),
                                            child: Card(
                                              elevation: 8.0,
                                              clipBehavior: Clip.antiAlias,
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      const Padding(
                                                        padding:
                                                            EdgeInsets.all(15),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      bottom:
                                                                          16.0),
                                                              child: Text(
                                                                "Hotels",
                                                                // style: textTheme.labelLarge!.copyWith(
                                                                //   color: textColor,
                                                                // ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      bottom:
                                                                          0),
                                                              child: Text(
                                                                "6",
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 14,
                                                                ),
                                                                // style: textTheme.headlineMedium!.copyWith(
                                                                //   color: textColor,
                                                                //   fontWeight: FontWeight.w600,
                                                                // ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      bottom:
                                                                          0),
                                                              child: Text(
                                                                "UGX 5M/6M",
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: 12,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        // margin:
                                                        //     const EdgeInsets.all(16.0),
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        height: 80,
                                                        width: 80,
                                                        // decoration: BoxDecoration(
                                                        //   color: Colors.purple.shade100,
                                                        //   borderRadius:
                                                        //       const BorderRadius.all(
                                                        //           Radius.circular(10)),
                                                        // ),
                                                        child: const Icon(
                                                          Icons.hotel_sharp,
                                                          size: 50.0,
                                                          color: AppConstants
                                                              .primaryColor,
                                                        ),
                                                        // child: Image.asset(
                                                        //   "assets/images/starhotel.png",
                                                        // ),
                                                      ),
                                                    ],
                                                  ),
                                                  const Divider(),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 12.0,
                                                            left: 8.0,
                                                            right: 8.0,
                                                            top: 4.0),
                                                    child:
                                                        LinearPercentIndicator(
                                                      // width: ((MediaQuery.of(context)
                                                      //             .size
                                                      //             .width) /
                                                      //         5) -
                                                      //     50,
                                                      animation: true,
                                                      lineHeight: 7.0,
                                                      animationDuration: 2000,
                                                      percent: 0.85,
                                                      trailing: const Text(
                                                        "85.0%",
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      linearStrokeCap:
                                                          LinearStrokeCap
                                                              .roundAll,
                                                      progressColor:
                                                          Colors.green,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        BootstrapCol(
                                          sizes: 'col-lg-6 col-md-12 col-sm-12',
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                                bottom: 6.0),
                                            child: Card(
                                              elevation: 8.0,
                                              clipBehavior: Clip.antiAlias,
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      const Padding(
                                                        padding:
                                                            EdgeInsets.all(15),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      bottom:
                                                                          16.0),
                                                              child: Text(
                                                                "Beachfronts",
                                                                // style: textTheme.labelLarge!.copyWith(
                                                                //   color: textColor,
                                                                // ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      bottom:
                                                                          0),
                                                              child: Text(
                                                                "18",
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 14,
                                                                ),
                                                                // style: textTheme.headlineMedium!.copyWith(
                                                                //   color: textColor,
                                                                //   fontWeight: FontWeight.w600,
                                                                // ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      bottom:
                                                                          0),
                                                              child: Text(
                                                                "UGX 4M/9M",
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: 12,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        // margin:
                                                        //     const EdgeInsets.all(16.0),
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        height: 80,
                                                        width: 80,
                                                        // decoration: BoxDecoration(
                                                        //   color: Colors.purple.shade100,
                                                        //   borderRadius:
                                                        //       const BorderRadius.all(
                                                        //           Radius.circular(10)),
                                                        // ),
                                                        child: const Icon(
                                                          Icons.waves,
                                                          size: 50.0,
                                                          color: Colors.blue,
                                                        ),
                                                        // child: Image.asset(
                                                        //   "assets/images/motorcycle.png",
                                                        // ),
                                                      ),
                                                    ],
                                                  ),
                                                  const Divider(),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 12.0,
                                                            left: 8.0,
                                                            right: 8.0,
                                                            top: 4.0),
                                                    child:
                                                        LinearPercentIndicator(
                                                      // width: ((MediaQuery.of(context)
                                                      //             .size
                                                      //             .width) /
                                                      //         5) -
                                                      //     50,
                                                      animation: true,
                                                      lineHeight: 7.0,
                                                      animationDuration: 2000,
                                                      percent: 0.45,
                                                      trailing: const Text(
                                                        "45.0%",
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      linearStrokeCap:
                                                          LinearStrokeCap
                                                              .roundAll,
                                                      progressColor: Colors.red,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              : Container()
                        ],
                      ),
                    ), // the 5/12 containing graphs
                    BootstrapCol(
                      sizes: 'col-lg-5 col-md-12 col-sm-12',
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                "Mobility Summary",
                                style:
                                    themeData.textTheme.titleMedium!.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Card(
                            clipBehavior: Clip.antiAlias,
                            child: Column(
                              children: [
                                BootstrapRow(children: <BootstrapCol>[
                                  BootstrapCol(
                                    sizes: "col-lg-12 col-md-12 col-sm-12",
                                    child: SizedBox(
                                      height: 150,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 12.0, bottom: 4.0),
                                            child: Row(
                                              children: [
                                                Text(
                                                  "Fares Today (UGX): $faresToday",
                                                  style: themeData
                                                      .textTheme.titleMedium!
                                                      .copyWith(
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(height: 18.0),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "Active Vehicles: $activeVehicles/${activeVehicles + inactiveVehicles}",
                                                          style: themeData
                                                              .textTheme
                                                              .titleSmall!
                                                              .copyWith(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 6.0),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "Passengers today: $passengersToday",
                                                          style: themeData
                                                              .textTheme
                                                              .titleSmall!
                                                              .copyWith(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 6.0),
                                                    Row(
                                                      children: [
                                                        SizedBox(
                                                          height: 30,
                                                          child: Text(
                                                            "Trips today: $tripsToday",
                                                            style: themeData
                                                                .textTheme
                                                                .titleSmall!
                                                                .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          "Drivers' Details",
                                                          style: themeData
                                                              .textTheme
                                                              .titleSmall!
                                                              .copyWith(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                        ClipOval(
                                                          child: Material(
                                                            color: AppConstants
                                                                .primaryColor,
                                                            child: InkWell(
                                                              splashColor: Colors
                                                                  .blue
                                                                  .shade400, // Splash color
                                                              onTap: () {},
                                                              child: SizedBox(
                                                                  width: 30,
                                                                  height: 30,
                                                                  child: Icon(
                                                                    size: 20.0,
                                                                    Icons.menu,
                                                                    color: Colors
                                                                        .white,
                                                                  )),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 8.0),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          "View More",
                                                          style: themeData
                                                              .textTheme
                                                              .titleSmall!
                                                              .copyWith(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                        ClipOval(
                                                          child: Material(
                                                            color: AppConstants
                                                                .primaryColor,
                                                            child: InkWell(
                                                              splashColor: Colors
                                                                  .blue
                                                                  .shade400, // Splash color
                                                              onTap: () =>
                                                                  goRouter.go(
                                                                      "/mobility"),
                                                              child: SizedBox(
                                                                  width: 30,
                                                                  height: 30,
                                                                  child: Icon(
                                                                    size: 20.0,
                                                                    Icons
                                                                        .arrow_circle_right_outlined,
                                                                    color: Colors
                                                                        .white,
                                                                  )),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ]),
                                const SizedBox(
                                  height: 8,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 16),
                          Row(
                            children: [
                              Text(
                                "Revenue Distribution",
                                style:
                                    themeData.textTheme.titleMedium!.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Card(
                            clipBehavior: Clip.antiAlias,
                            child: Column(
                              children: [
                                BootstrapRow(children: <BootstrapCol>[
                                  BootstrapCol(
                                    sizes: "col-lg-12 col-md-12 col-sm-12",
                                    child: SizedBox(
                                      height: 220,
                                      child: PieChartSample2(),
                                    ),
                                  ),
                                ]),
                                const SizedBox(
                                  height: 8,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 16),
                          Row(
                            children: [
                              Text(
                                "Expected vs. Actual Revenue",
                                style:
                                    themeData.textTheme.titleMedium!.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Card(
                            clipBehavior: Clip.antiAlias,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    // const Text(
                                    //   "Fare Collections",
                                    //   style: TextStyle(
                                    //       fontSize: 20,
                                    //       fontWeight: FontWeight.bold),
                                    // ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: DropdownButton(
                                        value: _selectedFilter,
                                        onChanged: (newValue) {
                                          setState(() {
                                            _selectedFilter = newValue!;
                                          });
                                        },
                                        items: _filters.map((filter) {
                                          return DropdownMenuItem(
                                            value: filter,
                                            child: Text(filter),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ],
                                ),
                                Center(
                                  child: Container(
                                    margin: const EdgeInsets.all(18.0),
                                    // color: Colors.orange,
                                    height: 300,
                                    width: 400,
                                    // child: BarChartPage(),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
