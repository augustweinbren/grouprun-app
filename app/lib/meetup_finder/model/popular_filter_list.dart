class PopularFilterListData {
  PopularFilterListData({
    this.titleTxt = '',
    this.isSelected = false,
  });

  String titleTxt;
  bool isSelected;

  static List<PopularFilterListData> popularFList = <PopularFilterListData>[
    PopularFilterListData(
      titleTxt: 'Bag drop',
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: 'Dog friendly',
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: 'Post-run social',
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: 'Competition\ntraining',
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: 'Beginner friendly',
      isSelected: false,
    ),
  ];

  static List<PopularFilterListData> runningSettingList = [
    PopularFilterListData(
      titleTxt: 'All',
      isSelected: true,
    ),
    PopularFilterListData(
      titleTxt: 'Parks',
      isSelected: true,
    ),
    PopularFilterListData(
      titleTxt: 'Tracks',
      isSelected: true,
    ),
    PopularFilterListData(
      titleTxt: 'Streets',
      isSelected: true,
    ),
  ];
}
