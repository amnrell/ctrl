# ⚡ Quick Start Guide

## 🎯 Fastest Way to Deploy to Render

### Step 1: Push to GitHub (5 minutes)

```bash
# Navigate to your project
cd ctrl-backend

# Initialize git (if not already done)
git init

# Add all files
git add .

# Commit
git commit -m "Initial commit: Ready for Render deployment"

# Create repository on GitHub.com, then:
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO_NAME.git
git branch -M main
git push -u origin main
```

### Step 2: Deploy to Render (10 minutes)

#### Option A: Using Blueprint (Easiest - Recommended)

1. Go to [render.com](https://render.com) and sign up/login
2. Click **"New +"** → **"Blueprint"**
3. Connect GitHub account
4. Select your `ctrl-backend` repository
5. Render will detect `render.yaml` and set everything up automatically
6. Click **"Apply"**
7. Wait for deployment (5-10 minutes)
8. Done! Your API is live at `https://ctrl-backend.onrender.com`

#### Option B: Manual Setup

1. **Create Database:**
   - Click **"New +"** → **"PostgreSQL"**
   - Name: `ctrl-db`
   - Plan: Free
   - Click **"Create Database"**
   - Copy the **Internal Database URL**

2. **Create Web Service:**
   - Click **"New +"** → **"Web Service"**
   - Connect your GitHub repo
   - Settings:
     - **Name**: `ctrl-backend`
     - **Build Command**: `pip install -r requirements.txt && alembic upgrade head`
     - **Start Command**: `uvicorn app.main:app --host 0.0.0.0 --port $PORT`
   - **Environment Variables:**
     - `DATABASE_URL`: Paste Internal Database URL from step 1
     - `SECRET_KEY`: Run `python -c "import secrets; print(secrets.token_urlsafe(32))"` and paste result
     - `ACCESS_TOKEN_EXPIRE_MINUTES`: `60`
   - Click **"Create Web Service"**

3. **Wait for Deployment:**
   - Monitor logs in Render dashboard
   - Should take 5-10 minutes

### Step 3: Test Your API

Once deployed, test these URLs:

- **Health Check**: `https://ctrl-backend.onrender.com/api/v1/health`
- **API Docs**: `https://ctrl-backend.onrender.com/docs`
- **ReDoc**: `https://ctrl-backend.onrender.com/redoc`

---

## 🔧 Common Issues & Quick Fixes

### Issue: Database Connection Error

**Fix**: In Render dashboard, go to Web Service → Environment → Edit `DATABASE_URL`:
- Change `postgresql://` to `postgresql+psycopg://`
- Save and redeploy

### Issue: Build Fails

**Fix**: 
- Check Python version (needs 3.11+)
- Verify `requirements.txt` has all dependencies
- Check build logs for specific error

### Issue: Migrations Not Running

**Fix**: 
- Verify `DATABASE_URL` is set correctly
- Check build command includes `alembic upgrade head`
- Review logs for migration errors

### Issue: Port Error

**Fix**: 
- Ensure start command uses `$PORT` not hardcoded `8080`
- Render automatically sets `$PORT` environment variable

---

## 📝 Next Steps

1. ✅ Test all API endpoints
2. ✅ Set up custom domain (optional)
3. ✅ Configure CORS for your frontend
4. ✅ Set up monitoring/alerts
5. ✅ Upgrade to paid plan for production (optional)

---

## 🆘 Need Help?

- Check full guide: `README.md`
- Review checklist: `DEPLOYMENT_CHECKLIST.md`
- Check Render logs: Dashboard → Your Service → Logs
- Render Docs: [render.com/docs](https://render.com/docs)

---

**That's it! Your API should be live now! 🎉**

