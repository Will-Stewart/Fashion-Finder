import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
  List<CameraDescription>? cameras; //list out the camera available
  CameraController? controller; //controller for camera
  XFile? image; //for caputred image

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
        appBar: AppBar(
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
        ),
        body: Stack(
          children: [
            Container(
              height: 800,
              width: 400,
              child: controller == null
                  ? Center(child: Text("Loading Camera..."))
                  : !controller!.value.isInitialized
                      ? Center(child: CircularProgressIndicator())
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CameraPreview(controller!),
                        ),
            ),
            Container(
              alignment: Alignment(-1, 0.8),
              padding: EdgeInsets.all(15),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                child: image == null
                    ? Text("No image captured")
                    : Image.file(
                        File(image!.path),
                        height: 150,
                      ),
              ),
              decoration: image == null
                  ? null
                  : BoxDecoration(
                      border: Border.all(
                        color: Color.fromARGB(255, 24, 24, 24), // border color
                        width: 2.0, // border width
                      ),
                      borderRadius: BorderRadius.all(
                          Radius.circular(10.0) // rounded border
                          ),
                    ),
            ),
            // Position the floating action button at the bottom center
            Positioned(
              bottom: 100,
              right: 30,
              left: 30,
              child: FloatingActionButton(
                backgroundColor: Color.fromARGB(255, 29, 29, 29),
                onPressed: () async {
                  try {
                    if (controller != null) {
                      //check if contrller is not null
                      if (controller!.value.isInitialized) {
                        //check if controller is initialized
                        image = await controller!.takePicture(); //capture image
                        setState(() {
                          //update UI
                        });
                      }
                    }
                  } catch (e) {
                    print(e); //show error
                  }
                },
                child: Icon(Icons.camera),
              ),
            ),
          ],
        ));
  }
}
