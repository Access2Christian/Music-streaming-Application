import http.client
import json
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from .models import Music 

def fetch_local_music(request):
    """
    Fetch and return music data from the local database.
    """
    try:
        music_data = Music.objects.all().values('title', 'artist', 'release_date', 'album_art')
        return JsonResponse(list(music_data), safe=False)
    except Exception as e:
        return JsonResponse({'error': f"An error occurred: {e}"}, status=500)


def get_latest_release(artist_id):
    """
    Fetch the latest release of an artist from the Shazam API.
    """
    conn = http.client.HTTPSConnection("shazam.p.rapidapi.com")

    headers = {
        'x-rapidapi-key': "2eb727c693msh7f22be1c5aefefdp180abfjsn6a16de4195a2",  
        'x-rapidapi-host': "shazam.p.rapidapi.com"
    }

    try:
        # Make the API request to get the latest release for the given artist_id
        conn.request("GET", f"/artists/get-latest-release?id={artist_id}&l=en-US", headers=headers)
        
        res = conn.getresponse()
        data = res.read()
        conn.close()  # Close the connection after reading the response

        # Decode and parse the JSON response
        decoded_data = data.decode("utf-8")
        music_data = json.loads(decoded_data)
        
        # Return music data if 'data' key exists, otherwise return None
        return music_data.get('data', None)

    except Exception as e:
        print(f"Error fetching data from Shazam API: {e}")
        return None


@csrf_exempt
def latest_release_view(request, artist_id):
    """
    Django view to fetch and return the latest release for an artist as JSON.
    """
    if request.method == 'GET':
        # Call the function to get the latest release
        latest_release = get_latest_release(artist_id)

        # If data is returned, display it; otherwise, return a 404 error
        if latest_release:
            return display_music_data(latest_release)
        else:
            return JsonResponse({'error': 'No data found for the provided artist ID'}, status=404)
    else:
        # Return 405 for invalid HTTP methods
        return JsonResponse({'error': 'Invalid HTTP method'}, status=405)


def display_music_data(music_data):
    """
    Extract relevant music information and return it as a JSON response.
    """
    if isinstance(music_data, list) and len(music_data) > 0:
        # Assuming the music data comes as a list, we take the first entry
        music_data = music_data[0]

    if 'attributes' in music_data:
        # Extract the relevant fields from the 'attributes' of the music data
        response = {
            'track_title': music_data['attributes'].get('title', 'Unknown Title'),
            'artist_name': music_data['attributes'].get('artistName', 'Unknown Artist'),
            'release_date': music_data['attributes'].get('releaseDate', 'Unknown Date'),
            'album_art': music_data['attributes'].get('artwork', {}).get('url', 'No Artwork Available'),
        }
        return JsonResponse(response)
    else:
        # If 'attributes' are missing in the data, return an error
        return JsonResponse({'error': 'Attributes missing from the music data'}, status=400)


def fetch_music(search_term):
    """
    Fetch music details from Shazam API based on a search term.
    """
    conn = http.client.HTTPSConnection("shazam.p.rapidapi.com")

    headers = {
        'x-rapidapi-key': "2eb727c693msh7f22be1c5aefefdp180abfjsn6a16de4195a2",  
        'x-rapidapi-host': "shazam.p.rapidapi.com"
    }

    try:
        # Make the API request to search for music using the provided search term
        conn.request("GET", f"/search?term={search_term}&locale=en-US&offset=0&limit=5", headers=headers)
        
        res = conn.getresponse()
        data = res.read()
        conn.close()  # Close the connection after reading the response

        # Decode and parse the JSON response
        decoded_data = data.decode("utf-8")
        search_data = json.loads(decoded_data)
        
        # Return search results if 'tracks' key exists, otherwise return None
        return search_data.get('tracks', None)

    except Exception as e:
        print(f"Error fetching music from Shazam API: {e}")
        return None


@csrf_exempt
def fetch_music_view(request, search_term):
    """
    Django view to fetch and return music data based on a search term as JSON.
    """
    if request.method == 'GET':
        # Call the function to fetch music
        search_results = fetch_music(search_term)

        # If data is returned, display it; otherwise, return a 404 error
        if search_results:
            return display_music_data(search_results['hits'])
        else:
            return JsonResponse({'error': 'No data found for the provided search term'}, status=404)
    else:
        # Return 405 for invalid HTTP methods
        return JsonResponse({'error': 'Invalid HTTP method'}, status=405)


