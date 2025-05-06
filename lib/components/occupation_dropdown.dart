import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:histocr_app/theme/app_colors.dart';

class OccupationDropdown extends StatefulWidget {
  final ValueChanged<String?>? onChanged;
  const OccupationDropdown({super.key, this.onChanged});

  @override
  State<OccupationDropdown> createState() => _OccupationDropdownState();
}

class _OccupationDropdownState extends State<OccupationDropdown> {
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    final dropdownItems = [
      'Arquivista',
      'Bibliotecário(a)',
      'Historiador(a)',
      'Museólogo(a)',
      'Outro',
    ];

    List<DropdownMenuItem<String>> addDividersAfterItems(List<String> items) {
      final List<DropdownMenuItem<String>> menuItems = [];
      for (final String item in items) {
        menuItems.addAll(
          [
            DropdownMenuItem<String>(
              value: item,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(item),
              ),
            ),
            //If it's last item, we will not add Divider after it.
            if (item != items.last)
              const DropdownMenuItem<String>(
                enabled: false,
                child: Divider(
                  color: Color(0x80606060),
                ),
              ),
          ],
        );
      }
      return menuItems;
    }

    List<double> getCustomItemsHeights() {
      final List<double> itemsHeights = [];
      for (int i = 0; i < (dropdownItems.length * 2) - 1; i++) {
        if (i.isEven) {
          itemsHeights.add(48);
        }
        //Dividers indexes will be the odd indexes
        if (i.isOdd) {
          itemsHeights.add(4);
        }
      }
      return itemsHeights;
    }

    return DropdownButton2<String>(
      buttonStyleData: ButtonStyleData(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: white,
        ),
      ),
      underline: const SizedBox.shrink(),
      iconStyleData: const IconStyleData(
        icon: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Icon(Icons.keyboard_arrow_down),
        ),
        iconSize: 24,
        iconEnabledColor: textColor,
        openMenuIcon: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Icon(Icons.keyboard_arrow_up),
        ),
      ),
      dropdownStyleData: DropdownStyleData(
        offset: const Offset(0, -2),
        padding: const EdgeInsets.all(0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: white,
        ),
        elevation: 0,
      ),
      menuItemStyleData: MenuItemStyleData(
        padding: const EdgeInsets.all(0),
        customHeights: getCustomItemsHeights(),
      ),
      hint: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Text(
          'Qual é a sua profissão?',
          style: TextStyle(
            fontSize: 16,
            color: textColor.withOpacity(0.5),
          ),
        ),
      ),
      items: addDividersAfterItems(dropdownItems),
      value: selectedValue,
      onChanged: (value) {
        setState(() {
          selectedValue = value;
        });
        if (widget.onChanged != null) {
          widget.onChanged!(value);
        }
      },
    );
  }
}
