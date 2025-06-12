import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:histocr_app/components/loading_indicator.dart';
import 'package:histocr_app/components/occupation_dropdown.dart';
import 'package:histocr_app/components/scaffold_with_return_button.dart';
import 'package:histocr_app/models/occupation.dart';
import 'package:histocr_app/models/user_info.dart';
import 'package:histocr_app/providers/auth_provider.dart';
import 'package:histocr_app/theme/app_colors.dart';
import 'package:histocr_app/utils/routes.dart';
import 'package:provider/provider.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = Provider.of<AuthProvider>(context, listen: false);
      if (!mounted) return;
      await provider.fetchUserInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthProvider>(context);
    final UserInfo? userInfo = provider.userInfo;

    return ScaffoldWithReturnButton(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _buildUserInfoWithFallback(userInfo, provider),
        ),
      ),
    );
  }

  List<Widget> _buildUserInfoWithFallback(
      UserInfo? userInfo, AuthProvider provider) {
    return [
      Text(
        'Informações da Conta',
        style: GoogleFonts.inter(
          fontSize: 24,
          fontWeight: FontWeight.w800,
        ),
      ),
      const SizedBox(height: 24),
      if (userInfo == null)
        const Center(
          child: Text(
            'Não foi possível recuperar as informações do usuário, por favor tente mais tarde.',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        )
      else
        Expanded(
          child: Column(
            children: [
              _buildUserInfo(
                name: userInfo.name,
                occupationText: userInfo.jobName,
                onEditOccupation: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => _buildAddOccupationDialog(provider),
                  );
                },
                hasOccupation: userInfo.job != null,
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    final navigator = Navigator.of(context);
                    final scaffoldMessenger = ScaffoldMessenger.of(context);
                    provider.logout().then((success) {
                    if (success) {
                      navigator.pushReplacementNamed(Routes.login);
                    } else {
                      scaffoldMessenger.showSnackBar(
                        const SnackBar(
                          content: Text('Erro ao sair.'),
                        ),
                      );
                    }
                  });
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: accentColor,
                  ),
                  child: provider.loading
                      ? const LoadingIndicator()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Sair',
                              style: GoogleFonts.inter(
                                color: white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.logout_rounded,
                              color: white,
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
    ];
  }

  Widget _buildUserInfo({
    required String name,
    required String occupationText,
    required Function() onEditOccupation,
    required bool hasOccupation,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nome',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(name),
        const SizedBox(height: 16),
        Text(
          'Profissão',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Text(occupationText),
            ),
            Visibility(
              visible: !hasOccupation,
              child: IconButton(
                onPressed: () => onEditOccupation.call(),
                icon: const Icon(Icons.add_circle_outline_rounded),
              ),
            )
          ],
        )
      ],
    );
  }

  Widget _buildAddOccupationDialog(AuthProvider provider) {
    final TextEditingController otherOccupationController =
        TextEditingController();

    return FutureBuilder<List<Occupation>>(
      future: provider.fetchOccupations(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const AlertDialog(
            content: SizedBox(
              height: 80,
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }
        final occupations = snapshot.data!;
        Occupation? selectedOccupation;

        return AlertDialog(
          contentPadding: const EdgeInsets.only(
            bottom: 8,
            top: 20,
            left: 16,
            right: 16,
          ),
          actionsPadding: const EdgeInsets.only(
            bottom: 20,
            top: 8,
            left: 16,
            right: 16,
          ),
          content: StatefulBuilder(builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                OccupationDropdown(
                  occupations: occupations,
                  onChanged: (value) => setState(() {
                    selectedOccupation = value;
                  }),
                ),
                const SizedBox(height: 8),
                if (selectedOccupation?.name == "Outro")
                  TextField(
                    decoration: const InputDecoration(
                      hintText: "Escreva sua profissão",
                    ),
                    controller: otherOccupationController,
                  ),
              ],
            );
          }),
          actions: [
            FilledButton(
              onPressed: () {
                if (selectedOccupation == null) {
                  return;
                }
                final navigator = Navigator.of(context);
                final scaffoldMessenger = ScaffoldMessenger.of(context);
                provider
                    .updateJob(
                  selectedOccupation!,
                  otherOccupation: otherOccupationController.text,
                )
                    .then((success) {
                  if (success) {
                    provider.userInfo?.job = selectedOccupation;
                    provider.userInfo?.customJobName =
                        otherOccupationController.text;
                    navigator.pop();
                  } else {
                    scaffoldMessenger.showSnackBar(
                      const SnackBar(
                        content: Text('Erro ao atualizar ocupação.'),
                      ),
                    );
                  }
                });
              },
              style: FilledButton.styleFrom(backgroundColor: secondaryColor),
              child: provider.loading
                  ? const LoadingIndicator()
                  : Text(
                      "Salvar",
                      style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                    ),
            ),
          ],
        );
      },
    );
  }
}
