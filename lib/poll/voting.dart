import 'package:appwithapi/Cstum/constant.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';

class Dashboured extends StatelessWidget {
  const Dashboured({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: VotingScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class VotingScreen extends StatefulWidget {
  const VotingScreen({super.key});

  @override
  State<VotingScreen> createState() => _VotingScreenState();
}

class _VotingScreenState extends State<VotingScreen> {
  int option1count = 0;
  int option2count = 0;

  void voteforoption1() {
    setState(() {
      ++option1count;
    });
  }

  void voteforoption2() {
    setState(() {
      ++option2count;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        centerTitle: true,
        title: Text(
          "Voting App ",
          style: GoogleFonts.poppins(color: Colors.white),
        ),
      ),
      body: ListView.builder(
          itemCount: 1,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                      width: 400,
                      height: 400,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: Colors.grey),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width - 50,
                              height: 145,
                              color: Colors.white30,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: Image.network(
                                  'https://i.pinimg.com/236x/d8/c9/90/d8c990a4e36b9883bcbd8c7c3d090349.jpg',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  width: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Hi  can you vote  ",
                                        style: GoogleFonts.poppins(
                                          color: Color.fromARGB(255, 2, 0, 3),
                                        ),
                                      ),
                                      Text(
                                        "Welcom to poll  ",
                                        style: GoogleFonts.poppins(
                                          color: Color.fromARGB(255, 2, 0, 3),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            LinearPercentIndicator(
                                width: MediaQuery.of(context).size.width - 100,
                                animation: true,
                                lineHeight: 60,
                                animationDuration: 1000,
                                percent: option1count / 10,
                                barRadius: const Radius.circular(20),
                                progressColor: Colors.green,
                                backgroundColor:
                                    const Color.fromARGB(255, 224, 217, 217),
                                center: Text(
                                  "Maha",
                                  style: GoogleFonts.poppins(
                                    color: Color.fromARGB(255, 2, 0, 3),
                                  ),
                                )),
                            const SizedBox(
                              height: 10,
                            ),
                            LinearPercentIndicator(
                                width: MediaQuery.of(context).size.width - 100,
                                animation: true,
                                lineHeight: 60,
                                animationDuration: 1000,
                                percent: option2count / 10,
                                barRadius: const Radius.circular(20),
                                progressColor: Colors.green,
                                backgroundColor:
                                    Color.fromARGB(255, 224, 217, 217),
                                center: Text(
                                  "Ayman",
                                  style: GoogleFonts.poppins(
                                    color: Color.fromARGB(255, 2, 0, 3),
                                  ),
                                ))
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            voteforoption1();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Color.fromARGB(255, 224, 217, 217)),
                            width: 190,
                            height: 80,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Maha",
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text("$option1count",
                                    style: GoogleFonts.poppins(
                                      color: Colors.green,
                                    )),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            voteforoption2();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: // Colors.white
                                    Color.fromARGB(255, 224, 217, 217)),
                            width: 190,
                            height: 80,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Ayman",
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text("$option1count",
                                    style: GoogleFonts.poppins(
                                      color: Colors.green,
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          }),
    );
  }
}
