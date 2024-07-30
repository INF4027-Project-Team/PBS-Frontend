import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:shop_app/objects/User.dart';
import 'package:shop_app/screens/home/components/barcodeScanner.dart';
import 'package:shop_app/screens/home/components/imageLabeler.dart';
import 'package:shop_app/screens/barcode_offers/offers_screen.dart';
import 'package:shop_app/screens/item_scan_offers/item_offers_screen.dart';
import 'package:shop_app/screens/scan_history/search_history.dart';
import 'components/camera_overlay_animator.dart';
import '../../objects/Product.dart';
import 'package:shop_app/database%20access/database_service.dart';
import '/objects/history_item.dart'; 

class HomeScreen extends StatefulWidget {
  static String routeName = "/home";
  const HomeScreen({Key? key}) : super(key: key);

  @override
  BarcodeScannerScreenState createState() => BarcodeScannerScreenState();
}

class BarcodeScannerScreenState extends State<HomeScreen> {
  late CameraController _controller;
  Future<void>? _initializeControllerFuture;
  CameraImage? _capturedImage;

  // Impact Colours
  Color impactGrey = const Color(0xFFC9C8CA);
  Color impactRed = const Color(0xFFF4333C);
  Color impactBlack = const Color(0xFF040404);

  // Other interface colours
  Color softPurple = const Color(0xFFAA62B7);
  Color gloomyPurple = const Color(0xFF8A4EDD);

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  // Function to set up camera and begin capturing images
  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    _controller = CameraController(
      firstCamera,
      ResolutionPreset.veryHigh,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.nv21,
    );

    _initializeControllerFuture = _controller.initialize();
    await _initializeControllerFuture!;

