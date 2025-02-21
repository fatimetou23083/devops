from django import forms
from .models import PlayList, Video, Scholar

class PlayListForm(forms.ModelForm):
    class Meta:
        model = PlayList
        fields = ['title', 'scholar']

class VideoForm(forms.ModelForm):
    scholar = forms.ModelChoiceField(
        queryset=Scholar.objects.all(),
        required=True,
        label="اختر العالم"
    )
    
    playlist = forms.ModelChoiceField(
        queryset=PlayList.objects.none(),  
        required=True,
        label="اختر قائمة التشغيل"
    )

    class Meta:
        model = Video
        fields = ['title', 'video_id', 'download_url', 'is_favorite', 'scholar', 'playlist']

    def __init__(self, *args, **kwargs):
        super(VideoForm, self).__init__(*args, **kwargs)
       
        if self.data.get('scholar'):
            try:
                scholar_id = int(self.data.get('scholar'))
                self.fields['playlist'].queryset = PlayList.objects.filter(scholar_id=scholar_id)
            except (ValueError, TypeError):
                self.fields['playlist'].queryset = PlayList.objects.none()
        else:
            self.fields['playlist'].queryset = PlayList.objects.none()