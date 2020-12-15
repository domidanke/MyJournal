class AppUser {
  AppUser(
      {this.userName,
      this.userID,
      this.email,
      this.created,
      this.userImage,
      this.darkMode});

  final String userID;
  final String email;
  final DateTime created;
  final bool darkMode;
  final String userName;
  dynamic userImage;
}
