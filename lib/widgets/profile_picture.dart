import 'package:flutter/material.dart';
import '../util/styles.dart';

///
/// Profile Picture
///
/// Creates the widget shown in the settings page. It shows the user's
/// profile picture with an icon on top of it to show that it can be changed.
///
class ProfilePicture extends StatelessWidget {
  final String pictureURL;

  const ProfilePicture({super.key, this.pictureURL = ''});

  @override
  Widget build(BuildContext context) {
    double profilePictureRadius = getProfilePictureRadiusBig();

    return GestureDetector(
      onTap: (){},
      child: SizedBox(
          child: pictureURL.isEmpty || pictureURL == '' ?
          CircleAvatar(
            backgroundColor: getYellowColor(),
            radius: profilePictureRadius
          ) :
          CircleAvatar(
            radius: profilePictureRadius,
            foregroundImage: NetworkImage(pictureURL)
          )
      ),
    );
  }
}