import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:zeus/constants.dart';
import 'package:zeus/data_json/card_json.dart';
import 'package:zeus/pages/deposit_choose_page.dart';

import 'package:zeus/theme/color.dart';

class CardPage extends StatefulWidget {
  const CardPage({Key? key}) : super(key: key);

  @override
  State<CardPage> createState() => _CardPageState();
}

class _CardPageState extends State<CardPage> {
  Map<String, dynamic> profileData = {};

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    var endpoint = 'getcards';
    var url = '${Constants.baseUrl}$endpoint';
    var response = await http.get(Uri.parse(url));
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    if (response.statusCode == 200) {
      setState(() {
        profileData = jsonDecode(response.body);
      });
    } else {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: getAppBar(),
      ),
      body: profileData.isEmpty
          ? Center(child: CircularProgressIndicator())
          : getBody(),
    );
  }

  Widget getAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: white,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(
          Icons.arrow_back_ios_new,
          color: black,
          size: 22,
        ),
      ),
      title: Text(
        'Card',
        style: TextStyle(color: black, fontSize: 18),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.more_vert, color: black, size: 25),
        ),
      ],
    );
  }

  Widget getBody() {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          SizedBox(height: 10),
          Container(
            width: double.infinity,
            height: 240,
            child: profileData.isEmpty
                ? Center(child: CircularProgressIndicator())
                : PageView(
                    children: List.generate(
                      profileData['data']['cards'].length,
                      (index) => getCards(
                        profileData['data']['cards'][index]['money'],
                        profileData['data']['cards'][index]['card_num'],
                        profileData['data']['cards'][index]['card_holder_name'],
                        profileData['data']['cards'][index]['expiry'],
                        cardLists[2]['bg_color'],
                      ),
                    ),
                  ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: Container(
              child: Column(
                children: [
                  TabBar(
                    tabs: [
                      Tab(text: 'Deposit'),
                      Tab(text: 'Withdraw'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        DepositTab(),
                        WithdrawTab(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getCards(amount, cardNumber, cardHoldername, validDate, bgColor) {
    var size = MediaQuery.of(context).size;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Amount: ',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: black,
              ),
            ),
            SizedBox(width: 5),
            Text(
              amount.toString(),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: black,
              ),
            ),
          ],
        ),
        SizedBox(width: 15),
        Container(
          width: size.width * 0.85,
          height: 170,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.credit_card,
                      size: 30,
                      color: white.withOpacity(0.3),
                    ),
                    SizedBox(height: 15),
                    Text(
                      cardNumber,
                      style: TextStyle(
                        color: white.withOpacity(0.8),
                        fontSize: 20,
                        wordSpacing: 15,
                      ),
                    ),
                    SizedBox(height: 1),
                    Text(
                      cardHoldername,
                      style: TextStyle(
                        color: white.withOpacity(0.8),
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'VALID DATE',
                          style: TextStyle(
                            color: white.withOpacity(0.3),
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          validDate,
                          style: TextStyle(
                            color: white,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    Image.asset(
                      "assets/images/master_card_logo.png",
                      width: 50,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class DepositTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DepositChoosePage(),
              ),
            );
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: grey.withOpacity(0.1),
                  spreadRadius: 10,
                  blurRadius: 10,
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: secondary.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Icon(Icons.charging_station_rounded,
                        size: 20, color: primary),
                  ),
                ),
                SizedBox(width: 15),
                Text(
                  'Deposit',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 20),
        GestureDetector(
          onTap: () {
            // Handle History tap
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: grey.withOpacity(0.1),
                  spreadRadius: 10,
                  blurRadius: 10,
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: secondary.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Icon(Icons.history, size: 20, color: primary),
                  ),
                ),
                SizedBox(width: 15),
                Text(
                  'History',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 30),
      ],
    );
  }
}

class WithdrawTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DepositChoosePage(),
              ),
            );
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: grey.withOpacity(0.1),
                  spreadRadius: 10,
                  blurRadius: 10,
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: secondary.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Icon(Icons.charging_station_rounded,
                        size: 20, color: primary),
                  ),
                ),
                SizedBox(width: 15),
                Text(
                  'Withdraw',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 20),
        GestureDetector(
          onTap: () {
            // Handle History tap
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: grey.withOpacity(0.1),
                  spreadRadius: 10,
                  blurRadius: 10,
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: secondary.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Icon(Icons.history, size: 20, color: primary),
                  ),
                ),
                SizedBox(width: 15),
                Text(
                  'History',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 30),
      ],
    );
  }
}

List<Map<String, dynamic>> cardOperations = [
  {
    'title': 'Deposit Money',
    'icon': Icon(Icons.charging_station_rounded, size: 20, color: primary),
  },
  {
    'title': 'Withdraw Money',
    'icon': Icon(Icons.money_off_csred, size: 20, color: primary),
  },
];
