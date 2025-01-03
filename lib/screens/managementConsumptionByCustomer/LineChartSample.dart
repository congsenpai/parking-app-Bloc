// ignore_for_file: file_names, unnecessary_import

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class LineChartSample extends StatelessWidget {
  final List<FlSpot> up;
  final List<FlSpot> down;
  final String X_AxisTitles;
  final String Y_AxisTitles;
  final double maxX;
  final double maxY;

  const LineChartSample({
    super.key,
    required this.up,
    required this.down,
    required this.X_AxisTitles,
    required this.Y_AxisTitles,
    required this.maxX,
    required this.maxY,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(Get.width / 70),
      child: Column(
        children: [
          Text(
            'Consumption Graph',
            style: TextStyle(
                fontSize: Get.width / 20,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),
          SizedBox(
            height: Get.width / 30,
          ),
          Container(
            color: Colors.transparent, // Đảm bảo Container trong suốt
            height: Get.width/1.3,
            width: Get.width / 1.2,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: true),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1000000,
                      reservedSize: 40, // Đảm bảo đủ không gian để hiển thị
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: false,
                      interval: 1,
                      reservedSize: 60,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(), // Nội dung nhãn
                          style: TextStyle(
                            fontSize: Get.width / 45, // Kích thước chữ nhỏ hơn
                            color: Colors.black, // Màu chữ đen
                          ),
                        );
                      },
                    ),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: true),
                minX: 0,
                maxX: maxX,
                minY: 0,
                maxY: maxY,
                lineBarsData: [
                  // Dữ liệu cho đường 1
                  LineChartBarData(
                    spots: up,
                    isCurved: true,
                    barWidth: 1,
                    color: Colors.green,
                    dotData: FlDotData(show: true),
                  ),
                  // Dữ liệu cho đường 2
                  LineChartBarData(
                    spots: down,
                    isCurved: true,
                    barWidth: 1,
                    color: Colors.red,
                    dotData: FlDotData(show: true),
                  ),
                ],
                // Thêm LineTouchData để tuỳ chỉnh tooltip
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    // Màu nền tooltip
                    tooltipPadding: const EdgeInsets.all(8), // Padding bên trong tooltip
                    tooltipMargin: 8, // Khoảng cách từ tooltip tới điểm trên biểu đồ
                    tooltipRoundedRadius: 8, // Bo góc tooltip
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        return LineTooltipItem(
                          'Day: ${spot.x.toStringAsFixed(0)}th\n${spot.y.toStringAsFixed(2)} VNĐ\nType: ${spot.barIndex == 0 ? 'Up' : 'Down'}',
                          const TextStyle(
                            color: Colors.white, // Màu chữ trong tooltip
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}