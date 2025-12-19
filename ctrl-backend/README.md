# CTRL Backend - FastAPI Application

A FastAPI backend application with PostgreSQL database, authentication, and mood tracking features.

## 📋 Table of Contents

- [Prerequisites](#prerequisites)
- [Local Development](#local-development)
- [Deploying to GitHub](#deploying-to-github)
- [Deploying to Render](#deploying-to-render)
- [Environment Variables](#environment-variables)
- [API Documentation](#api-documentation)

---

## Prerequisites

Before you begin, make sure you have:

- Python 3.11 or higher
- Git installed
- A GitHub account
- A Render account (free tier available)
- PostgreSQL database (provided by Render)

---

## 🚀 Local Development

### 1. Clone the Repository

```bash
git clone <your-repo-url>
cd ctrl-backend
```

### 2. Create Virtual Environment

```bash
python -m venv venv

# On Windows
venv\Scripts\activate

# On Mac/Linux
source venv/bin/activate
```

### 3. Install Dependencies

```bash
pip install -r requirements.txt
```

### 4. Set Up Environment Variables

Create a `.env` file in the root directory:

```bash
cp .env.example .env
```

Edit `.env` with your local database credentials.

### 5. Run with Docker (Recommended)

```bash
docker-compose up --build
```

The API will be available at `http://localhost:8080`

### 6. Run Migrations

```bash
alembic upgrade head
```

### 7. Run Without Docker

```bash
uvicorn app.main:app --host 0.0.0.0 --port 8080 --reload
```

---

## 📤 Deploying to GitHub

### Step 1: Initialize Git Repository (if not already done)

```bash
cd ctrl-backend
git init
```

### Step 2: Add All Files

```bash
git add .
```

### Step 3: Create Initial Commit

```bash
git commit -m "Initial commit: FastAPI backend with PostgreSQL"
```

### Step 4: Create GitHub Repository

1. Go to [GitHub](https://github.com) and sign in
2. Click the **"+"** icon in the top right → **"New repository"**
3. Name your repository (e.g., `ctrl-backend`)
4. Choose **Public** or **Private**
5. **DO NOT** initialize with README, .gitignore, or license (we already have these)
6. Click **"Create repository"**

### Step 5: Connect Local Repository to GitHub

GitHub will show you commands. Use these (replace `YOUR_USERNAME` and `YOUR_REPO_NAME`):

```bash
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO_NAME.git
git branch -M main
git push -u origin main
```

### Step 6: Verify Upload

Go to your GitHub repository page and verify all files are uploaded.

---

## 🌐 Deploying to Render

### Option 1: Using render.yaml (Recommended - Automated Setup)

Render can automatically set up your services using the `render.yaml` file.

#### Step 1: Push to GitHub

Make sure your code is pushed to GitHub (follow steps above).

#### Step 2: Connect Render to GitHub

1. Go to [Render Dashboard](https://dashboard.render.com)
2. Click **"New +"** → **"Blueprint"**
3. Connect your GitHub account if not already connected
4. Select your repository (`ctrl-backend`)
5. Render will detect `render.yaml` and set up services automatically
6. Click **"Apply"**

#### Step 3: Set Environment Variables

After services are created, go to each service and add environment variables:

**For Web Service:**
- `DATABASE_URL` - Will be auto-populated from PostgreSQL service
  - **Note**: If you get database connection errors, you may need to manually set `DATABASE_URL` and change `postgresql://` to `postgresql+psycopg://` in the connection string
- `SECRET_KEY` - Generate a secure random string
- `FIREBASE_PROJECT_ID` - Your Firebase project ID (if using Firebase)
- `ACCESS_TOKEN_EXPIRE_MINUTES` - 60 (or your preferred value)

**For PostgreSQL Database:**
- No additional env vars needed (Render manages this)

#### Step 4: Deploy

Render will automatically deploy. Check the logs to ensure migrations run successfully.

---

### Option 2: Manual Setup on Render

#### Step 1: Create PostgreSQL Database

1. Go to [Render Dashboard](https://dashboard.render.com)
2. Click **"New +"** → **"PostgreSQL"**
3. Configure:
   - **Name**: `ctrl-db` (or your preferred name)
   - **Database**: `ctrl_db`
   - **User**: `ctrl_user` (or auto-generated)
   - **Region**: Choose closest to your users
   - **PostgreSQL Version**: 15
   - **Plan**: Free (or paid for production)
4. Click **"Create Database"**
5. **IMPORTANT**: Copy the **Internal Database URL** (starts with `postgresql://`)

#### Step 2: Create Web Service

1. Click **"New +"** → **"Web Service"**
2. Connect your GitHub repository
3. Configure:
   - **Name**: `ctrl-backend`
   - **Region**: Same as database
   - **Branch**: `main` (or your default branch)
   - **Root Directory**: Leave empty (or `ctrl-backend` if repo is in subfolder)
   - **Runtime**: `Python 3`
   - **Build Command**: 
     ```bash
     pip install -r requirements.txt && alembic upgrade head
     ```
   - **Start Command**: 
     ```bash
     uvicorn app.main:app --host 0.0.0.0 --port $PORT
     ```
   - **Plan**: Free (or paid for production)

#### Step 3: Add Environment Variables

In the Web Service settings, go to **"Environment"** and add:

| Key | Value | Description |
|-----|-------|-------------|
| `DATABASE_URL` | `postgresql://...` | **Internal Database URL** from Step 1<br>**Note**: If connection fails, try changing `postgresql://` to `postgresql+psycopg://` |
| `SECRET_KEY` | `your-secret-key-here` | Generate a secure random string |
| `FIREBASE_PROJECT_ID` | `your-firebase-id` | Your Firebase project ID (optional) |
| `ACCESS_TOKEN_EXPIRE_MINUTES` | `60` | Token expiration time |

**How to generate SECRET_KEY:**
```bash
python -c "import secrets; print(secrets.token_urlsafe(32))"
```

#### Step 4: Deploy

1. Click **"Create Web Service"**
2. Render will build and deploy your application
3. Check the **"Logs"** tab to monitor deployment
4. Once deployed, your API will be available at: `https://ctrl-backend.onrender.com` (or your custom domain)

#### Step 5: Verify Deployment

1. Visit your service URL: `https://your-service.onrender.com/api/v1/health`
2. Check API docs: `https://your-service.onrender.com/docs`
3. Verify database connection in logs

---

## 🔐 Environment Variables

Create a `.env` file for local development (see `.env.example`):

```env
# Database
DATABASE_URL=postgresql+psycopg://user:password@localhost:5432/ctrl_db

# Security
SECRET_KEY=your-secret-key-here

# Firebase (Optional)
FIREBASE_PROJECT_ID=your-firebase-project-id

# Token Settings
ACCESS_TOKEN_EXPIRE_MINUTES=60
```

**⚠️ Important**: Never commit `.env` file to GitHub! It's already in `.gitignore`.

---

## 📚 API Documentation

Once deployed, access:

- **Swagger UI**: `https://your-service.onrender.com/docs`
- **ReDoc**: `https://your-service.onrender.com/redoc`
- **Health Check**: `https://your-service.onrender.com/api/v1/health`

---

## 🐛 Troubleshooting

### Database Connection Issues

- Verify `DATABASE_URL` uses **Internal Database URL** on Render
- Check database is running and accessible
- Ensure migrations have run: `alembic upgrade head`

### Build Failures

- Check Python version (3.11+)
- Verify all dependencies in `requirements.txt`
- Check build logs for specific errors

### Migration Issues

- Ensure `DATABASE_URL` is set correctly
- Check database user has proper permissions
- Review migration files in `migrations/versions/`

### Port Issues

- Render uses `$PORT` environment variable automatically
- Don't hardcode port 8080 in production
- Update start command to use `$PORT`

---

## 📝 Project Structure

```
ctrl-backend/
├── app/
│   ├── core/          # Configuration
│   ├── models/         # SQLAlchemy models
│   ├── routers/        # API routes
│   ├── schemas/        # Pydantic schemas
│   ├── services/       # Business logic
│   └── utils/          # Utilities
├── migrations/         # Alembic migrations
├── tests/              # Test files
├── Dockerfile          # Docker configuration
├── docker-compose.yml  # Docker Compose setup
├── requirements.txt    # Python dependencies
├── alembic.ini         # Alembic configuration
└── render.yaml         # Render infrastructure config
```

---

## 🔄 Updating Deployment

After making changes:

1. Commit changes to Git:
   ```bash
   git add .
   git commit -m "Your commit message"
   git push origin main
   ```

2. Render will automatically detect changes and redeploy

3. Monitor deployment in Render dashboard logs

---

## 📞 Support

For issues or questions:
- Check Render logs: Dashboard → Your Service → Logs
- Review API documentation at `/docs`
- Check GitHub issues

---

## 📄 License

[Your License Here]

---

**Happy Deploying! 🚀**

