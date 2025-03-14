from abc import ABC, abstractmethod
from typing import Generic, TypeVar, Sequence

from pydantic import BaseModel
from sqlalchemy.orm import DeclarativeBase

ModelType = TypeVar("ModelType", bound=DeclarativeBase)
SchemaType = TypeVar("SchemaType", bound=BaseModel)


class BaseDBRepository(ABC, Generic[ModelType, SchemaType]):
    def __init__(self, model: type[ModelType]) -> None:
        self.model = model

    @abstractmethod
    def create(self, **kwargs) -> ModelType: ...

    @abstractmethod
    def get_all(self) -> Sequence[ModelType]: ...

    @abstractmethod
    def get_by_id(self, obj_id: int) -> ModelType | None: ...

    @abstractmethod
    def update(self, obj_id: int, **kwargs) -> ModelType | None: ...

    @abstractmethod
    def filter_by(self, **filters) -> Sequence[ModelType]: ...

    @abstractmethod
    def delete(self, obj_id: int) -> bool: ...
