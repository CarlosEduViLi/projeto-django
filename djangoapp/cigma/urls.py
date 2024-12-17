from django.urls import path
from cigma.views import index

app_name = 'cigma'

urlpatterns = [
    #cigma:index
    path('', index, name='index'),
]