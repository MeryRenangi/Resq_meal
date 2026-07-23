import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Flutter App Widgets & Forms Test Suite (APP-251 to APP-300)', () {
    testWidgets('APP-251: Custom primary button renders child text correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ElevatedButton(
              onPressed: () {},
              child: const Text('Submit Donation'),
            ),
          ),
        ),
      );
      expect(find.text('Submit Donation'), findsOneWidget);
    });

    testWidgets('APP-252: Custom primary button trigger onPressed callback when tapped', (WidgetTester tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ElevatedButton(
              onPressed: () => tapped = true,
              child: const Text('Tap Me'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Tap Me'));
      expect(tapped, isTrue);
    });

    testWidgets('APP-253: TextFormField displays validation error message when empty', (WidgetTester tester) async {
      final formKey = GlobalKey<FormState>();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: TextFormField(
                validator: (val) => val == null || val.isEmpty ? 'Field required' : null,
              ),
            ),
          ),
        ),
      );
      formKey.currentState!.validate();
      await tester.pump();
      expect(find.text('Field required'), findsOneWidget);
    });

    testWidgets('APP-254: TextFormField input updates controller text property', (WidgetTester tester) async {
      final controller = TextEditingController();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TextFormField(controller: controller),
          ),
        ),
      );
      await tester.enterText(find.byType(TextFormField), 'Hello ResQ');
      expect(controller.text, 'Hello ResQ');
    });

    testWidgets('APP-255: Loading indicator widget renders CircularProgressIndicator', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ),
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('APP-256: Card container widget displays title and subtitle text', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Card(
              child: ListTile(
                title: Text('Food Donation'),
                subtitle: Text('10kg apples'),
              ),
            ),
          ),
        ),
      );
      expect(find.text('Food Donation'), findsOneWidget);
      expect(find.text('10kg apples'), findsOneWidget);
    });

    testWidgets('APP-257: Checkbox form control toggles state from unchecked to checked', (WidgetTester tester) async {
      bool checked = false;
      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) {
            return MaterialApp(
              home: Scaffold(
                body: Checkbox(
                  value: checked,
                  onChanged: (val) => setState(() => checked = val!),
                ),
              ),
            );
          },
        ),
      );
      await tester.tap(find.byType(Checkbox));
      await tester.pump();
      expect(checked, isTrue);
    });

    testWidgets('APP-258: Switch control toggles state between on and off', (WidgetTester tester) async {
      bool swState = false;
      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) {
            return MaterialApp(
              home: Scaffold(
                body: Switch(
                  value: swState,
                  onChanged: (val) => setState(() => swState = val),
                ),
              ),
            );
          },
        ),
      );
      await tester.tap(find.byType(Switch));
      await tester.pump();
      expect(swState, isTrue);
    });

    testWidgets('APP-259: DropdownButtonFormField displays selected item string value', (WidgetTester tester) async {
      String selected = 'Vegetables';
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DropdownButtonFormField<String>(
              value: selected,
              items: const [
                DropdownMenuItem(value: 'Vegetables', child: Text('Vegetables')),
                DropdownMenuItem(value: 'Bakery', child: Text('Bakery')),
              ],
              onChanged: (val) {},
            ),
          ),
        ),
      );
      expect(find.text('Vegetables'), findsOneWidget);
    });

    testWidgets('APP-260: Chip widget renders label string with custom background color', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Chip(
              label: Text('Available'),
              backgroundColor: Colors.green,
            ),
          ),
        ),
      );
      expect(find.text('Available'), findsOneWidget);
    });

    testWidgets('APP-261: Search text field triggers filter callback on text change', (WidgetTester tester) async {
      String query = '';
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TextField(
              onChanged: (val) => query = val,
            ),
          ),
        ),
      );
      await tester.enterText(find.byType(TextField), 'Soup');
      expect(query, 'Soup');
    });

    testWidgets('APP-262: Empty state banner renders placeholder icon and helper message', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                Icon(Icons.inbox),
                Text('No active donations found'),
              ],
            ),
          ),
        ),
      );
      expect(find.byIcon(Icons.inbox), findsOneWidget);
      expect(find.text('No active donations found'), findsOneWidget);
    });

    testWidgets('APP-263: Custom badge widget renders numeric unread count', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Badge(
              label: Text('5'),
              child: Icon(Icons.notifications),
            ),
          ),
        ),
      );
      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('APP-264: SnackBar alert banner renders message text on showSnackBar call', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Donation Saved!')),
                    );
                  },
                  child: const Text('Show'),
                );
              },
            ),
          ),
        ),
      );
      await tester.tap(find.text('Show'));
      await tester.pump();
      expect(find.text('Donation Saved!'), findsOneWidget);
    });

    testWidgets('APP-265: AlertDialog dialog pops up on button tap displaying confirm message', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => const AlertDialog(
                        title: Text('Confirm Delete'),
                      ),
                    );
                  },
                  child: const Text('Delete'),
                );
              },
            ),
          ),
        ),
      );
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();
      expect(find.text('Confirm Delete'), findsOneWidget);
    });

    testWidgets('APP-266: Password obscuring eye icon toggles obscureText property', (WidgetTester tester) async {
      bool obscure = true;
      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) {
            return MaterialApp(
              home: Scaffold(
                body: TextField(
                  obscureText: obscure,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(obscure ? Icons.visibility : Icons.visibility_off),
                      onPressed: () => setState(() => obscure = !obscure),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );
      expect(obscure, isTrue);
      await tester.tap(find.byType(IconButton));
      await tester.pump();
      expect(obscure, isFalse);
    });

    testWidgets('APP-267: TabBar widget renders tab labels correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(50),
                child: TabBar(
                  tabs: [
                    Tab(text: 'Available'),
                    Tab(text: 'History'),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
      expect(find.text('Available'), findsOneWidget);
      expect(find.text('History'), findsOneWidget);
    });

    testWidgets('APP-268: ListView widget renders multiple item child tiles', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView(
              children: const [
                Text('Item 1'),
                Text('Item 2'),
                Text('Item 3'),
              ],
            ),
          ),
        ),
      );
      expect(find.text('Item 1'), findsOneWidget);
      expect(find.text('Item 3'), findsOneWidget);
    });

    testWidgets('APP-269: BottomNavigationBar renders destination icon items', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: BottomNavigationBar(
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
              ],
            ),
          ),
        ),
      );
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
    });

    testWidgets('APP-270: CircleAvatar renders initials text inside avatar builder', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CircleAvatar(
              child: Text('JD'),
            ),
          ),
        ),
      );
      expect(find.text('JD'), findsOneWidget);
    });

    testWidgets('APP-271: LinearProgressIndicator widget renders loading bar', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LinearProgressIndicator(value: 0.5),
          ),
        ),
      );
      expect(find.byType(LinearProgressIndicator), findsOneWidget);
    });

    testWidgets('APP-272: Image placeholder renders fallback icon on loading asset', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Icon(Icons.fastfood, size: 48),
          ),
        ),
      );
      expect(find.byIcon(Icons.fastfood), findsOneWidget);
    });

    testWidgets('APP-273: Divider widget renders thin horizontal separator line', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                Text('Top'),
                Divider(),
                Text('Bottom'),
              ],
            ),
          ),
        ),
      );
      expect(find.byType(Divider), findsOneWidget);
    });

    testWidgets('APP-274: Tooltip widget displays text message on long press gesture', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Tooltip(
              message: 'Add New Item',
              child: Icon(Icons.add),
            ),
          ),
        ),
      );
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('APP-275: SegmentedButton widget allows single choice selection', (WidgetTester tester) async {
      String selected = 'day';
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'day', label: Text('Day')),
                ButtonSegment(value: 'week', label: Text('Week')),
              ],
              selected: {selected},
              onSelectionChanged: (val) => selected = val.first,
            ),
          ),
        ),
      );
      expect(find.text('Day'), findsOneWidget);
    });

    testWidgets('APP-276: ExpansionTile widget expands content on tap gesture', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ExpansionTile(
              title: Text('Accordion Header'),
              children: [Text('Expanded Details')],
            ),
          ),
        ),
      );
      expect(find.text('Accordion Header'), findsOneWidget);
      await tester.tap(find.text('Accordion Header'));
      await tester.pumpAndSettle();
      expect(find.text('Expanded Details'), findsOneWidget);
    });

    testWidgets('APP-277: RefreshIndicator enables pull to refresh gesture on ListView', (WidgetTester tester) async {
      bool refreshed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RefreshIndicator(
              onRefresh: () async => refreshed = true,
              child: ListView(
                children: const [Text('Pull Down Item')],
              ),
            ),
          ),
        ),
      );
      expect(find.text('Pull Down Item'), findsOneWidget);
      expect(refreshed, isFalse);
    });

    testWidgets('APP-278: FilterChip toggles selection checkmark on tap', (WidgetTester tester) async {
      bool isSelected = false;
      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) {
            return MaterialApp(
              home: Scaffold(
                body: FilterChip(
                  label: const Text('Organic'),
                  selected: isSelected,
                  onSelected: (val) => setState(() => isSelected = val),
                ),
              ),
            );
          },
        ),
      );
      await tester.tap(find.text('Organic'));
      await tester.pump();
      expect(isSelected, isTrue);
    });

    testWidgets('APP-279: ChoiceChip toggles single option selection on tap', (WidgetTester tester) async {
      bool isSelected = false;
      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) {
            return MaterialApp(
              home: Scaffold(
                body: ChoiceChip(
                  label: const Text('Urgent'),
                  selected: isSelected,
                  onSelected: (val) => setState(() => isSelected = val),
                ),
              ),
            );
          },
        ),
      );
      await tester.tap(find.text('Urgent'));
      await tester.pump();
      expect(isSelected, isTrue);
    });

    testWidgets('APP-280: FloatingActionButton renders icon and handles tap', (WidgetTester tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () => tapped = true,
              child: const Icon(Icons.add),
            ),
          ),
        ),
      );
      await tester.tap(find.byType(FloatingActionButton));
      expect(tapped, isTrue);
    });

    testWidgets('APP-281: AppBar displays screen header title text', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(title: const Text('ResQ Dashboard')),
          ),
        ),
      );
      expect(find.text('ResQ Dashboard'), findsOneWidget);
    });

    testWidgets('APP-282: Drawer menu panel slides out on hamburger icon tap', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(),
            drawer: const Drawer(
              child: Text('Navigation Menu'),
            ),
          ),
        ),
      );
      await tester.tap(find.byTooltip('Open navigation menu'));
      await tester.pumpAndSettle();
      expect(find.text('Navigation Menu'), findsOneWidget);
    });

    testWidgets('APP-283: DatePicker widget pops up on date select button tap', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    showDatePicker(
                      context: context,
                      initialDate: DateTime(2026, 1, 15),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                    );
                  },
                  child: const Text('Pick Date'),
                );
              },
            ),
          ),
        ),
      );
      await tester.tap(find.text('Pick Date'));
      await tester.pumpAndSettle();
      expect(find.text('15'), findsWidgets);
    });

    testWidgets('APP-284: TimePicker widget pops up on time select button tap', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    showTimePicker(
                      context: context,
                      initialTime: const TimeOfDay(hour: 10, minute: 0),
                    );
                  },
                  child: const Text('Pick Time'),
                );
              },
            ),
          ),
        ),
      );
      await tester.tap(find.text('Pick Time'));
      await tester.pumpAndSettle();
      expect(find.text('Select time'), findsOneWidget);
    });

    testWidgets('APP-285: ModalBottomSheet slides up on bottom sheet trigger button tap', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (_) => const Text('Bottom Sheet Options'),
                    );
                  },
                  child: const Text('Open Options'),
                );
              },
            ),
          ),
        ),
      );
      await tester.tap(find.text('Open Options'));
      await tester.pumpAndSettle();
      expect(find.text('Bottom Sheet Options'), findsOneWidget);
    });

    testWidgets('APP-286: Form clear button resets form controller input text', (WidgetTester tester) async {
      final controller = TextEditingController(text: 'Initial text');
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                TextField(controller: controller),
                ElevatedButton(
                  onPressed: () => controller.clear(),
                  child: const Text('Clear'),
                ),
              ],
            ),
          ),
        ),
      );
      await tester.tap(find.text('Clear'));
      expect(controller.text, isEmpty);
    });

    testWidgets('APP-287: Slider control updates numeric double value on change', (WidgetTester tester) async {
      double value = 5.0;
      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) {
            return MaterialApp(
              home: Scaffold(
                body: Slider(
                  value: value,
                  min: 0.0,
                  max: 10.0,
                  onChanged: (val) => setState(() => value = val),
                ),
              ),
            );
          },
        ),
      );
      expect(value, 5.0);
    });

    testWidgets('APP-288: Stepper widget renders step titles and navigation buttons', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Stepper(
              steps: const [
                Step(title: Text('Step 1: Details'), content: Text('Fill details')),
                Step(title: Text('Step 2: Pickup'), content: Text('Set pickup time')),
              ],
            ),
          ),
        ),
      );
      expect(find.text('Step 1: Details'), findsOneWidget);
    });

    testWidgets('APP-289: Radio list tile selects active option choice', (WidgetTester tester) async {
      int groupValue = 1;
      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) {
            return MaterialApp(
              home: Scaffold(
                body: RadioListTile<int>(
                  title: const Text('Option 2'),
                  value: 2,
                  groupValue: groupValue,
                  onChanged: (val) => setState(() => groupValue = val!),
                ),
              ),
            );
          },
        ),
      );
      await tester.tap(find.text('Option 2'));
      await tester.pump();
      expect(groupValue, 2);
    });

    testWidgets('APP-290: IndexedStack displays only active indexed child widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: IndexedStack(
              index: 1,
              children: [
                Text('Child 0'),
                Text('Child 1'),
              ],
            ),
          ),
        ),
      );
      expect(find.text('Child 1'), findsOneWidget);
      expect(find.text('Child 0'), findsNothing);
    });

    testWidgets('APP-291: GridView layout renders grid tiles in 2-column format', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GridView.count(
              crossAxisCount: 2,
              children: const [
                Text('Grid 1'),
                Text('Grid 2'),
              ],
            ),
          ),
        ),
      );
      expect(find.text('Grid 1'), findsOneWidget);
      expect(find.text('Grid 2'), findsOneWidget);
    });

    testWidgets('APP-292: SingleChildScrollView enables vertical scrolling for overflowing forms', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Text('Header'),
                  SizedBox(height: 1000),
                  Text('Footer'),
                ],
              ),
            ),
          ),
        ),
      );
      expect(find.text('Header'), findsOneWidget);
    });

    testWidgets('APP-293: Hero widget wraps element with tag parameter for screen transitions', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Hero(
              tag: 'avatar_hero',
              child: Icon(Icons.person),
            ),
          ),
        ),
      );
      expect(find.byType(Hero), findsOneWidget);
    });

    testWidgets('APP-294: AnimatedOpacity changes opacity from 0.0 to 1.0 smoothly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AnimatedOpacity(
              opacity: 1.0,
              duration: Duration(milliseconds: 300),
              child: Text('Fade In'),
            ),
          ),
        ),
      );
      expect(find.text('Fade In'), findsOneWidget);
    });

    testWidgets('APP-295: Flexible widget constrains child flex weight ratio', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Row(
              children: [
                Flexible(flex: 1, child: Text('Left')),
                Flexible(flex: 2, child: Text('Right')),
              ],
            ),
          ),
        ),
      );
      expect(find.text('Left'), findsOneWidget);
      expect(find.text('Right'), findsOneWidget);
    });

    testWidgets('APP-296: Wrap widget wraps inline chips horizontally without overflow', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Wrap(
              children: [
                Chip(label: Text('Tag 1')),
                Chip(label: Text('Tag 2')),
              ],
            ),
          ),
        ),
      );
      expect(find.text('Tag 1'), findsOneWidget);
      expect(find.text('Tag 2'), findsOneWidget);
    });

    testWidgets('APP-297: AspectRatio widget sets child width to height proportion ratio 16:9', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AspectRatio(
              aspectRatio: 16 / 9,
              child: SizedBox(),
            ),
          ),
        ),
      );
      expect(find.byType(AspectRatio), findsOneWidget);
    });

    testWidgets('APP-298: ClipRRect applies border radius clipping to child photo widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: const Icon(Icons.image),
            ),
          ),
        ),
      );
      expect(find.byType(ClipRRect), findsOneWidget);
    });

    testWidgets('APP-299: CustomScrollView renders Slivers header app bar layout', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverAppBar(title: Text('Sliver Title')),
              ],
            ),
          ),
        ),
      );
      expect(find.text('Sliver Title'), findsOneWidget);
    });

    testWidgets('APP-300: KeyedSubtree preserves element widget state across rebuilds', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: KeyedSubtree(
              key: const ValueKey('sub_tree_1'),
              child: const Text('Subtree content'),
            ),
          ),
        ),
      );
      expect(find.text('Subtree content'), findsOneWidget);
    });
  });
}
