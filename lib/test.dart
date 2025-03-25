//shadcn ui test

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:testform/na.dart';

class ShadCnTest extends StatefulWidget {
  const ShadCnTest({super.key});

  @override
  State<ShadCnTest> createState() => _ShadCnTestState();
}

class _ShadCnTestState extends State<ShadCnTest> {
  bool value = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Text(
            'Taxing Laughter: The Joke Tax Chronicles',
            style: ShadTheme.of(context).textTheme.blockquote,
          ),
          ShadButton.outline(
            child: const Text('Show Toast'),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => const Na()));
              ShadToaster.of(context).show(
                const ShadToast(
                  duration: Duration(milliseconds: 1000),
                  title: Text('Uh oh! Something went wrong'),
                  description: Text('There was a problem with your request'),
                ),
              );
            },
          ),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.sizeOf(context).width * 0.6,
            ),
            child: const ShadProgress(),
          ),
          ShadTooltip(
            builder: (context) => const Text('Add to library'),
            child: ShadButton.outline(
              child: const Text('Hover/Focus'),
              onPressed: () {},
            ),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: const ShadTimePicker(
              trailing: Padding(
                padding: EdgeInsets.only(left: 8, top: 14),
                child: Icon(LucideIcons.clock4),
              ),
            ),
          ),
          ShadSwitch(
            value: value,
            onChanged: (v) => setState(() => value = v),
            label: const Text('Airplane Mode'),
          ),
          ShadSlider(
            initialValue: 33,
            max: 100,
            onChanged: (value) {
              log(value.toString());
              if (value == 60) {
                setState(() {
                  const ShadToast(
                    duration: Duration(milliseconds: 1000),
                    title: Text('Uh oh! Something went wrong'),
                    description: Text('There was a problem with your request'),
                  );
                });
              }
            },
          ),
        ],
      ),
    );
  }
}
