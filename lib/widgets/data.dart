class SliderModel {
  String? imageAssetPath;
  String? title;
  String? desc;

  SliderModel({this.imageAssetPath, this.title, this.desc});

  void setImageAssetPath(String getImageAssetPath) {
    imageAssetPath = getImageAssetPath;
  }

  void setTitle(String getTitle) {
    title = getTitle;
  }

  void setDesc(String getDesc) {
    desc = getDesc;
  }

  String? getImageAssetPath() {
    return imageAssetPath;
  }

  String? getTitle() {
    return title.toString();
  }

  String? getDesc() {
    return desc;
  }
}

List<SliderModel> getSlides() {
  List<SliderModel> slides = [];
  SliderModel sliderModel = new SliderModel();

  //1
  sliderModel.setDesc(
      "One App to Solve All Students Problems.... Encountering any problem as a student? Consult UniApp.");
  sliderModel.setTitle("Students N0.1 Solution Centre");
  sliderModel.setImageAssetPath("images/uniappLogo.png");
  slides.add(sliderModel);

  sliderModel = new SliderModel();

  //2
  sliderModel.setDesc(
      "E-learning tailored towards your need. We offer preparatory CBT test and video tutorials as a service across Universities, Polythenics, A-level programmes and Professional exams Nationwide.");
  sliderModel.setTitle("Academic Solution");
  sliderModel.setImageAssetPath("images/academic.png");
  slides.add(sliderModel);

  sliderModel = new SliderModel();

  //3
  sliderModel.setDesc(
      "A universal marketplace to handle your on-campus and off-campus needs. Get anything from anywhere at anytime nationwide. Unihub! less stress, more flex.");
  sliderModel.setTitle("Universal Hub");
  sliderModel.setImageAssetPath("images/unihub.jpg");
  slides.add(sliderModel);

  sliderModel = new SliderModel();
  //4
  sliderModel.setDesc(
      "Get all news from different universities across the nation in one place. UniApp! One App to replace them all");
  sliderModel.setTitle("Campus Trends");
  sliderModel.setImageAssetPath("images/news.png");
  slides.add(sliderModel);

  sliderModel = new SliderModel();

  return slides;
}
