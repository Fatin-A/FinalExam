import 'package:map_exam/viewmodel.dart';

class Viewmodel {
  Future editScreen({
    required String id,
    required String title,
    required String content,
  }) async {
    return await _Service.editProfile(id, title, content);
  }
}
