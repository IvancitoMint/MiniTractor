from launch import LaunchDescription
from launch.actions import IncludeLaunchDescription
from launch.launch_description_sources import PythonLaunchDescriptionSource
from ament_index_python.packages import get_package_share_directory
import os


def generate_launch_description():

    bringup_pkg = get_package_share_directory('tractor_bringup')
    slam_pkg = get_package_share_directory('slam_toolbox')

    sim_launch = os.path.join(
        bringup_pkg,
        'launch',
        'sim_with_safety.launch.py'
    )

    slam_launch = os.path.join(
        slam_pkg,
        'launch',
        'online_async_launch.py'
    )

    slam_params = os.path.join(
        bringup_pkg,
        'config',
        'slam_toolbox.yaml'
    )

    simulation = IncludeLaunchDescription(
        PythonLaunchDescriptionSource(sim_launch)
    )

    slam_toolbox = IncludeLaunchDescription(
        PythonLaunchDescriptionSource(slam_launch),
        launch_arguments={
            'use_sim_time': 'true',
            'slam_params_file': slam_params
        }.items()
    )

    return LaunchDescription([
        simulation,
        slam_toolbox
    ])
