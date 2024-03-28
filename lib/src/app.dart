import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/services.dart'; // Import for rootBundle


class BarcodeScanning extends StatefulWidget {
  const BarcodeScanning({
    super.key,
    required this.camera,
  });
  final CameraDescription camera;
  @override
  BarcodeScannerScreenState createState() => BarcodeScannerScreenState();
}


class CameraOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double screenWidth = size.width;
    final double screenHeight = size.height;
    const double squareSize = 300; // Adjust square size as needed
    const double sideRectWidth = 40;

    final Paint paint = Paint()..color = Colors.white;
    final Rect topRect = Rect.fromLTWH(0, 0, screenWidth, (screenHeight - squareSize) / 3.5);
    final Rect bottomRect = Rect.fromLTWH(0, (screenHeight + squareSize) / 2.5, screenWidth, (screenHeight - squareSize) );
    final Rect leftRect = Rect.fromLTWH(0, ((screenHeight - squareSize) / 3.5) - 30, sideRectWidth, squareSize+100);
    final Rect rightRect = Rect.fromLTWH(screenWidth - sideRectWidth, ((screenHeight - squareSize) / 3.5) -30, sideRectWidth, squareSize+100);

    canvas.drawRect(topRect, paint);
    canvas.drawRect(bottomRect, paint);
    canvas.drawRect(leftRect, paint);
    canvas.drawRect(rightRect, paint);
  }

  @override
  bool shouldRepaint(CameraOverlayPainter oldDelegate) => false;
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
  Color impactGrey = Color(0xFFC9C8CA);
  Color impactRed = Color(0xFFF4333C);
  Color impactBlack = Color(0xFF040404);

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

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
          // Transparent area with white background
          CustomPaint(
            size: MediaQuery.of(context).size,
            painter: CameraOverlayPainter(),
          ),
          // Image overlay
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
                      scanBarcodes(inputImage);
                    } catch (e) {
                      print(e);
                    }
                  },
                  child: Text(
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

      //return list of decoded barcodes, this will need to be further developed later to return the specific code required
      for (Barcode item in barcodes) {
      
      //Opens up the temporary screen that we are using to display the barcode values for demo purposes
      //Btw this is a bad place to place this because in the case of two codes being relelvant it will open two screens... keep in mind and change moving forward
      Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ResultsScreen(code: item.displayValue),
              ),
            );

      }
      return barcodes;
    } 
    catch (e) 
    {
      print('Error scanning barcodes: $e');
      return [];
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


//Class to display the barcode after has been captured... currently this class is not in use
class DisplayBarcode extends StatelessWidget {
  final img.Image cameraImage; // Processed CameraImage

  const DisplayBarcode({Key? key, required this.cameraImage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Processed Image')),
      body: Center(
        child: Image.memory(
          Uint8List.fromList(img.encodePng(cameraImage)), // Convert Image to PNG bytes
        ),
      ),
    );
  }
}

//This is a temporary screen for demo purposes
class ResultsScreen extends StatelessWidget {

//Impact Colours
  final Color impactGrey = Color(0xFFC9C8CA);
  final Color impactRed = Color(0xFFF4333C);
  final Color impactBlack = Color(0xFF040404);

  final String? code; // Parameter to hold the word

  // Constructor to receive the word parameter
  ResultsScreen({super.key, required this.code});

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
      body: Center(
        child: Text(
          code!,
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}


class BlankScreenTemplate extends StatelessWidget {

  //Impact Colours
  final Color impactGrey = Color(0xFFC9C8CA);
  final Color impactRed = Color(0xFFF4333C);
  final Color impactBlack = Color(0xFF040404);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Add your additional items here
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Your Content Goes Here',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            // Add more widgets as needed
          ],
        ),
      ),
    );
  }
}