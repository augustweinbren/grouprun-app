class PopularFilterListData {
  PopularFilterListData({
    this.titleTxt = '',
    this.isSelected = false,
  });

  String titleTxt;
  bool isSelected;

  static List<PopularFilterListData> popularFList = <PopularFilterListData>[
    PopularFilterListData(
      titleTxt: 'A bag drop',
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: 'Dog friendly',
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: 'Social post-run activity',
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: 'Competitive streak',
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
