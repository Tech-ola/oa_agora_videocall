import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:oa_agora_video/oa_agora_video.dart';

void main() {
  group('VideoPackage', () {
    testWidgets('Widget Test', (WidgetTester tester) async {
      // Build the VideoPackage widget and trigger frame rendering
      await tester.pumpWidget(VideoPackage());

      // Verify that the VideoPackage widget renders successfully
      expect(find.byType(VideoPackage), findsOneWidget);
    });

    testWidgets('Mute Audio Test', (WidgetTester tester) async {
      // Build the VideoPackage widget
      await tester.pumpWidget(VideoPackage());

      // Tap the audio mute button
      await tester.tap(find.byIcon(Icons.mic));
      await tester.pump();

      // Verify that the audio mute button toggles its state
      expect(find.byIcon(Icons.mic_off), findsOneWidget);
    });

    testWidgets('Mute Video Test', (WidgetTester tester) async {
      // Build the VideoPackage widget
      await tester.pumpWidget(VideoPackage());

      // Tap the video mute button
      await tester.tap(find.byIcon(Icons.pause));
      await tester.pump();

      // Verify that the video mute button toggles its state
      expect(find.byIcon(Icons.play_arrow), findsOneWidget);
    });

    testWidgets('View Participants Test', (WidgetTester tester) async {
      // Build the VideoPackage widget
      await tester.pumpWidget(VideoPackage());

      // Tap the "View Participants" button
      await tester.tap(find.byIcon(Icons.person));
      await tester.pump();

      // Verify that the functionality related to viewing participants is triggered
      // You can add more specific expectations based on the expected behavior
    });

    testWidgets('Add Participant Test', (WidgetTester tester) async {
      // Build the VideoPackage widget
      await tester.pumpWidget(VideoPackage());

      // Tap the "Add Participant" button
      await tester.tap(find.byIcon(Icons.add_box));
      await tester.pump();

      // Verify that the functionality related to adding participants is triggered
      // You can add more specific expectations based on the expected behavior
    });
  });
}
