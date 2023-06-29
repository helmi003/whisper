class SliderContent{
  String image;
  String description;
  SliderContent({required this.image, required this.description});
}
List<SliderContent> contents = [
  SliderContent(
    image: 'assets/images/social_interaction.svg',
    description: "Whisper will provide you an easy way to communicate with your friends and beloved ones in a safe way."
  ),
  SliderContent(
    image: 'assets/images/online_world.svg',
    description: "Also you can make new friends by adding them with the possibility to contact with them either via text messages or by reacting to their posts."
  ),
  SliderContent(
    image: 'assets/images/add_friends.svg',
    description: "You also have the posibility to add and delete friends or even add chat groups."
  ),
];


