import 'package:fazart_admin1/pages/ArtistProfile/addService.dart';
import 'package:fazart_admin1/pages/ArtistProfile/editPainting.dart';
import 'package:fazart_admin1/pages/ArtistProfile/editService.dart';
import 'package:fazart_admin1/pages/ArtistProfile/serviceQuestions.dart';
import 'package:fazart_admin1/pages/ArtistProfile/updateBio.dart';
import 'package:fazart_admin1/pages/home.dart';
import 'package:fazart_admin1/pages/newArtist.dart';
import 'package:flutter/material.dart';
import 'package:fazart_admin1/pages/ArtistProfile/artistprofile.dart';
import 'package:fazart_admin1/pages/ArtistProfile/addPainting.dart';

class MyRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => HomePage());
        break;

      case '/updatebio':
        return MaterialPageRoute(
            builder: (_) => UpdateBio(artist: settings.arguments));
        break;

      case '/artistprofile':
        return MaterialPageRoute(
            builder: (_) => ArtistProfile(settings.arguments));
        break;
      case '/artistaddpainting':
        return MaterialPageRoute(
            builder: (_) => AddPainting(settings.arguments));
        break;
      case '/artisteditpainting':
        return MaterialPageRoute(
            builder: (_) => EditPainting(settings.arguments));
        break;
      case '/artistaddservice':
        return MaterialPageRoute(
            builder: (_) => AddService(settings.arguments));
        break;
      case '/servicecustomquestions':
        return MaterialPageRoute(builder: (_) => ServiceQuestions());
        break;
      case '/artisteditservice':
        return MaterialPageRoute(
            builder: (_) => EditService(settings.arguments));
        break;
      case '/newArtist':
        return MaterialPageRoute(builder: (_) => AddNewArtist());
        break;
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                      child: Text('No route defined for ${settings.name}')),
                ));
    }
  }
}
