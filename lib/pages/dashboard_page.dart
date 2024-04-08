import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:zeus/constants.dart';
import 'package:zeus/data_json/balance_json.dart';
import 'package:zeus/data_json/card_json.dart';
import 'package:zeus/pages/add_money.dart';
import 'package:zeus/pages/card_page.dart';
import 'package:zeus/theme/color.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Map<dynamic, dynamic> transactionData = {};
  Map<dynamic, dynamic> cardData = {};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary,
      appBar:
          PreferredSize(child: getAppBar(), preferredSize: Size.fromHeight(60)),
      body: getBody(),
    );
  }

  Widget getAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      leading: IconButton(
          onPressed: () {},
          icon: CircleAvatar(
            backgroundImage: NetworkImage(
                "https://images.unsplash.com/photo-1447966531936-911738a2a722?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"),
          )),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.search),
          iconSize: 20,
        )
      ],
    );
  }

  Widget getCards(amount, cardNumber, cardHoldername, validDate, bgColor) {
    var size = MediaQuery.of(context).size;
    return Column(
      children: [
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: [
        //     Text(
        //       'Amount: ',
        //       style: TextStyle(
        //         fontSize: 17,
        //         fontWeight: FontWeight.bold,
        //         color: black,
        //       ),
        //     ),
        //     SizedBox(width: 5),
        //     Text(
        //       amount.toString(),
        //       style: TextStyle(
        //         fontSize: 24,
        //         fontWeight: FontWeight.bold,
        //         color: black,
        //       ),
        //     ),
        //   ],
        // ),
        SizedBox(width: 15),
        Container(
          width: size.width,

          // decoration: BoxDecoration(
          //   color: bgColor,
          //   borderRadius: BorderRadius.circular(15),
          // ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
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

  Widget getBody() {
    var size = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          width: size.width,
          height: size.height * 0.35,
          decoration: BoxDecoration(
            color: primary,
          ),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  width: size.width,
                  height: 170,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: cardData.isEmpty
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : Row(
                            children: List.generate(
                              cardData["data"]["cards"].length,
                              (index) => getCards(
                                transactionData["data"]["cards"][index]
                                    ['money'],
                                transactionData["data"]["cards"][index]
                                    ['card_num'],
                                transactionData["data"]["cards"][index]
                                    ['card_holder_name'],
                                transactionData["data"]["cards"][index]
                                    ['expiry'],
                                cardLists[2]['bg_color'],
                              ),
                            ),
                          ),
                  )),
              Row(
                children: [
                  Expanded(
                      child: Container(
                    width: size.width,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            // Add your onTap logic here
                            // For example, you can navigate to another screen or perform some action
                            Navigator.push(context,
                                MaterialPageRoute(builder: (_) => AddMoney()));
                          },
                          child: Flexible(
                            child: Container(
                              height: 50,
                              width: 110,
                              decoration: BoxDecoration(
                                  color: secondary.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(12)),
                              child: Center(
                                child: Text(
                                  "Transfer",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Flexible(
                            child: Container(
                          height: 50,
                          width: 110,
                          decoration: BoxDecoration(
                              color: secondary.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(12)),
                          child: Center(
                            child: Text(
                              "Exchange",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        )),
                        SizedBox(
                          width: 15,
                        ),
                        Flexible(
                            child: Container(
                          height: 50,
                          width: 110,
                          decoration: BoxDecoration(
                              color: secondary.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(12)),
                          child: Center(
                            child: Text(
                              "Top Up",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        )),
                        SizedBox(
                          width: 15,
                        ),
                      ],
                    ),
                  )),
                ],
              )
            ],
          ),
        ),
        Expanded(
            child: SingleChildScrollView(
          child: Container(
            width: size.width,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                )),
            child: Padding(
              padding: const EdgeInsets.only(
                top: 50,
                bottom: 40,
                left: 20,
                right: 20,
              ),
              child: getAccountSection(),
            ),
          ),
        ))
      ],
    );
  }

  Map<String, dynamic> profileData = {};
  Map<String, dynamic> userCards = {};

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _fetchUserCards();
  }

  Future<void> _fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    var url = 'https://ambernoak.co.uk/Api/zeus2/public/api/dashboard';
    // var response = await http.get(Uri.parse(url));
    var response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization':
            'Bearer $token', // Include JWT token in the request headers
      },
    );
    // print('Response status: ${response.statusCode}');
    // print('Response body: ${response.body}');
    if (response.statusCode == 200) {
      setState(() {
        var responseData = jsonDecode(response.body);
        transactionData = responseData;
      });
    } else {
      // Handle error
    }
  }

  Future<void> _fetchUserCards() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    var url = 'https://ambernoak.co.uk/Api/zeus2/public/api/getcards';
    // var response = await http.get(Uri.parse(url));
    var response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization':
            'Bearer $token', // Include JWT token in the request headers
      },
    );
    // print('Response status: ${response.statusCode}');
    // print('Response body: ${response.body}');
    if (response.statusCode == 200) {
      setState(() {
        var responseData = jsonDecode(response.body);
        cardData = responseData;
      });
      // print(cardData);
    } else {
      // Handle error
    }
  }

  Widget getAccountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Last Transactions',
          style: TextStyle(
            color: Colors.black,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 10,
                  blurRadius: 10,
                )
              ]),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: List.generate(
                  transactionData.isEmpty
                      ? 1
                      : transactionData["data"]["transaction"].length, (index) {
                if (transactionData.isEmpty) {
                  return CircularProgressIndicator();
                }
                var transaction = transactionData["data"]["transaction"][index];

                String formatDate(String dateString) {
                  DateTime now = DateTime.now();
                  DateTime date = DateTime.parse(dateString);

                  // Calculate difference in days
                  int differenceInDays = now.difference(date).inDays;

                  // If the date is today
                  if (differenceInDays == 0) {
                    return 'Today';
                  }
                  // If the date is yesterday
                  else if (differenceInDays == 1) {
                    return 'Yesterday';
                  }
                  // If the date is from this week
                  else if (differenceInDays < 7) {
                    return '$differenceInDays days ago';
                  }
                  // For other dates, format as "Y-m-d"
                  else {
                    return DateFormat('yyyy-MM-dd').format(date);
                  }
                }

                String formattedDate =
                    formatDate(transaction["created_at"].toString());
                return Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 100, // Adjust width as needed
                          height: 40,
                          decoration: BoxDecoration(
                            color: primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.attach_money,
                                  color: Colors.white,
                                  size: 18), // Currency icon
                              SizedBox(
                                  width: 10), // Space between icon and text
                              Text(
                                "${transaction["price"].toString()} USD", // Including currency in the text
                                style: TextStyle(
                                    fontSize: 14, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 20,
                          height: 15,
                        ),
                        Expanded(
                          child: Text(
                            transaction["source"].toString(),
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                        SizedBox(
                            height:
                                1), // Space between source text and date text
                        Opacity(
                          opacity: 0.9, // Adjust opacity as needed

                          child: Text(
                            formattedDate,
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                        SizedBox(height: 10), // Space between rows
                      ],
                    ),
                    SizedBox(height: 10),
                  ],
                );
              }),
            ),
          ),
        ),
        SizedBox(
          height: 25,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Cards",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            // Container(
            //   width: 90,
            //   height: 22,
            //   decoration: BoxDecoration(
            //       color: secondary.withOpacity(0.5),
            //       borderRadius: BorderRadius.circular(8)),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       Icon(
            //         Icons.ios_share,
            //         size: 16,
            //         color: primary,
            //       ),
            //       Text(
            //         "ADD CARD",
            //         style: TextStyle(
            //             fontSize: 11,
            //             fontWeight: FontWeight.w600,
            //             color: primary),
            //       )
            //     ],
            //   ),
            // )
          ],
        ),
        SizedBox(
          height: 15,
        ),
        GestureDetector(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => CardPage()));
            },
            child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 10,
                      blurRadius: 10,
                      // changes position of shadow
                    ),
                  ],
                ),
                child: Padding(
                    padding: const EdgeInsets.all(65),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                      color: primary.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(12)),
                                  child: Center(
                                    child: Icon(
                                      Icons.credit_card,
                                      color: primary,
                                      size: 20,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  "EUR *2330",
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                )
                              ],
                            ),
                            Text(
                              "18 199 USD",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w600),
                            )
                          ],
                        )
                      ],
                    ))))
      ],
    );
  }
}
