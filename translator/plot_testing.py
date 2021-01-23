#!/usr/bin/python3
#
# Copyright (C) 2020 Ryan Linnabary
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

"""Plots data from testing program."""

import argparse

import matplotlib.pyplot as plt
import cartopy.crs as ccrs
import cartopy.feature as cfeature
import numpy as np
import random
    
from helper_data import read_node_parameters
from helper_system import check_dir
from helper_system import check_file

def main():
    """
    Plots data from testing program.

    """

    # Inputs
    args = argparser()
    data, _, _, _, _ = read_node_parameters(args.in_file)

    cons = np.unique(data['constellation'])
    rand = lambda: str(hex(random.randint(0, 255)))[2:]
    colors = [f'#{rand()}{rand()}{rand()}' for _ in range(len(cons))]
    groups = [data.loc[data['constellation'] == i] for i in cons]
    #print(colors)
    #print(groups)
    #quit()


    plt.figure()
    axes = plt.axes(projection=ccrs.PlateCarree())
    axes.set_global()
    axes.add_feature(cfeature.NaturalEarthFeature('physical',
                                                  'land',
                                                  '110m',
                                                  edgecolor='#A1A1A1',
                                                  lw=0.5,
                                                  facecolor='#E6E6E6'))
    #groups = [data.loc[data['constellation'] == i] for i in range(1)]
    #colors = ['#40d97f', '#ff4c4c', '#4c4cff', '#8af5da', '#fbc08c', '#b741d0', '#e599f1', '#bbcb59', '#a2a6c0']
    for idx, group in enumerate(groups):
        axes.scatter(group['longitude'],
                     group['latitude'],
                     lw=0.0,
                     facecolor=colors[idx],
                     s=2,
                     zorder=30,
                     marker='o')
        current = group.loc[data.index[-1][0]]
        axes.scatter(current['longitude'],
                     current['latitude'],
                     lw=0.5,
                     facecolor=colors[idx],
                     s=7,
                     edgecolor='k',
                     zorder=40,
                     marker='o')
    plt.savefig(f'{args.out_dir}orbits.png', dpi=300, bbox_inches='tight',
                pad_inches=0.05)
    plt.close()



def argparser():
    """
    Obtains command-line arguments.

    Returns:
        Arguments

    Examples:
        >>> args = argparser()
    """
    parser = argparse.ArgumentParser()
    parser.add_argument('-i',
                        '--in_file',
                        default='output/data.nc4',
                        nargs='?',
                        help='Path to input file')
    parser.add_argument('-o',
                        '--out_dir',
                        default='analysis/',
                        nargs='?',
                        help='Path to output directory')
    args = parser.parse_args()
    check_file(args.in_file)
    check_dir(args.out_dir)
    return args


if __name__ == '__main__':
    main()
