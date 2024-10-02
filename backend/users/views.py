from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.authtoken.models import Token  # For token authentication
from .models import User
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
        
        serializer = UserSerializer(data=data)
        if serializer.is_valid():
            # Save the user, ensuring password is hashed
            user = serializer.save()
            user.set_password(data['password'])
            user.save()
            
            # Generate a token for the newly registered user
            token, created = Token.objects.get_or_create(user=user)
            return Response({
                'user': serializer.data,
                'token': token.key,
                'message': 'Registration successful'
            }, status=status.HTTP_201_CREATED)
        
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class LoginView(APIView):
    def post(self, request):
        email = request.data.get('email')
        password = request.data.get('password')

        user = authenticate(username=email, password=password)
        if user:
            # Generate or retrieve the token
            token, created = Token.objects.get_or_create(user=user)
            return Response({
                'token': token.key,
                'message': 'Login successful'
            }, status=status.HTTP_200_OK)
        
        return Response({'error': 'Invalid email or password'}, status=status.HTTP_400_BAD_REQUEST)


class UserProfileView(APIView):
    permission_classes = [IsAuthenticated]  # Ensure user is logged in
    
    def get(self, request):
        user = request.user
        serializer = UserSerializer(user)
        return Response(serializer.data, status=status.HTTP_200_OK)
