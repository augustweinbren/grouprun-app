class FilterListData {
  FilterListData({
    this.titleTxt = '',
    this.isSelected = false,
    this.id = -1,
  });

  String titleTxt;
  bool isSelected;
  int id;

  static List<FilterListData> mustHaveFList = <FilterListData>[
    FilterListData(
      titleTxt: 'Bag drop',
      isSelected: false,
      id: 0,
    ),
    FilterListData(
      titleTxt: 'Dog friendly',
      isSelected: false,
      id: 1,
    ),
    FilterListData(
      titleTxt: 'Post-run social',
      isSelected: false,
      id: 2,
    ),
    FilterListData(
      titleTxt: 'Competition\ntraining',
      isSelected: false,
      id: 3,
    ),
    FilterListData(
      titleTxt: 'Beginner friendly',
      isSelected: false,
      id: 4,
    ),
  ];

  static List<FilterListData> runningSettingList = [
    FilterListData(
      titleTxt: 'All',
      isSelected: true,
      id: 5,
    ),
    FilterListData(
      titleTxt: 'Parks',
      isSelected: true,
      id: 6,
    ),
    FilterListData(
      titleTxt: 'Tracks',
      isSelected: true,
      id: 7,
    ),
    FilterListData(
      titleTxt: 'Streets',
      isSelected: true,
      id: 8,
    ),
  ];
}
