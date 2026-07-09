import 'package:flutter/material.dart';
import 'package:resq_meal/models/donation_model.dart';
import 'package:resq_meal/theme/app_colors.dart';
import 'package:resq_meal/utils/formatters.dart';

class DonationListTile extends StatelessWidget {
  const DonationListTile({super.key, required this.donation, this.onTap});

  final DonationModel donation;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              _Thumbnail(imageUrl: donation.imageUrls.isNotEmpty ? donation.imageUrls.first : null),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(donation.title, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(
                      '${donation.quantity} ${donation.unit} · ${donation.category.label}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    if (donation.expiryAt != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Expires ${Formatters.shortDate.format(donation.expiryAt!)}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.warning,
                            ),
                      ),
                    ],
                  ],
                ),
              ),
              _StatusChip(status: donation.status.name),
            ],
          ),
        ),
      ),
    );
  }
}

class _Thumbnail extends StatelessWidget {
  const _Thumbnail({this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 56,
        height: 56,
        color: AppColors.surfaceVariant,
        child: imageUrl != null
            ? Image.network(imageUrl!, fit: BoxFit.cover)
            : const Icon(Icons.restaurant_rounded, color: AppColors.primary),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.primaryDark,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}
