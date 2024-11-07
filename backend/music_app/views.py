import requests
import json
import os
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from .models import Music
from dotenv import load_dotenv
from rest_framework.permissions import AllowAny  # Import permission to allow public access
from rest_framework.decorators import api_view, permission_classes  # Import necessary decorators

# Load environment variables
load_dotenv()

# Access Freesound API key from environment variables
FREESOUND_API_KEY = os.getenv('FREESOUND_API_KEY')

def fetch_music_from_freesound(search_term):
    """
    Fetch music details from the Freesound API based on a search term.
    This function makes a GET request to the Freesound API and returns the search results as JSON.
    """
    url = f'https://freesound.org/apiv2/search/text/?query={search_term}'  # Freesound search endpoint
    headers = {
        'Authorization': f'Token {FREESOUND_API_KEY}',  # Use the API token for authentication
    }

    try:
        response = requests.get(url, headers=headers)  # Make the GET request to Freesound API
        response.raise_for_status()  # Check if the request was successful (status code 200)
        return response.json().get('results', None)  # Return results or None if not found
    except requests.exceptions.HTTPError as http_err:
        print(f"HTTP error occurred: {http_err}")  # Log HTTP errors (e.g., 404, 500)
        return None  # Return None if there's an error fetching data
    except Exception as e:
        print(f"Error fetching music from Freesound API: {e}")  # Log any other errors
        return None

@csrf_exempt  # Exempt CSRF protection to allow for requests from any client (use with caution)
@api_view(['GET'])  # Only allow GET requests for this endpoint
@permission_classes([AllowAny])  # Allow any user (authenticated or not) to access this view
def fetch_music_view(request, search_term):
    """
    Django view to fetch and return music data based on a search term as JSON.
    This is the endpoint that users will call to get music based on a search term.
    It also allows public access without authentication.
    """
    if request.method == 'GET':  # Only respond to GET requests
        search_results = fetch_music_from_freesound(search_term)  # Call function to fetch data from Freesound
        if search_results:
            return display_freesound_data(search_results)  # Display data if available
        else:
            return JsonResponse({'error': 'No data found for the provided search term'}, status=404)  # Return error if no data found
    else:
        return JsonResponse({'error': 'Invalid HTTP method'}, status=405)  # Return error for methods other than GET

def display_freesound_data(music_data):
    """
    Extract relevant music information from Freesound data and return as JSON response.
    This function formats the data into a list of dictionaries with music details
    that will be returned as a JSON response to the user.
    """
    results = []
    for item in music_data:
        # For each item, extract relevant fields and prepare them for the response
        results.append({
            'track_title': item.get('name', 'Unknown Title'),  # Track title
            'description': item.get('description', 'No Description Available'),  # Track description
            'duration': item.get('duration', 'Unknown Duration'),  # Track duration
            'preview_url': item.get('previews', {}).get('preview-lq-mp3', 'No Preview Available'),  # Preview URL
            'license': item.get('license', 'Unknown License'),  # License type
        })

    # Return the formatted data as a JSON response
    return JsonResponse(results, safe=False)  # 'safe=False' allows the response to be a list



