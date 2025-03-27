from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, DeclarativeBase
from sqlalchemy.exc import OperationalError
from sqlalchemy_utils import database_exists, create_database

from config import DB_URL

if not database_exists(DB_URL):
    create_database(DB_URL)

engine = create_engine(DB_URL)

SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)


class BaseTable(DeclarativeBase):
    ...


def create_tables():
    BaseTable.metadata.create_all(engine)


def drop_all_tables():
    BaseTable.metadata.drop_all(engine.connect(), checkfirst=False)
