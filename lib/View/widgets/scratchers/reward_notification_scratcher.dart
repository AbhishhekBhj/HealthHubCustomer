import 'package:flutter/material.dart';

class RewardNotificationScratcher extends StatefulWidget {
  const RewardNotificationScratcher({
    super.key,
    required this.expiryDate,
    required this.rewardPoints,
  });

  final DateTime expiryDate;
  final String rewardPoints;

  @override
  State<RewardNotificationScratcher> createState() => _RewardNotificationScratcherState();
}

class _RewardNotificationScratcherState extends State<RewardNotificationScratcher> {
  bool isExpired = false;

  @override
  void initState() {
    super.initState();
    _checkExpiryDate();
  }

  void _checkExpiryDate() {
    final now = DateTime.now();
    if (widget.expiryDate.isBefore(now)) {
      setState(() {
        isExpired = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scratch to Win Award'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isExpired ? 'This reward has expired!' : 'You have a new reward!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isExpired ? Colors.red : Colors.green,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              'Reward Points: ${widget.rewardPoints}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            if (!isExpired) ...[
              ElevatedButton(
                onPressed: () {
                  // Implement the scratch action here
                },
                child: Text('Scratch to Claim Reward'),
              ),
            ] else ...[
              ElevatedButton(
                onPressed: () {
                  // Implement what to do when reward is expired
                },
                child: Text('View Other Rewards'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
