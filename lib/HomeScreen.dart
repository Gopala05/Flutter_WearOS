import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double screenHeight = 0;
  double screenWidth = 0;

  String checkIn = "--/--";
  String checkOut = "--/--";

  @override
  void initState() {
    super.initState();
    _getRecord();
  }

  void _getRecord() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection("Gopal").where('id', isEqualTo: 'Gopal').get();

      DocumentSnapshot snap2 = await FirebaseFirestore.instance
          .collection("Gopal")
          .doc(snap.docs[0].id)
          .collection("Record")
          .doc(DateFormat('dd MMMM yyyy').format(DateTime.now()))
          .get();

      setState(() {
        checkIn = snap2['Check-IN'];
        checkOut = snap2['Check-OUT'];
      });
    }catch(e) {
      setState(() {
        checkIn = "--/--";
        checkOut = "--/--";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20) ,
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: screenHeight/20),
              child: Text(
                "WELCOME",
                style: TextStyle(
                  color: Colors.black54,
                  fontFamily: "NexaRegular",
                  fontSize: screenWidth/ 20,
                ),
              ),
            ),
            Container(
                margin: EdgeInsets.only(top: screenHeight / 20),
                alignment: Alignment.centerLeft,
                child: RichText(
                  text: TextSpan(
                    text: DateTime.now().day.toString(),
                    style: const TextStyle(
                        color: Colors.blueAccent,
                        fontFamily: "NexaBold"
                    ),
                    children: [
                      TextSpan(
                        text: DateFormat('MMMM yyyy').format(DateTime.now()),
                        style: const TextStyle(
                            color: Colors.black54,
                            fontFamily: "NexaRegular"
                        ),
                      ),
                    ],
                  ),
                )
            ),
            StreamBuilder(
              stream: Stream.periodic(const Duration(seconds: 1)),
              builder: (context, snapshot) {
                return Container(
                  margin: EdgeInsets.only(top: screenHeight / 30),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    DateFormat('hh:mm:ss').format(DateTime.now()),
                    style: TextStyle(
                      fontSize: screenWidth/20,
                      fontFamily: "NexaRegular",
                      color: Colors.black54,
                    ),
                  ),
                );
              }
            ),
            checkOut == "--/--" ? Container(
              margin: EdgeInsets.only(top: screenHeight / 10),
              child: ElevatedButton(
                onPressed: () async {
                  QuerySnapshot snap = await FirebaseFirestore.instance
                      .collection("Gopal").where('id', isEqualTo: 'Gopal').get();

                  DocumentSnapshot snap2 = await FirebaseFirestore.instance
                      .collection("Gopal")
                      .doc(snap.docs[0].id)
                      .collection("Record")
                      .doc(DateFormat('dd MMMM yyyy').format(DateTime.now()))
                      .get();
                  try {
                    String checkIn = snap2['Check-IN'];
                    setState(() {
                      checkOut = DateFormat('dd MMMM yyyy').format(DateTime.now());
                    });
                    await FirebaseFirestore.instance
                        .collection("Gopal")
                        .doc(snap.docs[0].id)
                        .collection("Record")
                        .doc(DateFormat('dd MMMM yyyy').format(DateTime.now()))
                        .update({
                      'Check-IN' : checkIn,
                      'Check-OUT' : DateFormat('hh:mm').format(DateTime.now())
                    });
                  } catch(e) {
                    setState(() {
                      checkIn = DateFormat('dd MMMM yyyy').format(DateTime.now());
                    });
                    await FirebaseFirestore.instance
                        .collection("Gopal")
                        .doc(snap.docs[0].id)
                        .collection("Record")
                        .doc(DateFormat('dd MMMM yyyy').format(DateTime.now()))
                        .set({
                      'Check-IN' : DateFormat('hh:mm').format(DateTime.now())
                    });
                  }

                },
                child : Text(checkIn== "--/--" ? "Check-In" : "Check-Out"),

              ),
            ) : Container(
              margin: const EdgeInsets.only(top: 20),
              child: const Text("Sorry But you have already Checked-Out for the Day!"),
            )
          ],
        ),
      )
    );
  }
}
