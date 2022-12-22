import '../image/image.dart';
import '../image/pixel.dart';
import 'draw_pixel.dart';

/// Draw the image [src] onto the image [dst].
///
/// In other words, drawImage will take an rectangular area from src of
/// width [srcW] and height [srcH] at position ([srcX],[srcY]) and place it
/// in a rectangular area of [dst] of width [dstW] and height [dstH] at
/// position ([dstX],[dstY]).
///
/// If the source and destination coordinates and width and heights differ,
/// appropriate stretching or shrinking of the image fragment will be performed.
/// The coordinates refer to the upper left corner. This function can be used to
/// copy regions within the same image (if [dst] is the same as [src])
/// but if the regions overlap the results will be unpredictable.
///
/// if [center] is true, the [src] will be centered in [dst].
Image drawImage(Image dst, Image src, {
    int? dstX,
    int? dstY,
    int? dstW,
    int? dstH,
    int? srcX,
    int? srcY,
    int? srcW,
    int? srcH,
    bool blend = true,
    bool center = false }) {
  dstX ??= 0;
  dstY ??= 0;
  srcX ??= 0;
  srcY ??= 0;
  srcW ??= src.width;
  srcH ??= src.height;
  dstW ??= (dst.width < src.width) ? dstW = dst.width : src.width;
  dstH ??= (dst.height < src.height) ? dst.height : src.height;

  if (center) {
    // if [src] is wider than [dst]
    var wdt = dst.width - src.width;
    if (wdt < 0) wdt = 0;
    dstX = wdt ~/ 2;
    // if [src] is higher than [dst]
    var height = dst.height - src.height;
    if (height < 0) height = 0;
    dstY = height ~/ 2;
  }

  final dy = srcH / dstH;
  final dx = srcW / dstW;
  final yCache = List<int>.generate(dstH, (y) => srcY! + (y * dy).toInt(),
      growable: false);
  final xCache = List<int>.generate(dstW, (x) => srcX! + (x * dx).toInt(),
      growable: false);

  Pixel? p;
  if (blend) {
    for (var y = 0; y < dstH; ++y) {
      for (var x = 0; x < dstW; ++x) {
        p = src.getPixel(xCache[x], yCache[y], p);
        drawPixel(dst, dstX + x, dstY + y, p);
      }
    }
  } else {
    for (var y = 0; y < dstH; ++y) {
      for (var x = 0; x < dstW; ++x) {
        p = src.getPixel(xCache[x], yCache[y], p);
        dst.setPixel(dstX + x, dstY + y, p);
      }
    }
  }

  return dst;
}
