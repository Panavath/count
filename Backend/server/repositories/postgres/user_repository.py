from sqlalchemy.orm import Session

from models import UserModel
from repositories.postgres.base import BaseRepository
from database.database import SessionLocal

class UserRepository(BaseRepository[UserModel]):
    def __init__(self) -> None:
        super().__init__(SessionLocal(), UserModel)
    
    def create(self, data: dict) -> UserModel:
        obj = self.model(data)
        self.db.add(obj)
        self.db.commit()
        self.db.refresh(obj)
        return obj
    
    
