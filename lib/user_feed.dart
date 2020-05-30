class UserFeed{
  final int likes;
  final int comments;
  final String firstName;
  final String lastName;
  final String profilePic;
  final String location;
  final String coverImage;
  final String videoUrl;

  UserFeed(this.likes,this.comments,this.firstName,this.lastName,
      this.profilePic,this.location,this.coverImage,this.videoUrl);



}

class UserVideos{
  final String videoUrl;

  UserVideos(this.videoUrl);
}
