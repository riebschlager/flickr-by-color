class Tile {

  String flickrUrl;
  String tineyeUrl;
  int width;
  int height;
  PImage image;

  Tile(String _flickrUrl, String _tineyeUrl, int _width, int _height) {
    this.flickrUrl = _flickrUrl;
    this.tineyeUrl = _tineyeUrl;
    float divisor = random(1, 4);
    this.width = floor(_width / divisor);
    this.height = floor(_height / divisor);
  }

  void load(String service) {
    if (service == "flickr") {
      this.image = loadImage(this.flickrUrl);
    }
    if (service == "tineye") {
      this.image = loadImage(this.tineyeUrl);
    }
  }
}

