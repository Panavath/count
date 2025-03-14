from abc import ABC, abstractmethod
from typing import Generic, TypeVar

from pydantic import BaseModel
from sqlalchemy.ext.declarative import DeclarativeMeta

ModelType = TypeVar("ModelType", bound=DeclarativeMeta)
SchemaType = TypeVar("SchemaType", bound=BaseModel)


class BaseDBRepository(ABC, Generic[ModelType, SchemaType]):
    def __init__(self, model: type[ModelType]) -> None:
        self.model = model
        
    @abstractmethod
    def create(self, data: dict) -> SchemaType: ...

    @abstractmethod
    def get_all(self) -> list[SchemaType]: ...

    @abstractmethod
    def get_by_id(self, obj_id: int) -> SchemaType | None: ...

    @abstractmethod
    def update(self, obj_id: int, data: dict) -> SchemaType | None: ...

    @abstractmethod
    def filter_by(self, **filters) -> list[SchemaType]: ...

    @abstractmethod
    def delete(self, obj_id: int) -> bool: ...
