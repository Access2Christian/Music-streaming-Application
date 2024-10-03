from django.contrib.auth.models import User  # Import the User model
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.authtoken.models import Token
from .models import UserProfile
from .serializers import UserSerializer
from django.contrib.auth import authenticate
from rest_framework.permissions import IsAuthenticated
from rest_framework import status

class RegisterView(APIView):
    def post(self, request):
        data = request.data
        
        # Ensure the email is not already in use
        if User.objects.filter(email=data.get('email')).exists():
            return Response({'error': 'Email is already registered'}, status=status.HTTP_400_BAD_REQUEST)
        
        # Ensure username is not already taken
        if User.objects.filter(username=data.get('username')).exists():
            return Response({'error': 'Username already exists'}, status=status.HTTP_400_BAD_REQUEST)

        # Create user
        user = User.objects.create_user(
            username=data['username'], 
            email=data['email'],
            password=data['password']
        )
        user.save()
        
        # Generate a token for the newly registered user
        token, created = Token.objects.get_or_create(user=user)
        return Response({
            'user': UserSerializer(user).data,
            'token': token.key,
            'message': 'Registration successful'
        }, status=status.HTTP_201_CREATED)


class LoginView(APIView):
    def post(self, request):
        email = request.data.get('email')
        password = request.data.get('password')

        # Authenticate user with username as email
        user = authenticate(username=email, password=password)
        if user:
            # Generate or retrieve the token
            token, created = Token.objects.get_or_create(user=user)
            return Response({
                'token': token.key,
                'message': 'Login successful'
            }, status=status.HTTP_200_OK)
        
        return Response({'error': 'Invalid email or password'}, status=status.HTTP_400_BAD_REQUEST)


class ProfileView(APIView):
    permission_classes = [IsAuthenticated]  # Ensure user is logged in

    def get(self, request):
        user = request.user  # Get the currently authenticated user
        profile = UserProfile.objects.get(user=user)  # Fetch user profile data
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

    def put(self, request):
        user = request.user  # Get the currently authenticated user
        data = request.data  # Use DRF's request data parsing
        profile = UserProfile.objects.get(user=user)  # Get the user's profile

        # Update user fields
        user.first_name = data.get('first_name', user.first_name)
        user.last_name = data.get('last_name', user.last_name)
        user.email = data.get('email', user.email)

        # Update profile fields
        profile.gender = data.get('gender', profile.gender)
        profile.date_of_birth = data.get('date_of_birth', profile.date_of_birth)
        profile.city = data.get('city', profile.city)
        profile.country = data.get('country', profile.country)

        user.save()  # Save the updated user data
        profile.save()  # Save the updated profile data

        return Response({'message': 'Profile updated successfully'}, status=status.HTTP_200_OK)
