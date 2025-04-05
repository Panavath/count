from __future__ import annotations

from typing import TYPE_CHECKING, Any
from datetime import datetime

from sqlalchemy import ForeignKey
from sqlalchemy.orm import relationship, Mapped, mapped_column

from database import BaseTable

if TYPE_CHECKING:
    from .user_table import UserTable


class WeightLogTable(BaseTable):
    __tablename__ = 'WeightLog'

    weight_log_id: Mapped[int] = mapped_column(primary_key=True, index=True, autoincrement=True)
    user_id: Mapped[int] = mapped_column(ForeignKey('User.user_id'))
    weight: Mapped[float]
    date: Mapped[datetime]

    user: Mapped['UserTable'] = relationship(
        'UserTable', uselist=False, back_populates='weight_logs'
    )

    def __init__(self, weight: float, date: datetime, **kwargs):
        super().__init__(weight=weight, date=date, **kwargs)


    def __repr__(self) -> str:
        return f'WeightLog({self.weight}, date={self.date})'

class HeightLogTable(BaseTable):
    __tablename__ = 'HeightLog'

    height_log_id: Mapped[int] = mapped_column(primary_key=True, index=True, autoincrement=True)
    user_id: Mapped[int] = mapped_column(ForeignKey('User.user_id'))
    height: Mapped[float]
    date: Mapped[datetime]

    user: Mapped['UserTable'] = relationship(
        'UserTable', uselist=False, back_populates='height_logs'
    )

    def __init__(self, height: float, date: datetime, **kwargs):
        super().__init__(height=height, date=date, **kwargs)


    def __repr__(self) -> str:
        return f'HeightLog({self.height}, date={self.date})'
