import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4F9792), // Teal background at the top
      body: Stack(
        children: [
          // Top Background + Content Scrollable
          Positioned.fill(
            child: Column(
              children: [
                const SizedBox(height: 60), // status bar space
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: HeaderCard(),
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                      BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
                    ),
                    child: ListView(
                      padding: const EdgeInsets.only(top: 20),
                      children: const [
                        TopExpensesSection(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Notification Icon
          Positioned(
            top: 50,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.notifications, color: Colors.white),
              onPressed: () {},
            ),
          ),
        ],
      ),

      // FAB
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF4F9792),
        elevation: 5,
        child: const Icon(Icons.add, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // Bottom Nav Bar
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 6.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              Icon(Icons.home, color: Colors.black54),
              Icon(Icons.bar_chart, color: Colors.black54),
              SizedBox(width: 40), // space for FAB
              Icon(Icons.receipt_long, color: Colors.black54),
              Icon(Icons.person, color: Colors.black54),
            ],
          ),
        ),
      ),
    );
  }
}
class HeaderCard extends StatelessWidget {
  const HeaderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF397F78),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Text(
                "Total Balance ",
                style: TextStyle(color: Colors.white70),
              ),
              Icon(Icons.expand_more, color: Colors.white70, size: 18),
              Spacer(),
              Icon(Icons.more_horiz, color: Colors.white),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            "Rs 2,548.00",
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              IncomeExpenseItem(label: "Income", amount: "Rs 1,840.00", isIncome: true),
              IncomeExpenseItem(label: "Expenses", amount: "Rs 284.00", isIncome: false),
            ],
          )
        ],
      ),
    );
  }
}
class IncomeExpenseItem extends StatelessWidget {
  final String label;
  final String amount;
  final bool isIncome;

  const IncomeExpenseItem({
    super.key,
    required this.label,
    required this.amount,
    required this.isIncome,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(isIncome ? Icons.arrow_upward : Icons.arrow_downward,
            color: Colors.white70, size: 20),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(color: Colors.white70),
            ),
            Text(
              amount,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        )
      ],
    );
  }
}

class TopExpensesSection extends StatelessWidget {
  const TopExpensesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final expenses = [
      {
        "icon": "assets/images/preview.jpg",
        "title": "Groceries",
        "date": "Today",
        "amount": "+ Rs 1,850.00",
        "isIncome": true
      },
      {
        "icon": "assets/images/preview.jpg",
        "title": "Paypal",
        "date": "Jan 30, 2022",
        "amount": "+ Rs 1,406.00",
        "isIncome": true
      },
      {
        "icon": "assets/images/preview.jpg",
        "title": "Youtube",
        "date": "Jan 16, 2022",
        "amount": "- \$11.99",
        "isIncome": false
      },
      {
        "icon": "assets/images/preview.jpg",
        "title": "Youtube",
        "date": "Jan 16, 2022",
        "amount": "- \$11.99",
        "isIncome": false
      },
      {
        "icon": "assets/images/preview.jpg",
        "title": "Youtube",
        "date": "Jan 16, 2022",
        "amount": "- \$11.99",
        "isIncome": false
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Expanded(
              child: Text(
                "Top Expenses",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            Text("See all", style: TextStyle(color: Colors.grey)),
          ],
        ),
        const SizedBox(height: 20),
        ...expenses.map((e) => ExpenseItem(
          iconPath: e['icon'] as String,
          title: e['title'] as String,
          date: e['date'] as String,
          amount: e['amount'] as String,
          isIncome: e['isIncome'] as bool,
        )),
      ],
    );
  }
}

class ExpenseItem extends StatelessWidget {
  final String iconPath;
  final String title;
  final String date;
  final String amount;
  final bool isIncome;

  const ExpenseItem({
    super.key,
    required this.iconPath,
    required this.title,
    required this.date,
    required this.amount,
    required this.isIncome,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          // Icon
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(iconPath, height: 40, width: 40),
          ),
          const SizedBox(width: 14),

          // Title + Date
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
                Text(date, style: const TextStyle(color: Colors.grey, fontSize: 13)),
              ],
            ),
          ),

          // Amount
          Text(
            amount,
            style: TextStyle(
              color: isIncome ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}


