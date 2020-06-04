import 'package:flutter/material.dart';

class CreateEntry extends StatefulWidget {
  static String id = 'create_entry_screen';
  @override
  _CreateEntryState createState() => _CreateEntryState();
}

class _CreateEntryState extends State<CreateEntry> {
  final _formKey = GlobalKey<FormState>();
  bool isSwitchedOn = false;
  //String selectedValue = 'A';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const Text(''),
          title: const Text('MyJournal'),
        ),
        body: SafeArea(
          child: Container(
            color: Colors.greenAccent,
            margin:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            child: Builder(
              builder: (context) => Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    TextFormField(),
                    SwitchListTile(
                      title: const Text('TEST'),
                      value: isSwitchedOn,
                      onChanged: (value) {
                        setState(() {
                          isSwitchedOn = value;
                        });
                      },
                    )
//                    DropdownButtonFormField(
//                      value: selectedValue,
//                      items: [
//                        DropdownMenuItem(
//                          value: 'A',
//                          onTap: () {},
//                        ),
//                        DropdownMenuItem(
//                          value: 'B',
//                          onTap: () {},
//                        ),
//                        DropdownMenuItem(
//                          value: 'C',
//                          onTap: () {},
//                        )
//                      ],
//                      onChanged: (value) {
//                        setState(() {
//                          selectedValue = value;
//                        });
//                      },
//                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
