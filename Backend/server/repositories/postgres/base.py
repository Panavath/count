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
    def create(self, **kwargs) -> SchemaType: ...

    @abstractmethod
    def get_all(self) -> Sequence[SchemaType]: ...

    @abstractmethod
    def get_by_id(self, obj_id: int) -> SchemaType | None: ...

    @abstractmethod
    def update(self, obj_id: int, **kwargs) -> SchemaType | None: ...

    @abstractmethod
    def delete(self, obj_id: int) -> bool: ...
