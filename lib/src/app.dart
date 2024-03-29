import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'camera_overlay_painter.dart';
import 'screen_display_product.dart'; // Import for rootBundle


class BarcodeScanning extends StatefulWidget {
  const BarcodeScanning({
    super.key,
    required this.camera,
  });
  final CameraDescription camera;
  @override
  BarcodeScannerScreenState createState() => BarcodeScannerScreenState();
}


class BarcodeScannerScreenState extends State<BarcodeScanning> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  late CameraImage? _capturedImage;
  
  //Orientations required to calculate the degree of camera rotation
  final _orientations = {
  DeviceOrientation.portraitUp: 0,
  DeviceOrientation.landscapeLeft: 90,
  DeviceOrientation.portraitDown: 180,
  DeviceOrientation.landscapeRight: 270,
  };

  //Impact Colours
  Color impactGrey = const Color(0xFFC9C8CA);
  Color impactRed = const Color(0xFFF4333C);
  Color impactBlack = const Color(0xFF040404);

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }
  
  //Barcode scanning screen interface creation
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: impactGrey,
        leading: IconButton(
        icon: Icon(Icons.menu),
        onPressed: (){},
      ),

      actions: [
          IconButton(
            icon: Icon(Icons.home), // Add the home button icon
            onPressed: () {
              // Add functionality for the home button here
            },
          ),
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
          
          // Paint white borders around camera preview
          CustomPaint(
            size: MediaQuery.of(context).size,
            painter: CameraOverlayPainter(),
          ),
          
          // Page heading
           Positioned(
            top: 50, // Adjust the top padding as needed
            left: 40, // Adjust the left padding as needed
            right: 40, // Adjust the right padding as needed
            child: Text(
              'Product Barcode Scanner',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: impactBlack,
              ),
            ),
          ),

          //Impact Logo
          Positioned(
            bottom: MediaQuery.of(context).size.height / 7, // Adjust the value to position the image vertically
            left: 0, // Align the image to the left edge
            right: 0, // Align the image to the right edge
            child: Center(
              child: Image.asset(
                'assets/images/impact_logo.png', // Replace 'your_image.png' with your image asset path
                width: 220, // Adjust width as needed
                height: 220, // Adjust height as needed
              ),
            ),
          ),

          //Scan Button
          Positioned(
            bottom: MediaQuery.of(context).size.height / 10, // Adjust the value to position the button vertically
            left: 40, // Adjust the left padding as needed
            right: 40, // Adjust the right padding as needed
            child: Center(
              child: Container(
                width: double.infinity,
                height: 60,
                color: Colors.black,
                child: TextButton(
                  onPressed: () async {
                    try {

                      // Last captured frame is prepared for barcode scan
                      final inputImage = _inputImageFromCameraImage(_capturedImage);
                      // Check if an image has been successfully passed in 
                      if (inputImage == null) return;
                      // Scan the barcode
                      List<Barcode> barcodesList = await scanBarcodes(inputImage);
                      String? barcodeNumber = barcodesList.first.displayValue;
                      
                      //Barcode is posted to java server
                      postToBackend(barcodeNumber);

                      //Barcode is displayed on the results screen
                      Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResultsScreen(code: barcodeNumber),
                      ),
                    );
                    } catch (e) {
                      print(e);
                    }
                  },
                  child: const Text(
                    'SCAN',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
          ),

        ],
      ),
      
    );
  }


/// ****************************Class Methods******************************************* 

  //Function to set up camera and begin capturing images
  Future<void> _initializeCamera() async {
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.veryHigh,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.nv21,
    );

    _initializeControllerFuture = _controller.initialize();
    await _initializeControllerFuture;
    
    _startImageStream();
  }


  //Function to shut down image capture and close camera
  @override
  void dispose() {
    _stopImageStream();
    _controller.dispose();
    super.dispose();
  }
  

//Method to begin capturing images
void _startImageStream() {
    _controller.startImageStream((CameraImage image) {
      
      //As each frame is captured this method is called to record the image as a variable.
      //Currently, only one frame is used for manual barcode scanning, but possible this method could be adjusted
      //So that the barcode scanning happens seemlessly as the barcode comes into frame, without need for a button click
      setState(() {
        _capturedImage = image;
         
      });
    });
  }


  //Method to stop capturing images
  void _stopImageStream() {
    _controller.stopImageStream();
  }


//This method is used to scan the barcodes and return a list of codes which are found for any given barcode
Future<List<Barcode>> scanBarcodes(InputImage? inputImage) async {
    try {
      //Creates the instance of barcode scanner
      final barcodeScan = BarcodeScanner();

      //Begin scanning
      final barcodes = await barcodeScan.processImage(inputImage!);

      //Close scanner
      await barcodeScan.close();

     
      return barcodes;
    } 
    catch (e) 
    {
      print('Error scanning barcodes: $e');
      return [];
    }
  }


  //Post to backend
  Future<void> postToBackend(String? stringToSend) async {
    const url = 'http://192.168.1.149:8080/endpoint'; //Change the 192.168.1.149 to the IP of server computer
    final response = await http.post(
      Uri.parse(url),
      body: {'stringData': stringToSend},
    );

    if (response.statusCode == 200) {
      print('String sent successfully');
    } else {
      print('Failed to send string. Status code: ${response.statusCode}');
    }
  }


  //This is the method to prepare the images for barcode scanning
  InputImage? _inputImageFromCameraImage(CameraImage? image) {
    if (image == null) return null;

    //Save image format
    final InputImageFormat? format = InputImageFormatValue.fromRawValue(image.format.raw);
    
    //Check that image is in correct format
    if ((format == null) || (format != InputImageFormat.nv21)) return null;

    //Save image plane
    final plane = image.planes.first;

    //Calculate the rotation degree of camera
    final sensorOrientation = widget.camera.sensorOrientation;
    var rotationCompensation = _orientations[_controller!.value.deviceOrientation];
      
    if (rotationCompensation == null) return null;

    rotationCompensation = (sensorOrientation - rotationCompensation + 360) % 360;

    //Save image rotation
    InputImageRotation? rotation = InputImageRotationValue.fromRawValue(rotationCompensation);
    
    //Check that image rotation is valid
    if (rotation == null) return null;

    //Create the InputImage object using the above variables and then return it
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

}



