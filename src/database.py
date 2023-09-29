"""Db module."""
import os
from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker

SQLALCHEMY_DATABASE_URI = os.environ.get(
    "SQLALCHEMY_DATABASE_URI", "sqlite:///tmp/db.sqlite"
)

engine = create_engine(
    SQLALCHEMY_DATABASE_URI,
)

SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base = declarative_base()


def healthcheck():
    is_database_working = True
    connection = engine.raw_connection()
    try:
        cursor_obj = connection.cursor()
        cursor_obj.execute("SELECT 1")
        cursor_obj.close()
    except Exception as e:
        output = str(e)
        is_database_working = False
    finally:
        connection.close()
    return is_database_working
