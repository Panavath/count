from abc import ABC, abstractmethod
from typing import Generic, TypeVar

from sqlalchemy.orm import Session

T = TypeVar('T')


class BaseRepository(ABC, Generic[T]):
    def __init__(self, db: Session | None, model: type[T]) -> None:
        self._db = db
        self.model = model
        
    @property
    def db(self) -> Session:
        if self._db is None:
            raise RuntimeError('No database specified')
        return self._db

    def close(self) -> None:
        self.db.close()

    @abstractmethod
    def create(self, data: dict) -> T: ...

    @abstractmethod
    def get_all(self) -> list[T]: ...

    @abstractmethod
    def get_by_id(self, obj_id: int) -> T | None: ...

    @abstractmethod
    def update(self, obj_id: int, data: dict) -> T | None: ...

    @abstractmethod
    def filter_by(self, **filters) -> list[T]: ...

    @abstractmethod
    def delete(self, obj_id: int) -> bool: ...
