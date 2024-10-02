# music_app/serializers.py
from rest_framework import serializers
from django.contrib.auth.models import User
from django.contrib.auth.hashers import make_password  # For hashing passwords

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['email', 'password']
        extra_kwargs = {'password': {'write_only': True}}  # Password should be write-only

    def create(self, validated_data):
        # Hash the password before saving the user
        validated_data['password'] = make_password(validated_data['password'])
        user = User(**validated_data)
        user.save()
        return user

    def update(self, instance, validated_data):
        # Update the user instance with new data
        for attr, value in validated_data.items():
            if attr == 'password':
                # Hash the new password
                value = make_password(value)
            setattr(instance, attr, value)
        instance.save()
        return instance
