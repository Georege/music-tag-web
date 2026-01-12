# Music Tag Web 使用说明文档

## 📚 目录

- [项目简介](#项目简介)
- [技术架构](#技术架构)
- [功能特性](#功能特性)
- [环境要求](#环境要求)
- [部署方式](#部署方式)
- [功能使用指南](#功能使用指南)
- [项目结构说明](#项目结构说明)
- [配置说明](#配置说明)
- [常见问题](#常见问题)
- [进阶使用](#进阶使用)

---

## 项目简介

**Music Tag Web** 是一款基于 Web 的音乐标签编辑器，专为远程服务器上的音乐库管理设计。它可以编辑歌曲的标题、专辑、艺术家、歌词、封面等元数据信息，支持 FLAC, APE, WAV, AIFF, WV, TTA, MP3, M4A, OGG, MPC, OPUS, WMA, DSF, MP4 等主流音频格式。

### 设计初衷

本项目作为 Navidrome 的边车应用而开发，解决了传统桌面端音乐标签编辑器（如 MusicTag、Mp3tag）无法直接编辑远程服务器音乐文件的痛点。

### 适用场景

- NAS 用户的音乐库管理
- 远程服务器音乐文件元数据编辑
- 音乐流媒体服务的辅助工具
- 批量音乐标签整理与刮削

---

## 技术架构

### 后端技术栈

| 技术/框架 | 版本 | 用途 |
|---------|------|------|
| 技术/框架 | 版本 | 用途 |
|---------|------|------|
| Python | 3.10+ | 运行环境 |
| Django | 3.2.23 | Web 框架 (LTS) |
| Django REST Framework | 3.14.0 | RESTful API |
| Celery | 5.2.7 | 异步任务队列 |
| music-tag | 0.4.3 | 音频元数据处理核心库 |
| Pillow | 9.4.0 | 图像处理 |
| gunicorn + gevent | 20.1.0 / 21.12.0 | WSGI 服务器 |

### 前端技术栈

| 技术/框架 | 版本 | 用途 |
|---------|------|------|
| Vue.js | 2.5.2 | 前端框架 |
| View Design (iView) | 4.1.3 | UI 组件库 |
| Vuex | 2.3.1 | 状态管理 |
| Vue Router | 3.0.1 | 路由管理 |
| ECharts | 5.1.1 | 数据可视化 |
| Axios | 0.16.2 | HTTP 客户端 |

### 数据存储

- **默认数据库**: SQLite3（开箱即用，无需额外配置）
- **可选数据库**: MySQL（适用于大规模部署）
- **缓存/消息队列**: Redis（启用 Celery 时需要）

### 架构特点

- **前后端分离**: Vue.js 单页应用 + Django REST API
- **容器化部署**: 提供 Docker 镜像，支持一键部署
- **模块化设计**: 应用层、组件层分离，便于维护扩展
- **异步任务支持**: 通过 Celery 处理耗时操作（如批量标签刮削）

---

## 功能特性

### 核心功能

#### 1. 音乐元数据管理
- ✅ 查看音频文件的完整元数据信息
- ✅ 编辑标题、艺术家、专辑、年份、流派等标签
- ✅ 自定义上传/导出专辑封面
- ✅ 批量编辑多个文件的元数据

#### 2. 智能标签刮削
- ✅ 从多个音乐平台自动获取标签信息
  - 网易云音乐
  - QQ 音乐
  - 酷我音乐
  - 咪咕音乐
  - 酷狗音乐
- ✅ 音乐指纹识别技术（即使文件无元数据也可识别）
- ✅ 批量自动匹配与修改标签

#### 3. 文件整理
- ✅ 按艺术家、专辑自动分组
- ✅ 自定义多级目录结构
- ✅ 文件名拆分解包（从文件名提取元数据）
- ✅ 文件排序（按文件名/大小/修改时间）

#### 4. 高级编辑功能
- ✅ 歌词编辑与翻译
- ✅ 文本批量替换（清理脏数据）
- ✅ 繁简体转换
- ✅ 整轨音乐文件切割
- ✅ 音频格式转换（基于 FFmpeg）

#### 5. 播放与统计
- ✅ 在线音乐播放
- ✅ 播放记录统计
- ✅ 图表可视化展示（柱形图、折线图）
- ✅ 支持小爱同学播放本地音乐
- ✅ 网盘音乐播放支持

#### 6. Subsonic API
- ✅ 兼容 Subsonic 协议
- ✅ 可与第三方音乐客户端集成
- ✅ 支持音频转码（默认 MP3）

#### 7. 其他特性
- ✅ 完整的操作记录日志
- ✅ 移动端 UI 适配
- ✅ 多用户权限管理
- ✅ 支持反向代理（Nginx）

---

## 环境要求

### Docker 部署（推荐）

| 项目 | 要求 |
|-----|------|
| Docker | ≥ 19.03 |
| Docker Compose | ≥ 1.27（可选）|
| CPU 架构 | amd64 / arm64 |

### 源码部署

| 项目 | 要求 |
|-----|------|
| Python | ≥ 3.10 |
| uv | ≥ 0.1.0 | 包管理工具 |
| Node.js | ≥ 16.0.0 | 前端构建 |

| 操作系统 | Linux / macOS / Windows |

### 可选依赖

| 服务 | 用途 | 是否必需 |
|-----|------|---------|
| MySQL | 数据库（替代 SQLite）| 否 |
| Redis | Celery 消息队列 | 否（不启用异步任务可省略）|
| FFmpeg | 音频格式转换 | 否（需要格式转换功能时安装）|

---

## 部署方式

### 方式一：源码部署

#### 前置准备

```bash
# 克隆项目
git clone https://github.com/xhongc/music-tag-web.git
cd music-tag-web

# 安装 uv (如果尚未安装)
pip install uv
```

#### 后端部署

```bash
# --- 手动执行步骤 ---

# 1. 创建环境并安装依赖
uv venv
uv add -r requirements.txt

# 2. 数据库迁移
uv run python manage.py migrate

# 3. 创建超级用户
uv run python manage.py createsuperuser

# 4. 收集静态文件
uv run python manage.py collectstatic --noinput

# 5. 启动开发服务器
uv run python manage.py runserver 0.0.0.0:8002

# Windows 用户推荐直接使用启动脚本
./run.ps1
```

#### 前端部署

```bash
cd web

# 安装依赖
npm install

# 开发模式
npm run dev

# 生产构建
npm run build
```

#### 生产环境启动

```bash
# 使用 gunicorn（推荐）
gunicorn django_vue_cli.wsgi:application \
  --bind 0.0.0.0:8002 \
  --workers 4 \
  --worker-class gevent \
  --timeout 300
```


### 方式二：Docker Compose 部署

#### 创建 `docker-compose.yml`

```yaml
version: '3'

services:
  music-tag:
    image: xhongc/music_tag_web:latest
    container_name: music-tag-web
    ports:
      - "8002:8002"
    volumes:
      - /path/to/your/music:/app/media:rw
      - /path/to/your/config:/app/data
    restart: unless-stopped
```

#### 启动服务

```bash
# 启动
docker-compose up -d

# 查看日志
docker-compose logs -f

# 停止
docker-compose down
```

---

### 方式三：完整 Docker Compose 部署（含 MySQL + Redis + Nginx）

适用于生产环境或大规模部署场景。

```yaml
version: '3'

services:
  django:
    image: xhongc/music_tag_web:latest
    container_name: music-tag-web
    expose:
      - "8001"
    volumes:
      - /path/to/your/music:/app/media:z
    restart: always
    environment:
      dockerrun: "yes"
    depends_on:
      - redis
      - db
    networks:
      - internal
    command: /start

  celeryworker:
    image: xhongc/music_tag_web:latest
    container_name: music_celeryworker
    environment:
      dockerrun: "yes"
    volumes:
      - /path/to/your/music:/app/media:z
    networks:
      - internal
    depends_on:
      - redis
      - db
    command: /start-celeryworker

  celerybeat:
    image: xhongc/music_tag_web:latest
    container_name: music_celerybeat
    environment:
      dockerrun: "yes"
    networks:
      - internal
    depends_on:
      - redis
      - db
    command: /start-celerybeat

  redis:
    image: redis:latest
    restart: always
    container_name: music_redis
    networks:
      - internal
    expose:
      - "6379"

  db:
    image: mysql:latest
    restart: always
    container_name: music_mysql
    environment:
      MYSQL_DATABASE: music3
      MYSQL_ROOT_PASSWORD: 123456
    networks:
      - internal
    expose:
      - "3306"

  nginx:
    image: nginx:latest
    restart: always
    container_name: music_nginx
    ports:
      - "9150:80"
    networks:
      - internal
    depends_on:
      - django
    volumes:
      - /path/to/nginx.conf:/etc/nginx/nginx.conf:ro
      - /path/to/your/music:/app/media:z

networks:
  internal:
```
---

## 功能使用指南

### 首次使用流程

#### 1. 登录系统

访问 `http://your-server:8002/admin`，使用默认账号 `admin/admin` 登录。

#### 2. 修改默认密码

登录后进入用户管理界面，修改 admin 账户密码。

#### 3. 配置音乐库路径

在管理界面中配置音乐文件的扫描路径（如已通过 Docker 挂载，则无需此步骤）。

#### 4. 扫描音乐文件

点击"扫描音乐库"，系统将自动索引挂载路径下的所有音频文件。

---

### 音乐标签编辑

#### 单文件编辑

1. 在音乐列表中选择目标文件
2. 点击进入详情页
3. 编辑各项元数据字段
4. 点击"保存"应用更改

#### 批量编辑

1. 勾选多个音乐文件
2. 点击"批量编辑"
3. 选择要修改的字段
4. 输入新值
5. 确认应用

---

### 自动标签刮削

#### 在线匹配

1. 选择需要刮削的文件
2. 点击"自动刮削"
3. 选择音乐平台（网易云、QQ 音乐等）
4. 系统自动搜索并匹配最佳结果
5. 预览结果，确认应用

#### 音乐指纹识别

适用于无元数据或元数据错误的文件：

1. 选择文件
2. 点击"指纹识别"
3. 系统分析音频特征自动识别
4. 选择匹配结果并应用

---

### 文件整理

#### 按规则整理

1. 进入"文件整理"模块
2. 选择整理规则（如：`艺术家/专辑/曲目`）
3. 预览整理后的目录结构
4. 确认执行

#### 自定义规则

支持使用变量构建路径：
- `{artist}`: 艺术家
- `{album}`: 专辑
- `{title}`: 标题
- `{year}`: 年份

示例: `{artist}/{year} - {album}/{track} - {title}`

---

### 歌词管理

#### 编辑歌词

1. 打开歌曲详情
2. 点击"歌词"标签
3. 在编辑器中修改歌词
4. 保存更改

#### 歌词翻译

1. 在歌词编辑界面
2. 点击"翻译"
3. 选择目标语言
4. 系统自动翻译并生成双语歌词

---

### 格式转换

#### 音频转码

1. 选择源文件
2. 点击"格式转换"
3. 选择目标格式（MP3、FLAC、M4A 等）
4. 设置比特率、采样率等参数
5. 开始转换

⚠️ **注意**: 需要系统安装 FFmpeg

---

### 播放统计

#### 查看统计

1. 进入"统计"模块
2. 选择时间范围
3. 查看图表展示：
   - 播放次数排行
   - 时间分布趋势
   - 艺术家/专辑分析

---

### Subsonic 使用

#### 配置客户端

1. 在设置中启用 Subsonic 服务
2. 获取 Subsonic API URL: `http://your-server:8002/subsonic/`
3. 在第三方客户端（如 DSub、Ultrasonic）中配置：
   - 服务器地址: `http://your-server:8002/subsonic`
   - 用户名: 您的账号
   - 密码: 您的密码

---

## 项目结构说明

```
music-tag-web/
├── applications/              # Django 应用层
│   ├── music/                # 音乐模块
│   ├── subsonic/             # Subsonic API 模块
│   ├── task/                 # 任务管理模块
│   ├── user/                 # 用户管理模块
│   └── utils/                # 工具函数
├── component/                # 公共组件层
│   ├── async_request/        # 异步请求组件
│   ├── drf/                  # DRF 扩展组件
│   ├── music_tag/            # 音乐标签处理核心
│   ├── mz/                   # 音乐平台接口
│   ├── translators/          # 翻译组件
│   ├── utils/                # 通用工具
│   └── zhconv/               # 繁简转换
├── compose/                  # Docker Compose 配置
│   ├── local/                # 本地部署配置
│   │   ├── django/           # Django 容器配置
│   │   └── nginx/            # Nginx 配置
│   └── prod/                 # 生产环境配置
├── django_vue_cli/           # Django 项目配置
│   ├── settings.py           # 核心配置文件
│   ├── urls.py               # 路由配置
│   ├── wsgi.py               # WSGI 入口
│   └── celery_app.py         # Celery 配置
├── static/                   # 静态文件（前端构建产物）
├── templates/                # Django 模板
├── web/                      # Vue.js 前端项目
│   ├── src/                  # 源代码
│   │   ├── api/              # API 接口定义
│   │   ├── assets/           # 静态资源
│   │   ├── components/       # Vue 组件
│   │   ├── router/           # 路由配置
│   │   ├── views/            # 页面视图
│   │   ├── vuex/             # Vuex 状态管理
│   │   └── main.js           # 入口文件
│   ├── build/                # Webpack 构建配置
│   ├── config/               # 项目配置
│   └── package.json          # 前端依赖
├── media/                    # 音乐文件存储目录（挂载点）
├── requirements.txt          # Python 依赖
├── manage.py                 # Django 管理脚本
├── local.yml                 # Docker Compose 本地配置
└── README.md                 # 项目说明
```

### 核心模块说明

#### applications/music
- 音乐文件模型定义
- 元数据读写接口
- 文件扫描与索引逻辑

#### applications/task
- 批量任务管理
- 刮削任务调度
- 转码任务处理

#### component/music_tag
- music-tag 库封装
- 支持的音频格式处理
- 元数据标准化

#### component/mz
- 各音乐平台 API 对接
- 搜索与匹配算法
- 数据清洗与标准化

---

## 配置说明

### Django 配置文件

位置: `django_vue_cli/settings.py`

#### 数据库配置

**默认（SQLite）**:
```python
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': os.path.join(BASE_DIR, 'db.sqlite3'),
    }
}
```

**切换到 MySQL**:
```python
DATABASES = {
    "default": {
        "ENGINE": "django.db.backends.mysql",
        "NAME": 'music3',
        "USER": "root",
        "PASSWORD": "your_password",
        "HOST": "127.0.0.1",
        "PORT": "3306",
    },
}
```

#### Celery 配置

启用异步任务支持（设置 `IS_USE_CELERY = True`）:

```python
IS_USE_CELERY = True
BROKER_URL = "redis://127.0.0.1:6379/1"
CELERY_TIMEZONE = 'Asia/Shanghai'
```

#### 媒体文件配置

```python
MEDIA_URL = '/media/'
MEDIA_ROOT = os.path.join(BASE_DIR, "media")
```

#### Subsonic 配置

```python
SUBSONIC_DEFAULT_TRANSCODING_FORMAT = "mp3"
```

### 本地配置文件

创建 `local_settings.py` 覆盖默认配置（此文件会被自动导入）：

```python
# local_settings.py
DEBUG = True
ALLOWED_HOSTS = ['your-domain.com', '192.168.1.100']

DATABASES = {
    "default": {
        "ENGINE": "django.db.backends.mysql",
        "NAME": 'music_production',
        "USER": "music_user",
        "PASSWORD": "secure_password",
        "HOST": "db.example.com",
        "PORT": "3306",
    },
}
```

### 环境变量

| 变量名 | 说明 | 默认值 |
|-------|------|-------|
| `dockerrun` | 是否在 Docker 中运行 | `no` |
| `SITE_LOGIN` | 是否启用站点登录 | `true` |

---

## 常见问题

### 部署相关

#### Q1: Docker 容器无法启动？

**排查步骤**:
1. 检查端口是否被占用: `netstat -tuln | grep 8002`
2. 查看容器日志: `docker logs music-tag-web`
3. 验证挂载路径是否存在且有读写权限

#### Q2: 音乐文件扫描不到？

**可能原因**:
- 挂载路径配置错误
- 容器内无权限访问文件
- 文件格式不支持

**解决方法**:
```bash
# 检查挂载是否成功
docker exec -it music-tag-web ls -la /app/media

# 修改文件权限
chmod -R 755 /path/to/your/music
```

#### Q3: V1 和 V2 版本如何选择？

| 版本 | 端口 | 特点 | 推荐场景 |
|-----|------|------|---------|
| V1 | 8001 | 稳定版，功能完善 | 追求稳定性 |
| V2 | 8002 | 最新版，UI 优化 | 体验新功能 |

### 功能使用相关

#### Q4: 刮削不到歌曲信息？

**解决方法**:
1. 尝试不同的音乐平台
2. 使用音乐指纹识别
3. 手动搜索并选择正确的匹配结果

#### Q5: 格式转换失败？

**检查 FFmpeg 安装**:
```bash
# Docker 容器内
docker exec -it music-tag-web ffmpeg -version

# 源码部署
ffmpeg -version
```

#### Q6: Subsonic 无法连接？

**检查清单**:
- URL 是否正确（注意末尾的 `/subsonic/`）
- 用户名密码是否正确
- 防火墙是否开放端口

### 性能优化

#### Q7: 大量文件扫描很慢？

**优化建议**:
1. 启用 MySQL 替代 SQLite
2. 启用 Celery 异步任务
3. 配置 Redis 缓存

#### Q8: 内存占用过高？

**调整 Docker 资源限制**:
```yaml
services:
  music-tag:
    # ...
    deploy:
      resources:
        limits:
          memory: 1G
        reservations:
          memory: 512M
```

### 安全相关

#### Q9: 如何修改默认密码？

**方法一（Web 界面）**:
1. 访问 `/admin`
2. 进入用户管理
3. 编辑 admin 用户

**方法二（命令行）**:
```bash
docker exec -it music-tag-web python manage.py changepassword admin
```

#### Q10: 如何实现外网访问？

**推荐方案**:
1. 使用反向代理（Nginx）并配置 HTTPS
2. 配置防火墙规则
3. 使用 Zerotier/Tailscale 等内网穿透

**Nginx 示例配置**:
```nginx
server {
    listen 80;
    server_name music.example.com;

    location / {
        proxy_pass http://127.0.0.1:8002;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    location /media/ {
        alias /path/to/your/music/;
    }
}
```

---

## 进阶使用

### 自定义音乐平台接口

编辑 `component/mz/` 模块，添加新的音乐平台支持。

### 扩展元数据字段

修改 `applications/music/models.py`，添加自定义字段。

### 定制 UI 主题

修改 `web/src/assets/` 中的样式文件。

### API 二次开发

所有 REST API 端点位于 `applications/*/views.py`，可基于此开发第三方客户端。

---

## 免责声明

本项目仅供**个人学习研究**使用，禁止任何形式的商业用途。使用本项目产生的版权数据，使用者务必在 24 小时内清除。详细条款请参阅项目 [LICENSE](LICENSE) 文件。
.
---
