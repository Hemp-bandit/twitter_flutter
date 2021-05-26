/*
 * @LastEditors: wyswill
 * @Description: 
 * @Date: 2021-05-10 10:52:41
 * @LastEditTime: 2021-05-26 09:46:21
 */
import 'package:flutter/material.dart';
import 'package:weita_app/widgets/gallery_photo_view_wrapper.dart';

//  图片Widget
Widget imageWidget(List data) {
  if (data != null) {
    if (data.length > 0) {
      List list = [];
      for (int x = 0; x < data.length; x++) {
        GalleryExampleItem item = GalleryExampleItem();
        item.id = data[x];
        item.resource = "http://${data[x]}";
        list.add(item);
      }
      // print("http://${list[0].resource}");
      return GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: list.length,
        padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
        itemBuilder: (context, index) {
          return GalleryExampleItemThumbnail(
            galleryExampleItem: list[index],
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => GalleryPhotoViewWrapper(
                    galleryItems: list,
                    backgroundDecoration:
                        const BoxDecoration(color: Colors.black),
                    initialIndex: index,
                  ),
                ),
              );
            },
          );
        },
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: list.length <= 2 ? list.length : 3,
          childAspectRatio: list.length <= 2 ? 16 / 9 : 1 / 1,
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
        ),
      );
    }
  } else {
    return Container(
      width: 0,
      height: 0,
    );
  }
}
