import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:histocr_app/components/last_transcripts_item.dart';
import 'package:histocr_app/components/loading_indicator.dart';
import 'package:histocr_app/components/scaffold_with_return_button.dart';
import 'package:histocr_app/main.dart';
import 'package:histocr_app/models/document.dart';
import 'package:histocr_app/theme/app_colors.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Document> documents = [];
  bool success = true;
  bool loading = false;

  void _fetchDocuments() async {
    setState(() {
      loading = true;
    });

    try {
      final response = await supabase
          .from('documents')
          .select()
          .eq('user_id', supabase.auth.currentUser!.id)
          .order('updated_at', ascending: false);
      documents = List<Document>.from(
        response.map((doc) => Document.fromJson(doc)),
      );
    } catch (e) {
      success = false;
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao carregar documentos'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    _fetchDocuments();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithReturnButton(
      title: Container(
        alignment: Alignment.bottomCenter,
        height: 40,
        width: double.infinity,
        child: TextField(
          //TODO implement search
          decoration: InputDecoration(
            hintStyle: GoogleFonts.inter(
              fontSize: 14,
            ),
            hintText: 'Search',
            suffixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
      child: loading
          ? const Center(child: LoadingIndicator())
          : success
              ? ListView.separated(
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16),
                    child: LastTranscriptsItem(
                      document: documents[index],
                      isOnHomeScreen: false,
                    ),
                  ),
                  separatorBuilder: (context, index) => const Divider(
                    color: primaryColor,
                    height: 4,
                  ),
                  itemCount: documents.length,
                )
              : const Center(
                  child: Text(
                    'Nenhum documento encontrado',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
    );
  }
}
