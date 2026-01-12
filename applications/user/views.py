from rest_framework.decorators import action
from rest_framework.response import Response

from component.drf.viewsets import GenericViewSet



from rest_framework_simplejwt.views import TokenObtainPairView
from rest_framework_simplejwt.serializers import TokenObtainPairSerializer

class CustomTokenObtainPairSerializer(TokenObtainPairSerializer):
    def validate(self, attrs):
        data = super().validate(attrs)
        # 适配旧版前端：前端 login.vue 期望返回 {token: "..."}
        # simplejwt 默认返回 {access: "...", refresh: "..."}
        data['token'] = data['access']
        return data

class CustomTokenObtainPairView(TokenObtainPairView):
    serializer_class = CustomTokenObtainPairSerializer

class UserViewSets(GenericViewSet):
    @action(methods=['GET'], detail=False)
    def info(self, request, *args, **kwargs):
        return Response({
            "username": request.user.username,
            "role": "admin" if request.user.is_superuser else "other"
        })
