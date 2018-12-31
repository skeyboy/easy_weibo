class ProfileModel {
  String name;
  String screen_name;
  String description;
  String profile_image_url;
  String cover_image_phone;
  String avatar_large;
  String avatar_hd;

  int followers_count;
  int friends_count;
  int pagefriends_count;
  int statuses_count;
  int video_status_count;
  int favourites_count;

  ProfileModel(jsonObj) {
    name = jsonObj['name'];
    screen_name = jsonObj['screen_name'];
    description = jsonObj['description'];
    profile_image_url = jsonObj['profile_image_url'];
    cover_image_phone = jsonObj['cover_image_phone'];
    avatar_large = jsonObj['avatar_large'];
    avatar_hd = jsonObj['avatar_hd'];

    followers_count = jsonObj['followers_count'];
    friends_count = jsonObj['friends_count'];
    pagefriends_count = jsonObj['pagefriends_count'];
    statuses_count = jsonObj['statuses_count'];
    video_status_count = jsonObj['video_status_count'];
    favourites_count = jsonObj['favourites_count'];
  }
}
