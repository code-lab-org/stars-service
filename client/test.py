#!/usr/bin/python3

import json
import requests
from time import sleep
from pprint import pprint

def main():
    base_url = 'http://localhost:8080'

    # Create Job
    print('-'*80)
    print('Create Job')
    body = {'label': 'Test', 'owner': 'User Name'}
    response = json.loads(requests.post(f'{base_url}/job', json=body).text)
    pprint(response)
    job_id = response['job_id']

    # Pause
    print('-'*80)
    print('Pause')
    sleep(2)

    # Delete Job
    print('-'*80)
    print('Delete Job')
    requests.delete(f'{base_url}/job/{job_id}')

    # Get Job by ID
    print('-'*80)
    print('Get Job')
    response = json.loads(requests.get(f'{base_url}/job/{job_id}').text)
    pprint(response)

    # Get Job Output
    print('-'*80)
    print('Get Job Output')
    response = json.loads(requests.get(f'{base_url}/job/{job_id}/output').text)
    pprint(response)

    # Get Job Output By Request
    print('-'*80)
    print('Get Job Output by Request')
    body = {'log_level': 'ALL', 'data_fields': ['owner', 'label']}
    response = json.loads(requests.post(f'{base_url}/job/{job_id}/output',
                                        json=body).text)
    pprint(response)

    # Get Service Info
    print('-'*80)
    print('Get Service Info')
    response = json.loads(requests.get(f'{base_url}/service').text)
    pprint(response)

    # List Jobs
    print('-'*80)
    print('Get Service Info')
    response = json.loads(requests.get(f'{base_url}/service/listJobs').text)
    pprint(response)

if __name__ == '__main__':
    main()
