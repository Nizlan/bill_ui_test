import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mrx_charts/mrx_charts.dart';
import 'package:sf_symbols/sf_symbols.dart';

class CircularDiagramWithWidgets extends StatelessWidget {
  final List<ChartPiece> items;
  final double size;
  final double horizontalPadding;
  final String centralText;
  const CircularDiagramWithWidgets(
      {super.key,
      required this.items,
      required this.size,
      required this.horizontalPadding,
      required this.centralText});

  @override
  Widget build(BuildContext context) {
    final sizeWithPadding = size - horizontalPadding * 2;
    double initialAngle = -90;

    return Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(
              maxWidth: sizeWithPadding, maxHeight: sizeWithPadding),
          child: Stack(
            fit: StackFit.loose,
            children: [
              Center(
                child: Chart(
                  duration: Duration.zero,
                  layers: layers(items, initialAngle),
                ),
              ),
              Center(
                child: Text(
                  centralText,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
              Center(
                child: CircularLayout(
                  radius: sizeWithPadding / 2 * .86,
                  angles: _addRads(items, initialAngle, 10),
                  children: items.map((e) => e.icon).toList(),
                ),
              ),
            ],
          ),
        ));
  }
}

List<double> _addRads(
    List<ChartPiece> pieces, double initialAngle, double gapSweepAngle) {
  final List<double> radians = [];
  double angle = initialAngle +
      gapSweepAngle / 2; // Стартовый угол сдвигается на половину зазора
  for (final piece in pieces) {
    double totalSweepAngle = 360 -
        gapSweepAngle *
            pieces.length; // Общий угол, доступный для всех секторов
    double pieceAngle = piece.percent *
        totalSweepAngle /
        100; // Угол для данного сектора, учитывая зазоры
    double pieceAngleForIcon =
        pieceAngle; // Полный угол для расчета позиции иконки
    double pieceRad =
        ((pieceAngleForIcon / 2) + angle) * pi / 180; // Расчет угла для иконки

    radians.add(pieceRad);
    angle +=
        pieceAngle + gapSweepAngle; // Угол обновляется на угол сектора и зазор
  }
  return radians;
}

List<ChartLayer> layers(List<ChartPiece> pieces, double initialAngle) {
  return [
    ChartGroupPieLayer(
      items: [
        pieces
            .map((e) => ChartGroupPieDataItem(
                amount: e.percent, color: e.color, label: e.percent.toString()))
            .toList()
      ],
      settings: ChartGroupPieSettings(
          angleOffset: initialAngle, thickness: 20, gapSweepAngle: 10),
    ),
  ];
}

class ChartPiece {
  final Color color;
  final double percent;
  final Widget icon;

  ChartPiece({required this.color, required this.percent, required this.icon});
}

class CircularLayout extends StatelessWidget {
  final double radius;
  final List<Widget> children;
  final List<double> angles;

  const CircularLayout(
      {super.key,
      required this.radius,
      required this.children,
      required this.angles});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        ...List.generate(children.length, (index) {
          final double dx = cos(angles[index]) * radius;
          final double dy = sin(angles[index]) * radius;
          return Transform(
            transform: Matrix4.translationValues(dx, dy, 0),
            child: children[index],
          );
        }),
      ],
    );
  }
}

class DiagramIcon extends StatelessWidget {
  final Color color;
  final String name;
  const DiagramIcon({super.key, required this.color, required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      width: 24,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Center(
        child: SvgPicture.asset(
          "assets/svg/tshirt.fill.svg",
          color: Colors.white,
          width: 12,
        ),
      ),
    );
  }
}
