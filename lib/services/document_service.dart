import 'package:histocr_app/main.dart';
import 'package:histocr_app/models/document.dart';
import 'package:histocr_app/models/transcription_request.dart';

class DocumentService {
  static Future<List<Document>?> fetchDocuments({int? limit}) async {
    if (supabase.auth.currentUser == null) return null;

    try {
      var query = supabase
          .from('documents')
          .select()
          .eq('user_id', supabase.auth.currentUser!.id)
          .order('created_at', ascending: false);

      if (limit != null) {
        query = query.limit(limit);
      }

      final response = await query;
      return List<Document>.from(
        response.map((doc) => Document.fromJson(doc)),
      );
    } catch (e) {
      throw Exception('Erro ao carregar documentos: $e');
    }
  }

  static Future<void> updateDocumentName({
    required String name,
    required String documentId,
  }) async {
    try {
      await supabase
          .from('documents')
          .update({'document_name': name}).eq('id', documentId);
    } catch (e) {
      throw Exception('Erro ao atualizar o nome do documento: $e');
    }
  }

  static Future<Document?> getTranscription(
      TranscriptionRequest request) async {
    try {
      final response = await supabase.functions.invoke(
        'gemini',
        body: request.toJson(),
      );

      return Document.fromTranscriptionResponseJson(response.data);
    } catch (e) {
      throw Exception(
        'Erro ao processar a imagem: $e',
      );
    }
  }

  static Future<void> updateRating({
    required String documentId,
    required int rating,
  }) async {
    try {
      await supabase
          .from('documents')
          .update({'rating': rating}).eq('id', documentId);
    } catch (e) {
      throw Exception(
        'Erro ao atualizar a avaliação do documento: $e',
      );
    }
  }

  static Future<void> sendCorrection({
    required String documentId,
    required String correction,
  }) async {
    try {
      await supabase
          .from('documents')
          .update({'corrected_text': correction}).eq('id', documentId);
    } catch (e) {
      throw Exception(
        'Erro ao enviar correção do documento: $e',
      );
    }
  }
}
