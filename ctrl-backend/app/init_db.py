from app.database import Base, engine
from app.models import user, mood   # import every model module

print("Creating tables...")
Base.metadata.create_all(bind=engine)
print("Done!")
