# api/views.py

import requests
from rest_framework import status
from rest_framework.response import Response
from rest_framework.views import APIView
from django.contrib.auth.models import User
from django.contrib.auth import authenticate
from rest_framework.authtoken.models import Token
from rest_framework.permissions import IsAuthenticated

# Register View
class RegisterView(APIView):
    def post(self, request):
        username = request.data.get('username')
        password = request.data.get('password')

        if not username or not password:
            return Response({'error': 'Username and password are required'}, status=status.HTTP_400_BAD_REQUEST)

        if User.objects.filter(username=username).exists():
            return Response({'error': 'Username already exists'}, status=status.HTTP_400_BAD_REQUEST)

        user = User.objects.create_user(username=username, password=password)
        token = Token.objects.create(user=user)
        return Response({'token': token.key}, status=status.HTTP_201_CREATED)

# Login View
class LoginView(APIView):
    def post(self, request):
        username = request.data.get('username')
        password = request.data.get('password')

        if not username or not password:
            return Response({'error': 'Username and password are required'}, status=status.HTTP_400_BAD_REQUEST)

        user = authenticate(username=username, password=password)

        if user is not None:
            token, created = Token.objects.get_or_create(user=user)
            return Response({'token': token.key}, status=status.HTTP_200_OK)
        else:
            return Response({'error': 'Invalid credentials'}, status=status.HTTP_401_UNAUTHORIZED)

# Logout View
class LogoutView(APIView):
    permission_classes = [IsAuthenticated]  # Ensure the user is authenticated

    def post(self, request):
        request.user.auth_token.delete()  # Delete the user's token
        return Response({'message': 'Successfully logged out'}, status=status.HTTP_204_NO_CONTENT)

# Profile View
class ProfileView(APIView):
    permission_classes = [IsAuthenticated]  # Ensure the user is authenticated

    def get(self, request):
        user = request.user
        # You can return more user-related information here if needed
        return Response({'username': user.username, 'email': user.email}, status=status.HTTP_200_OK)

# Music View
class MusicAPIView(APIView):
    permission_classes = [IsAuthenticated]  # Ensure the user is authenticated

    def get(self, request):
        """
        Fetches music data from the Shazam API.
        """
        shazam_url = 'https://shazam.p.rapidapi.com/charts/list'
        headers = {
            'x-rapidapi-host': 'shazam.p.rapidapi.com',
            'x-rapidapi-key': '2eb727c693msh7f22be1c5aefefdp180abfjsn6a16de4195a2',
        }

        try:
            response = requests.get(shazam_url, headers=headers)
            if response.status_code == 200:
                music_data = response.json().get('tracks', [])
                return Response(music_data, status=status.HTTP_200_OK)
            else:
                return Response({'error': 'Failed to fetch music data'}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

        except Exception as e:
            return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

