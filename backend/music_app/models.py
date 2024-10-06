from django.db import models

class Music(models.Model):
    title = models.CharField(max_length=255)
    artist = models.CharField(max_length=255)
    album = models.CharField(max_length=255, null=True, blank=True)
    release_date = models.DateField(null=True, blank=True)
    genre = models.CharField(max_length=100, null=True, blank=True)

    def __str__(self):
        return f'{self.title} by {self.artist}'
