# coding: utf-8

from __future__ import absolute_import
from datetime import date, datetime  # noqa: F401

from typing import List, Dict  # noqa: F401

from swagger_server.models.base_model_ import Model
from swagger_server import util


class ServiceInfo(Model):
    """NOTE: This class is auto generated by the swagger code generator program.

    Do not edit the class manually.
    """

    def __init__(self, label: str=None, version: str=None, author: str=None, updated: datetime=None, host: str=None):  # noqa: E501
        """ServiceInfo - a model defined in Swagger

        :param label: The label of this ServiceInfo.  # noqa: E501
        :type label: str
        :param version: The version of this ServiceInfo.  # noqa: E501
        :type version: str
        :param author: The author of this ServiceInfo.  # noqa: E501
        :type author: str
        :param updated: The updated of this ServiceInfo.  # noqa: E501
        :type updated: datetime
        :param host: The host of this ServiceInfo.  # noqa: E501
        :type host: str
        """
        self.swagger_types = {
            'label': str,
            'version': str,
            'author': str,
            'updated': datetime,
            'host': str
        }

        self.attribute_map = {
            'label': 'label',
            'version': 'version',
            'author': 'author',
            'updated': 'updated',
            'host': 'host'
        }

        self._label = label
        self._version = version
        self._author = author
        self._updated = updated
        self._host = host

    @classmethod
    def from_dict(cls, dikt) -> 'ServiceInfo':
        """Returns the dict as a model

        :param dikt: A dict.
        :type: dict
        :return: The ServiceInfo of this ServiceInfo.  # noqa: E501
        :rtype: ServiceInfo
        """
        return util.deserialize_model(dikt, cls)

    @property
    def label(self) -> str:
        """Gets the label of this ServiceInfo.


        :return: The label of this ServiceInfo.
        :rtype: str
        """
        return self._label

    @label.setter
    def label(self, label: str):
        """Sets the label of this ServiceInfo.


        :param label: The label of this ServiceInfo.
        :type label: str
        """

        self._label = label

    @property
    def version(self) -> str:
        """Gets the version of this ServiceInfo.


        :return: The version of this ServiceInfo.
        :rtype: str
        """
        return self._version

    @version.setter
    def version(self, version: str):
        """Sets the version of this ServiceInfo.


        :param version: The version of this ServiceInfo.
        :type version: str
        """

        self._version = version

    @property
    def author(self) -> str:
        """Gets the author of this ServiceInfo.


        :return: The author of this ServiceInfo.
        :rtype: str
        """
        return self._author

    @author.setter
    def author(self, author: str):
        """Sets the author of this ServiceInfo.


        :param author: The author of this ServiceInfo.
        :type author: str
        """

        self._author = author

    @property
    def updated(self) -> datetime:
        """Gets the updated of this ServiceInfo.

        Datetime the service was last updated  # noqa: E501

        :return: The updated of this ServiceInfo.
        :rtype: datetime
        """
        return self._updated

    @updated.setter
    def updated(self, updated: datetime):
        """Sets the updated of this ServiceInfo.

        Datetime the service was last updated  # noqa: E501

        :param updated: The updated of this ServiceInfo.
        :type updated: datetime
        """

        self._updated = updated

    @property
    def host(self) -> str:
        """Gets the host of this ServiceInfo.


        :return: The host of this ServiceInfo.
        :rtype: str
        """
        return self._host

    @host.setter
    def host(self, host: str):
        """Sets the host of this ServiceInfo.


        :param host: The host of this ServiceInfo.
        :type host: str
        """

        self._host = host