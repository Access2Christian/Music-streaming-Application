import http.client
import json
import os
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from django.contrib.auth.decorators import login_required
from .models import Music
from dotenv import load_dotenv
import os

load_dotenv()

# Access environment variables
SHZAM_API_KEY = os.getenv('SHAZAM_API_KEY')
SHZAM_API_HOST = os.getenv('x-rapidapi-host')


@login_required
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
    conn = http.client.HTTPSConnection(SHZAM_API_HOST)
    headers = {
        'x-rapidapi-key': SHZAM_API_KEY,
        'x-rapidapi-host': SHZAM_API_HOST
    }

    try:
        conn.request("GET", f"/artists/get-latest-release?id={artist_id}&l=en-US", headers=headers)
        res = conn.getresponse()
        data = res.read()
        conn.close()
        
        decoded_data = data.decode("utf-8")
        music_data = json.loads(decoded_data)
        return music_data.get('data', None)

    except Exception as e:
        print(f"Error fetching data from Shazam API: {e}")
        return None


@csrf_exempt
@login_required
def latest_release_view(request, artist_id):
    """
    Django view to fetch and return the latest release for an artist as JSON.
    """
    if request.method == 'GET':
        latest_release = get_latest_release(artist_id)
        if latest_release:
            return display_music_data(latest_release)
        else:
            return JsonResponse({'error': 'No data found for the provided artist ID'}, status=404)
    else:
        return JsonResponse({'error': 'Invalid HTTP method'}, status=405)


def display_music_data(music_data):
    """
    Extract relevant music information and return it as a JSON response.
    """
    if isinstance(music_data, list) and len(music_data) > 0:
        music_data = music_data[0]

    if 'attributes' in music_data:
        response = {
            'track_title': music_data['attributes'].get('title', 'Unknown Title'),
            'artist_name': music_data['attributes'].get('artistName', 'Unknown Artist'),
            'release_date': music_data['attributes'].get('releaseDate', 'Unknown Date'),
            'album_art': music_data['attributes'].get('artwork', {}).get('url', 'No Artwork Available'),
        }
        return JsonResponse(response)
    else:
        return JsonResponse({'error': 'Attributes missing from the music data'}, status=400)


def fetch_music(search_term):
    """
    Fetch music details from Shazam API based on a search term.
    """
    conn = http.client.HTTPSConnection(SHZAM_API_HOST)
    headers = {
        'x-rapidapi-key': SHZAM_API_KEY,
        'x-rapidapi-host': SHZAM_API_HOST
    }

    try:
        conn.request("GET", f"/search?term={search_term}&locale=en-US&offset=0&limit=5", headers=headers)
        res = conn.getresponse()
        data = res.read()
        conn.close()

        decoded_data = data.decode("utf-8")
        search_data = json.loads(decoded_data)
        return search_data.get('tracks', None)

    except Exception as e:
        print(f"Error fetching music from Shazam API: {e}")
        return None


@csrf_exempt
@login_required
def fetch_music_view(request, search_term):
    """
    Django view to fetch and return music data based on a search term as JSON.
    """
    if request.method == 'GET':
        search_results = fetch_music(search_term)
        if search_results:
            return display_music_data(search_results['hits'])
        else:
            return JsonResponse({'error': 'No data found for the provided search term'}, status=404)
    else:
        return JsonResponse({'error': 'Invalid HTTP method'}, status=405)

