import os
from pathlib import Path
from decouple import config  # Import config from python-decouple

# Define BASE_DIR
BASE_DIR = Path(__file__).resolve().parent.parent

# Security settings
SECRET_KEY = config('SECRET_KEY', default='your-secret-key')  # Use decouple for SECRET_KEY
DEBUG = config('DEBUG', default=True, cast=bool)  # Use decouple for DEBUG
ALLOWED_HOSTS = []  # Update with your allowed hosts in production

# Application definition
INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'corsheaders',  # Add corsheaders to INSTALLED_APPS
    'rest_framework',
    'rest_framework.authtoken',
    'users',
    'api',
    'music_app',
]

# Middleware definition
MIDDLEWARE = [
    'corsheaders.middleware.CorsMiddleware',  # Ensure this is at the top
    'django.middleware.security.SecurityMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
]

# Database settings
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': BASE_DIR / 'db.sqlite3',
    }
}

# Static files
STATIC_URL = '/static/'

# CORS configuration
CORS_ALLOW_ALL_ORIGINS = True  # Allow all origins for CORS

# REST framework configuration
REST_FRAMEWORK = {
    'DEFAULT_AUTHENTICATION_CLASSES': (
        'rest_framework_simplejwt.authentication.JWTAuthentication',
    ),
}
