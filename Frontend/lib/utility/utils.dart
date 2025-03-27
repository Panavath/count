List<Map<String, dynamic>> castListDynamicToListMap(List<dynamic> list) {
  return (list as List<dynamic>?)
          ?.map((item) => item as Map<String, dynamic>)
          .toList() ??
      [];
}
