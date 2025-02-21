from django.db import models
from django.utils import timezone  

class Scholar(models.Model):
    id = models.AutoField(primary_key=True)
    name = models.CharField(max_length=255, unique=True)
    image_url = models.URLField()
    created_at = models.DateTimeField(default=timezone.now)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return self.name

class PlayList(models.Model):
    id = models.AutoField(primary_key=True)
    title = models.CharField(max_length=255, unique=True)
    scholar = models.ForeignKey(Scholar, on_delete=models.CASCADE, related_name="playlists")
    created_at = models.DateTimeField(default=timezone.now)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f"{self.title} - {self.scholar.name}"

class Video(models.Model):
    id = models.AutoField(primary_key=True)
    title = models.CharField(max_length=255)
    video_id = models.CharField(max_length=100, unique=True)
    download_url = models.URLField()
    is_favorite = models.BooleanField(default=False)
    playlist = models.ForeignKey(PlayList, on_delete=models.CASCADE, related_name="videos", null=True, blank=True)
    created_at = models.DateTimeField(default=timezone.now)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return self.title

class DownloadedVideo(models.Model):
    title = models.CharField(max_length=255)
    video_id = models.CharField(max_length=100, unique=True)
    local_path = models.CharField(max_length=255)
    thumbnail_path = models.CharField(max_length=255)
    download_date = models.DateTimeField(default=timezone.now)