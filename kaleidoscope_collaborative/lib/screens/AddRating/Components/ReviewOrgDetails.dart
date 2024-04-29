import 'package:flutter/material.dart';

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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        FadeInImage.assetNetwork(
          placeholder: 'result',
          image: OrgImgLink,
          fit: BoxFit.fill,
          width: 117.0,
          height: 99.0,
        ),
        const SizedBox(width: 16.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                OrganizationName,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                OrganizationType,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                ),
                overflow: TextOverflow.clip,
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ],
    );
  }
}
