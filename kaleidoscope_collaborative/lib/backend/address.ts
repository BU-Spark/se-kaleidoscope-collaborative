import express from 'express';
import * as dotenv from 'dotenv';
import axios from 'axios';
import path from 'path';
import fs from 'fs/promises';

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
const port = process.env.PORT || 3000;

// Make sure to set your Google Maps API key in the .env file 

// const G_KEY = process.env.GOOGLE_MAPS_API_KEY;

const G_KEY='AIzaSyCqi_7MNOwxuYcfPvrk2F7IUN5juYYvTPk'

app.use(express.json());

// Test locally, e.g. http://localhost:3000/api/coordinates/1600+Amphitheatre+Parkway,+Mountain+View,+CA 
app.get('/api/coordinates/:address', async (req, res) => {
  const address = req.params.address;
  try {
    const coordinates = await getCoordinates(address);
    res.json(coordinates);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.get('/api/distance/:origin/:destination', async (req, res) => {
  const origin = req.params.origin;
  const destination = req.params.destination;
  try {
    const distance = await getDistance(origin, destination);
    res.json({ distance });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.get('/api/nearby/:location/:radius/:type', async (req, res) => {
  const location = req.params.location;
  // const radius = req.params.radius;
  const radius = parseInt(req.params.radius, 50);
  const type = req.params.type;
  try {
    const places = await getNearbyPlaces(location, radius, type);
    res.json(places);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.get('/api/place/:placeId', async (req, res) => {
  const placeId = req.params.placeId;
  try {
    const placeDetails = await getPlaceDetails(placeId);
    res.json(placeDetails);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Demo: returns all the nearby places of a certain type, e.g. http://localhost:3000/api/place_type/restaurant 
app.get('/api/place_type/:place_type', async (req, res) => {
  const place_type = req.params.place_type;
  try {
    const places = await getPlaceType(place_type);
    res.json(places);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});


app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});

// Function calls to Google Maps API 


/**
 * @param address: string 
 * 
 * @returns { lat: number, lng: number}  
 */ 
// async function getCoordinates(address: string) {
//   const url = `https://maps.googleapis.com/maps/api/geocode/json?address=${address}&key=${G_KEY}`;
//   const response = await axios.get(url);
//   const data = response.data;
//   const coordinates = data.results[0].geometry.location;
//   return coordinates;
// }

async function getCoordinates(address: string) {
  const url = `https://maps.googleapis.com/maps/api/geocode/json?address=${address}&key=${G_KEY}`;
  const response = await axios.get(url);
  const data = response.data;
  console.log(data);  // Log the full response data to debug
  if (data.results && data.results.length > 0) {
    const coordinates = data.results[0].geometry.location;
    return coordinates;
  } else {
    throw new Error('No results found for the specified address.');
  }
}


/**
 * @param origin: string 
 * 
 * @param destination: string 
 * @returns any / text 
 */ 
async function getDistance(origin: string, destination: string) {
  const url = `https://maps.googleapis.com/maps/api/distancematrix/json?units=metric&origins=${origin}&destinations=${destination}&key=${G_KEY}`;
  const response = await axios.get(url);
  const data = response.data;
  const distance = data.rows[0].elements[0].distance.text;
  return distance;
}

/**
 * @param location: string 
 * 
 * @param radius: number (km)
 * 
 * @param type: string (restaurant, doctor etc), for a full list see https://developers.google.com/places/web-service/supported_types 
 * @returns  Places: [
  {
    business_status: 'OPERATIONAL',
    geometry: { location: [Object], viewport: [Object] },
    icon: 'https://maps.gstatic.com/mapfiles/place_api/icons/v1/png_71/lodging-71.png',
    icon_background_color: '#909CE1',
    icon_mask_base_uri: 'https://maps.gstatic.com/mapfiles/place_api/icons/v2/hotel_pinlet',
    name: "Dinah's Garden Hotel",
    photos: [ [Object] ],
    place_id: 'ChIJxUf2lnm6j4ARf-dI1c4L9sA',
    plus_code: {
      compound_code: 'CV4H+XV Palo Alto, CA, USA',
      global_code: '849VCV4H+XV'
    },
    rating: 4.5,
    reference: 'ChIJxUf2lnm6j4ARf-dI1c4L9sA',
    scope: 'GOOGLE',
    types: [
      'lodging',
      'restaurant',
      'food',
      'point_of_interest',
      'establishment'
    ],
    user_ratings_total: 1016,
    vicinity: '4261 El Camino Real, Palo Alto'
  },
  .... 
 */

async function getNearbyPlaces(location: string, radius: number, type: string) {
  const url = `https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${location}&radius=${radius}&type=${type}&key=${G_KEY}`;
  const response = await axios.get(url);
  const data = response.data;
  const places = data.results;
  return places;
}


/**
 * @param placeId: string 
 * @returns SEE placesDetails_sample.json for FULL response 
 */

async function getPlaceDetails(placeId: string) {
  const url = `https://maps.googleapis.com/maps/api/place/details/json?place_id=${placeId}&key=${G_KEY}`;
  const response = await axios.get(url);
  const data = response.data;
  const placeDetails = data.result;
  return placeDetails;
}

const placeDetailsSamplePath = path.join(__dirname, 'placeDetails_sample.json');

app.get('/api/place_details_sample', async (req, res) => {
  try {
    // Read the contents of the JSON file.
    const placeDetailsSample = await fs.readFile(placeDetailsSamplePath, 'utf-8');
    
    // Parse the JSON data and send it as a response.
    res.json(JSON.parse(placeDetailsSample));
  } catch (error) {
    // If there's an error, such as the file not existing, send a 500 server error.
    res.status(500).json({ error: error.message });
  }
});



/**
 * @param place_type: string
 * @returns DEMO 
 */

async function getPlaceType(place_type: string) {
  const url = `https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=42.3475186,%20-71.1029006&radius=${50}&type=${place_type}&key=${G_KEY}`;
  const response = await axios.get(url);
  const data = response.data;
  const places = data.results;
  return places;

}