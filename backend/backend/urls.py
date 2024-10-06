from django.contrib import admin
from django.urls import path, include

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/', include('api.urls')),  # Include the api app's URLs
     path('api/', include('music_app.urls')),  # Include music_app's URLs
]
