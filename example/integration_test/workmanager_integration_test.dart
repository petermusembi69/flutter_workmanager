import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:workmanager/workmanager.dart';

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    return true;
  });
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('initialize & schedule task - android',
      (WidgetTester tester) async {
    final wm = Workmanager();
    await wm.initialize(callbackDispatcher);
    await wm.registerOneOffTask('taskId', 'taskName');
  }, skip: !Platform.isAndroid);

  testWidgets('initialize & schedule task - iOS', (WidgetTester tester) async {
    final wm = Workmanager();
    await wm.initialize(callbackDispatcher);
    try {
      await wm.registerOneOffTask('taskId', 'taskName');
    } on PlatformException catch (e) {
      if (e.code !=
          'bgTaskSchedulingFailed(Error Domain=BGTaskSchedulerErrorDomain Code=1 "(null)") error') {
        rethrow;
      }
    }
  }, skip: !Platform.isIOS);
}
