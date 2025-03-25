import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:testform/model.dart';

class FamilyMemberService {
  static const String baseUrl =
      'YOUR_API_BASE_URL'; // Replace with your API URL

  Future<void> submitFamilyMembers(List<FamilyMember> members) async {
    try {
      log(
        jsonEncode({
          'members': members.map((member) => member.toJson()).toList(),
        }),
      );
      final url = Uri.parse('$baseUrl/family-members');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'members': members.map((member) => member.toJson()).toList(),
        }),
      );

      if (response.statusCode == 200) {
        print('Family members submitted successfully');
      } else {
        throw Exception(
            'Failed to submit family members: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error submitting family members: $e');
    }
  }
}
