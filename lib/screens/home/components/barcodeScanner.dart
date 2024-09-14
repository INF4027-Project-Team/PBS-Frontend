import 'package:camera/camera.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:flutter/services.dart';
class Barcodes
{
  // Orientations required to calculate the degree of camera rotation
  final _orientations = {
    DeviceOrientation.portraitUp: 0,
    DeviceOrientation.landscapeLeft: 90,
    DeviceOrientation.portraitDown: 180,
    DeviceOrientation.landscapeRight: 270,
  };



  // This is the method to prepare the images for barcode scanning
  InputImage? prepareInputImage(CameraImage? image, CameraController controller) {
    
    if (image == null) return null;
    // Save image format
    final InputImageFormat? format = InputImageFormatValue.fromRawValue(image.format.raw);
    // Check that image is in correct format
    if ((format == null) || (format != InputImageFormat.nv21)) return null;

    // Save image plane
    final plane = image.planes.first;

    // Calculate the rotation degree of camera
    final sensorOrientation = controller.description.sensorOrientation;
    var rotationCompensation = _orientations[controller.value.deviceOrientation];

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



  // This method is used to scan the barcodes and return a list of codes which are found for any given barcode
  Future<List<Barcode>> scanBarcodes(InputImage? inputImage) async {
    try {
      // Creates the instance of barcode scanner
      final barcodeScan = BarcodeScanner();
      //final ImageLabeler label = ImageLabeler(options: ImageLabelerOptions());
      //final labels = await label.processImage(inputImage!);
      //for (ImageLabel labele in labels)
      //{
        //print(labele.label);
      //}
    
      // Begin scanning
      final barcodes = await barcodeScan.processImage(inputImage!);

      // Close scanner
      await barcodeScan.close();

      return barcodes;
    } catch (e) {
      return [];
    }
  }
}