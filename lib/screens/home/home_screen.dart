import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/screens/offers/offers_screen.dart';
import 'package:shop_app/screens/Scan%20History/search_history.dart';
import 'components/camera_overlay_animator.dart';
import 'dart:convert';
import '/objects/product.dart';

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

  // Orientations required to calculate the degree of camera rotation
  final _orientations = {
    DeviceOrientation.portraitUp: 0,
    DeviceOrientation.landscapeLeft: 90,
    DeviceOrientation.portraitDown: 180,
    DeviceOrientation.landscapeRight: 270,
  };

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

  // This method is used to scan the barcodes and return a list of codes which are found for any given barcode
  Future<List<Barcode>> scanBarcodes(InputImage? inputImage) async {
    try {
      // Creates the instance of barcode scanner
      final barcodeScan = BarcodeScanner();

      // Begin scanning
      final barcodes = await barcodeScan.processImage(inputImage!);

      // Close scanner
      await barcodeScan.close();

      return barcodes;
    } catch (e) {
      return [];
    }
  }

  // Post to backend
  Future<void> postToBackend(String? stringToSend) async {
    const url = 'http://192.168.1.149:8080/barcode'; // Change the 192.168.1.149 to the IP of server computer
    final response = await http.post(
      Uri.parse(url),
      body: stringToSend,
    );
    String code = stringToSend!;
    if (response.statusCode == 200) {
      
     
      List<dynamic> offers = jsonDecode(response.body);
      

      List<Product> offersList = offers.map((jsonItem) => Product.fromJson( jsonItem)).toList();
      if (offersList.isEmpty)
      {
        if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();}
        showDialog(
          context: context,
          builder: (context) {
          return AlertDialog(
              title: Text('Scan Concluded'),
              content: Text('There are no offers available for this item'),
              actions: [
              TextButton(
                  onPressed: () {
                      Navigator.of(context).pop(); // Close the timeout dialog
                    },
                  child: Text('OK'),
                  ),
                  ],
              );
            },
           );
      }
      else
      {
      //Identify best offer
      Product bestOffer = offersList[0];

      //Identify best price
      Product lowestPricedOffer = offersList[0];
      for (var offer in offersList) {
        if (offer.price < lowestPricedOffer.price) {
          lowestPricedOffer = offer;
        }
      }

      //Identify best price
      Product bestCommissionOffer = offersList[0];
      for (var offer in offersList) {
        if (offer.commission > bestCommissionOffer.commission) {
          bestCommissionOffer = offer;
        }
      }

      List<Product> specialOffers =[bestOffer,lowestPricedOffer,bestCommissionOffer];


      // Barcode is displayed on the results screen
      if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();}
      
      
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductList(
                      products: offersList,
                      barcodeValue: code,
                      specialOffers: specialOffers,
                    ),
          //builder: (context) => NetworkResults(impactOffers: impactProductList, ebayOffers: ebayProductList),
        ),
      );
      }
    } else {
      
      
      print('Failed to send string. Status code: ${response.statusCode}');
    }
  }

  // This is the method to prepare the images for barcode scanning
  InputImage? _inputImageFromCameraImage(CameraImage? image) {
    if (image == null) return null;

    // Save image format
    final InputImageFormat? format = InputImageFormatValue.fromRawValue(image.format.raw);

    // Check that image is in correct format
    if ((format == null) || (format != InputImageFormat.nv21)) return null;

    // Save image plane
    final plane = image.planes.first;

    // Calculate the rotation degree of camera
    final sensorOrientation = _controller.description.sensorOrientation;
    var rotationCompensation = _orientations[_controller.value.deviceOrientation];

    if (rotationCompensation == null) return null;

    rotationCompensation = (sensorOrientation - rotationCompensation + 360) % 360;

    // Save image rotation
    InputImageRotation? rotation = InputImageRotationValue.fromRawValue(rotationCompensation);

    // Check that image rotation is valid
    if (rotation == null) return null;

    // Create the InputImage object using the above variables and then return it
    return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: format,
        bytesPerRow: plane.bytesPerRow,
      ),
    );
  }

  // Barcode scanning screen interface creation
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
      centerTitle: true,
      title: Text(
        'Scan Barcode',
        style: Theme.of(context).textTheme.titleLarge,
      ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, SearchHistoryScreen.routeName);
            },
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: EdgeInsets.zero,
              elevation: 0,
              backgroundColor: Colors.white,
            ),
            child: const Icon(
              Icons.history,
              color: Colors.black,
              size: 30,
            ),
          ),
        ),
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
          // Paint black borders and moving red line
          CameraOverlay(),
          // Impact Logo
          /*Positioned(
            top: 0, 
            left: 0, 
            right: 0, 
            child: Center(
              child: Image.asset(
                'assets/images/impact_logo.webp', 
                width: 250, 
                height: 250, 
              ),
            ),
          ),*/
          // Scan Button
          Positioned(
            bottom: MediaQuery.of(context).size.height /35, 
            left: 20, 
            right: 20, 
            child: Center(
              child: Container(
                width: double.infinity,
                height: 60,
                // color: softPurple,
                decoration: BoxDecoration(
                  color: impactRed,
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
                      final inputImage = _inputImageFromCameraImage(_capturedImage);
                      // Check if an image has been successfully passed in
                      if (inputImage == null) {
                        //Navigator.of(context).pop(); // Close the loading dialog
                        return;
                      }

                      // Scan the barcode with a 2-second timeout
                      List<Barcode> barcodesList = await scanBarcodes(inputImage).timeout(Duration(seconds: 15));
                      String? barcodeNumber = barcodesList.first.displayValue;

                      // Barcode is posted to java server
                      postToBackend(barcodeNumber);
                    } catch (e) {
                      if (e is TimeoutException) {
                        // Close the loading dialog first
                        Navigator.of(context).pop();

                        // Show timeout dialog
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Error'),
                              content: Text('No response from server'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(); // Close the timeout dialog
                                  },
                                  child: Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        // Handle other errors if necessary
                        print(e);
                        Navigator.of(context).pop(); // Close the loading dialog
                      }
                    } finally {
                      //if (Navigator.of(context).canPop()) {
                        //Navigator.of(context).pop(); // Close the loading dialog if it's still open
                      //}
                    }
                  },
                  child: const Text("Scan"),
                ), 
              ),
            ),
          ),
        ],
      ),
    );
  }
}
