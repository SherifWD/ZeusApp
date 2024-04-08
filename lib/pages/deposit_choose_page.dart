import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'deposit_bank.dart'; // Import the DepositBankPage
import 'deposit_vodafone.dart'; // Import the DepositVodafonePage
import 'deposit_usdd.dart'; // Import the DepositUSDDPage
import 'deposit_link.dart'; // Import the DepositLinkPage

class DepositChoosePage extends StatefulWidget {
  const DepositChoosePage({Key? key}) : super(key: key);

  @override
  _DepositChoosePageState createState() => _DepositChoosePageState();
}

class _DepositChoosePageState extends State<DepositChoosePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Deposit'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DepositBankPage(), // Navigate to DepositBankPage
                          ),
                        );
                      },
                      child: DepositCard(
                        title: 'Bank Transfer',
                        icon: Icons.account_balance,
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DepositVodafonePage(), // Navigate to DepositVodafonePage
                          ),
                        );
                      },
                      child: DepositCard(
                        title: 'Vodafone Cash',
                        icon: Icons.phone,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DepositUSDDPage(), // Navigate to DepositUSDDPage
                          ),
                        );
                      },
                      child: DepositCard(
                        title: 'USDD',
                        icon: Icons.attach_money,
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DepositLinkPage(), // Navigate to DepositLinkPage
                          ),
                        );
                      },
                      child: DepositCard(
                        title: 'Payment Link',
                        icon: Icons.link,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DepositCard extends StatelessWidget {
  final String title;
  final IconData icon;

  const DepositCard({
    required this.title,
    required this.icon,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.redAccent, // Set background color to black
        border: Border.all(
          color: Colors.blue,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white, // Set text color to white
              ),
            ),
          ),
          Divider(
            color: Colors.blue,
          ),
          Expanded(
            child: Icon(
              icon,
              size: 50,
              color: Colors.white, // Set icon color to white
            ),
          ),
        ],
      ),
    );
  }
}
