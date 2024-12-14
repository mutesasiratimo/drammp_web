import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bootstrap/flutter_bootstrap.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:weather/weather.dart';
import 'package:web_socket_channel/html.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;
import '../../../config/base.dart';
import '../../../config/constants.dart';
import 'home/barchart.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends Base<DashboardPage> {
  var today = DateTime.now();
  // IOWebSocketChannel/WebSocketChannel for Mobile
  final homeChannel =
      HtmlWebSocketChannel.connect(Uri.parse('wss://drammp.space/ws/'));
  String salutation = "";
  WeatherFactory wf = WeatherFactory(AppConstants.weatherApiKey);
  Weather? weather;
  Timer? timer;
  final dateFormat = new DateFormat('dd-MM-yyyy');
  String _selectedFilter = "This Week";
  final List<String> _filters = [
    'This Week',
    'This Month',
    'Last Month',
    'This year',
  ];

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

  @override
  void initState() {
    salutation = greeting();
    initSocket();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> initSocket() async {
    // await homeChannel.ready;

    homeChannel.stream.listen((message) {
      // homeChannel.sink.add('received!');
      // homeChannel.sink.close(status.goingAway);
      debugPrint(message);
    });
  }

  sendMessage(HtmlWebSocketChannel channel) {
    channel.sink.add("Test Socket");
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: [
          BootstrapContainer(
            fluid: true,
            decoration: BoxDecoration(
              color: Colors.purple.shade50,
            ),
            padding: const EdgeInsets.only(top: 0),
            children: <Widget>[
              BootstrapRow(
                children: <BootstrapCol>[
                  BootstrapCol(
                    sizes: 'col-lg-6 col-md-8 col-sm-18',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 4),
                        Text(
                          "Good $salutation, Admin.",
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
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
                                        color: Colors.black,
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
              // BootstrapRow(
              //   children: <BootstrapCol>[
              //     BootstrapCol(
              //       sizes: 'col-lg-6 col-md-12 col-sm-12',
              //       child: Text(
              //         textAlign: TextAlign.start,
              //         DateFormat.yMMMEd().format(today),
              //         style: const TextStyle(
              //           fontSize: 18,
              //           fontWeight: FontWeight.bold,
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              //Entire row
              // ElevatedButton(
              //     onPressed: () => sendMessage(homeChannel),
              //     child: Text("Send Message")),
              BootstrapRow(
                children: <BootstrapCol>[
                  BootstrapCol(
                    //the 7/12 containing expansion tiles
                    sizes: 'col-lg-7 col-md-12 col-sm-12',
                    child: Column(
                      children: [
                        ExpansionTile(
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
                                  child: Card(
                                    clipBehavior: Clip.antiAlias,
                                    color: Colors.white,
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.all(15),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: 16),
                                                    child: Text(
                                                      "Motorbikes",

                                                      // style: textTheme.labelLarge!.copyWith(
                                                      //   color: textColor,
                                                      // ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: 0),
                                                    child: Text(
                                                      "18,558",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 14,
                                                      ),
                                                      // style: textTheme.headlineMedium!.copyWith(
                                                      //   color: textColor,
                                                      //   fontWeight: FontWeight.w600,
                                                      // ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: 0),
                                                    child: Text(
                                                      "UGX 1.77M/1.86M",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w600,
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
                                                  const EdgeInsets.all(8.0),
                                              height: 80,
                                              width: 80,
                                              // decoration: BoxDecoration(
                                              //   color: Colors.purple.shade100,
                                              //   borderRadius:
                                              //       const BorderRadius.all(
                                              //           Radius.circular(10)),
                                              // ),
                                              // child: const Icon(
                                              //   Icons.motorcycle,
                                              //   size: 40.0,
                                              //   color:
                                              //       AppConstants.primaryColor,
                                              // ),
                                              child: Image.asset(
                                                "assets/images/motorcycle.png",
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Divider(),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 12.0,
                                              left: 8.0,
                                              right: 8.0,
                                              top: 4.0),
                                          child: LinearPercentIndicator(
                                            // width: ((MediaQuery.of(context)
                                            //             .size
                                            //             .width) /
                                            //         5) -
                                            //     50,
                                            animation: true,
                                            lineHeight: 7.0,
                                            animationDuration: 2000,
                                            percent: 0.9,
                                            trailing: const Text(
                                              "90.0%",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            linearStrokeCap:
                                                LinearStrokeCap.roundAll,
                                            progressColor: Colors.green,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                BootstrapCol(
                                  sizes: 'col-lg-6 col-md-12 col-sm-12',
                                  child: Card(
                                    clipBehavior: Clip.antiAlias,
                                    color: Colors.white,
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.all(15),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: 16.0),
                                                    child: Text(
                                                      "Taxis",
                                                      // style: textTheme.labelLarge!.copyWith(
                                                      //   color: textColor,
                                                      // ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: 0),
                                                    child: Text(
                                                      "119",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 14,
                                                      ),
                                                      // style: textTheme.headlineMedium!.copyWith(
                                                      //   color: textColor,
                                                      //   fontWeight: FontWeight.w600,
                                                      // ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: 0),
                                                    child: Text(
                                                      "UGX 340k/960k",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w600,
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
                                                  const EdgeInsets.all(8.0),
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
                                          padding: const EdgeInsets.only(
                                              bottom: 12.0,
                                              left: 8.0,
                                              right: 8.0,
                                              top: 4.0),
                                          child: LinearPercentIndicator(
                                            // width: ((MediaQuery.of(context)
                                            //             .size
                                            //             .width) /
                                            //         5) -
                                            //     50,
                                            animation: true,
                                            lineHeight: 7.0,
                                            animationDuration: 2000,
                                            percent: 0.35,
                                            trailing: const Text(
                                              "35.0%",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            linearStrokeCap:
                                                LinearStrokeCap.roundAll,
                                            progressColor: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        ExpansionTile(
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
                                  child: Card(
                                    clipBehavior: Clip.antiAlias,
                                    color: Colors.white,
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.all(15),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: 16.0),
                                                    child: Text(
                                                      "Lockups",
                                                      // style: textTheme.labelLarge!.copyWith(
                                                      //   color: textColor,
                                                      // ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: 0),
                                                    child: Text(
                                                      "152",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 14,
                                                      ),
                                                      // style: textTheme.headlineMedium!.copyWith(
                                                      //   color: textColor,
                                                      //   fontWeight: FontWeight.w600,
                                                      // ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: 0),
                                                    child: Text(
                                                      "UGX 39M/50M",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w600,
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
                                                  const EdgeInsets.all(8.0),
                                              height: 80,
                                              width: 80,
                                              // decoration: BoxDecoration(
                                              //   color: Colors.purple.shade100,
                                              //   borderRadius:
                                              //       const BorderRadius.all(
                                              //           Radius.circular(10)),
                                              // ),
                                              child: const Icon(
                                                Icons.door_front_door_outlined,
                                                size: 50.0,
                                                color: Colors.green,
                                              ),
                                              // child: Image.asset(
                                              //   "assets/images/starhotel.png",
                                              // ),
                                            ),
                                          ],
                                        ),
                                        const Divider(),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 12.0,
                                              left: 8.0,
                                              right: 8.0,
                                              top: 4.0),
                                          child: LinearPercentIndicator(
                                            // width: ((MediaQuery.of(context)
                                            //             .size
                                            //             .width) /
                                            //         5) -
                                            //     50,
                                            animation: true,
                                            lineHeight: 7.0,
                                            animationDuration: 2000,
                                            percent: 0.79,
                                            trailing: const Text(
                                              "79.0%",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            linearStrokeCap:
                                                LinearStrokeCap.roundAll,
                                            progressColor: Colors.amber,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                BootstrapCol(
                                  sizes: 'col-lg-6 col-md-12 col-sm-12',
                                  child: Card(
                                    clipBehavior: Clip.antiAlias,
                                    color: Colors.white,
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.all(15),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: 16.0),
                                                    child: Text(
                                                      "Toll Gate Fee",
                                                      // style: textTheme.labelLarge!.copyWith(
                                                      //   color: textColor,
                                                      // ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: 0),
                                                    child: Text(
                                                      "195",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 14,
                                                      ),
                                                      // style: textTheme.headlineMedium!.copyWith(
                                                      //   color: textColor,
                                                      //   fontWeight: FontWeight.w600,
                                                      // ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: 0),
                                                    child: Text(
                                                      "UGX 195k/195k",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w600,
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
                                                  const EdgeInsets.all(8.0),
                                              height: 80,
                                              width: 80,
                                              // decoration: BoxDecoration(
                                              //   color: Colors.purple.shade100,
                                              //   borderRadius:
                                              //       const BorderRadius.all(
                                              //           Radius.circular(10)),
                                              // ),
                                              child: const Icon(
                                                Icons.toll,
                                                size: 50.0,
                                                color: Colors.teal,
                                              ),
                                              // child: Image.asset(
                                              //   "assets/images/motorcycle.png",
                                              // ),
                                            ),
                                          ],
                                        ),
                                        const Divider(),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 12.0,
                                              left: 8.0,
                                              right: 8.0,
                                              top: 4.0),
                                          child: LinearPercentIndicator(
                                            // width: ((MediaQuery.of(context)
                                            //             .size
                                            //             .width) /
                                            //         5) -
                                            //     50,
                                            animation: true,
                                            lineHeight: 7.0,
                                            animationDuration: 2000,
                                            percent: 1.0,
                                            trailing: const Text(
                                              "100%",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            linearStrokeCap:
                                                LinearStrokeCap.roundAll,
                                            progressColor: Colors.green,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        ExpansionTile(
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
                                  child: Card(
                                    clipBehavior: Clip.antiAlias,
                                    color: Colors.white,
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.all(15),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: 16.0),
                                                    child: Text(
                                                      "Hotels",
                                                      // style: textTheme.labelLarge!.copyWith(
                                                      //   color: textColor,
                                                      // ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: 0),
                                                    child: Text(
                                                      "6",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 14,
                                                      ),
                                                      // style: textTheme.headlineMedium!.copyWith(
                                                      //   color: textColor,
                                                      //   fontWeight: FontWeight.w600,
                                                      // ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: 0),
                                                    child: Text(
                                                      "UGX 5M/6M",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w600,
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
                                                  const EdgeInsets.all(8.0),
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
                                                color:
                                                    AppConstants.primaryColor,
                                              ),
                                              // child: Image.asset(
                                              //   "assets/images/starhotel.png",
                                              // ),
                                            ),
                                          ],
                                        ),
                                        const Divider(),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 12.0,
                                              left: 8.0,
                                              right: 8.0,
                                              top: 4.0),
                                          child: LinearPercentIndicator(
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
                                                color: Colors.black,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            linearStrokeCap:
                                                LinearStrokeCap.roundAll,
                                            progressColor: Colors.green,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                BootstrapCol(
                                  sizes: 'col-lg-6 col-md-12 col-sm-12',
                                  child: Card(
                                    clipBehavior: Clip.antiAlias,
                                    color: Colors.white,
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.all(15),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: 16.0),
                                                    child: Text(
                                                      "Beachfronts",
                                                      // style: textTheme.labelLarge!.copyWith(
                                                      //   color: textColor,
                                                      // ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: 0),
                                                    child: Text(
                                                      "18",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 14,
                                                      ),
                                                      // style: textTheme.headlineMedium!.copyWith(
                                                      //   color: textColor,
                                                      //   fontWeight: FontWeight.w600,
                                                      // ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: 0),
                                                    child: Text(
                                                      "UGX 4M/9M",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w600,
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
                                                  const EdgeInsets.all(8.0),
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
                                          padding: const EdgeInsets.only(
                                              bottom: 12.0,
                                              left: 8.0,
                                              right: 8.0,
                                              top: 4.0),
                                          child: LinearPercentIndicator(
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
                                                color: Colors.black,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            linearStrokeCap:
                                                LinearStrokeCap.roundAll,
                                            progressColor: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ), // the 5/12 containing graphs
                  BootstrapCol(
                    sizes: 'col-lg-5 col-md-12 col-sm-12',
                    child: Column(
                      children: [
                        const Text(
                          "Revenue Distribution",
                          // style: textTheme.headlineMedium!.copyWith(
                          //   color: textColor,
                          //   fontWeight: FontWeight.w600,
                          // ),
                        ),
                        Card(
                          clipBehavior: Clip.antiAlias,
                          color: Colors.white,
                          child: Column(
                            children: [
                              BootstrapRow(children: <BootstrapCol>[
                                BootstrapCol(
                                  sizes: "col-lg-6 col-md-12 col-sm-12",
                                  child: SizedBox(
                                    height: size.height * .4,
                                    child: const PieChartSample2(),
                                  ),
                                ),
                                BootstrapCol(
                                  sizes: "col-lg-6 col-md-12 col-sm-12",
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: size.height * .05,
                                        ),
                                        SizedBox(
                                          width: size.width * .1,
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 20,
                                                height: 20,
                                                color: Colors.blue.shade500,
                                              ),
                                              const SizedBox(
                                                width: 8,
                                              ),
                                              const Text(
                                                "Transport",
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 8.0,
                                        ),
                                        SizedBox(
                                          width: size.width * .1,
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 20,
                                                height: 20,
                                                color: Colors.orange,
                                              ),
                                              const SizedBox(
                                                width: 8,
                                              ),
                                              const Text(
                                                "Hospitality",
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 8.0,
                                        ),
                                        SizedBox(
                                          width: size.width * .1,
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 20,
                                                height: 20,
                                                color: Colors.pink,
                                              ),
                                              const SizedBox(
                                                width: 8,
                                              ),
                                              const Text(
                                                "Trade/Commerce",
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 8.0,
                                        ),
                                        SizedBox(
                                          width: size.width * .1,
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 20,
                                                height: 20,
                                                color: Colors.green,
                                              ),
                                              const SizedBox(
                                                width: 8,
                                              ),
                                              const Text(
                                                "Fisheries",
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 8.0,
                                        ),
                                        SizedBox(
                                          width: size.width * .1,
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 20,
                                                height: 20,
                                                color: Colors.red,
                                              ),
                                              const SizedBox(
                                                width: 8,
                                              ),
                                              const Text(
                                                "Sports",
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 8.0,
                                        ),
                                        SizedBox(
                                          width: size.width * .1,
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 20,
                                                height: 20,
                                                color: Colors.yellow,
                                              ),
                                              const SizedBox(
                                                width: 8,
                                              ),
                                              const Text(
                                                "Admin",
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
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
                        const Text(
                          "Revenue Collection",
                          // style: textTheme.headlineMedium!.copyWith(
                          //   color: textColor,
                          //   fontWeight: FontWeight.w600,
                          // ),
                        ),
                        Card(
                          clipBehavior: Clip.antiAlias,
                          color: Colors.white,
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
                                  child: BarChartPage(),
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
    );
  }

  Widget _linearProgressIndicator(BuildContext context, double? value,
      Color color, bool withBottomPadding) {
    final themeData = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: (withBottomPadding ? 15.0 : 0.0)),
      child: Theme(
        data: themeData.copyWith(
          colorScheme: themeData.colorScheme.copyWith(primary: color),
        ),
        child: LinearProgressIndicator(
          value: value,
          backgroundColor: themeData.scaffoldBackgroundColor,
        ),
      ),
    );
  }

  Widget _accountToggle(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(0.0),
      margin: const EdgeInsets.only(right: 12.0),
      child: PopupMenuButton(
        splashRadius: 0.0,
        tooltip: '',
        position: PopupMenuPosition.under,
        itemBuilder: (context) => [
          PopupMenuItem(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage:
                        NetworkImage("https://picsum.photos/id/28/50"),
                    radius: 20.0,
                  ),
                  SizedBox(width: kDefaultPadding * 0.5),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Admin User"),
                      Text("admin@email.com"),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const PopupMenuItem(
            child: Row(
              children: [
                Icon(Icons.logout),
                Text("Sign Out"),
              ],
            ),
          ),
        ],
        child: Row(
          children: [
            const CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: NetworkImage("https://picsum.photos/id/28/50"),
              radius: 16.0,
            ),
            SizedBox(width: kDefaultPadding * 0.5),
            const Text(
              'Hi, Admin',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PieChartSample2 extends StatefulWidget {
  const PieChartSample2({super.key});

  @override
  State<StatefulWidget> createState() => PieChart2State();
}

class PieChart2State extends State {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: Row(
        children: <Widget>[
          const SizedBox(
            height: 18,
          ),
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          touchedIndex = -1;
                          return;
                        }
                        touchedIndex = pieTouchResponse
                            .touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                  sections: showingSections(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(4, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Colors.blue.shade500,
            value: 40,
            title: '40%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: Colors.orange,
            value: 22,
            title: '22%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        case 2:
          return PieChartSectionData(
            color: Colors.pink,
            value: 20,
            title: '20%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        case 3:
          return PieChartSectionData(
            color: const Color.fromRGBO(76, 175, 80, 1),
            value: 18,
            title: '18%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        default:
          throw Error();
      }
    });
  }
}

// class BarChartPage extends StatefulWidget {
//   const BarChartPage({super.key});

//   @override
//   State<StatefulWidget> createState() => _BarChartPageState();
// }

// class _BarChartPageState extends State {
// // class _BarChart extends StatelessWidget {
// //   const _BarChart();

//   @override
//   Widget build(BuildContext context) {
//     return BarChart(
//       BarChartData(
//         barTouchData: barTouchData,
//         titlesData: titlesData,
//         borderData: borderData,
//         barGroups: barGroups,
//         gridData: const FlGridData(show: false),
//         alignment: BarChartAlignment.spaceAround,
//         maxY: 20,
//       ),
//     );
//   }

//   BarTouchData get barTouchData => BarTouchData(
//         enabled: false,
//         touchTooltipData: BarTouchTooltipData(
//           getTooltipColor: (group) => Colors.transparent,
//           tooltipPadding: EdgeInsets.zero,
//           tooltipMargin: 8,
//           getTooltipItem: (
//             BarChartGroupData group,
//             int groupIndex,
//             BarChartRodData rod,
//             int rodIndex,
//           ) {
//             return BarTooltipItem(
//               rod.toY.round().toString(),
//               const TextStyle(
//                 color: AppConstants.primaryColor,
//                 fontWeight: FontWeight.bold,
//               ),
//             );
//           },
//         ),
//       );

//   Widget getTitles(double value, TitleMeta meta) {
//     final style = TextStyle(
//       color: Colors.black,
//       fontWeight: FontWeight.bold,
//       fontSize: 14,
//     );
//     String text;
//     switch (value.toInt()) {
//       case 0:
//         text = 'Mon';
//         break;
//       case 1:
//         text = 'Tue';
//         break;
//       case 2:
//         text = 'Wed';
//         break;
//       case 3:
//         text = 'Thu';
//         break;
//       case 4:
//         text = 'Fri';
//         break;
//       case 5:
//         text = 'Sat';
//         break;
//       case 6:
//         text = 'Sun';
//         break;
//       default:
//         text = '';
//         break;
//     }
//     return SideTitleWidget(
//       axisSide: meta.axisSide,
//       space: 4,
//       child: Text(text, style: style),
//     );
//   }

//   FlTitlesData get titlesData => FlTitlesData(
//         show: true,
//         bottomTitles: AxisTitles(
//           sideTitles: SideTitles(
//             showTitles: true,
//             reservedSize: 30,
//             getTitlesWidget: getTitles,
//           ),
//         ),
//         leftTitles: const AxisTitles(
//           sideTitles: SideTitles(showTitles: false),
//         ),
//         topTitles: const AxisTitles(
//           sideTitles: SideTitles(showTitles: false),
//         ),
//         rightTitles: const AxisTitles(
//           sideTitles: SideTitles(showTitles: false),
//         ),
//       );

//   FlBorderData get borderData => FlBorderData(
//         show: false,
//       );

//   LinearGradient get _barsGradient => LinearGradient(
//         colors: [
//           Colors.blue,
//           Colors.blueAccent,
//         ],
//         begin: Alignment.bottomCenter,
//         end: Alignment.topCenter,
//       );

//   List<BarChartGroupData> get barGroups => [
//         BarChartGroupData(
//           x: 0,
//           barRods: [
//             BarChartRodData(
//               toY: 8,
//               gradient: _barsGradient,
//             )
//           ],
//           showingTooltipIndicators: [0],
//         ),
//         BarChartGroupData(
//           x: 1,
//           barRods: [
//             BarChartRodData(
//               toY: 10,
//               gradient: _barsGradient,
//             )
//           ],
//           showingTooltipIndicators: [0],
//         ),
//         BarChartGroupData(
//           x: 2,
//           barRods: [
//             BarChartRodData(
//               toY: 14,
//               gradient: _barsGradient,
//             )
//           ],
//           showingTooltipIndicators: [0],
//         ),
//         BarChartGroupData(
//           x: 3,
//           barRods: [
//             BarChartRodData(
//               toY: 15,
//               gradient: _barsGradient,
//             )
//           ],
//           showingTooltipIndicators: [0],
//         ),
//         BarChartGroupData(
//           x: 4,
//           barRods: [
//             BarChartRodData(
//               toY: 13,
//               gradient: _barsGradient,
//             )
//           ],
//           showingTooltipIndicators: [0],
//         ),
//         BarChartGroupData(
//           x: 5,
//           barRods: [
//             BarChartRodData(
//               toY: 10,
//               gradient: _barsGradient,
//             )
//           ],
//           showingTooltipIndicators: [0],
//         ),
//         BarChartGroupData(
//           x: 6,
//           barRods: [
//             BarChartRodData(
//               toY: 16,
//               gradient: _barsGradient,
//             )
//           ],
//           showingTooltipIndicators: [0],
//         ),
//       ];
// }
