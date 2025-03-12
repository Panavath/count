from abc import ABC, abstractmethod
from typing import Generic, TypeVar

from sqlalchemy.orm import Session

T = TypeVar('T')


class BaseRepository(ABC, Generic[T]):
    def __init__(self, db: Session, model: type[T]) -> None:
        self.db = db
        self.model = model

    def close(self) -> None:
        self.db.close()

    @abstractmethod
    def create(self, data: dict) -> T: ...

    @abstractmethod
    def get_by_id(self, data: dict) -> T | None: ...

    @abstractmethod
    def get_all(self, data: dict) -> list[T]: ...

    @abstractmethod
    def update(self, data: dict) -> T | None: ...
    
    @abstractmethod
    def delete(self, data: dict) -> bool: ...
