# -*- coding: utf-8 -*-

from django.conf.urls import include, url
from django.contrib import admin

from blog import views

admin.autodiscover()

from django.urls import path
from django.views.generic import RedirectView

urlpatterns = [
#    url(r'^$', views.IndexView.as_view(), name="index"),

    path('', RedirectView.as_view(url='/hitcount-detail-view-count-hit/1/'), name='go-to-youtube'),

    url(r'^generic-detail-view-ajax/(?P<pk>\d+)/$',
        views.PostDetailJSONView.as_view(),
        name="ajax"),
    url(r'^hitcount-detail-view/(?P<pk>\d+)/$',
        views.PostDetailView.as_view(),
        name="detail"),
    url(r'^hitcount-detail-view-count-hit/(?P<pk>\d+)/$',
        views.PostCountHitDetailView.as_view(),
        name="detail-with-count"),

    # for our built-in ajax post view
    url(r'hitcount/', include('hitcount.urls', namespace='hitcount')),
]

try:
    urlpatterns.append(url(r'^admin/', include(admin.site.urls)))
except:
    urlpatterns.append(url(r'^admin/', admin.site.urls))
