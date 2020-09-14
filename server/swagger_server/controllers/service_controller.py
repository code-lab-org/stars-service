import connexion
import six

from swagger_server.models.job_list import JobList  # noqa: E501
from swagger_server.models.service_info import ServiceInfo  # noqa: E501
from swagger_server.models.simulation_config import SimulationConfig  # noqa: E501
from swagger_server import util

import shutil
import json
import pathlib as pl

def get_job_list():  # noqa: E501
    """List all jobs

    Get a list of all job IDs currently used by the STARS Service # noqa: E501


    :rtype: JobList
    """
    service = json.loads(open('out/service.json', 'r').read())
    return list(service['jobs'].keys())


def get_service_info():  # noqa: E501
    """Get information about the STARS Service

    Returns a job&#39;s output # noqa: E501
    Version, date, author.


    :rtype: ServiceInfo
    """
    return json.loads(open('out/service.json', 'r').read())['service_info']


def restart_service():  # noqa: E501
    """Restarts the STARS Service

    Clear all jobs and restart the STARS Service # noqa: E501
    Delete all jobs and output, start clean. (kill all processes)

    :rtype: None
    """
    for path in pl.Path('out').iterdir():
        if path.is_dir():
            shutil.rmtree(path)
        else:
            if path.stem != '.gitignore':
                path.unlink()
    shutil.copy('sys/template.json', 'out/service.json')


def validate_json(config):  # noqa: E501
    """Validate Simulation Config

    Validate JSON for a STARS Simulation Configuration # noqa: E501

    :param config: STARS Simulation Config JSON Object
    :type config: dict | bytes

    :rtype: None
    """
    #  if connexion.request.is_json:
    #      config = SimulationConfig.from_dict(connexion.request.get_json())  # noqa: E501
    pass
