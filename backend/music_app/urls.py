from django.urls import path
from . import views

urlpatterns = [
    path('music/<str:search_term>/', views.fetch_music_view, name='fetch_music'),  # External API music fetching
    path('music/local/', views.fetch_local_music, name='fetch_local_music'),  # Local DB music fetching
    path('music/artist/<str:artist_id>/latest/', views.latest_release_view, name='latest_release'),  # Latest release for artist
]

