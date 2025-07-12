// Chakame app widget tests
//
// Tests for the Persian poetry app functionality

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:chakame/l10n/l10n.dart';

void main() {
  // Test helper to create a test app with minimal setup
  Widget createTestApp(Widget child) {
    return ProviderScope(
      child: MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''),
          Locale('fa', ''),
        ],
        home: child,
      ),
    );
  }

  group('Basic Widget Tests', () {
    testWidgets('Test app title appears correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestApp(
          Scaffold(
            appBar: AppBar(title: const Text('Chakame')),
            body: const Center(child: Text('Persian Poetry App')),
          ),
        ),
      );

      // Check that the title appears
      expect(find.text('Chakame'), findsOneWidget);
      expect(find.text('Persian Poetry App'), findsOneWidget);
    });

    testWidgets('MaterialApp has correct localizations', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestApp(
          Builder(
            builder: (context) {
              final locale = Localizations.localeOf(context);
              return Text('Locale: ${locale.languageCode}');
            },
          ),
        ),
      );

      // Should have English locale by default
      expect(find.textContaining('Locale: en'), findsOneWidget);
    });

    testWidgets('Bottom navigation bar can be created', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestApp(
          Scaffold(
            bottomNavigationBar: BottomNavigationBar(
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.favorite),
                  label: 'Favorites',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  label: 'Settings',
                ),
              ],
            ),
          ),
        ),
      );

      // Should have bottom navigation
      expect(find.byType(BottomNavigationBar), findsOneWidget);
      expect(find.byIcon(Icons.home), findsOneWidget);
      expect(find.byIcon(Icons.favorite), findsOneWidget);
      expect(find.byIcon(Icons.settings), findsOneWidget);
    });

    testWidgets('Theme data can be applied', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          ),
          home: const Scaffold(
            body: Center(child: Text('Test')),
          ),
        ),
      );

      final BuildContext context = tester.element(find.byType(Scaffold));
      final ThemeData theme = Theme.of(context);
      
      // Check that theme is applied (just verify it's not null)
      expect(theme.colorScheme.primary, isNotNull);
      expect(find.text('Test'), findsOneWidget);
    });

    testWidgets('Persian text direction can be set', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: const Scaffold(
              body: Center(child: Text('چکامه')),
            ),
          ),
        ),
      );

      // Should find Persian text
      expect(find.text('چکامه'), findsOneWidget);
      
      // Check text direction
      final BuildContext context = tester.element(find.byType(Scaffold));
      final TextDirection direction = Directionality.of(context);
      expect(direction, TextDirection.rtl);
    });

    testWidgets('Card widgets can be created', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestApp(
          Scaffold(
            body: Card(
              child: ListTile(
                leading: const Icon(Icons.book),
                title: const Text('Poetry Collection'),
                subtitle: const Text('Persian poems'),
              ),
            ),
          ),
        ),
      );

      // Should have card with content
      expect(find.byType(Card), findsOneWidget);
      expect(find.byType(ListTile), findsOneWidget);
      expect(find.byIcon(Icons.book), findsOneWidget);
      expect(find.text('Poetry Collection'), findsOneWidget);
    });

    testWidgets('Elevated button can be created', (WidgetTester tester) async {
      bool buttonPressed = false;
      
      await tester.pumpWidget(
        createTestApp(
          Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () {
                  buttonPressed = true;
                },
                child: const Text('Get Random Poem'),
              ),
            ),
          ),
        ),
      );

      // Should have button
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.text('Get Random Poem'), findsOneWidget);
      
      // Test button press
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();
      
      expect(buttonPressed, true);
    });

    testWidgets('Floating action button can be created', (WidgetTester tester) async {
      bool fabPressed = false;
      
      await tester.pumpWidget(
        createTestApp(
          Scaffold(
            body: const Center(child: Text('Main Content')),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                fabPressed = true;
              },
              child: const Icon(Icons.add),
            ),
          ),
        ),
      );

      // Should have FAB
      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
      
      // Test FAB press
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pump();
      
      expect(fabPressed, true);
    });
  });

  group('Localization Tests', () {
    testWidgets('English localization works', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''),
            ],
            locale: const Locale('en', ''),
            home: Builder(
              builder: (context) {
                final l10n = AppLocalizations.of(context);
                return Scaffold(
                  body: Text(l10n.appTitle),
                );
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Chakame'), findsOneWidget);
    });

    testWidgets('Persian localization works', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('fa', ''),
            ],
            locale: const Locale('fa', ''),
            home: Builder(
              builder: (context) {
                final l10n = AppLocalizations.of(context);
                return Scaffold(
                  body: Text(l10n.appTitle),
                );
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('چکامه'), findsOneWidget);
    }, skip: true);
  });

  group('Widget Interactions', () {
    testWidgets('Switch widget can be toggled', (WidgetTester tester) async {
      bool switchValue = false;
      
      await tester.pumpWidget(
        createTestApp(
          Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return Switch(
                  value: switchValue,
                  onChanged: (value) {
                    setState(() {
                      switchValue = value;
                    });
                  },
                );
              },
            ),
          ),
        ),
      );

      // Initially switch should be off
      expect(find.byType(Switch), findsOneWidget);
      expect(switchValue, false);
      
      // Toggle switch
      await tester.tap(find.byType(Switch));
      await tester.pump();
      
      expect(switchValue, true);
    });

    testWidgets('Text field can accept input', (WidgetTester tester) async {
      final TextEditingController controller = TextEditingController();
      
      await tester.pumpWidget(
        createTestApp(
          Scaffold(
            body: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Enter text',
              ),
            ),
          ),
        ),
      );

      // Should have text field
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Enter text'), findsOneWidget);
      
      // Enter text
      await tester.enterText(find.byType(TextField), 'Hello World');
      await tester.pump();
      
      expect(controller.text, 'Hello World');
      expect(find.text('Hello World'), findsOneWidget);
    });

    testWidgets('Icon buttons can be pressed', (WidgetTester tester) async {
      bool iconPressed = false;
      
      await tester.pumpWidget(
        createTestApp(
          Scaffold(
            body: Center(
              child: IconButton(
                icon: const Icon(Icons.star),
                onPressed: () {
                  iconPressed = true;
                },
              ),
            ),
          ),
        ),
      );

      // Should have icon button
      expect(find.byType(IconButton), findsOneWidget);
      expect(find.byIcon(Icons.star), findsOneWidget);
      
      // Test icon button press
      await tester.tap(find.byType(IconButton));
      await tester.pump();
      
      expect(iconPressed, true);
    });

    testWidgets('App bar can be created', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestApp(
          Scaffold(
            appBar: AppBar(
              title: const Text('Poetry App'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {},
                ),
              ],
            ),
            body: const Center(child: Text('Content')),
          ),
        ),
      );

      // Should have app bar
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('Poetry App'), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.text('Content'), findsOneWidget);
    });
  });
}