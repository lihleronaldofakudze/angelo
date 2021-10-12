import 'package:angelo/models/Gallery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class GalleryWidget extends StatelessWidget {
  const GalleryWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gallery = Provider.of<List<Gallery>>(context);
    return StaggeredGridView.countBuilder(
      crossAxisCount: 4,
      itemCount: gallery.length,
      itemBuilder: (BuildContext context, int index) => InkWell(
          onTap: () {
            Navigator.pushNamed(context, '/image',
                arguments: gallery[index].id);
          },
          child: new Image.network(gallery[index].image)),
      staggeredTileBuilder: (int index) => new StaggeredTile.fit(2),
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
    );
  }
}
