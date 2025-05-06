import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:histocr_app/components/histocr_title.dart';
import 'package:histocr_app/components/screen_width_button.dart';
import 'package:histocr_app/theme/app_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);
    const itemCount = 4;
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const HistocrTitle(),
              const SizedBox(height: 32),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Últimas Transcrições:',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ListView.separated(
                        padding: const EdgeInsets.all(0),
                        shrinkWrap: true,
                        itemCount: 3,
                        itemBuilder: (context, _) => const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: LastTranscriptsItem(
                            imageUrl: 'imageUrl',
                            title: 'Decreto 127',
                            description:
                                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut vel nisi vitae est molestie vestibulum ac ac risus. Praesent tincidunt molestie urna, nec auctor dolor interdum ut.',
                          ),
                        ),
                        separatorBuilder: (BuildContext context, int _) =>
                            const Divider(
                          color: primaryColor,
                          height: 4,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (itemCount > 3)
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            'Ver mais',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: secondaryColorDark,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  ScreenWidthButton(
                    label: 'Iniciar Chat',
                    onPressed: () {},
                    color: secondaryColor,
                  ),
                  const SizedBox(height: 8),
                  ScreenWidthButton(
                    label: 'Configurações da Conta',
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LastTranscriptsItem extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;

  const LastTranscriptsItem(
      {super.key,
      required this.imageUrl,
      required this.title,
      required this.description});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 84,
          height: 84,
          color: Colors.grey.shade300,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
