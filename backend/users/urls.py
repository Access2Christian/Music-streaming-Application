from django.urls import path
from .views import RegisterView, LoginView, ProfileView

urlpatterns = [
    path('api/register/', RegisterView.as_view(), name='register'),  # Route for user registration
    path('api/login/', LoginView.as_view(), name='login'),          # Route for user login
    path('api/profile/', ProfileView.as_view(), name='profile'),    # Route for fetching and updating user profile
]


