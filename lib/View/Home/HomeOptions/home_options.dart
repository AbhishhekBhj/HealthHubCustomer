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
            crossAxisAlignment: CrossAxisAlignment.start,
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

              Center(
                child: SizedBox(
                  
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: MediaQuery.of(context).size.width*0.4,
                  child: StepCounterPage()),
              ),
                
              // Pass the ValueNotifier to BuildRowsOfThisWeekDays
              BuildRowsOfThisWeekDays(selectedDayNotifier: selectedDayNotifier),
              const SizedBox(height: 20),
            AnimatedWaterContainer(initialWaterPercentage: 0,currentValue: 0,targetValue: 2500,)
            
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

  // Get today's date
  DateTime today = DateTime.now();

  // Calculate the starting date (Sunday of the current week)
  DateTime startOfWeek = today.subtract(Duration(days: today.weekday % 7));

  // Generate the dates for the week (Sunday to Saturday)
  for (var i = 0; i < 7; i++) {
    dates.add(startOfWeek.add(Duration(days: i)));
  }

  // Print out the dates with the corresponding day names
  for (int i = 0; i < dates.length; i++) {
    print('${days[i]}: ${dates[i]}');
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





class AnimatedWaterContainer extends StatefulWidget {
  final double initialWaterPercentage; 
  double currentValue;
  double targetValue;

  AnimatedWaterContainer({
    super.key,
    required this.initialWaterPercentage,
    required this.currentValue,
    required this.targetValue,
  });

  @override
  _AnimatedWaterContainerState createState() => _AnimatedWaterContainerState();
}

class _AnimatedWaterContainerState extends State<AnimatedWaterContainer> {
  static const double _maxContainerHeight = 100.0; // Max height of the container
  late double _waterPercentage; // To store the current water percentage
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _waterPercentage = widget.initialWaterPercentage; // Initialize with the passed value
  }

  double get _calculatedWaterHeight {
    // Calculate the water height based on the percentage
    return (_maxContainerHeight * _waterPercentage) / 100;
  }

  void updateWaterPercentage(double newCurrentValue) {
    setState(() {
      widget.currentValue = newCurrentValue;
      // Ensure the value doesn't exceed the target
      _waterPercentage = (widget.currentValue / widget.targetValue).clamp(0.0, 1.0) * 100;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Add Water Intake'),
                  content: TextFormField(
                    controller: _controller,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Enter the amount of water in ml',
                    ),
                    // Clear the input field when the dialog is dismissed
                    onFieldSubmitted: (value) {
                      double? waterAmount = double.tryParse(value);
                      if (waterAmount != null && waterAmount > 0) {
                        updateWaterPercentage(widget.currentValue + waterAmount);
                        _controller.clear(); // Clear the input
                        Navigator.of(context).pop();
                      } else {
                        // You can show a snack bar or dialog to inform the user
                        // about invalid input if needed.
                      }
                    },
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        double? waterAmount = double.tryParse(_controller.text);
                        if (waterAmount != null && waterAmount > 0) {
                          updateWaterPercentage(widget.currentValue + waterAmount);
                          _controller.clear(); // Clear the input
                          Navigator.of(context).pop();
                        } else {
                          // Optional: Notify the user about invalid input
                        }
                      },
                      child: const Text('Done'),
                    ),
                  ],
                );
              },
            );
          },
          child: Container(
            width: 100.0,
            height: _maxContainerHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(color: themeProvider.isLightTheme ? Colors.black : Colors.pink, width: 2),
            ),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                AnimatedContainer(
                  duration: const Duration(seconds: 3),
                  width: 100.0,
                  height: _calculatedWaterHeight, // Set the height based on percentage
                  decoration: BoxDecoration(
                    color: themeProvider.isLightTheme ? appMainColor : Colors.white, // Adjust color for light/dark mode
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(10.0),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "${widget.currentValue.toStringAsFixed(0)} / ${widget.targetValue.toStringAsFixed(0)} ml",
                      style: TextStyle(
                        color: themeProvider.isLightTheme ? Colors.white : Colors.black,
                        fontSize: 10.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
       
       
        ),
      ],
    );
  }
}







