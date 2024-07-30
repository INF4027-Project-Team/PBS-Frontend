import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
class imageLabeler
{
  Future<List<ImageLabel>> scanImage(InputImage? inputImage) async {
    try {
      // Creates the instance of barcode scanner
      //final barcodeScan = BarcodeScanner();
      final ImageLabeler labeler = ImageLabeler(options: ImageLabelerOptions());
      
      //Begin image scanning
      final labels = await labeler.processImage(inputImage!);
      //for (ImageLabel labele in labels)
      //{
        //print(labele.label);
      //}
    

      // Close scanner
      await labeler.close();

      return labels;
    } catch (e) {
      return [];
    }
  }
}