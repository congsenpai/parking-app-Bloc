import 'package:flutter/material.dart';

import '../../../constants.dart';

class SearchField extends StatefulWidget {
  final String controllerText;
  final ValueChanged <String> ? onChanged;
  final ValueChanged<String>? onSearch; // Callback khi nhấn nút search
  const SearchField({
    Key? key, required this.controllerText, this.onChanged, this.onSearch,
  }) : super(key: key);

  @override
  State<SearchField> createState() => _SearchFieldState();

}

class _SearchFieldState extends State<SearchField> {
  late TextEditingController _textEditingController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _textEditingController = TextEditingController(text: widget.controllerText);
  }
  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }


  Widget build(BuildContext context) {
    return TextField(
      controller: _textEditingController,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        hintText: "Search",
        fillColor: secondaryColor,
        filled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        suffixIcon: InkWell(
          onTap: () {
            if (widget.onSearch != null) {
              widget.onSearch!(_textEditingController.text);
            }
          },
          child: Container(
              padding: EdgeInsets.all(defaultPadding * 0.75),
              margin: EdgeInsets.symmetric(horizontal: defaultPadding / 2),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: Icon(Icons.search)

          ),
        ),
      ),
    );
  }
}