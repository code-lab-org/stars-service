import connexion
import six

from swagger_server.models.job import Job  # noqa: E501
from swagger_server.models.job_info import JobInfo  # noqa: E501
from swagger_server.models.job_output import JobOutput  # noqa: E501
from swagger_server.models.job_output_request import JobOutputRequest  # noqa: E501
from swagger_server.models.job_status import JobStatus  # noqa: E501
from swagger_server import util

import subprocess
import pathlib as pl
import multiprocessing as mp
import os
import signal
import shutil
import json
import random
import string

def create_job(body):  # noqa: E501
    """Create a new job

     # noqa: E501

    :param body: Job object that needs to be added to the queue
    :type body: dict | bytes

    :rtype: JobInfo
    """
    
    service_file = pl.Path('out/service.json')
    service = json.loads(open(service_file, 'r').read())
    flag = True
    job_id = ''
    counter = 0
    job_ids = list(service['jobs'].keys())

    while flag and counter < 10:
        job_id = ''.join(random.choice(string.digits) for x in range(6))
        if job_id not in job_ids:
            flag = False
        counter += 1
    
    workspace = pl.Path('out') / job_id
    workspace.mkdir(exist_ok=True, parents=True)
    
    # dump json config to file

    json_file = (workspace / job_id).with_suffix('.json')
    json_output = json.dumps(body['simulation_config'], indent=2)
    open(json_file, 'w').write(json_output)

    print('\nWriting JSON to file:\n');
    print(json_output)
    print('\n\n');
    
    # call translator
    source = (workspace / job_id).with_suffix('.cc')
    subprocess.check_call(['perl', '/translator/translate.pl', json_file, source])            

    #source = (workspace / job_id).with_suffix('.cc')
    #shutil.copy('sys/stars.cc', source)

    executable = source.parent / (source.stem + '.out')
    
    #subprocess.check_call(['g++', '-o', executable, '-fPIC', source])
    
    subprocess.check_call(['sh', '/server/stars_app_build.sh', job_id])
    
    #proc = subprocess.Popen(f'./{executable} {workspace}', shell=True)
    job_info = {'job_id': str(job_id),
                'label': body['label'],
                'owner': body['owner'],
                'pid': 1, #proc.pid+1,
                'status': 'running',
                'url_log': str(workspace / 'log.txt'),
                'url_data': str(workspace / 'data.nc4')}
    service['jobs'][str(job_id)] = job_info
    output = json.dumps(service, indent=2)
    open(service_file, 'w').write(output)
    return service['jobs'][job_id]


def delete_job(jobID):  # noqa: E501
    """Deletes a job

     # noqa: E501

    :param jobID: Job ID to delete
    :type jobID: int

    :rtype: None
    """
    service_file = pl.Path('out/service.json')
    service = json.loads(open(service_file, 'r').read())
    for v in service['jobs'].keys():
        if v == str(jobID):
            workspace = pl.Path('out') / str(jobID)
            pid = service['jobs'][v]['pid']
            os.kill(int(pid), signal.SIGKILL)
            service['jobs'][v]['status'] = 'cancelled'
            output = json.dumps(service, indent=2)
            open(service_file, 'w').write(output)


def delete_job_output(jobID):  # noqa: E501
    """Deletes a job&#39;s output

     # noqa: E501

    :param jobID: Job ID of output to delete
    :type jobID: int

    :rtype: None
    """
    service = json.loads(open('out/service.json', 'r').read())
    for v in service['jobs'].keys():
        if v == str(jobID):
            workspace = pl.Path('out') / str(jobID)
            shutil.rmtree(workspace)


def get_job_by_id(jobID):  # noqa: E501
    """Find job by ID

    Returns the status of a job that was submitted # noqa: E501

    :param jobID: ID of job to return
    :type jobID: int

    :rtype: JobStatus
    """
    service = json.loads(open('out/service.json', 'r').read())
    for v in service['jobs'].keys():
        if v == str(jobID):
            log = pl.Path('out') / str(jobID) / 'log.txt'
            return {'status': service['jobs'][v]['status'],
                    'percent': [l.strip() for l in open(log)][-1]}

def get_job_output_by_id(jobID):  # noqa: E501
    """Get a job&#39;s output

    Returns url information to download a job&#39;s output log and data files # noqa: E501

    :param jobID: ID of job to return
    :type jobID: int

    :rtype: JobOutput
    """
    service = json.loads(open('out/service.json', 'r').read())
    for v in service['jobs'].keys():
        if v == str(jobID):
            return {'url_data': service['jobs'][v]['url_data'],
                    'url_log': service['jobs'][v]['url_log']}


def get_job_output_by_request(jobID, RequestedOutput):  # noqa: E501
    """Request specific fields of a job&#39;s output

    Returns url information to download a job&#39;s output log and data files # noqa: E501

    :param jobID: ID of job to return
    :type jobID: int
    :param RequestedOutput: Log level and output data fields
    :type RequestedOutput: dict | bytes

    :rtype: JobOutput
    """
    service = json.loads(open('out/service.json', 'r').read())
    retval = {}
    for v in service['jobs'].keys():
        if v == str(jobID):
            retval = {k: service['jobs'][v][k] for k in RequestedOutput['data_fields']}
    return retval
