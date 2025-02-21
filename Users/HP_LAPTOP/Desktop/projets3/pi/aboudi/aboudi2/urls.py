# your_app_name/urls.py
from django.urls import path
from . import views

urlpatterns = [
    path('scholars/', views.get_scholars, name='get_scholars'),
    path('playlists/<int:scholar_id>/', views.get_playlists_by_scholar, name='get_playlists_by_scholar'),
    path('videos/', views.get_videos, name='get_videos'),
    path('downloads/', views.downloaded_videos, name='downloaded_videos'),
    path('downloads/<str:video_id>/', views.delete_video, name='delete_video'),
    path('playlists/add/', views.add_playlist, name='add_playlist'),
    path('videos/add/', views.add_video, name='add_video'),
    path('downloads/save/', views.save_downloaded_video, name='save_downloaded_video'),

]