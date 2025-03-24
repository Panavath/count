from __future__ import annotations

import json
from enum import Enum

from requests import Response, Session

from dataclasses import dataclass, field
from typing import Any, Literal, Callable


URL = 'http://127.0.0.1:727'


class ResultStatus(Enum):
    passed = 0
    content_mismatch = 1
    code_mismatch = 2
    check_failed = 3

def pretty_print(content: dict[str, Any]) -> str:
    return json.dumps(content, indent=4)


@dataclass
class Case:
    """
    Defines a test case for the COUNT back-end api.
    
    Prefix with `.expects()` to set expected values.
    
    Execute test with `.test()`. This returns a `Result` object.
    """
    name: str
    endpoint: str
    method: Literal['GET', 'POST', 'PUT', 'DELETE', 'OPTION', 'PATCH']
    body: dict[str, object] | None = None
    description: str = ""
    image_path: str | None = None
    image_type: Literal['image/jpeg', 'image/png'] | None = None
    
    files: dict[str, tuple[str, bytes, Literal['image/jpeg', 'image/png']]] | None = (
        field(init=False, default=None)
    )
    expected_code: int | None = field(init=False, default=None)
    content: dict[str, Any] | None = field(init=False, default=None)
    check: Callable[[dict[str, Any]], str | None] | None = field(
        init=False, default=None
    )

    def __post_init__(self):
        if self.image_path is not None and self.image_type is None:
            ext = self.image_path.split('.')[-1].lower()
            match ext:
                case x if x in ['jpg', 'jpeg']:
                    self.image_type = 'image/jpeg'
                case 'png':
                    self.image_type = 'image/png'
                case _:
                    raise ValueError('No image type specified')
            with open(self.image_path, 'rb') as image_file:
                self.files = {
                    'file': (self.image_path, image_file.read(), self.image_type)
                }

    def expects(
        self,
        status_code: int | None,
        /,
        *,
        content: dict[str, Any] | None = None,
        check: Callable[[dict[str, Any]], str | None] | None = None,
    ):
        """
        Set an expectation for the test.
        
        Each fields can be `None` to be ignored during evaluation.
        
        Args:
            status_code (int or None) (Positional): The expected http status code.
            content (dict or None) (Keyword): The expected return content.
            check (Callable(dict) -> str or None) (Keyword): A callable function.\
            Alternative to `content` where the actual returned content is passed to the function.\
            The function must return `None` if it is correct, otherwise return an error message str.
        """
        self.expected_code = status_code
        self.expected_content = content
        self.check = check

        return self

    def test(self, session: Session) -> Result:
        match self.method:
            case 'GET':
                return Result.from_response(self, session.get(URL + self.endpoint))
            case 'POST':
                return Result.from_response(
                    self,
                    session.post(URL + self.endpoint, json=self.body, files=self.files),
                )
            case _:
                raise NotImplementedError


@dataclass
class Result:
    test_case: Case
    status_code: int
    content: dict[str, Any]
    status: ResultStatus = field(init=False, default=ResultStatus.passed)
    message: str = field(init=False, default='')

    def __post_init__(self):
        self.passed

    @property
    def pass_check(self) -> bool:
        if self.test_case.check is None:
            return True
        result = self.test_case.check(self.content)
        if result is None:
            return True
        self.status = ResultStatus.check_failed
        self.message = result
        return False

    @property
    def status_code_matched(self) -> bool:
        if self.test_case.expected_code is None:
            return True
        if self.test_case.expected_code == self.status_code:
            return True
        self.status = ResultStatus.code_mismatch
        self.message = f'Unexpected status code: {self.status_code}'
        return False

    @property
    def content_matched(self) -> bool:
        if not self.test_case.expected_content:
            return True
        if self.test_case.expected_content == self.content:
            return True
        self.status = ResultStatus.content_mismatch
        self.message = f'Response does not match expected content:\n{pretty_print(self.content)}'
        return False

    @property
    def passed(self) -> bool:
        return all([self.status_code_matched, self.content_matched, self.pass_check])

    @staticmethod
    def from_response(test_case: Case, res: Response) -> Result:
        response = res.content.decode()
        if response == 'Internal Server Error':
            return Result(
                test_case, status_code=500, content={'message': 'Internal Server Error'}
            )
        return Result(
            test_case=test_case,
            status_code=res.status_code,
            content=json.loads(res.content.decode()),
        )
