## Keep flutter version 3.13.9 

## Installing Flutter on Mac

1. Download the Flutter SDK from the following link: [here](https://flutter.dev/docs/get-started/install/macos)

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
## Installing Flutter on Windows: see [here](https://flutter.dev/docs/get-started/install/windows)

## Installing Flutter on Linux: see [here](https://flutter.dev/docs/get-started/install/linux) 

## finding_location_rating folder: 
This folder contains the code for the finding location and rating page. 

1. Ratings_card.dart: 
- This file contains the code for the rating card that is displayed on the finding location and rating page. 
- Users can rate the location OR the a member from the organization by clicking on the stars. 
- The rating is then displayed on the card. 

TO BE COMPLETED:
- The rating is not currently being saved to the database. 
- The information f the member or business is not currently being displayed on the card. 

2. search_page_1_0.dart: 

## Command + k: toggle the keyboard in the emulator  

- recent search section is implemented, however it DOES not save the recent searches ONCE you back to previous page OR close the app. It is something to consider implementing in the future. 
- the search bar is fully functional in terms of it routing to search_page_1.1.dart 
- the search bar is implemented 


3. search_page_1_1.dart: 

- Accomodations needed and filter page is implemented closely to the figma wireframes. 
- the selection of accomodation logic is completed. 
- the confirmation of filered accomodations is completed. 
- the routing to the ratings page is completed. 

TO BE COMPLETED: 
- directing the filter searches to the database to retrieve the information. 

4. search_page_1_2.dart: 
- boilerplate template for the search result item page with the location card implemented. 

TO BE COMPLETED: 
- the location card is not currently being populated with the information from the database. 

5. search_page_1_3.dart: 
- the endpoint of the selected dummy card from search_page_1_2.dart. 

TO BE COMPLETED: 
- route the logic with database to retrieve the information of the selected location. 