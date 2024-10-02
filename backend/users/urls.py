from django.urls import path
from .views import LoginView, UserProfileView

urlpatterns = [
    path('profile/', UserProfileView.as_view(), name='user_profile'),
    path('login/', LoginView.as_view(), name='user_login'),  # Changed to LoginView
]


