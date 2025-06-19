import 'package:histocr_app/main.dart';
import 'package:histocr_app/models/document.dart';
import 'package:histocr_app/providers/base_provider.dart';
import 'package:histocr_app/services/document_service.dart';

class DocumentsProvider extends BaseProvider {
  List<Document> allDocuments = [];

  get userDocuments =>
      allDocuments.where((doc) => doc.organizationId == null).toList();
  get organizationDocuments =>
      allDocuments.where((doc) => doc.organizationId != null).toList();

  // --- Public API ---
  Future<void> fetchDocuments({int? limit}) async {
    if (supabase.auth.currentUser == null) return;

    setLoading(true);
    success = true;
    try {
      final fetchedDocuments =
          await DocumentService.fetchDocuments(limit: limit);
      allDocuments = fetchedDocuments ?? [];
    } catch (e) {
      success = false;
      throw Exception('Erro ao carregar documentos: $e');
    } finally {
      setLoading(false);
    }
  }

  Future<void> updateDocumentName({
    required String name,
    required Document document,
  }) async {
    setLoading(true);
    success = true;
    try {
      await DocumentService.updateDocumentName(
        name: name,
        documentId: document.id,
      );
      document.name = name;
    } catch (e) {
      success = false;
      throw Exception('Erro ao atualizar o nome do documento: $e');
    } finally {
      setLoading(false);
    }
  }

  Future<void> updateDocumentRating({
    required Document document,
    required int rating,
  }) async {
    setLoading(true);
    success = true;
    try {
      await DocumentService.updateRating(
        documentId: document.id,
        rating: rating,
      );
      document.rating = rating;
    } catch (e) {
      success = false;
      throw Exception('Erro ao atualizar a avaliação do documento: $e');
    } finally {
      setLoading(false);
    }
  }

  Future<void> sendCorrection({
    required Document document,
    required String correction,
  }) async {
    setLoading(true);
    success = true;
    try {
      await DocumentService.sendCorrection(
        documentId: document.id,
        correction: correction,
      );
      document.correctedText = correction;
    } catch (e) {
      success = false;
      throw Exception('Erro ao enviar correção: $e');
    } finally {
      setLoading(false);
    }
  }

  void addNewDocument(Document document) {
    allDocuments.insert(0, document);
    notifyListeners();
  }
}
