import json

import requests

from colors import *
from cases import *
from exceptions import *


if __name__ == '__main__':
    session = requests.Session()

    failed_cases: list[tuple[int, str]] = []
    case_len = len(cases)

    for i, test in enumerate(cases):
        print()
        print(BColor.CYAN + f'Testing case {i+1}/{case_len}:' +
              BColor.ENDC, test.name)
        print(BColor.CYAN + 'Endpoint: ' + BColor.ENDC +
              BColor.UNDERLINE + test.endpoint + BColor.ENDC)
        print(BColor.CYAN + 'Method:' + BColor.ENDC, test.method)

        files = None

        if test.image_path is not None:
            if test.image_type is None:
                raise ValueError('Error: No image type specified')

            with open(test.image_path, 'rb') as file:
                files = {
                    'file': (test.image_path, file.read(), test.image_type)}

        try:
            if test.method == 'POST':
                response = session.post(
                    URL + test.endpoint, json=test.body, files=files)
            else:
                response = session.get(URL + test.endpoint)

            print(
                BColor.GREEN + f'[+] Request successful ({response.status_code})' + BColor.ENDC)

            if response.status_code == test.expected_code:
                expected_content = test.expected_content
                actual_content = json.loads(response.text.strip())

                if actual_content == expected_content:
                    print(BColor.GREEN + BColor.BOLD +
                          '[✓] Passed' + BColor.ENDC)
                elif expected_content == {}:
                    print(BColor.GREEN + BColor.BOLD +
                          '[✓] ' + str(actual_content) + BColor.ENDC)
                else:
                    raise ValidationError(
                        'Response does not match expected content', actual_content)
            else:
                raise ValidationError(
                    'Unexpected status code: ' + str(response.status_code) + str(response.content.decode())
                )
        except requests.exceptions.RequestException as e:
            print_error(f'Request failed: {str(e)}')
            failed_cases.append((i+1, f'Connection error: {str(e)}'))
        except ValidationError as e:
            print_error(f'[-] {str(e)}')
            failed_cases.append((i+1, f'Validation error: {str(e)}'))

    if len(failed_cases) > 0:
        print(BColor.RED + '\nFailed cases:' + BColor.ENDC)
        for case in failed_cases:
            index, reason = case
            print_error(f'Case {index}: {reason}')
