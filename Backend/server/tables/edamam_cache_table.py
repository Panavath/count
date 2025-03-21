from typing import TYPE_CHECKING
from datetime import datetime

from sqlalchemy.orm import Mapped, mapped_column
from sqlalchemy.sql import func

from database import BaseTable

if TYPE_CHECKING:
    from .food_log_table import FoodLogTable


class EdamamCacheTable(BaseTable):
    __tablename__ = 'EdamamCache'

    # Columns
    edamam_cache_id: Mapped[int] = mapped_column(
        primary_key=True, index=True, autoincrement=True
    )
    key: Mapped[str] = mapped_column(nullable=False)
    value: Mapped[str] = mapped_column(nullable=False)
    date_created: Mapped[datetime] = mapped_column(default=func.now())

    def __init__(
        self,
        *,
        key: str,
        value: str,
        **kwargs,
    ):
        super().__init__(key=key, value=value, **kwargs)