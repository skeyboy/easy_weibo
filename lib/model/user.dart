class User {
  String screen_name;
  String name;
  String province;
  String city;
  String location;
  String description;
  String profile_image_url;
  String cover_image;
  String cover_image_phone;

  User(jsonObj) {
    screen_name = jsonObj['screen_name'];
    name = jsonObj['name'];
    province = jsonObj['province'];
    city = jsonObj['city'];
    location = jsonObj['location'];
    description = jsonObj['description'];
    profile_image_url = jsonObj['profile_image_url'];
    cover_image = jsonObj['cover_image'];
    cover_image_phone = jsonObj['cover_image_phone'];
  }
}
