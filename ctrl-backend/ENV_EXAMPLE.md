# Environment Variables Example

Create a `.env` file in the root directory with the following variables:

```env
# Database Configuration
# Format: postgresql+psycopg://username:password@host:port/database_name
# For local development with Docker:
DATABASE_URL=postgresql+psycopg://ctrl_user:Ctrl2025!@localhost:5432/ctrl_db

# For Render deployment, use the Internal Database URL provided by Render
# DATABASE_URL=postgresql://ctrl_user:password@dpg-xxxxx-a.oregon-postgres.render.com/ctrl_db

# Security
# Generate a secure secret key using: python -c "import secrets; print(secrets.token_urlsafe(32))"
SECRET_KEY=change_me_in_production_generate_a_secure_key

# Firebase Configuration (Optional)
# FIREBASE_PROJECT_ID=your-firebase-project-id

# Token Settings
ACCESS_TOKEN_EXPIRE_MINUTES=60
```

## How to Generate SECRET_KEY

Run this command in your terminal:

```bash
python -c "import secrets; print(secrets.token_urlsafe(32))"
```

Copy the output and use it as your `SECRET_KEY` value.

## For Render Deployment

1. Go to your Web Service in Render Dashboard
2. Navigate to "Environment" tab
3. Add each variable:
   - `DATABASE_URL`: Use the **Internal Database URL** from your PostgreSQL service
   - `SECRET_KEY`: Generate using the command above
   - `FIREBASE_PROJECT_ID`: Your Firebase project ID (if applicable)
   - `ACCESS_TOKEN_EXPIRE_MINUTES`: 60 (or your preferred value)

