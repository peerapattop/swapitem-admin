import 'package:flutter/material.dart';
// import 'package:carousel_slider/carousel_slider.dart';

class ImageGalleryWidget extends StatefulWidget {
  final List<String> imageUrls;

  const ImageGalleryWidget({super.key, required this.imageUrls});

  @override
  _ImageGalleryWidgetState createState() => _ImageGalleryWidgetState();
}

class _ImageGalleryWidgetState extends State<ImageGalleryWidget> {
  int _currentIndex = 0;
  // final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double carouselHeight = screenWidth * (9 / 16);

    return Column(
      children: <Widget>[
        // CarouselSlider.builder(
        //   itemCount: widget.imageUrls.length,
        //   // carouselController: _controller,
        //   itemBuilder:
        //       (BuildContext context, int itemIndex, int pageViewIndex) =>
        //           GestureDetector(
        //     onTap: () {
        //       // Navigate to the DetailScreen when tapped
        //       Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //           builder: (context) => DetailScreen(
        //             imageUrl: widget.imageUrls[itemIndex],
        //             currentIndex: itemIndex,
        //             imageUrls: widget.imageUrls,
        //             // carouselController: _controller,
        //           ),
        //         ),
        //       );
        //     },
        //     child: AspectRatio(
        //       aspectRatio: 16 / 9,
        //       child: Image.network(
        //         widget.imageUrls[itemIndex],
        //         fit: BoxFit.cover,
        //       ),
        //     ),
        //   ),
        //   options: CarouselOptions(
        //     autoPlay: false,
        //     enlargeCenterPage: false,
        //     viewportFraction: 1.0,
        //     // Occupy the full width of the viewport
        //     height: carouselHeight,
        //     // Set the height based on the aspect ratio
        //     onPageChanged: (index, reason) {
        //       setState(() {
        //         _currentIndex = index;
        //       });
        //     },
        //   ),
        // ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.imageUrls.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () {
                // Handle indicator tap
                setState(() {
                  _currentIndex = entry.key;
                });
              },
              child: Container(
                width: 8.0,
                height: 8.0,
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentIndex == entry.key
                      ? Theme.of(context).primaryColor // Highlight if selected
                      : Colors.grey,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

// DetailScreen widget for displaying the image in full size
class DetailScreen extends StatelessWidget {
  final String imageUrl;
  final int currentIndex;
  final List<String> imageUrls;
  // final CarouselController carouselController;

  DetailScreen({
    required this.imageUrl,
    required this.currentIndex,
    required this.imageUrls,
    // required this.carouselController,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("ดูรูปภาพขนาดเต็ม"),
          toolbarHeight: 40,
          centerTitle: true,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/image 40.png'),
                fit: BoxFit.fill,
              ),
            ),
          ),
          actions: [
            if (currentIndex <
                imageUrls.length - 1) // Check if not the last image
              IconButton(
                icon: Icon(Icons.arrow_forward),
                onPressed: () {
                  // Navigate to the next image
                  // carouselController.nextPage();
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailScreen(
                        imageUrl: imageUrls[currentIndex + 1],
                        currentIndex: currentIndex + 1,
                        imageUrls: imageUrls,
                        // carouselController: carouselController,
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
        body: Container(
          color: Colors.black,
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context); // Close the full size view when tapped
            },
            child: Center(
              child: Image.network(imageUrl, fit: BoxFit.contain),
            ),
          ),
        ),
      ),
    );
  }
}
