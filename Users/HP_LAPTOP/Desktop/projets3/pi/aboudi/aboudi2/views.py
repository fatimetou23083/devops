from django.http import JsonResponse
from django.views.decorators.http import require_http_methods
from .models import Scholar, PlayList, Video, DownloadedVideo
from .forms import VideoForm
from .models import Scholar, PlayList,Video
from .forms import PlayListForm
import json
from django.views.decorators.csrf import csrf_exempt

@require_http_methods(["GET"])
def downloaded_videos(request):
    videos = DownloadedVideo.objects.all().order_by('-download_date')
    data = [{
        'title': video.title,
        'video_id': video.video_id,
        'local_path': video.local_path,
        'thumbnail_path': video.thumbnail_path,
        'download_date': video.download_date.isoformat()
    } for video in videos]
    return JsonResponse({'videos': data})

@require_http_methods(["DELETE"])
def delete_video(request, video_id):
    try:
        video = DownloadedVideo.objects.get(video_id=video_id)
        video.delete()
        return JsonResponse({'message': 'Video deleted successfully'})
    except DownloadedVideo.DoesNotExist:
        return JsonResponse({'error': 'Video not found'}, status=404)



@require_http_methods(["GET"])

def get_scholars(request):
    scholars = Scholar.objects.all()
    data = []

    for scholar in scholars:
        scholar_data = {
            "name": scholar.name,
            "imagePath": scholar.image_url,
            "playlists": []
        }

        for playlist in scholar.playlists.all():
            playlist_data = {
                "title": playlist.title,
                "videos": []
            }

            for video in playlist.videos.all():
                video_data = {
                    "title": video.title,
                    "video_id": video.video_id,
                    "download_url": video.download_url,
                    "is_favorite": video.is_favorite,
                }
                playlist_data["videos"].append(video_data)

            scholar_data["playlists"].append(playlist_data)

        data.append(scholar_data)

    return JsonResponse({"scholars": data})

from django.shortcuts import get_object_or_404

def add_video(request):
    if request.method == 'POST':
        form = VideoForm(request.POST)
        if form.is_valid():
            form.save()
            return JsonResponse({'message': 'Video added successfully'})
        else:
            return JsonResponse({'error': form.errors}, status=400)
    return JsonResponse({'error': 'Invalid request method'}, status=405)


@require_http_methods(["GET"])
def get_playlists_by_scholar(request, scholar_id):
    playlists = PlayList.objects.filter(scholar_id=scholar_id)
    data = [{'id': p.id, 'title': p.title} for p in playlists]
    return JsonResponse({'playlists': data})






def add_playlist(request):
    if request.method == 'POST':
        form = PlayListForm(request.POST)
        if form.is_valid():
            form.save()
            return JsonResponse({'message': 'Playlist added successfully'})  
    return JsonResponse({'error': 'Invalid data'}, status=400)






@require_http_methods(["GET"])
def get_videos(request):
    videos = Video.objects.all()
    data = [{
        'title': video.title,
        'video_id': video.video_id,
        'download_url': video.download_url,
        'is_favorite': video.is_favorite,
    } for video in videos]
    
    return JsonResponse({'videos': data})



@require_http_methods(["POST"])
@csrf_exempt  # ⚠️ تعطيل CSRF فقط إذا كنت تستخدم طلبات API من تطبيق خارجي
def save_downloaded_video(request):
    try:
        data = json.loads(request.body)

        video, created = DownloadedVideo.objects.get_or_create(
            video_id=data['video_id'],
            defaults={
                'title': data['title'],
                'local_path': data['local_path'],
                'thumbnail_path': data.get('thumbnail_path', ''),
            }
        )

        if created:
            return JsonResponse({'message': 'تم حفظ الفيديو بنجاح'}, status=201)
        else:
            return JsonResponse({'message': 'الفيديو موجود مسبقًا'}, status=200)

    except Exception as e:
        return JsonResponse({'error': str(e)}, status=400)