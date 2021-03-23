class Service {
  String id, name, artist, image, description;
  num height, width, reqImages, price, eta, index, relevance;
  List<dynamic> sampleImages;
  bool forSale;

  Service(
      {this.artist,
      this.description,
      this.eta,
      this.height,
      this.id,
      this.image,
      this.name,
      this.price,
      this.reqImages,
      this.sampleImages,
      this.width,
      this.index,
      this.relevance,
      this.forSale});
}
