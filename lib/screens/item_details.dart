import 'package:favorite_places/models/places.dart';
import 'package:favorite_places/screens/map_screen.dart';
import 'package:flutter/material.dart';

class PlaceDetails extends StatelessWidget {
  PlaceDetails({super.key, required this.place});
  Place place;
  String get locationImage {
    final lat = place.location.latitude;
    final lon = place.location.longitude;
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lon=&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$lat,$lon&key=AIzaSyCFjASk3Hout4NpQC_V49YSitJ-xvv0fzQ';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(place.title,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: Theme.of(context).colorScheme.onBackground)),
        ),
        body: Stack(
          children: [
            Image.file(
              place.image,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            Positioned(
                bottom: 0,
                right: 0,
                left: 0,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (ctx) => MapScreen(
                                  location: place.location,
                                  isSelecting: false,
                                )));
                      },
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage: NetworkImage(locationImage),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 25),
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(
                              colors: [Colors.transparent, Colors.black38],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight)),
                      child: Text(
                        place.location.address,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                      ),
                    ),
                  ],
                ))
          ],
        ));
  }
}
