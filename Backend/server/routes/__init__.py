import os
import sys
from importlib import import_module
from enum import Enum

from fastapi import FastAPI, APIRouter

from os.path import dirname, basename, isfile, join
import glob

modules = glob.glob(join(dirname(__file__), "*.py"))
__all__ = [
    basename(f)[:-3] for f in modules if isfile(f) and not f.endswith('__init__.py')
]
class Router:
    router: APIRouter

    @property
    def r(self):
        return self.router

    def __init__(
        self,
        *,
        prefix: str = "",
        tags: list[str | Enum] | None = None,
        **kwargs,
    ) -> None:
        self.router = APIRouter(prefix=prefix, tags=tags, **kwargs)
        Router._routers.append(self.router)

    _routers = []


def load_routes(app: FastAPI) -> None:
    # for root, dirs, files in os.walk(__package__):
    #     for file in files:
    #         if not file.startswith('__'):
    #             import_module(root + '/' + file)

    print(Router._routers)
    for router in Router._routers:
        app.include_router(router)
