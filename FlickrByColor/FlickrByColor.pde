PImage[][] images;
int startColor = 0xFF152422;
int endColor = 0xFFEB9000;

void setup() {
  size(3000, 3000);
  int[] colorList = new int[30];
  for (int i = 0; i < colorList.length; i++) {
    colorList[i] = lerpColor(startColor, endColor, map(i, 0, colorList.length, 0, 1));
  }
  images = new PImage[colorList.length][colorList.length];
  for (int i = 0; i < colorList.length; i++) {
    for (int j = 0; j < colorList.length; j++) {
      float dist = map(i, 0, colorList.length, 0, 1);
      images[i][j] = imageFromColor(dist, 1 - dist);
    }
  }
  for (int i = 0; i < images.length; i++) {
    for (int j = 0; j < images.length; j++) {
      image(images[i][j], i * 100, j * 100, 100, 100);
    }
  }
  saveFrame();
}

PImage imageFromColor(float a, float b) {
  String url = "http://labs.tineye.com/rest/?method=flickr_color_search&limit=73&offset=0&";
  url += "colors%5B0%5D=" + hex(startColor, 6) + "&colors%5B1%5D=" + hex(endColor, 6) + "&";
  url += "weights%5B0%5D="+a+"&weights%5B1%5D=" + b;
  println(url);
  JSONObject tineye = loadJSONObject(url);
  String filePath = "http://img.tineye.com/flickr-images/?filepath=labs-flickr/";
  filePath += tineye.getJSONArray("result").getJSONObject(floor(random(tineye.getJSONArray("result").size()))).getString("filepath");
  PImage img = loadImage(filePath);
  return img;
}

