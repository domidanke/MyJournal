import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_journal/models/journal.dart';
import 'package:my_journal/screens/entry/entry_overview_screen.dart';
import 'package:my_journal/services/navigation_service.dart';

import '../../services/locator.dart';

final NavigationService _navigationService = locator<NavigationService>();

class JournalCard extends StatelessWidget {
  const JournalCard({@required this.journal});

  final Journal journal;

  //region Convert dynamic Image
  Image getImage() {
    if (journal.image != null) {
      if (journal.image.runtimeType != String) {
        return Image.file(
          journal.image,
          fit: BoxFit.fill,
        );
      } else {
        return Image.network(journal.image, fit: BoxFit.fill, loadingBuilder:
            (BuildContext context, Widget child,
                ImageChunkEvent loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes
                  : null,
            ),
          );
        });
      }
    } else {
      return Image.asset(
        'assets/images/placeholder-journal-card.png',
        fit: BoxFit.fill,
      );
    }
  }
  //endregion

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (journal.image.runtimeType == String || journal.image == null) {
          _navigationService.navigateTo(EntryOverviewScreen.id, args: journal);
        }
      },
      child: AspectRatio(
        aspectRatio: 4 / 3,
        child: Stack(
          children: <Widget>[
            AspectRatio(
              aspectRatio: 4 / 3,
              child: Card(
                semanticContainer: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: getImage(),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 5,
                margin: const EdgeInsets.all(10),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Card(
                margin: const EdgeInsets.all(20),
                child: ListTile(
                  leading: journal.icon,
                  title: Text(journal.title),
                  subtitle: Text(journal.category),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
