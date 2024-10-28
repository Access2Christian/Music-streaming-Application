import requests
from rest_framework import status
from rest_framework.response import Response
from rest_framework.views import APIView
from django.contrib.auth.models import User
from django.contrib.auth import authenticate
from rest_framework.authtoken.models import Token
from rest_framework.permissions import IsAuthenticated
from decouple import config
from users.models import UserProfile  # Import UserProfile from users app


class RegisterView(APIView):
    """User registration view."""

    def post(self, request):
        username = request.data.get('username')
        password = request.data.get('password')

        # Validate input
        if not username or not password:
            return Response({'error': 'Username and password are required'}, status=status.HTTP_400_BAD_REQUEST)

        if User.objects.filter(username=username).exists():
            return Response({'error': 'Username already exists'}, status=status.HTTP_400_BAD_REQUEST)

        # Create user and token
        user = User.objects.create_user(username=username, password=password)
        token = Token.objects.create(user=user)

        return Response({'token': token.key}, status=status.HTTP_201_CREATED)


class LoginView(APIView):
    """User login view."""

    def post(self, request):
        username = request.data.get('username')
        password = request.data.get('password')

        # Validate input
        if not username or not password:
            return Response({'error': 'Username and password are required'}, status=status.HTTP_400_BAD_REQUEST)

        # Authenticate user
        user = authenticate(username=username, password=password)

        if user is not None:
            token, created = Token.objects.get_or_create(user=user)
            return Response({
                'token': token.key,
                'message': 'New token created' if created else 'Reused existing token'
            }, status=status.HTTP_200_OK)

        return Response({'error': 'Invalid credentials'}, status=status.HTTP_401_UNAUTHORIZED)


class LogoutView(APIView):
    """User logout view."""
    permission_classes = [IsAuthenticated]

    def post(self, request):
        # Log the user out by deleting their token
        Token.objects.filter(user=request.user).delete()
        return Response({'message': 'Successfully logged out'}, status=status.HTTP_204_NO_CONTENT)


class ProfileView(APIView):
    """User profile view."""
    permission_classes = [IsAuthenticated]

    def get(self, request):
        user = request.user  # Get the currently authenticated user

        # Fetch user profile data
        try:
            profile = UserProfile.objects.get(user=user)
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
            return Response(user_data, status=status.HTTP_200_OK)

        except UserProfile.DoesNotExist:
            return Response({'error': 'Profile does not exist'}, status=status.HTTP_404_NOT_FOUND)


class MusicAPIView(APIView):
    """Fetch music data from the Shazam API."""
    permission_classes = [IsAuthenticated]

    def get(self, request):
        shazam_url = 'https://shazam.p.rapidapi.com/charts/list'

        # Access environment variables using decouple.config
        SHZAM_API_KEY = config('SHAZAM_API_KEY')
        SHZAM_API_HOST = config('x-rapidapi-host')

        headers = {
            'x-rapidapi-host': SHZAM_API_HOST,
            'x-rapidapi-key': SHZAM_API_KEY,
        }

        try:
            # Make the API call once
            response = requests.get(shazam_url, headers=headers)
            response.raise_for_status()  # Raise exception for bad status codes
            music_data = response.json().get('tracks', [])
            return Response(music_data, status=status.HTTP_200_OK)

        # Handle specific request errors
        except requests.exceptions.HTTPError as http_err:
            return Response({'error': f'HTTP error occurred: {http_err}'}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
        except requests.exceptions.ConnectionError:
            return Response({'error': 'Connection error. Please check your network.'}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
        except requests.exceptions.Timeout:
            return Response({'error': 'The request timed out. Please try again later.'}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
        except Exception as e:
            return Response({'error': f'An error occurred: {e}'}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

