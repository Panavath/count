__all__ = [
    'BColor',
    'print_error',
]


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

def print_error(*message: str, sep=' ', end='\n'):
    msg = sep.join(message)
    colored_message = BColor.RED + BColor.BOLD + msg + BColor.ENDC
    print(colored_message, sep=sep, end=end)
