from django.urls import path
from . import views

urlpatterns = [
    path('music/', views.fetch_music, name='fetch_music'),  # External API music fetching
    path('music/local/', views.fetch_local_music, name='fetch_local_music'),  # Local DB music fetching
]
