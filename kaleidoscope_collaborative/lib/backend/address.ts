import express from 'express';
import * as dotenv from 'dotenv';
import axios from 'axios';
import cors from 'cors';
import path from 'path';
import { fileURLToPath } from 'url';

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

// Enable CORS for all routes (needed for Flutter app to access the API)
app.use(cors({
  origin: '*', // In production, you might want to restrict this to your Flutter app's domain
  methods: ['GET', 'POST', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization']
}));

app.use(express.json());

// Serve static HTML files from the public directory
// When compiled, __dirname will be 'dist', so we go up one level to find 'public'
const publicPath = path.join(__dirname, '..', 'public');
app.use(express.static(publicPath));

// Health check endpoint for Railway
app.get('/health', (req, res) => {
  res.status(200).json({ 
    status: 'ok', 
    message: 'Kaleidoscope Backend API is running',
    timestamp: new Date().toISOString()
  });
});

// Serve privacy policy
app.get('/privacy-policy', (req, res) => {
  res.sendFile(path.join(publicPath, 'privacy-policy.html'));
});

// Serve terms of service
app.get('/terms-of-service', (req, res) => {
  res.sendFile(path.join(publicPath, 'terms-of-service.html'));
});

// Root endpoint - serve index page
app.get('/', (req, res) => {
  res.sendFile(path.join(publicPath, 'index.html'));
});

app.get('/api/query/:query/:lat/:lng', async (req, res) => {
    try {
      const results = await textSearch(req.params.query, req.params.lat, req.params.lng);
      res.json(results);
    } catch (error: any) {
      console.error('Error in /api/query endpoint:', error.message);
      res.status(500).json({ error: error.message });
    }
  });

// Photo proxy endpoint - serves Google Places photos with proper authentication
// Using wildcard to capture the full path including slashes
app.get('/api/photo/*', async (req, res) => {
  // Extract the photo reference from the path
  // Remove '/api/photo/' prefix to get the full photo reference
  const photoReference = req.path.replace('/api/photo/', '');
  
  try {
    // Validate API key
    if (!G_KEY || G_KEY === '') {
      return res.status(500).json({ error: 'API key not configured' });
    }
    
    // Extract the place ID and photo name from the reference
    // Format: places/{place_id}/photos/{photo_name}
    const match = photoReference.match(/places\/([^\/]+)\/photos\/([^\/]+)/);
    
    if (!match) {
      return res.status(400).json({ error: 'Invalid photo reference format' });
    }
    
    const placeId = match[1];
    
    // Try Method 1: Use the new Places API (v1) to get place details with photo
    try {
      const placeDetailsUrl = `https://places.googleapis.com/v1/places/${placeId}`;
      const placeResponse = await axios.get(placeDetailsUrl, {
        headers: {
          'X-Goog-Api-Key': G_KEY,
          'X-Goog-FieldMask': 'photos'
        }
      });
      
      if (placeResponse.data && placeResponse.data.photos && placeResponse.data.photos.length > 0) {
        // Get the first photo's name
        const freshPhotoName = placeResponse.data.photos[0].name;
        
        // Now fetch the photo using the fresh reference
        const photoUrl = `https://places.googleapis.com/v1/${freshPhotoName}/media?maxHeightPx=400&maxWidthPx=400`;
        
        const photoResponse = await axios.get(photoUrl, {
          headers: {
            'X-Goog-Api-Key': G_KEY
          },
          responseType: 'arraybuffer',
          maxRedirects: 5
        });
        
        const contentType = photoResponse.headers['content-type'] || 'image/jpeg';
        res.set('Content-Type', contentType);
        res.set('Cache-Control', 'public, max-age=3600'); // Cache for 1 hour
        res.send(Buffer.from(photoResponse.data));
        return;
      }
    } catch (method1Error: any) {
      // Continue to Method 2
    }
    
    // Method 2: Try to use the photo reference directly (might be expired)
    try {
      const photoUrl = `https://places.googleapis.com/v1/${photoReference}/media?maxHeightPx=400&maxWidthPx=400`;
      const photoResponse = await axios.get(photoUrl, {
        headers: {
          'X-Goog-Api-Key': G_KEY
        },
        responseType: 'arraybuffer',
        maxRedirects: 5
      });
      
      const contentType = photoResponse.headers['content-type'] || 'image/jpeg';
      res.set('Content-Type', contentType);
      res.set('Cache-Control', 'public, max-age=3600');
      res.send(Buffer.from(photoResponse.data));
      return;
    } catch (method2Error: any) {
      // Continue to fallback
    }
    
    // Fallback: Return a placeholder image
    const placeholderUrl = 'https://maps.gstatic.com/mapfiles/place_api/icons/v1/png_71/generic_business-71.png';
    const placeholderResponse = await axios.get(placeholderUrl, {
      responseType: 'arraybuffer'
    });
    
    res.set('Content-Type', 'image/png');
    res.set('Cache-Control', 'public, max-age=86400');
    res.send(Buffer.from(placeholderResponse.data));
    
  } catch (error: any) {
    // Return error as JSON
    res.status(error.response?.status || 500).json({ 
      error: 'Failed to fetch photo',
      details: error.message,
      photoReference: photoReference
    });
  }
});


// Test endpoint to check if photo endpoint is working
app.get('/api/test-photo', async (req, res) => {
  res.json({
    message: 'Photo endpoint is accessible',
    apiKeyConfigured: G_KEY ? true : false,
    apiKeyPrefix: G_KEY ? G_KEY.substring(0, 10) + '...' : 'NOT SET'
  });
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
    
    try {
        // Validate API key
        if (!G_KEY || G_KEY === '') {
            console.error('ERROR: Google Maps API key is missing or empty!');
            return [];
        }
        
        // FieldMask is REQUIRED for the new Places API
        // Specify which fields to return (use '*' for all fields in testing)
        const fieldMask = 'places.id,places.displayName,places.formattedAddress,places.internationalPhoneNumber,places.rating,places.photos,places.currentOpeningHours,places.types,places.primaryType,places.primaryTypeDisplayName';
        
        const response = await axios.post(url, requestBody, {
            headers: {
                'Content-Type': 'application/json',
                'X-Goog-Api-Key': G_KEY,
                'X-Goog-FieldMask': fieldMask
            }
        });
        
        const data = response.data;
        
        // Check if we got results
        if (!data.places || data.places.length === 0) {
            return [];
        }
        
        const places = data.places || [];

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
                // Store just the photo reference name (not the full URL)
                // The Flutter app will construct the URL using our backend proxy
                result.photo = photoName;
                result.photoReference = photoName; // Keep for clarity
            } else {
                // Fallback to generic icon if no photo available
                result.photo = "https://maps.gstatic.com/mapfiles/place_api/icons/v1/png_71/generic_business-71.png";
            }

            // Handle place types for categorization
            result.types = place.types || [];
            result.primary_type = place.primaryType || "";
            result.primary_type_display = place.primaryTypeDisplayName?.text || "";

            return result;
        });

        return results;
    } catch (error: any) {
        console.error('ERROR calling Google Places API (New):', error.message);
        if (error.response) {
            console.error('Response status:', error.response.status);
        }
        return [];
    }
  }
