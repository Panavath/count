from models.user import UserModel

from database.database import SessionLocal


def seed_user():
    db = SessionLocal()
    try:
        user1 = UserModel(
            username='Manut',
            email='manut@gmail.com',
            password='9172912iddhkajsdhwgqyjasvqv3uytsdy',
            gender='Male',
        )
        db.add(user1)
        db.commit()
        db.refresh(user1)

    except:
        db.close()
