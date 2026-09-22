class PolicyBookList {
  String id;
  String title;
  String accessibleType;

  PolicyBookList({
    required this.id,
    required this.title,
    required this.accessibleType,
  });

  factory PolicyBookList.fromJson(Map<String, dynamic> json) {
    return PolicyBookList(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      accessibleType: json['accessible_type']?.toString() ?? '',
    );
  }
}

class PolicyBookDetail {
  String id;
  String title;
  List<String> chapters;
  List<PolicyPage> page;

  PolicyBookDetail({
    required this.id,
    required this.title,
    required this.chapters,
    required this.page,
  });

  factory PolicyBookDetail.fromJson(Map<String, dynamic> json) {
    return PolicyBookDetail(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      chapters:
          (json['chapters'] as List?)?.map((e) => e.toString()).toList() ?? [],
      page: (json['page'] as List?)
              ?.map((e) => PolicyPage.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class PolicyPage {
  MainChapter mainChapter;
  List<SubChapter> subChapters;

  PolicyPage({
    required this.mainChapter,
    required this.subChapters,
  });

  factory PolicyPage.fromJson(Map<String, dynamic> json) {
    return PolicyPage(
      mainChapter: MainChapter.fromJson(
        json['main_chapter'] ?? {},
      ),
      subChapters: (json['sub_chapters'] as List?)
              ?.map((e) => SubChapter.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class MainChapter {
  int id;
  String title;
  List<Content> contents;

  MainChapter({
    required this.id,
    required this.title,
    required this.contents,
  });

  factory MainChapter.fromJson(Map<String, dynamic> json) {
    return MainChapter(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      title: json['title']?.toString() ?? '',
      contents: (json['contents'] as List?)
              ?.map((e) => Content.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class SubChapter {
  int? id;
  String? title;
  List<Content> contents;

  // Important: recursive children
  List<SubChapter> children;

  SubChapter({
    this.id,
    this.title,
    required this.contents,
    required this.children,
  });

  factory SubChapter.fromJson(Map<String, dynamic> json) {
    return SubChapter(
      id: json['id'] == null ? null : int.tryParse(json['id'].toString()),
      title: json['title']?.toString(),
      contents: (json['contents'] as List?)
              ?.map((e) => Content.fromJson(e))
              .toList() ??
          [],
      children: (json['children'] as List?)
              ?.map((e) => SubChapter.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class Content {
  int id;
  String content;

  Content({
    required this.id,
    required this.content,
  });

  factory Content.fromJson(Map<String, dynamic> json) {
    return Content(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      content: json['content']?.toString() ?? '',
    );
  }
}
