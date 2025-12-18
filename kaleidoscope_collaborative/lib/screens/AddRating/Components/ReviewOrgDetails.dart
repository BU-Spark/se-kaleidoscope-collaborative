import 'package:flutter/material.dart';
import 'package:kaleidoscope_collaborative/utils/photo_url_helper.dart';
import 'package:kaleidoscope_collaborative/config/app_theme.dart';

class ReviewOrgDetails extends StatelessWidget {
  final String OrgImgLink;
  final String OrganizationName;
  final String OrganizationType;

  const ReviewOrgDetails(
      {super.key,
      required this.OrgImgLink,
      required this.OrganizationName,
      required this.OrganizationType});

  @override
  Widget build(BuildContext context) {
    // Construct the photo URL using the helper
    final photoUrl = PhotoUrlHelper.getPhotoUrl(OrgImgLink);
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: PhotoUrlHelper.isValidPhotoReference(OrgImgLink)
              ? Image.network(
                  photoUrl,
                  fit: BoxFit.cover,
                  width: 164.0,
                  height: 124.0,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 164.0,
                      height: 124.0,
                      color: Colors.grey.shade300,
                      child: Icon(
                        Icons.image_not_supported,
                        size: 48,
                        color: Colors.grey.shade500,
                      ),
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      width: 164.0,
                      height: 124.0,
                      color: Colors.grey.shade200,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppTheme.primaryColor,
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      ),
                    );
                  },
                )
              : Container(
                  width: 164.0,
                  height: 124.0,
                  color: Colors.grey.shade300,
                  child: Icon(
                    Icons.place,
                    size: 48,
                    color: Colors.grey.shade500,
                  ),
                ),
        ),
        const SizedBox(width: 16.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                OrganizationName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                OrganizationType,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey.shade700,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
