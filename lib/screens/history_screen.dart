import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:histocr_app/components/last_transcripts_item.dart';
import 'package:histocr_app/components/loading_indicator.dart';
import 'package:histocr_app/components/scaffold_with_return_button.dart';
import 'package:histocr_app/models/document.dart';
import 'package:histocr_app/providers/documents_provider.dart';
import 'package:histocr_app/theme/app_colors.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Document> filteredDocuments = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = Provider.of<DocumentsProvider>(context, listen: false);
      if (!mounted) return;
      setState(() {
        filteredDocuments = provider.documents;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DocumentsProvider>(context);
    
    return ScaffoldWithReturnButton(
      title: Container(
        alignment: Alignment.bottomCenter,
        height: 40,
        width: double.infinity,
        child: TextField(
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
          onChanged: (value) => setState(() {
            filteredDocuments = provider.documents
                .where((doc) =>
                    doc.name.toLowerCase().contains(value.toLowerCase()))
                .toList();
          }),
        ),
      ),
      child: provider.loading
          ? const Center(child: LoadingIndicator())
          : filteredDocuments.isNotEmpty
              ? ListView.separated(
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16),
                    child: LastTranscriptsItem(
                      document: filteredDocuments[index],
                      isOnHomeScreen: false,
                    ),
                  ),
                  separatorBuilder: (context, index) => const Divider(
                    color: primaryColor,
                    height: 4,
                  ),
                  itemCount: filteredDocuments.length,
                )
              : const Center(child: Text('Nenhum documento encontrado')),
    );
  }
}
