import os
from importlib import import_module

from fastapi import FastAPI

from routes.__router__ import CountRouter


def load_routes(app: FastAPI) -> None:
    for file in os.listdir(__package__):
        if not file.startswith('__'):
            import_module('routes.'+file[:-3])
    for router in CountRouter._routers:
        app.include_router(router)
