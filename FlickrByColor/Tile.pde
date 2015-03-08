class Tile {

  String flickrUrl;
  String tineyeUrl;
  int width;
  int height;
  PImage image;
  float multiplier;

  Tile(String _flickrUrl, String _tineyeUrl, int _width, int _height) {
    this.flickrUrl = _flickrUrl;
    this.tineyeUrl = _tineyeUrl;
    this.multiplier = 1;
  }

  void load(String service) {
    if (service == "flickr") {
      this.image = loadImage(this.flickrUrl);
      this.width = floor(this.image.width * this.multiplier);
      this.height = floor(this.image.height * this.multiplier);
    }
    if (service == "tineye") {
      this.image = loadImage(this.tineyeUrl);
      this.width = floor(this.image.width * this.multiplier);
      this.height = floor(this.image.height * this.multiplier);
    }
  }
}

