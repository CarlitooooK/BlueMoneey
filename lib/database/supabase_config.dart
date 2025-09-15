import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig{
  static const String supabaseURL = "https://qyelvkeiumcuiovckurk.supabase.co";
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InF5ZWx2a2VpdW1jdWlvdmNrdXJrIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc1NTY1NDUxNiwiZXhwIjoyMDcxMjMwNTE2fQ.6ZT_HYOdkXZVgyXpVqrp2oZALS8vmZFFhLWfbSTbxVI';

  static Future<void> initialize() async {
    await Supabase.initialize(url: supabaseURL, anonKey: supabaseAnonKey);
  }

  static SupabaseClient get client => Supabase.instance.client;
}
