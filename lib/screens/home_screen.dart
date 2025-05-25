import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:histocr_app/components/histocr_title.dart';
import 'package:histocr_app/components/last_transcripts_item.dart';
import 'package:histocr_app/components/loading_indicator.dart';
import 'package:histocr_app/components/screen_width_button.dart';
import 'package:histocr_app/main.dart';
import 'package:histocr_app/models/document.dart';
import 'package:histocr_app/providers/auth_provider.dart';
import 'package:histocr_app/theme/app_colors.dart';
import 'package:histocr_app/utils/routes.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with RouteAware {
  List<Document> documents = [];
  bool success = false;
  bool loading = false;
  bool _shouldFetchOnReturn = false;

  void _fetchDocuments() async {
    setState(() {
      success = true;
      loading = true;
    });

    try {
      final response = await supabase
          .from('documents')
          .select()
          .eq('user_id', supabase.auth.currentUser!.id)
          .limit(3)
          .order('updated_at', ascending: false);

      setState(() {
        if (response.isEmpty) {
          documents = [];
          return;
        }
        documents = List<Document>.from(
          response.map((doc) => Document.fromJson(doc)),
        );
      });
    } catch (e) {
      setState(() {
        success = false;
        documents = [];
      });
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    // Only fetch if flag was set
    if (_shouldFetchOnReturn) {
      _fetchDocuments();
      _shouldFetchOnReturn = false;
    }
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
              loading
                  ? const LoadingIndicator()
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
                            separatorBuilder: (BuildContext context, int _) =>
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
                                final shouldChange = await Navigator.pushNamed(
                                    context, Routes.history) as bool?;
                                if (shouldChange != null && shouldChange) {
                                  _shouldFetchOnReturn = true;
                                }
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
              const SizedBox(height: 24),
              ScreenWidthButton(
                label: 'Iniciar Chat',
                onPressed: () async {
                  final shouldChange =
                      await navigator.pushNamed(Routes.chat) as bool?;
                  if (shouldChange != null && shouldChange) {
                    _shouldFetchOnReturn = true;
                  }
                },
                color: secondaryColor,
              ),
              const SizedBox(height: 8),
              ScreenWidthButton(
                label: 'Configurações da Conta',
                onPressed: () {
                  Provider.of<AuthProvider>(context, listen: false).fetchUserInfo();
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
