from django.urls import path 
from .import views

urlpatterns=[
    path('',views.home,name='home'),
    path('leaderboard',views.leaderboard_view,name='leaderboard'),
    path('search/users',views.search_users_view,name='search_users'),

    
]