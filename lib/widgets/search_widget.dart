// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:whisper/utils/colors.dart';

class SearchWidget extends StatelessWidget {
  late final String query;
  final TextEditingController searchbtn;
  final VoidCallback onChanged;

  SearchWidget(this.query, this.searchbtn, this.onChanged);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25),
      child: SizedBox(
        height: 40,
        child: TextField(
            cursorColor: Theme.of(context).scaffoldBackgroundColor == kdarkBG
                ? kwhite
                : kdark,
            onChanged: (val) {},
            controller: searchbtn,
            style: TextStyle(
                color: Theme.of(context).scaffoldBackgroundColor == kdarkBG
                    ? kwhite
                    : kdark,
                fontSize: 16,
                fontFamily: "Poppins"),
            decoration: InputDecoration(
              hintStyle: TextStyle(
                  fontSize: 12, color: kdarkGrey, fontFamily: 'Poppins'),
              hintText: "Search...",
              prefixIcon: Icon(Icons.search, color: kdarkGrey),
              suffixIcon: searchbtn.text.isNotEmpty
                  ? GestureDetector(
                      child: Icon(Icons.close, color: kred),
                      onTap: () {
                        searchbtn.clear();
                        query = '';
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                    )
                  : null,
              filled: true,
              border: InputBorder.none,
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  borderSide: BorderSide(
                    color: kwhite,
                  )),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  borderSide: BorderSide(color: kwhite)),
            )),
      ),
    );
  }
}
