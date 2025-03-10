from enum import Enum
from fastapi import APIRouter


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
