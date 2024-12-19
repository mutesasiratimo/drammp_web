import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../../config/base.dart';
import '../../../../config/constants.dart';
import '../../../../config/functions.dart';
import '../../../../models/sectorrevenuedistribution.dart';

List<Color> pieColors = [
  Colors.blue.shade500,
  Colors.orange,
  Color.fromRGBO(76, 175, 80, 1),
  Colors.purple,
  AppConstants.primaryColor,
  Colors.red,
  Colors.yellow,
  Colors.pink,
  Colors.green.shade900,
  Colors.grey.shade500
];

class PieChartSample2 extends StatefulWidget {
  const PieChartSample2({super.key});

  @override
  State<StatefulWidget> createState() => PieChart2State();
}

class PieChart2State extends Base<PieChartSample2> {
  int touchedIndex = -1;
  List<SectorRevenueDistributionModel> dashDistributionStats = [];
  late Future<List<SectorRevenueDistributionModel>> statsFuture;

  @override
  void initState() {
    statsFuture = getSectorRevenueDistributionStats();
    // initSocket();
    // myMessageSink = context.read<MessageNotifierProvider>().notifyMessageSink;
    super.initState();
  }

  Future<List<SectorRevenueDistributionModel>>
      getSectorRevenueDistributionStats() async {
    List<SectorRevenueDistributionModel> returnVal = [];
    var url =
        Uri.parse(AppConstants.baseUrl + "dash/stats/revenuedistribution");
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
      List<SectorRevenueDistributionModel> statsmodel = (items as List)
          .map((data) => SectorRevenueDistributionModel.fromJson(data))
          .toList();

      setState(() {
        returnVal = statsmodel;
        dashDistributionStats = statsmodel;
      });
    }
    return returnVal;
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
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
          SizedBox(width: 36),
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FutureBuilder<List<SectorRevenueDistributionModel>>(
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.none &&
                      snapshot.hasData) {
                    //print('project snapshot data is: ${snapshot.data}');
                    return Container();
                  }
                  return SizedBox(
                    height: 200,
                    child: ListView.builder(
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, index) {
                        // SectorRevenueDistributionModel project =
                        //     snapshot.data[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                color: pieColors[index],
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                "${snapshot.data?[index].sectorname}",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
                future: statsFuture,
              ),
            ],
          ))
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    double total = 0.0;
    int index = 0;
    final isTouched = index == touchedIndex;
    final fontSize = isTouched ? 25.0 : 16.0;
    final radius = isTouched ? 60.0 : 50.0;
    const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
    List<PieChartSectionData> returnValue = [];
    if (dashDistributionStats.isNotEmpty) {
      for (var i in dashDistributionStats) {
        total += i.expectedrevenue;
      }
      for (var i in dashDistributionStats) {
        returnValue.add(PieChartSectionData(
          color: pieColors[index],
          value: ((i.expectedrevenue / total) * 100),
          title: '${((i.expectedrevenue / total) * 100).round()}%',
          radius: radius,
          titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: shadows,
          ),
        ));
        index++;
      }
    } else {
      throw Error();
    }
    return returnValue;
  }
}
