import requests

from cases import cases
from case import ResultStatus
from colors import *

if __name__ == '__main__':
    session = requests.Session()
    failed_cases: list[tuple[int, str]] = []
    case_len = len(cases)
    
    
    for i, test in enumerate(cases):
        print()
        print(BColor.CYAN + f'Testing case {i+1}/{case_len}:' + BColor.ENDC, test.name)
        print(
            BColor.CYAN
            + 'Endpoint: '
            + BColor.ENDC
            + BColor.UNDERLINE
            + test.endpoint
            + BColor.ENDC
        )
        print(BColor.CYAN + 'Method:' + BColor.ENDC, test.method)

        try:
            result = test.test(session)
            if result.status != ResultStatus.passed:
                print_error(result.message)
                failed_cases.append((i + 1, result.message))
                continue
            print(BColor.GREEN + BColor.BOLD + '[✓] Passed' + BColor.ENDC)
        except requests.exceptions.RequestException as e:
            print_error(f'Request failed: {e}')
            failed_cases.append((i + 1, f'Connection error: {e}'))

    print()
    print()
    if len(failed_cases) > 0:
        print(BColor.RED + 'Failed cases:' + BColor.ENDC)
        for case in failed_cases:
            index, reason = case
            print_error(f'Case {index}: {reason}')
    else:
        print(BColor.GREEN + BColor.BOLD + 'All tests passed.' + BColor.ENDC)
