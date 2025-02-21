from django.contrib import admin
from .models import Scholar, PlayList, Video

@admin.register(Scholar)
class ScholarAdmin(admin.ModelAdmin):
    list_display = ('id', 'name', 'created_at')
    search_fields = ('name',)

@admin.register(PlayList)
class PlayListAdmin(admin.ModelAdmin):
    list_display = ('id', 'title', 'scholar', 'created_at')  
    search_fields = ('title',)
    list_filter = ('scholar',)  # ✅ إضافة تصفية للعالم

@admin.register(Video)
class VideoAdmin(admin.ModelAdmin):
    list_display = ('id', 'title', 'video_id', 'playlist', 'created_at')
    search_fields = ('title', 'video_id')
    list_filter = ('playlist__scholar',)  # ✅ التأكد من تصفية الفيديوهات بناءً على العالم
    autocomplete_fields = ('playlist',)  # ✅ تفعيل البحث الذكي داخل القوائم

    def get_form(self, request, obj=None, **kwargs):
        form = super().get_form(request, obj, **kwargs)
        form.base_fields['playlist'].queryset = PlayList.objects.all()
        return form
