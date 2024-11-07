from django.urls import path
from . import views

urlpatterns = [
    path('music/<str:search_term>/', views.fetch_music_view, name='fetch_music'),  # External API music fetching
]

