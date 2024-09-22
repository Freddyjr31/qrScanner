import 'package:flutter/material.dart';
import 'package:qr_scan/main.dart';

// ignore: must_be_immutable
class ScanView extends StatefulWidget {

  dynamic qrValue;

  ScanView({
    super.key,
    required this.qrValue
    });

  @override
  State<ScanView> createState() => _ScanViewState();
}

class _ScanViewState extends State<ScanView> {
  @override
  Widget build(BuildContext context) {

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Stack(
          children: [

            //* Background
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    "https://i.pinimg.com/originals/bb/cb/b7/bbcbb72dc18ed5d4efc5232400326831.jpg"
                    ),
                  fit: BoxFit.cover
                )
              ),
            ),
        
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    const Text(
                      'Result:',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                        ),
                      ),

                    //* QR Value
                    Text(
                      '${widget.qrValue}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 20,
                        fontWeight: FontWeight.w100
                        ),
                      ),
                  ],
                ),
              ],
            ),
        
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.1,
                    vertical: MediaQuery.of(context).size.height * 0.1
                  ),
                  decoration:  const BoxDecoration(
                    color: Colors.white70,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => const HomeScreen()
                              )
                            );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black87,
                          elevation: 0
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.qr_code_scanner,
                              color: Colors.white70,
                              ),
                            SizedBox(width: 10),
                            Text(
                              'Scan Again',
                              style: TextStyle(
                                color: Colors.white70
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )

          ],
        ),
      ),
    );
  }
}