import express from 'express';
import * as dotenv from 'dotenv';
import axios from 'axios';

dotenv.config();

/****************
 * READ ME: 
 * We are using Google Maps API to retrieve the information of the locations. Please set up and store your own API key in .env file to run the code locally.
link to setup Google Maps API: [here](https://developers.google.com/maps/documentation/places/web-service/get-api-key) 
link to the documentation: [here](https://developers.google.com/maps/documentation/places/web-service/overview) 

Current API structure for the backend: 

# address.ts 
- Be sure to install all the necessary dependencies in the requirements.txt file 
- Troubleshoot potential errors: 
- use: **ts-node file.ts** to run the file 
- see the file for detailed information and end points 
 */


// Run with ts-node address.ts 
const app = express();
const port = process.env.PORT || 8000;

// Make sure to set your Google Maps API key in the .env file 
const G_KEY = process.env.GOOGLE_MAPS_API_KEY;
console.log(G_KEY);

app.use(express.json());

// Test locally, e.g. http://localhost:3000/api/coordinates/1600+Amphitheatre+Parkway,+Mountain+View,+CA 
app.get('/api/query/:query/:lat/:lng', async (req, res) => {
    console.log("received request");

    try {
      const results = await textSearch(req.params.query, req.params.lat, req.params.lng);
      res.json(results);
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  });


app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
  
});

// Function calls to Google Maps API 

function getPhotoFromReference(photo_reference:string) {
   const photoURL = `https://maps.googleapis.com/maps/api/place/photo?photo_reference=${photo_reference}&key=${G_KEY}&maxheight=400&maxwidth=400`
   return photoURL;

}

async function textSearch(query: string, lat: string, lng: string) {
    const locationbias = lat != "null" ? `circle:radius@${lat},${lng}` : 'ipbias';
    const fields = 'places.currentOpeningHours,places.formatted_address,places.formatted_phone_number,places.rating,place.photos';
    const url = `https://maps.googleapis.com/maps/api/place/textsearch/json?query=${query}&key=${G_KEY}&fields=${fields}&locationbias=${locationbias}`;
    const response = await axios.get(url);
    const data = response.data;
    const results = data.results

    for (let i=0; i<results.length; i++) {
        //Check if there's a photo field in result response
        if (results[i]["photos"] != null) {
            let photo = getPhotoFromReference(results[i]["photos"][0]["photo_reference"])
            results[i]["photo"] = photo
        } else {
            results[i]["photo"] = results[i]["icon"];
        }

        console.log(results[i])
    }

    return results;
  }
