import 'package:bizfns/core/utils/colour_constants.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class EasyDropDown extends StatefulWidget {
  final List<String> items;
  final String? value;
  final Color? color;
  final bool needBorder;
  final Widget? hint;
  final void Function(String?)? onChanged;
  final bool? hideIcon;
  final String? type;
  final String? searchText;
  final FocusNode? focusNode;

  const EasyDropDown({
    super.key,
    required this.items,
    this.value,
    this.color,
    this.needBorder = true,
    this.onChanged,
    this.hint,
    this.hideIcon,
    this.type,
    this.searchText,
    this.focusNode,
  });

  @override
  State<EasyDropDown> createState() => _EasyDropDownState();
}

class _EasyDropDownState extends State<EasyDropDown> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DropdownButton2(
      hint: widget.hint,

      isExpanded: true,
      underline: const SizedBox(),
      buttonStyleData: ButtonStyleData(
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      dropdownStyleData: DropdownStyleData(
        elevation: 1,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
        ),
        maxHeight: 400,
      ),
      value: widget.value,
      items: widget.items
          .map(
            (e) => DropdownMenuItem(
              value: e,
              child: Text(
                e,
                style: Theme.of(context)
                    .textTheme!
                    .bodyLarge!
                    .copyWith(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    )
                    .copyWith(color: Colors.black, fontWeight: FontWeight.w600),
              ),
            ),
          )
          .toList(),
      dropdownSearchData: widget.items.length > 5
          ? DropdownSearchData(
              searchController: controller,
              searchInnerWidgetHeight: 50,
              searchInnerWidget: Container(
                height: 50,
                padding: const EdgeInsets.only(
                  top: 8,
                  bottom: 4,
                  right: 8,
                  left: 8,
                ),
                child: TextFormField(
                  expands: true,
                  maxLines: null,
                  controller: controller,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    hintText: widget.searchText ?? 'Search for an item...',
                    hintStyle: const TextStyle(fontSize: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              searchMatchFn: (item, searchValue) {
                return item.value
                    .toString()
                    .capitalizeFirst!
                    .contains(searchValue.capitalizeFirst!.trim());
              },
            )
          : null,
      onChanged: (val) {
        widget.onChanged!((val ?? "") as String?);
      },
    );
  }
}
