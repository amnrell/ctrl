# 🚀 Deployment Checklist

Use this checklist to ensure a smooth deployment to Render.

## Pre-Deployment

- [ ] Code is tested locally
- [ ] All environment variables are documented
- [ ] `.env` file is NOT committed to Git (check `.gitignore`)
- [ ] `requirements.txt` is up to date
- [ ] Database migrations are tested
- [ ] API endpoints are working locally

## GitHub Setup

- [ ] Git repository initialized (`git init`)
- [ ] All files committed (`git add .` and `git commit -m "message"`)
- [ ] GitHub repository created
- [ ] Local repo connected to GitHub (`git remote add origin ...`)
- [ ] Code pushed to GitHub (`git push -u origin main`)
- [ ] Verified all files are on GitHub

## Render Setup - Database

- [ ] PostgreSQL service created on Render
- [ ] Database name, user, and password noted
- [ ] **Internal Database URL** copied (starts with `postgresql://`)
- [ ] Database is running and accessible

## Render Setup - Web Service

- [ ] Web service created and connected to GitHub repo
- [ ] Build command set: `pip install -r requirements.txt && alembic upgrade head`
- [ ] Start command set: `uvicorn app.main:app --host 0.0.0.0 --port $PORT`
- [ ] Environment variables added:
  - [ ] `DATABASE_URL` (Internal Database URL from PostgreSQL service)
  - [ ] `SECRET_KEY` (generated secure random string)
  - [ ] `FIREBASE_PROJECT_ID` (if using Firebase)
  - [ ] `ACCESS_TOKEN_EXPIRE_MINUTES` (default: 60)

## Post-Deployment

- [ ] Service deployed successfully (check logs)
- [ ] Health check endpoint working: `https://your-service.onrender.com/api/v1/health`
- [ ] API documentation accessible: `https://your-service.onrender.com/docs`
- [ ] Database migrations ran successfully (check logs)
- [ ] Test API endpoints are responding
- [ ] CORS is configured correctly (if frontend exists)

## Troubleshooting

If deployment fails:

1. **Check Build Logs**
   - Go to Render Dashboard → Your Service → Logs
   - Look for error messages during build or startup

2. **Verify Environment Variables**
   - Ensure `DATABASE_URL` uses Internal Database URL
   - Check all required variables are set

3. **Check Database Connection**
   - Verify database service is running
   - Ensure `DATABASE_URL` format is correct
   - Test connection from logs

4. **Migration Issues**
   - Check if migrations ran: `alembic upgrade head`
   - Verify database user has proper permissions
   - Review migration files

5. **Port Issues**
   - Ensure start command uses `$PORT` not hardcoded port
   - Check Render automatically sets `$PORT`

## Quick Commands

### Generate SECRET_KEY
```bash
python -c "import secrets; print(secrets.token_urlsafe(32))"
```

### Test Local Database Connection
```bash
python -c "from app.database import engine; engine.connect()"
```

### Run Migrations Locally
```bash
alembic upgrade head
```

### Test API Locally
```bash
uvicorn app.main:app --host 0.0.0.0 --port 8080 --reload
```

---

**✅ Once all items are checked, your deployment should be successful!**

