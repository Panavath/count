import json
from pathlib import Path as p
from typing import Sequence

from pydantic import BaseModel

from config import ENV_MODE


def list_model_to_dict(key: str, models: Sequence[BaseModel]):
    buffer: dict[str, list[dict]] = {"key": []}

    for model in models:
        buffer['key'].append(model.model_dump())

    return buffer


class Path:
    ROOT_DIR = p().absolute()
    CACHE_DIR = ROOT_DIR / 'cache'
    YOLO_MODEL_DIR = ROOT_DIR / 'yolo_models'

    @classmethod
    def save_cache(cls, file_name: str, content: str):
        with open(cls.CACHE_DIR/file_name, 'w') as f:
            f.write(content)

    @classmethod
    def save_cache_byte(cls, file_name: str, content: bytes):
        with open(cls.CACHE_DIR/file_name, 'wb') as f:
            f.write(content)

    @classmethod
    def save_cache_json(cls, file_name: str, content):
        with open(cls.CACHE_DIR/file_name, 'w') as f:
            json.dump(content, f, indent=4)


class BColor:
    PURPLE = '\033[95m'
    ORANGE = '\033[94m'
    CYAN = '\033[96m'
    GREEN = '\033[92m'
    YELLOW = '\033[93m'
    RED = '\033[91m'

    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'

    ENDC = '\033[0m'


class Log:

    @classmethod
    def error(cls, log: str) -> None:
        ...

    @classmethod
    def info(cls, log: str) -> None:
        ...

    @classmethod
    def print_error(cls, *message: object, sep: str = ' ', end='\n') -> None:
        msg = sep.join(str(message))
        colored_message = BColor.RED + BColor.BOLD + msg
        print(colored_message, sep=sep, end=BColor.ENDC + end)

    @classmethod
    def print_success(cls, *message: object, sep: str = ' ', end='\n') -> None:
        msg = sep.join(str(message))
        colored_message = BColor.GREEN + BColor.BOLD + msg
        print(colored_message, sep=sep, end=BColor.ENDC + end)

    # @classmethod
    # def print_debug(cls, *message: object, sep: str = ' ', end='\n') -> None:
    #     print(BColor.PURPLE + 'DEBUG' + BColor.ENDC + ':    ', end='')

    #     msg = sep.join(str(message))
    #     colored_message = BColor.PURPLE + BColor.BOLD + msg
    #     print(colored_message, sep=sep, end=BColor.ENDC + end)

    @classmethod
    def print_debug(cls, *message: object, sep: str = ' ', end='\n') -> None:
        if ENV_MODE == 'PROD':
            return
        print(BColor.PURPLE + 'DEBUG' + BColor.ENDC + ':    ', end='')

        print(*message, sep=sep, end=end)
