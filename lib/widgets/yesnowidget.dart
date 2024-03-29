import 'package:characrea/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/AttendProvider.dart';

class YesNoSelection extends StatelessWidget {
  const YesNoSelection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<AttendProvider>().setAttendProvider();
    AttendProvider applicationFunctionState = context.read<AttendProvider>();
    AttendProvider applicationVariableState = context.watch<AttendProvider>();
    Attending attending = applicationVariableState.attending;

    switch (attending) {
      case Attending.yes:
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(elevation: 0),
                onPressed: () => applicationFunctionState.attending = Attending.yes,
                child: const Text('YES'),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: () => applicationFunctionState.attending = Attending.no,
                child: const Text('NO'),
              ),
            ],
          ),
        );
      case Attending.no:
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              TextButton(
                onPressed: () => applicationFunctionState.attending = Attending.yes,
                child: const Text('YES'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(elevation: 0),
                onPressed: () => applicationFunctionState.attending = Attending.no,
                child: const Text('NO'),
              ),
            ],
          ),
        );
      default:
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              StyledButton(
                onPressed: () => applicationFunctionState.attending = Attending.yes,
                child: const Text('YES'),
              ),
              const SizedBox(width: 8),
              StyledButton(
                onPressed: () => applicationFunctionState.attending = Attending.no,
                child: const Text('NO'),
              ),
            ],
          ),
        );
    }
  }
}
