"""Request and response bodies. These also produce the OpenAPI schema."""
from typing import Literal, Optional

from pydantic import BaseModel, Field

SearchStatus = Literal['new', 'in-progress', 'complete']
SearchPriority = Literal['low', 'normal', 'high']


class SearchCreate(BaseModel):
    title: str = Field(min_length=1, max_length=400)
    reference: str = Field(default="", max_length=200)
    status: SearchStatus = 'new'
    priority: SearchPriority = 'normal'


class SearchUpdate(BaseModel):
    title: Optional[str] = Field(default=None, min_length=1, max_length=400)
    reference: Optional[str] = Field(default=None, max_length=200)
    status: Optional[SearchStatus] = None
    priority: Optional[SearchPriority] = None


class Search(SearchCreate):
    id: int
