import 'package:assignments/constants/app_colors.dart';
import 'package:flutter/material.dart';

class QuestionCard extends StatelessWidget {
  const QuestionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE8ECF0),
          width: 0.5,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: const Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Write a short essay within 100 words on the '
              'topic written below:',
              style: TextStyle(
                color: AppColors.darkText,
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
          SizedBox(height: 16),
          Text(
            '\u201cHow is Technology Impacting Education\u201d',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.darkText,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
