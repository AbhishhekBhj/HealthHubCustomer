import 'package:flutter/material.dart';
import 'package:healthhubcustomer/Controller/providers/theme_provider.dart';
import 'package:healthhubcustomer/colors/colors.dart';
import 'package:healthhubcustomer/utils/custom_textStyles.dart';
import 'package:healthhubcustomer/utils/utils.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import '../../../Controller/Sensor/senor_controller.dart';
import '../../../Controller/providers/day_phase_provider.dart';

class HomeOptions extends StatefulWidget {
  const HomeOptions({super.key});

  @override
  State<HomeOptions> createState() => _HomeOptionsState();
}

class _HomeOptionsState extends State<HomeOptions> {
  // Initialize ValueNotifier here
  ValueNotifier<int> selectedDayNotifier = ValueNotifier<int>(0);

  int percent = 0;



  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Access the DayPhaseProvider
    final dayPhaseProvider = Provider.of<DayPhaseProvider>(context);

    return SafeArea(
      child: Padding(
        padding: HealthHubPadding.allPagesPadding(context),
        child: Scaffold(
          body: Column(
            children: [
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text('Good ${dayPhaseProvider.phase}', style: TextStyle(fontSize: 20)),
                            Icon(dayPhaseProvider.icon, size: 30, color: dayPhaseProvider.color),
                          ],
                        ),
                        Text('Welcome back Abhishek', style: TextStyle(fontSize: 20)),
                      ],
                    ),
                    Spacer(),
                    IconButton(onPressed: () {}, icon: Icon(Icons.wallet)),
                  ],
                ),
              ),

              SizedBox(
                
                height: MediaQuery.of(context).size.height * 0.4,
                width: MediaQuery.of(context).size.width*0.4,
                child: StepCounterPage()),
                
              // Pass the ValueNotifier to BuildRowsOfThisWeekDays
              BuildRowsOfThisWeekDays(selectedDayNotifier: selectedDayNotifier),
            ],
          ),
        ),
      ),
    );
  }
}

class BuildRowsOfThisWeekDays extends StatelessWidget {
  final ValueNotifier<int> selectedDayNotifier;

  const BuildRowsOfThisWeekDays({super.key, required this.selectedDayNotifier});

  @override
  Widget build(BuildContext context) {
    var isLight = Provider.of<ThemeProvider>(context).isLightTheme;

    List<String> days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    List<DateTime> dates = [];

    // Generate the dates for the current week
    for (var i = 0; i < 7; i++) {
      dates.add(DateTime.now().add(Duration(days: i)));
    }

    return ValueListenableBuilder<int>(
      valueListenable: selectedDayNotifier,
      builder: (context, selectedDay, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for (var i = 0; i < 7; i++)
              GestureDetector(
                onTap: () {
                  // Update the selected day when tapped
                  selectedDayNotifier.value = i;
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: i == selectedDay ? appMainColor : Colors.grey,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text(
                        days[i],
                        style: interBold(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        dates[i].day.toString(),
                        style: interBold(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
