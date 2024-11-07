import requests  # Importing the 'requests' module to make HTTP requests
from rest_framework import status  # Importing HTTP status codes from the DRF (Django Rest Framework)
from rest_framework.response import Response  # Importing 'Response' class to send HTTP responses
from rest_framework.views import APIView  # Importing 'APIView' to create API views in Django
from django.contrib.auth.models import User  # Importing Django's User model for authentication
from django.contrib.auth import authenticate  # Importing 'authenticate' for authenticating users
from rest_framework.authtoken.models import Token  # Importing 'Token' for handling authentication tokens
from rest_framework.permissions import IsAuthenticated  # Importing permission class to restrict access to authenticated users
from rest_framework.permissions import AllowAny  # Importing permission class to allow unrestricted access
from decouple import config  # Importing 'config' to read environment variables securely
from users.models import UserProfile  # Importing 'UserProfile' model from the users app to manage user-specific data

# User registration view
class RegisterView(APIView):
    """User registration view."""

    def post(self, request):
        # Get username and password from the request data
        username = request.data.get('username')
        password = request.data.get('password')

        # Validate that both username and password are provided
        if not username or not password:
            return Response({'error': 'Username and password are required'}, status=status.HTTP_400_BAD_REQUEST)

        # Check if the username already exists
        if User.objects.filter(username=username).exists():
            return Response({'error': 'Username already exists'}, status=status.HTTP_400_BAD_REQUEST)

        # Create a new user and a corresponding authentication token
        user = User.objects.create_user(username=username, password=password)
        token = Token.objects.create(user=user)

        # Return the token as a response
        return Response({'token': token.key}, status=status.HTTP_201_CREATED)

# User login view
class LoginView(APIView):
    """User login view."""

    def post(self, request):
        # Get username and password from the request data
        username = request.data.get('username')
        password = request.data.get('password')

        # Validate that both username and password are provided
        if not username or not password:
            return Response({'error': 'Username and password are required'}, status=status.HTTP_400_BAD_REQUEST)

        # Authenticate the user with the provided username and password
        user = authenticate(username=username, password=password)

        # If the authentication is successful, generate or retrieve the token
        if user is not None:
            token, created = Token.objects.get_or_create(user=user)
            return Response({
                'token': token.key,
                'message': 'New token created' if created else 'Reused existing token'
            }, status=status.HTTP_200_OK)

        # If authentication fails, return an error response
        return Response({'error': 'Invalid credentials'}, status=status.HTTP_401_UNAUTHORIZED)

# User logout view
class LogoutView(APIView):
    """User logout view."""
    permission_classes = [IsAuthenticated]  # Only authenticated users can log out

    def post(self, request):
        # Delete the authentication token to log the user out
        Token.objects.filter(user=request.user).delete()
        return Response({'message': 'Successfully logged out'}, status=status.HTTP_204_NO_CONTENT)

# User profile view
class ProfileView(APIView):
    """User profile view."""
    permission_classes = [IsAuthenticated]  # Only authenticated users can view their profile

    def get(self, request):
        user = request.user  # Get the currently authenticated user

        # Try to fetch the user's profile data
        try:
            profile = UserProfile.objects.get(user=user)  # Get the UserProfile associated with the user
            user_data = {
                'username': user.username,
                'first_name': user.first_name,
                'last_name': user.last_name,
                'email': user.email,
                'gender': profile.gender,
                'date_of_birth': profile.date_of_birth,
                'city': profile.city,
                'country': profile.country,
            }
            return Response(user_data, status=status.HTTP_200_OK)  # Return the profile data

        # If the user does not have a profile, return an error response
        except UserProfile.DoesNotExist:
            return Response({'error': 'Profile does not exist'}, status=status.HTTP_404_NOT_FOUND)

# Music API view to fetch music data from the Freesound API
class MusicAPIView(APIView):
    """Fetch music data from the Freesound API."""
    permission_classes = [AllowAny]  # Allow unrestricted access to this view

    def get(self, request):
        # Get the search query from the request, default to 'music' if not provided
        query = request.query_params.get('query', 'music')
        freesound_url = f'https://freesound.org/apiv2/search/text/?query={query}'  # Freesound API URL

        # Access the API key from the environment variables
        FREESOUND_API_KEY = config('FREESOUND_API_KEY')

        headers = {
            'Authorization': f'Token {FREESOUND_API_KEY}',  # Pass the API token for authentication
        }

        try:
            # Make the API call to Freesound
            response = requests.get(freesound_url, headers=headers)
            response.raise_for_status()  # Raise exception for bad HTTP status codes

            # Parse the response JSON and extract relevant music data
            sounds_data = response.json().get('results', [])
            music_data = [
                {
                    'id': sound['id'],
                    'name': sound['name'],
                    'description': sound['description'],
                    'preview_url': sound['previews']['preview-lq-mp3']  # Get preview URL for the music track
                }
                for sound in sounds_data  # Loop through each sound in the response
            ]

            return Response(music_data, status=status.HTTP_200_OK)  # Return the music data as a response

        # Handle specific request errors and return appropriate responses
        except requests.exceptions.HTTPError as http_err:
            return Response({'error': f'HTTP error occurred: {http_err}'}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
        except requests.exceptions.ConnectionError:
            return Response({'error': 'Connection error. Please check your network.'}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
        except requests.exceptions.Timeout:
            return Response({'error': 'The request timed out. Please try again later.'}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
        except Exception as e:
            return Response({'error': f'An error occurred: {e}'}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
