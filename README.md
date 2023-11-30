## Keep flutter version 3.13.9 

## Command + k: toggle the keyboard in the emulator 

## Installing Flutter on Mac

1. Download the Flutter SDK from the following link: https://flutter.dev/docs/get-started/install/macos

2. Extract the file in the desired location 

3. Add the flutter tool to your path: 
``` 
export PATH="$PATH:`pwd`/flutter/bin"
``` 
4. Run the following command to see if there are any dependencies you need to install to complete the setup: 
``` 

flutter doctor
``` 
5. Run the following command to update your path: 
``` 
source ~/.bash_profile
```

## Installing Flutter on Windows: see https://flutter.dev/docs/get-started/install/windows 


## Installing Flutter on Linux: see https://flutter.dev/docs/get-started/install/linux 



## finding_location_rating folder: 
This folder contains the code for the finding location and rating page. 

1. Ratings_card.dart: 
- This file contains the code for the rating card that is displayed on the finding location and rating page. 
- Users can rate the location OR the a member from the organization by clicking on the stars. 
- The rating is then displayed on the card. 

TO BE COMPLETED:
- The rating is not currently being saved to the database. 
- The image of the member or business is not currently being displayed on the card. 

2. search_page_1_0.dart: 