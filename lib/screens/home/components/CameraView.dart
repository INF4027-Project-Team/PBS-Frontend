import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/AppProduct.dart';

class CameraView extends StatefulWidget {
  const CameraView({Key? key}) : super(key: key);

  @override
  _CameraViewState createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  final BarcodeScanner _barcodeScanner = GoogleMlKit.vision.barcodeScanner();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    if (_cameras!.isNotEmpty) {
      _controller = CameraController(
        _cameras![0], // Use the first camera
        ResolutionPreset.medium,
      );
      await _controller!.initialize();
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _barcodeScanner.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.black26,
          width: 2,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            CameraPreview(_controller!),
            Container(
              padding: const EdgeInsets.all(20),
              child: FloatingActionButton(
                onPressed: _takePicture,
                child: const Icon(Icons.camera),
                backgroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _takePicture() async {
    if (_controller != null && _controller!.value.isInitialized) {
      final image = await _controller!.takePicture();
      print("Picture taken: ${image.path}");
      final inputImage = InputImage.fromFilePath(image.path);
      processImage(inputImage);
    }
  }

  void processImage(InputImage inputImage) async {
    final List<Barcode> barcodes =
        await _barcodeScanner.processImage(inputImage);
    for (Barcode barcode in barcodes) {
      // Print barcode values; you can also handle them according to your app's needs.
      print(barcode.displayValue);
      String barcodeValue = barcode.displayValue!;
      await sendBarcodeToBackend(barcodeValue);
      await fetchProducts(barcodeValue);
    }
  }

  Future<void> sendBarcodeToBackend(String barcode) async {
    try {
      final response = await http.post(
        Uri.parse(
            'http://192.168.0.107:8080/barcode'), // Replace with your actual backend URL
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(barcode),
      );

      if (response.statusCode == 200) {
        print('Response from backend: ${response.body}');
        // Handle the response data here
      } else {
        print(
            'Failed to load data from backend. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending data to backend: $e');
    }
  }

  Future<List<AppProduct>> fetchProducts(String barcode) async {
    final response =
        await http.post(Uri.parse('http://192.168.0.107:8080/barcode'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: json.encode(barcode));

    if (response.statusCode == 200) {
      // Parse the JSON data
      List<dynamic> productJsonList =
          json.decode(response.body) as List<dynamic>;
      // Map the JSON data to a list of Product objects
      List<AppProduct> products =
          productJsonList.map((json) => AppProduct.fromJson(json)).toList();

      //print(products.length);

      return products;
    } else {
      throw Exception('Failed to load products');
    }
  }
}
