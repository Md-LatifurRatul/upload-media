import 'package:assignments/constants/app_colors.dart';
import 'package:flutter/material.dart';

class InstructionsCard extends StatelessWidget {
  const InstructionsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7E1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE8D9B0),
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
          Text(
            'Instructions',
            style: TextStyle(
              color: AppColors.primaryBlue,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 12),
          _NumberedItem(
            number: '1',
            text:
                'Write your essay in your notebook and take '
                'clear photos of your work.',
          ),
          SizedBox(height: 6),
          _NumberedItem(
            number: '2',
            text:
                'Upload your photos here, ensuring they are in '
                'the correct order.',
          ),
          SizedBox(height: 6),
          _NumberedItem(
            number: '3',
            text:
                'Supported files: PDF, JPG, or PNG (Max size: '
                '10MB).',
          ),
        ],
      ),
    );
  }
}

class _NumberedItem extends StatelessWidget {
  const _NumberedItem({required this.number, required this.text});

  final String number;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$number. ',
          style: const TextStyle(
            color: AppColors.darkText,
            fontSize: 13,
            height: 1.5,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: AppColors.darkText,
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
