import express from 'express';
import * as dotenv from 'dotenv';
import axios from 'axios';

dotenv.config();

/****************
 * READ ME: 
 * We are using Google Places API (New) to retrieve the information of the locations. 
 * Please set up and store your own API key in .env file to run the code locally.
 * 
 * IMPORTANT: You must enable the "Places API (New)" in Google Cloud Console.
 * The legacy Places API is deprecated and will not work.
 * 
 * Setup:
 * 1. Go to Google Cloud Console: https://console.cloud.google.com/
 * 2. Enable "Places API (New)" for your project
 * 3. Add your API key to .env file as: GOOGLE_MAPS_API_KEY=your_key_here
 * 
 * Links:
 * - API Setup: https://developers.google.com/maps/documentation/places/web-service/get-api-key
 * - New Places API Docs: https://developers.google.com/maps/documentation/places/web-service
 * 
 * Current API structure for the backend: 
 * # address.ts 
 * - Be sure to install all necessary dependencies: npm install
 * - Run with: **npx ts-node address.ts**
 * - Endpoint: GET /api/query/:query/:lat/:lng
 */


// Run with ts-node address.ts 
const app = express();
const port = process.env.PORT || 8000;

// Make sure to set your Google Maps API key in the .env file 
const G_KEY = process.env.GOOGLE_MAPS_API_KEY;
console.log(G_KEY);

app.use(express.json());

app.get('/api/query/:query/:lat/:lng', async (req, res) => {
    console.log("Received request:");
    console.log(`   Query: ${req.params.query}`);
    console.log(`   Location: ${req.params.lat}, ${req.params.lng}`);

    try {
      const results = await textSearch(req.params.query, req.params.lat, req.params.lng);
      console.log(`Returning ${results.length} results`);
      res.json(results);
    } catch (error: any) {
      console.error('Error in /api/query endpoint:', error.message);
      res.status(500).json({ error: error.message });
    }
  });


app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
  
});

// Function calls to Google Maps API 

function getPhotoFromReference(photo_reference:string) {
   // Using the new Places Photo API
   const photoURL = `https://places.googleapis.com/v1/${photo_reference}/media?key=${G_KEY}&maxHeightPx=400&maxWidthPx=400`
   return photoURL;
}

async function textSearch(query: string, lat: string, lng: string) {
    // Using the new Places API (New) endpoint
    // Note: Fields are NOT specified in request body for the new API
    const url = `https://places.googleapis.com/v1/places:searchText`;
    
    // Request body for the new API - only required fields
    const requestBody: any = {
        textQuery: query.trim(), // Remove any extra spaces
        maxResultCount: 10
    };
    
    // Build location bias for the new API format if coordinates are available
    if (lat !== "null" && lng !== "null" && lat && lng) {
        requestBody.locationBias = {
            circle: {
                center: {
                    latitude: parseFloat(lat),
                    longitude: parseFloat(lng)
                },
                radius: 2000.0 // radius in meters
            }
        };
    }
    
    console.log(`Making Google Places API (New) request to: ${url}`);
    console.log(`Request Body:`, JSON.stringify(requestBody, null, 2));
    console.log(`Query: "${query.trim()}", Location: ${lat}, ${lng}`);
    
    try {
        // Validate API key
        if (!G_KEY || G_KEY === '') {
            console.error('ERROR: Google Maps API key is missing or empty!');
            console.error('Please set GOOGLE_MAPS_API_KEY in your .env file');
            return [];
        }
        
        console.log(`Using API Key: ${G_KEY.substring(0, 10)}...`);
        
        // FieldMask is REQUIRED for the new Places API
        // Specify which fields to return (use '*' for all fields in testing)
        const fieldMask = 'places.id,places.displayName,places.formattedAddress,places.internationalPhoneNumber,places.rating,places.photos,places.currentOpeningHours';
        
        const response = await axios.post(url, requestBody, {
            headers: {
                'Content-Type': 'application/json',
                'X-Goog-Api-Key': G_KEY,
                'X-Goog-FieldMask': fieldMask
            }
        });
        
        const data = response.data;
        
        // Log full response for debugging
        console.log('Google Places API Response:', JSON.stringify(data, null, 2).substring(0, 500));
        
        // Check if we got results
        if (!data.places || data.places.length === 0) {
            console.log('No places found for query');
            console.log('Response structure:', Object.keys(data));
            return [];
        }
        
        const places = data.places || [];
        console.log(`Found ${places.length} places`);

        // Transform the new API response format to match expected frontend format
        const results = places.map((place: any, i: number) => {
            const result: any = {};
            
            // Map new API fields to legacy format for compatibility
            result.name = place.displayName?.text || "Unknown Place";
            result.place_id = place.id || place.placeId || "";
            result.formatted_address = place.formattedAddress || "Address not available";
            result.rating = place.rating || 0;
            
            // Handle phone number
            result.formatted_phone_number = place.internationalPhoneNumber || "Phone not available";
            
            // Handle opening hours
            if (place.currentOpeningHours) {
                result.current_opening_hours = {
                    weekday_text: place.currentOpeningHours.weekdayDescriptions || []
                };
            }
            
            // Handle photos - new API structure
            if (place.photos && place.photos.length > 0) {
                // New API uses photo name (e.g., "places/ChIJ.../photos/...")
                const photoName = place.photos[0].name;
                // Construct photo URL using the new Places Photo API
                // Note: photoName already includes the full resource path
                result.photo = `https://places.googleapis.com/v1/${photoName}/media?key=${G_KEY}&maxHeightPx=400&maxWidthPx=400`;
            } else {
                // Fallback to generic icon if no photo available
                result.photo = "https://maps.gstatic.com/mapfiles/place_api/icons/v1/png_71/generic_business-71.png";
            }
            
            console.log(`Place ${i}: ${result.name}`);
            return result;
        });

        return results;
    } catch (error: any) {
        console.error('ERROR calling Google Places API (New):', error.message);
        
        if (error.response) {
            console.error('Response status:', error.response.status);
            console.error('Response headers:', error.response.headers);
            console.error('Response data:', JSON.stringify(error.response.data, null, 2));
            
            // Provide specific error guidance
            if (error.response.status === 403) {
                console.error('403 Forbidden - Check:');
                console.error('   1. Places API (New) is enabled in Google Cloud Console');
                console.error('   2. API key has correct permissions');
                console.error('   3. Billing is enabled on your Google Cloud project');
            } else if (error.response.status === 400) {
                console.error('400 Bad Request - Check:');
                console.error('   1. Request format is correct');
                console.error('   2. Location coordinates are valid numbers');
            } else if (error.response.status === 401) {
                console.error('401 Unauthorized - Check:');
                console.error('   1. API key is valid');
                console.error('   2. API key is correctly set in .env file');
            }
        } else if (error.request) {
            console.error('No response received from Google Places API');
            console.error('Request details:', error.request);
        } else {
            console.error('Error setting up request:', error.message);
        }
        
        return [];
    }
  }
