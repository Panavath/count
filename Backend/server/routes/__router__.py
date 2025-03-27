from __future__ import annotations

from enum import Enum

from fastapi import APIRouter

class CountRouter(APIRouter):
    _routers: list[CountRouter] = []

    def __init__(
        self,
        *,
        prefix: str = "",
        tags: list[str | Enum] | None = None,
        **kwargs,
    ) -> None:
        CountRouter._routers.append(self)
        super().__init__(prefix=prefix, tags=tags, **kwargs)
