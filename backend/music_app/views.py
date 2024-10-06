import requests
from django.http import JsonResponse
from .models import Music  # Assuming you have a Music model in your app
from django.views.decorators.csrf import csrf_exempt

@csrf_exempt
def fetch_music(request):
    """
    Fetches a list of music data.
    
    If you want to fetch data from an external API, this can be done here.
    Alternatively, you can fetch music data stored in the database.
    """
    if request.method == 'GET':
        # Assuming you're fetching data from an external API or from your database
        try:
            # External API example (Shazam)
            shazam_url = 'https://shazam.p.rapidapi.com/charts/list'
            headers = {
                'x-rapidapi-host': 'shazam.p.rapidapi.com',
                'x-rapidapi-key': '2eb727c693msh7f22be1c5aefefdp180abfjsn6a16de4195a2',
            }
            response = requests.get(shazam_url, headers=headers)
            if response.status_code == 200:
                music_data = response.json().get('tracks', [])
                return JsonResponse(music_data, safe=False, status=200)
            else:
                return JsonResponse({'error': 'Failed to fetch music data'}, status=500)

        except Exception as e:
            return JsonResponse({'error': str(e)}, status=500)

# Example to fetch music stored in your database
@csrf_exempt
def fetch_local_music(request):
    """
    Fetches a list of music from the local database.
    """
    if request.method == 'GET':
        try:
            music_list = list(Music.objects.all().values())  # Fetch all music from DB
            return JsonResponse(music_list, safe=False, status=200)
        except Exception as e:
            return JsonResponse({'error': str(e)}, status=500)




