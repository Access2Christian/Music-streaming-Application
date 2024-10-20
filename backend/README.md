
# Backend - Music Streaming App

## Project Structure

```plaintext
music_streaming_app/
├── backend/
│   ├── api/
│   │   ├── urls.py                  # URL routing for API endpoints
│   │   ├── views.py                 # API views handling requests and responses
│   │   └── serializers.py           # Serializers for converting complex data types to JSON
│   ├── migrations/                   # Database migrations for schema changes
│   ├── music_app/                    # Main application logic for the music app
│   │   └── models.py                # Data models for music-related entities
│   ├── users/                        # User authentication and management logic
│   │   ├── models.py                # User model
│   │   └── views.py                 # Views for user registration and login
│   ├── db.sqlite                     # SQLite database file
│   ├── manage.py                     # Command-line utility for managing the Django project
│   └── README.md                     # Documentation for the backend
```

## Description
The backend is responsible for managing data, user authentication, and serving API endpoints for the music streaming application. It is built using Django and Django REST Framework.

## Components Overview
- **api/**: Contains code for API endpoints, including views, URLs, and serializers.
- **migrations/**: Directory for database migration files, allowing for schema changes over time.
- **music_app/**: Main application logic, including models for music-related data.
- **users/**: Handles user authentication, registration, and management.
- **db.sqlite**: The SQLite database file where application data is stored.
- **manage.py**: A command-line utility that helps with various administrative tasks.
- **README.md**: Documentation for the backend.

## Getting Started

### Prerequisites
- Python 3.x
- Django
- Django REST Framework
- SQLite (comes pre-configured with Django)

### Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/Access2Christian/Music-streaming-Application.git
   cd backend
   ```

2. Set up a virtual environment (optional but recommended):

   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows use `venv\Scripts\activate`
   ```

3. Install the required packages:

   ```bash
   pip install -r requirements.txt  # Create a requirements.txt file if you haven't already
   ```

4. Run database migrations:

   ```bash
   python manage.py migrate
   ```

5. Start the Django development server:

   ```bash
   python manage.py runserver
   ```

## Usage
- The backend API can be accessed at `http://127.0.0.1:8000/api/`.
- Use endpoints for user registration, login, and fetching music data.
- Token-based authentication is implemented for secure access.

## Contributing
Contributions are welcome! Please submit a pull request or open an issue.

## License
This project is licensed under the MIT License. See the LICENSE file for details.