    _startImageStream();
  }

  // Function to shut down image capture and close camera
  @override
  void dispose() {
    _stopImageStream();
    _controller.dispose();
    super.dispose();
  }

  // Method to begin capturing images
  void _startImageStream() {
    _controller.startImageStream((CameraImage image) {
      // As each frame is captured this method is called to record the image as a variable.
      // Currently, only one frame is used for manual barcode scanning, but possible this method could be adjusted
      // So that the barcode scanning happens seamlessly as the barcode comes into frame, without need for a button click
      setState(() {
        _capturedImage = image;
      });
    });
  }

  // Method to stop capturing images
  void _stopImageStream() {
    _controller.stopImageStream();
  }

  //Boolean flag to manage camera scanning modes
  bool labelCentered = false;

  //Method to toggle camera scan modes
  void _toggleButtonPosition() {
    setState(() {
      labelCentered = !labelCentered;
    });
  }

  
  // Barcode scanning screen interface creation
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Scan Barcode',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        elevation: 0,
        actions: [
          IconButton(onPressed: ()=>{Navigator.pushNamed(context, SearchHistoryScreen.routeName)}, icon: const Icon(Icons.history)),
        ],
      ),
      body: Stack(
        children: [
          // Camera preview
          FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return CameraPreview(_controller);
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
          

        // Paint barcode scanning animations                          
        if (!labelCentered)
        CameraOverlay(),

        //Text instruction at top of scanner screen
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Align(
            alignment: Alignment.topCenter,
            child: Padding(
            padding: const EdgeInsets.only(top: 50.0), // Adjust the padding as needed
            child: Container(
            padding: const EdgeInsets.all(7.0),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Text(
              labelCentered
              ?  "Place an Item in Front of the Camera to Begin Scanning"
              : "Place a Barcode Inside the Frame to Begin Scanning",
              style: const TextStyle(
                fontSize: 21.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            textAlign: TextAlign.center,
            ),
          ),
        ),
       ),
      ),



      // Selector buttons
      Positioned(
        bottom: MediaQuery.of(context).size.height / 35,
        left: 20,
        right: 20,
        child: Center(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: labelCentered
                ? MainAxisAlignment.center
                : MainAxisAlignment.start,
                children: [
                  if (!labelCentered) const Spacer(),

                  //Barcode selector button
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    child: ElevatedButton(
                      onPressed: _toggleButtonPosition,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: labelCentered ? Colors.transparent : Colors.white,
                        foregroundColor: labelCentered ? Colors.white : Colors.black,
                        elevation: 0,
                        shadowColor: Colors.transparent,
                        side: BorderSide.none,
                        minimumSize: const Size(100, 40),
                      ),
                      child: Text(
                        "Barcodes",
                        style: TextStyle(
                          fontWeight: labelCentered ? FontWeight.normal : FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  //Item scan selector button
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    child: ElevatedButton(
                      onPressed: _toggleButtonPosition,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: labelCentered ? Colors.white : Colors.transparent,
                        foregroundColor: labelCentered ? Colors.black : Colors.white,
                        elevation: 0,
                        shadowColor: Colors.transparent,
                        side: BorderSide.none,
                        minimumSize: const Size(100, 40),
                      ),
                      
                      child: Text(
                        "Items",
                        style: TextStyle(
                          fontWeight: labelCentered ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),

                  if (labelCentered) const Spacer(),

                ],
              ),
                  
              const SizedBox(height: 20),
                  
              //Scan button
              Container(
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(16.0),
                ),
                
                child: ElevatedButton(
                  onPressed: () async {
                  
                  // Show loading spinner
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) {
                      return const AlertDialog(
                        content: Row(
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(width: 20),
                            Text('Scanning...'),
                          ],
                        ),
                      );
                    },
                  );

                        
                  try {
                    // Last captured frame is prepared for barcode scan
                    Barcodes barcodeScanner = Barcodes();     
                    final inputImage = barcodeScanner.prepareInputImage(_capturedImage, _controller);
                          
                    // Check if an image has been successfully passed in
                    if (inputImage == null) {
                    //Navigator.of(context).pop(); // Close the loading dialog
                      return;
                    }

                    //Open database service for barcode and image scanning      
                    DatabaseService dbs = DatabaseService();

                    //Scan barcodes if barcode is selected
                    if (!labelCentered){
                      // Scan the barcode with a 15-second timeout
                      
                      //Scan barcode image
                      List<Barcode> barcodesList = await barcodeScanner.scanBarcodes(inputImage).timeout(const Duration(seconds: 15));//await scanBarcodes(inputImage).timeout(Duration(seconds: 15));
                      
                      //Store barcode number
                      String? barcodeNumber = barcodesList.first.displayValue;
                      String nonNullBc = barcodeNumber ?? "0";

                      //Retrieve list of offers for this barcode
                      List<Product> offersList = await dbs.lookupBarcode(barcodeNumber);

                      //Identify special offers
                      List<Product> specialOffersList = dbs.getSpecialOffers(offersList);

                      //Place special offers at the front
                      List<Product> finalOffersList = dbs.placeSpecialOffersFirst(offersList, specialOffersList);

                      //Create a history item
                      var session = userSession();
                      String? email = session.userEmail;
                      HistoryItem scanResult = HistoryItem(
                        scanID:"",
                        creatorID: "", 
                        productBarcode: nonNullBc,
                        dateOfScan:  "",
                        name:  offersList[0].title,
                        photo:  offersList[0].imagePath
                      );
                      
                      //Add item to product history
                      dbs.addHistoryToDatabase(email, scanResult);

                      // Remove loading icons from screen
                      if (Navigator.of(context).canPop()) {
                            Navigator.of(context).pop();}
      
                      //open offers screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductList(
                                      products: finalOffersList,
                                      barcodeValue: barcodeNumber,
                                      specialOffers: specialOffersList,
                                    ),
                        ),
                      );
                    } 

                    //Do image scanning of item button is selected
                    else{
                      //Create image labeller object
                      imageLabeler labeler = imageLabeler();

                      //Scan Image
                      List<ImageLabel> labelList = await labeler.scanImage(inputImage).timeout(const Duration(seconds: 15));//await scanBarcodes(inputImage).timeout(Duration(seconds: 15));
                      
                      //Store image scan results
                      String? item = labelList.first.label;
                      
                      //Remove spaces from results string
                      String itemTrimmed = item.trim();
                      String itemFinal = itemTrimmed.replaceAll(RegExp(r'\s+'), '%20');

                      //Retrieve offers
                      List<Product> itemList = await dbs.lookupItem(itemFinal);
                      List<Product> specialItemList = dbs.getSpecialOffers(itemList);
                      List<Product> finalItemList = dbs.placeSpecialOffersFirst(itemList, specialItemList);

                      //Move to item list screen      
                      if (Navigator.of(context).canPop()) {
                        Navigator.of(context).pop();}
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ItemList(
                              products: finalItemList,
                              keyword: item,
                              specialOffers: specialItemList,
                            ),
                          ),
                       );
                      }
                    } catch (e) {
                      if (e is TimeoutException) {
                      // Close the loading dialog first
                      Navigator.of(context).pop();

                      // Show timeout dialog
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Error'),
                            content: const Text('No response from server'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(); // Close the timeout dialog
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    } 
                    else {
                            // Handle other errors if necessary
                            print(e);
                            Navigator.of(context).pop(); // Close the loading dialog
                          }
                        } finally {
                        }
                      },
                      child: const Text("Scan"),
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
}
