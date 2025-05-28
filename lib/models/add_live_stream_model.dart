
class AddLiveStreamVideo {
  String? youtubeLink;
  String? coverImage;
  String? videoTitle;
  String? astrologerId;
  String? categoryId;
  String? sortOrder;
  String? createdBy;
  String? modifiedBy;
  String? updatedAt;
  String? createdAt;
  int? id;

  AddLiveStreamVideo(
      {this.youtubeLink,
        this.coverImage,
        this.videoTitle,
        this.astrologerId,
        this.categoryId,
        this.sortOrder,
        this.createdBy,
        this.modifiedBy,
        this.updatedAt,
        this.createdAt,
        this.id});

  AddLiveStreamVideo.fromJson(Map<String, dynamic> json) {
    youtubeLink = json['youtubeLink'];
    coverImage = json['coverImage'];
    videoTitle = json['videoTitle'];
    astrologerId = json['astrologer_id'];
    categoryId = json['category_id'];
    sortOrder = json['sort_order'];
    createdBy = json['createdBy'];
    modifiedBy = json['modifiedBy'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['youtubeLink'] = this.youtubeLink;
    data['coverImage'] = this.coverImage;
    data['videoTitle'] = this.videoTitle;
    data['astrologer_id'] = this.astrologerId;
    data['category_id'] = this.categoryId;
    data['sort_order'] = this.sortOrder;
    data['createdBy'] = this.createdBy;
    data['modifiedBy'] = this.modifiedBy;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    return data;
  }
}
