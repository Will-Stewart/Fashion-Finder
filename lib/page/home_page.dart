import 'dart:io';
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
                backgroundColor: const Color.fromARGB(255, 29, 29, 29),
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

                            setState(() {
                              predictedText = itemTitle;
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
            Center(
              child: Column(
                children: [
                  ReturnedItem(
                      text: predictedText ?? 'Take a photo to get started!'),
                ],
              ),
            )
          ],
        ));
  }
}

class ReturnedItem extends StatelessWidget {
  final String text;
  const ReturnedItem({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 120),
      width: MediaQuery.of(context).size.width * 0.9,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(fontSize: 18, color: Colors.black),
        ),
      ),
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
