class GeminiService {
  static Future<String> matchVolunteerToNeed({
    required String needDescription,
    required String needCategory,
    required String needLocation,
    required List<dynamic> volunteers,
  }) async {
    return 'Best matched volunteer will appear here once Gemini is connected.';
  }

  static Future<String> getMatch(String prompt) async {
    return 'Match result coming soon';
  }
}