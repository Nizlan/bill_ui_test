import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import 'circular_diagram.dart';

enum MoneyValue { income, spending }

List<String> sfSymbols = [
  'tshirt.fill',
  'airplane',
  'bell.fill',
  'book.closed.fill',
  'calendar',
  'camera.fill',
  'car.fill',
];

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  var items = generateRandomChartPieces(5);
  int categoriesAmount = 3;
  bool showSlider = false;
  MoneyValue selectedElement = MoneyValue.income;
  setCategoryAmount(int amount) {
    if (categoriesAmount == amount) return;
    categoriesAmount = amount;
    setState(() {
      items = generateRandomChartPieces(amount);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          top: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ColoredBox(
                color: const Color(0xFFF4F4F6),
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 16, right: 16, top: 12, bottom: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(
                              "assets/svg/calendar-month.svg",
                              color: Color(0xFF0A4FFF),
                              width: 20,
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            const Text(
                              "Mar 1 - Apr 13",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 15,
                                  height: 20 / 15,
                                  color: Color(0xFF0A4FFF)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          "Balance",
                          style: TextStyle(
                            fontSize: 14,
                            height: 16 / 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text("\$777",
                            style: TextStyle(
                              fontSize: 60,
                              height: 72 / 60,
                              fontWeight: FontWeight.w700,
                            )),
                        const SizedBox(height: 12),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IncomeWidget(
                              name: "Income",
                              value: "+\$1,233.82",
                              valueColor: Color(0xFF54C242),
                            ),
                            IncomeWidget(
                                name: "Spending",
                                value: "-\$315.22",
                                valueColor: Color(0xFFE20F00)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ConstrainedBox(
                constraints:
                    BoxConstraints(minWidth: MediaQuery.sizeOf(context).width),
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: CupertinoSlidingSegmentedControl<MoneyValue>(
                    onValueChanged: (value) {
                      if (value == null) return;
                      setState(() {
                        selectedElement = value;
                      });
                    },
                    groupValue: selectedElement,
                    children: const {
                      MoneyValue.spending: Text("Spending"),
                      MoneyValue.income: Text("Income"),
                    },
                  ),
                ),
              ),
              CircularDiagramWithWidgets(
                items: items,
                size: MediaQuery.sizeOf(context).width,
                horizontalPadding: 16,
                centralText: "-\$721.91",
              ),
              if (showSlider)
                Column(
                  children: [
                    Slider(
                      value: categoriesAmount.toDouble(),
                      onChanged: (newValue) =>
                          setCategoryAmount(newValue.toInt()),
                      min: 1,
                      max: 30,
                    ),
                    Text("Категорий: $categoriesAmount")
                  ],
                ),
              ...List.generate(
                10,
                (index) => ListElement(
                  name: "Clothing",
                  valuePercents: "37",
                  value: "\$315.22",
                  icon: "tshirt.fill.svg",
                  date: DateTime.now(),
                  category: "Shopping",
                  color: const Color(0xFFE20F00),
                ),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Switch(
                    value: showSlider,
                    onChanged: (value) {
                      setState(() {
                        showSlider = value;
                      });
                    }),
                Text("Показать слайдер"),
              ])
            ],
          ),
        ),
      ),
    );
  }
}

class IncomeWidget extends StatelessWidget {
  final String name;
  final String value;
  final Color valueColor;
  const IncomeWidget(
      {super.key,
      required this.name,
      required this.value,
      required this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(
              fontSize: 14,
              height: 16 / 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
                color: valueColor,
                fontSize: 20,
                height: 28 / 20,
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

class ListElement extends StatelessWidget {
  final String name;
  final String valuePercents;
  final String value;
  final String category;
  final String icon;
  final DateTime date;
  final Color color;
  const ListElement(
      {super.key,
      required this.name,
      required this.valuePercents,
      required this.value,
      required this.icon,
      required this.date,
      required this.category,
      required this.color});

  @override
  Widget build(BuildContext context) {
    const greyStyle = TextStyle(
        fontSize: 14,
        height: 16 / 14,
        fontWeight: FontWeight.w400,
        color: Color(0xFFA5AAB6));
    const horizontalPadding = 15.0;
    final width = MediaQuery.sizeOf(context).width;
    final widthWithoutPadding = width - (horizontalPadding * 2);
    return SizedBox(
      width: width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(
                      left: 4, top: 4, right: 8, bottom: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: color,
                  ),
                  height: 44,
                  width: 44,
                  child: Center(
                    child: SvgPicture.asset(
                      "assets/svg/$icon",
                      color: Colors.white,
                      width: 20,
                    ),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                name,
                                style: const TextStyle(
                                    fontSize: 14,
                                    height: 16 / 14,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              value,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  height: 16 / 14),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "$valuePercents%",
                              style: greyStyle,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              category,
                              style: greyStyle,
                            ),
                            const Spacer(),
                            Text("Last: ${DateFormat('d MMM').format(date)}",
                                style: greyStyle),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(
              height: 1,
              color: Color(0xFFF1F2F5),
              endIndent: 0,
              indent: 0,
            ),
          ],
        ),
      ),
    );
  }
}

List<ChartPiece> generateRandomChartPieces(int amount) {
  final random = Random();

  final List<ChartPiece> pieces = [];
  final randomPercents = divideIntoRandomParts(amount);

  for (int i = 0; i < amount; i++) {
    final color = Color.fromRGBO(
        random.nextInt(255), random.nextInt(255), random.nextInt(255), 1);
    pieces.add(ChartPiece(
      color: color,
      percent: randomPercents[i],
      icon: DiagramIcon(
        color: color,
        name: "tshirt.fill.svg",
      ),
    ));
  }
  return pieces;
}

List<double> divideIntoRandomParts(int parts) {
  if (parts == 0) return [];
  if (parts == 1) return [100.0];
  final Random random = Random();
  final List<double> randomValues =
      List.generate(parts, (_) => random.nextDouble());
  final double sum = randomValues.reduce((a, b) => a + b);
  final List<double> percentages =
      randomValues.map((value) => (value / sum) * 100).toList();

  // Для точного соответствия 100%, округлим последний элемент
  final double roundedSum =
      percentages.sublist(0, percentages.length - 1).reduce((a, b) => a + b);
  percentages[percentages.length - 1] = 100.0 - roundedSum;
  return percentages;
}
