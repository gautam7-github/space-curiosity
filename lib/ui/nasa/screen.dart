import 'package:clipboard_manager/clipboard_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:share/share.dart';
import 'package:space_news/ui/general/sliver_bar.dart';

import '../../data/classes/nasa/image.dart';
import '../general/cache_image.dart';
import '../general/expand_widget.dart';
import '../general/separator.dart';

class NasaImagePage extends StatelessWidget {
  final NasaImage image;

  NasaImagePage(this.image);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverBar(
            height: 0.4,
            header: InkWell(
              child: Hero(
                tag: image.getDate,
                child: CacheImage(image?.url),
              ),
              onTap: () async => await FlutterWebBrowser.openWebPage(
                    url: image.hdurl,
                    androidToolbarColor: Theme.of(context).primaryColor,
                  ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: <Widget>[
                  Text(
                    image.title,
                    style: Theme.of(context).textTheme.headline,
                    textAlign: TextAlign.center,
                  ),
                  Separator.spacer(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      HeaderDetails(
                        icon: Icons.copyright,
                        title: image.getCopyright(context),
                      ),
                      HeaderDetails(
                        icon: Icons.calendar_today,
                        title: image.getDate,
                      ),
                    ],
                  ),
                  Separator.divider(height: 24),
                  TextExpand(
                    text: image.getDescription(context),
                    maxLength: 10,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.caption.color,
                      fontSize: 15,
                    ),
                  ),
                  Separator.divider(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      OptionButton(
                        icon: Icons.share,
                        title: FlutterI18n.translate(context, 'nasa.share'),
                        onTap: () => Share.share(image.share(context)),
                      ),
                      OptionButton(
                        icon: Icons.link,
                        title: FlutterI18n.translate(context, 'nasa.copy_link'),
                        onTap: () => ClipboardManager.copyToClipBoard(
                              image.url,
                            ),
                      ),
                      OptionButton(
                        icon: Icons.get_app,
                        title: FlutterI18n.translate(context, 'nasa.download'),
                        onTap: () => ImageDownloader.downloadImage(image.url),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class HeaderDetails extends StatelessWidget {
  final IconData icon;
  final String title;

  HeaderDetails({this.icon, this.title});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Column(children: <Widget>[
        Icon(
          icon,
          size: 27,
          color: Theme.of(context).textTheme.caption.color,
        ),
        Separator.spacer(height: 8),
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.subhead.copyWith(
                color: Theme.of(context).textTheme.caption.color,
              ),
        ),
      ]),
    );
  }
}

class OptionButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  OptionButton({this.icon, this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: InkWell(
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Row(
            children: <Widget>[
              Icon(icon, size: 32),
              Flexible(
                child: Center(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.subhead.copyWith(
                        color: Theme.of(context).textTheme.caption.color),
                  ),
                ),
              )
            ],
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
