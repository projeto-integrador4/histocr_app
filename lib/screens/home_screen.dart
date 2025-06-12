import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:histocr_app/components/histocr_title.dart';
import 'package:histocr_app/components/last_transcripts_item.dart';
import 'package:histocr_app/components/loading_indicator.dart';
import 'package:histocr_app/components/screen_width_button.dart';
import 'package:histocr_app/providers/documents_provider.dart';
import 'package:histocr_app/theme/app_colors.dart';
import 'package:histocr_app/utils/routes.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  _fetchDocuments(BuildContext context) async {
    final provider = Provider.of<DocumentsProvider>(context, listen: false);
    try {
      await provider.fetchDocuments();
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao carregar documentos: $e'),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchDocuments(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const HistocrTitle(),
              Consumer<DocumentsProvider>(builder: (context, provider, child) {
                final documents = provider.documents.take(3).toList();
                return Container(
                  child: provider.loading
                      ? const Center(child: LoadingIndicator())
                      : Visibility(
                          visible: documents.isNotEmpty,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 24),
                              Text(
                                'Últimas Transcrições:',
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              ListView.separated(
                                padding: const EdgeInsets.all(0),
                                shrinkWrap: true,
                                itemCount: documents.length,
                                itemBuilder: (context, index) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: LastTranscriptsItem(
                                    document: documents[index],
                                  ),
                                ),
                                separatorBuilder:
                                    (BuildContext context, int _) =>
                                        const Divider(
                                  color: primaryColor,
                                  height: 4,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () async {
                                    await Navigator.pushNamed(
                                        context, Routes.history);
                                  },
                                  child: Text(
                                    'Ver mais',
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: secondaryColorDark,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                );
              }),
              const SizedBox(height: 24),
              ScreenWidthButton(
                label: 'Iniciar Chat',
                onPressed: () async {
                  await navigator.pushNamed(Routes.chat);
                },
                color: secondaryColor,
              ),
              const SizedBox(height: 8),
              ScreenWidthButton(
                label: 'Configurações da Conta',
                onPressed: () {
                  navigator.pushNamed(Routes.accountSettings);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
