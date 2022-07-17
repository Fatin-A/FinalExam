import 'package:map_exam/viewmodel.dart';

class viewmodel extends viewmodel {
  Future editScreen({
    required String id,
    required String title,
    required String content,
  }) async {
    return await _Service.editProfile(id, title, content);
  }
}
