import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../functions/vision_api.dart';
import '../functions/shopify_api.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<CameraDescription>? cameras;
  CameraController? controller;
  XFile? image;
  String? textResponse;
  String? predictedText;
  String? itemVendor; // Add this line to declare itemVendor
  Uint8List? productImage;
  ValueNotifier<String?> predictedTextNotifier = ValueNotifier<String?>(null);
  ValueNotifier<Uint8List?> productImageNotifier =
      ValueNotifier<Uint8List?>(null);

  @override
  void initState() {
    loadCamera();
    super.initState();
  }

  loadCamera() async {
    cameras = await availableCameras();
    if (cameras != null) {
      controller = CameraController(cameras![0], ResolutionPreset.max);
      //cameras[0] = first camera, change to 1 to another camera

      controller!.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
    } else {
      print("NO any camera found");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: const DarkBar(),
        body: Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: controller == null
                  ? const Center(child: Text("Loading Camera..."))
                  : !controller!.value.isInitialized
                      ? const Center(child: CircularProgressIndicator())
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CameraPreview(controller!),
                        ),
            ),
            PhotoPreview(image: image),
            // Position the floating action button at the bottom center
            Positioned(
              bottom: 100,
              right: 30,
              left: 30,
              child: FloatingActionButton(
                backgroundColor: const Color.fromARGB(255, 41, 41, 41),
                onPressed: () async {
                  try {
                    if (controller != null) {
                      //check if contrller is not null
                      if (controller!.value.isInitialized) {
                        //check if controller is initialized
                        image = await controller!.takePicture(); //capture image
                        setState(() {
                          File photoAsFile = File(image?.path ??
                              ''); // use null-aware operator to access path
                          sendImageToCustomVision(photoAsFile)
                              .then((predictedTags) {
                            // predictedTags is the result of sendImageToCustomVision

                            // Update the predictedText with the predicted tags

                            return searchProductsByTags(predictedTags);
                          }).then((matchingProducts) {
                            // matchingProducts is the result of searchProductsByTags
                            // do something with matchingProducts

                            String itemTitle = matchingProducts['title'];
                            itemVendor = matchingProducts[
                                'vendor']; // Update itemVendor directly

                            setState(() {
                              predictedTextNotifier.value = itemTitle;
                              int productId = matchingProducts['id'];
                              getProductImage(productId).then((imageData) {
                                setState(() {
                                  productImageNotifier.value = imageData;
                                });
                              }).catchError((error) {
                                // handle errors from getProductImage
                              });
                            });
                          }).catchError((error) {
                            // handle errors from either sendImageToCustomVision or searchProductsByTags
                          });
                        });
                      }
                    }
                  } catch (e) {
                    print(e); //show error
                  }
                },
                child: const Icon(Icons.camera),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
                // Adjust this value to position the container
                child: SafeArea(
                  child: IntrinsicHeight(
                    child: SizedBox(
                      height: 120, // Set a maximum height for the container
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        child: ValueListenableBuilder<String?>(
                          valueListenable: predictedTextNotifier,
                          builder: (context, text, child) =>
                              ValueListenableBuilder<Uint8List?>(
                            valueListenable: productImageNotifier,
                            builder: (context, image, child) => ReturnedItem(
                              text: text ?? 'Take a photo to get started!',
                              vendor:
                                  itemVendor, // itemVendor is now accessible here
                              image: image,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}

class ReturnedItem extends StatelessWidget {
  final String text;
  final String? vendor;
  final Uint8List? image;
  const ReturnedItem({Key? key, required this.text, this.vendor, this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (image != null)
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.memory(
                image!,
                width: 90,
                height: 90,
                fit: BoxFit.cover,
              ),
            ),
          ),
        Expanded(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text,
                textAlign: TextAlign.center,
                style: GoogleFonts.libreBaskerville(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
              ),
              if (vendor != null)
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Text(
                    vendor!,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.libreBaskerville(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.black),
                  ),
                ),
            ],
          ),
        ),
        if (text != 'Take a photo to get started!' &&
            vendor != null) // Added condition
          Container(
            height: 90,
            width: 90,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 41, 41, 41),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: IconButton(
              onPressed: () {
                // Handle button action here
              },
              icon: const Icon(
                Icons.local_mall,
                color: Colors.white,
                size: 40,
              ),
            ),
          ),
      ],
    );
  }
}

class PhotoPreview extends StatelessWidget {
  const PhotoPreview({
    Key? key,
    required this.image,
  }) : super(key: key);

  final XFile? image;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: const Alignment(-1, 0.8),
      padding: const EdgeInsets.all(15),
      decoration: image == null
          ? null
          : BoxDecoration(
              border: Border.all(
                color: const Color.fromARGB(255, 24, 24, 24), // border color
                width: 2.0, // border width
              ),
              borderRadius:
                  const BorderRadius.all(Radius.circular(10.0) // rounded border
                      ),
            ),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        child: image == null
            ? const Text("No image captured")
            : Image.file(
                File(image!.path),
                height: 150,
              ),
      ),
    );
  }
}

// AppBar Class

class DarkBar extends StatelessWidget implements PreferredSizeWidget {
  const DarkBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(30),
        ),
      ),
      title: Text(
        'Home Page',
        style: GoogleFonts.libreBaskerville(
            textStyle:
                const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
            fontSize: 24),
      ),
      backgroundColor: const Color.fromARGB(255, 41, 41, 41),
      shadowColor: const Color.fromARGB(255, 41, 41, 41),
      elevation: 0,
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
