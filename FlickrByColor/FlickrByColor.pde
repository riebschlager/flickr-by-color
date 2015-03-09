import java.util.Date;
import java.util.Calendar;
import java.sql.Timestamp;

PImage[][] images;
int startColor = 0xFF0000FF;
int endColor = 0xFF00FFFF;
PImage source;

int segmentWidth = 60;
int segmentHeight = 60;

ArrayList<PVector> gridPoints = new ArrayList<PVector>();

void setup() {
  size(1920, 1080);

  source = loadImage("grad.jpg");
  image(source, 0, 0);

  for (int ix = 0; ix < source.width; ix += segmentWidth) {
    for (int iy = 0; iy < source.height; iy += segmentHeight) {
      gridPoints.add(new PVector(ix, iy));
    }
  }
}

void draw() {
  int randomX = (int) random(source.width);
  int randomY = (int) random(source.height);
  render(randomX, randomY);
}

Tile imageFromColor(int _color0, int _color1, int _color2, int _color3, int _color4) {
  // Flickr photo URLS: https://www.flickr.com/services/api/misc.urls.html

  String url = "http://labs.tineye.com/multicolr/rest/color_search/?";
  String params = "return_metadata=<serverID%2f><photoID%2f><farmID%2f><imageHeight%2f><imageWidth%2f>";
  params += "&colors[0]=" + hex(_color0, 6);
  params += "&colors[1]=" + hex(_color1, 6);
  params += "&colors[2]=" + hex(_color1, 6);
  params += "&colors[3]=" + hex(_color1, 6);
  params += "&colors[4]=" + hex(_color1, 6);
  params += "&weights[0]=" + 20;
  params += "&weights[1]=" + 20;
  params += "&weights[2]=" + 20;
  params += "&weights[3]=" + 20;
  params += "&weights[4]=" + 20;
  params += "&limit=" + 10;

  JSONObject tineye = loadJSONObject(url + params);
  JSONArray photos = tineye.getJSONArray("result");

  int randomIndex = floor(random(photos.size()));
  JSONObject randomPhoto = photos.getJSONObject(randomIndex);

  String filename = randomPhoto.getString("filepath");
  String secret = filename.split("_")[1];
  String farmID =  randomPhoto.getJSONObject("metadata").getString("farmID");
  String photoID =  randomPhoto.getJSONObject("metadata").getString("photoID");
  String serverID =  randomPhoto.getJSONObject("metadata").getString("serverID");
  String imageExt = filename.split("\\.")[1];
  int imageWidth = randomPhoto.getJSONObject("metadata").getInt("imageWidth");
  int imageHeight = randomPhoto.getJSONObject("metadata").getInt("imageHeight");
  String flickrUrl = "https://farm" + farmID + ".staticflickr.com/" + serverID + "/" + photoID + "_" + secret + "_s." + imageExt;
  String tineyeUrl = "http://img.tineye.com/flickr-images/?filepath=labs-flickr-public/images/" + filename;

  return new Tile(flickrUrl, tineyeUrl, imageWidth, imageHeight);
}

int snappedX(int _x) {
  int x = 0;
  for (int i = 0; i < gridPoints.size (); i++) {
    if (_x < gridPoints.get(i).x + segmentWidth) {
      x = floor(gridPoints.get(i).x);
      break;
    }
  }
  return x;
}

int snappedY(int _y) {
  int y = 0;
  for (int i = 0; i < gridPoints.size (); i++) {
    if (_y < gridPoints.get(i).y + segmentHeight) {
      y = floor(gridPoints.get(i).y);
      break;
    }
  }
  return y;
}

void render(int _x, int _y) {
  PImage segment = source.get(snappedX(_x), snappedY(_y), segmentWidth, segmentHeight);
  segment.loadPixels();
  int color0 = segment.pixels[int(random(0, segment.pixels.length))];
  int color1 = segment.pixels[int(random(0, segment.pixels.length))];
  int color2 = segment.pixels[int(random(0, segment.pixels.length))];
  int color3 = segment.pixels[int(random(0, segment.pixels.length))];
  int color4 = segment.pixels[int(random(0, segment.pixels.length))];
  Tile tile = imageFromColor(color0, color1, color2, color3, color4);
  tile.load("tineye");
  pushMatrix();
  translate(snappedX(_x), snappedY(_y) - 60);
  rotate(HALF_PI / 2);
  image(tile.image, 0, 0, tile.width, tile.height);
  popMatrix();
}

void mousePressed() {
  render(mouseX, mouseY);
}

void keyPressed() {
  if (key == 's') {
    long unixTime = System.currentTimeMillis() / 1000L;
    saveFrame("output/" + unixTime + ".png");
  }
}

