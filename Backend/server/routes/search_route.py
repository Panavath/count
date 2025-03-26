from fastapi import Query, HTTPException

from . import CountRouter

from services.search_service import SearchService

search_router = CountRouter(prefix='/search', tags=['search'])

@search_router.get('/food')
async def search_food(query: str = Query(...)):
    return {'results': SearchService.search_food(query)}