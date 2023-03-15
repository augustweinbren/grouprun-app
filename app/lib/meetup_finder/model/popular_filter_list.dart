class FilterListData {
  FilterListData({
    this.titleTxt = '',
    this.isSelected = false,
  });

  String titleTxt;
  bool isSelected;

  static List<FilterListData> mustHaveFList = <FilterListData>[
    FilterListData(
      titleTxt: 'Bag drop',
      isSelected: false,
    ),
    FilterListData(
      titleTxt: 'Dog friendly',
      isSelected: false,
    ),
    FilterListData(
      titleTxt: 'Post-run social',
      isSelected: false,
    ),
    FilterListData(
      titleTxt: 'Competition\ntraining',
      isSelected: false,
    ),
    FilterListData(
      titleTxt: 'Beginner friendly',
      isSelected: false,
    ),
  ];

  static List<FilterListData> runningSettingList = [
    FilterListData(
      titleTxt: 'All',
      isSelected: true,
    ),
    FilterListData(
      titleTxt: 'Parks',
      isSelected: true,
    ),
    FilterListData(
      titleTxt: 'Tracks',
      isSelected: true,
    ),
    FilterListData(
      titleTxt: 'Streets',
      isSelected: true,
    ),
  ];
}
