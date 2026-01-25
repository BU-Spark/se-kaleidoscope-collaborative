// Shared accommodations constants used across the app
// This ensures consistency between profile customization and search filters

/// Complete list of all standard accommodations
const List<String> kAllAccommodations = [
  "Accessible Washroom",
  "Alternative Entrance",
  "Handrails",
  "Elevator",
  "Lowered Counter",
  "Accessible Parking",
  "Outdoor Access Only",
  "Reduced Crowd",
  "Scent Free",
  "Digital Menu",
  "Bright Lighting",
  "Reduced Noise",
  "Spaced Seating",
  "Braille",
  "Customer Service",
  "Service Animal Friendly",
  "Sign Language ASL",
  "Fenced/Gated",
  "Indoor Play Area",
  "Automated Doors",
  "Gender Neutral Washroom",
];

/// Accommodations organized by category for UI display
const Map<String, List<String>> kAccommodationCategories = {
  "Mobility": [
    "Accessible Washroom",
    "Alternative Entrance",
    "Handrails",
    "Elevator",
    "Lowered Counter",
    "Accessible Parking",
    "Automated Doors",
    "Gender Neutral Washroom",
  ],
  "Stimuli": [
    "Outdoor Access Only",
    "Reduced Crowd",
    "Scent Free",
    "Digital Menu",
    "Bright Lighting",
    "Reduced Noise",
    "Spaced Seating",
  ],
  "Communication": [
    "Braille",
    "Customer Service",
    "Service Animal Friendly",
    "Sign Language ASL",
  ],
  "Safety & Environment": [
    "Fenced/Gated",
    "Indoor Play Area",
  ],
};
