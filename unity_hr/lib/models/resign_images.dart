class ResignImages {
  String? id;
  String? url;

  ResignImages({
    this.id,
    this.url,
  });

  factory ResignImages.fromJson(Map<String, dynamic> json) {
    return ResignImages(
      id: json['id'],
      url: json['url'],
    );
  }
}