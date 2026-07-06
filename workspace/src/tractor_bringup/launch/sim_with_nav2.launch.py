from launch import LaunchDescription
from launch.actions import DeclareLaunchArgument, GroupAction, IncludeLaunchDescription, SetEnvironmentVariable
from launch.launch_description_sources import PythonLaunchDescriptionSource
from launch.substitutions import EnvironmentVariable, LaunchConfiguration, PathJoinSubstitution
from launch_ros.actions import SetRemap
from ament_index_python.packages import get_package_share_directory
import os


def generate_launch_description():

    bringup_pkg = get_package_share_directory('tractor_bringup')
    nav2_pkg = get_package_share_directory('nav2_bringup')

    sim_launch = os.path.join(
        bringup_pkg,
        'launch',
        'sim_with_safety.launch.py'
    )

    nav2_launch = os.path.join(
        nav2_pkg,
        'launch',
        'bringup_launch.py'
    )

    nav2_params = os.path.join(
        bringup_pkg,
        'config',
        'nav2_params.yaml'
    )

    default_map = PathJoinSubstitution([
        EnvironmentVariable(
            'MINITRACTOR_WORKSPACE',
            default_value='/home/ros/MiniTractor/workspace'
        ),
        'maps',
        'huerto_map.yaml'
    ])

    use_sim_time = LaunchConfiguration('use_sim_time')
    map_file = LaunchConfiguration('map')
    params_file = LaunchConfiguration('params_file')

    simulation = IncludeLaunchDescription(
        PythonLaunchDescriptionSource(sim_launch)
    )

    navigation = GroupAction([
        SetRemap(src='cmd_vel', dst='/cmd_vel_raw'),
        SetRemap(src='/cmd_vel', dst='/cmd_vel_raw'),
        IncludeLaunchDescription(
            PythonLaunchDescriptionSource(nav2_launch),
            launch_arguments={
                'map': map_file,
                'use_sim_time': use_sim_time,
                'params_file': params_file,
                'autostart': 'true',
                'slam': 'False'
            }.items()
        )
    ])

    return LaunchDescription([
        SetEnvironmentVariable(
            'RCUTILS_LOGGING_BUFFERED_STREAM',
            '1'
        ),
        DeclareLaunchArgument(
            'use_sim_time',
            default_value='true',
            description='Use simulation/Gazebo clock'
        ),
        DeclareLaunchArgument(
            'map',
            default_value=default_map,
            description='Full path to the map YAML file'
        ),
        DeclareLaunchArgument(
            'params_file',
            default_value=nav2_params,
            description='Full path to the Nav2 parameters file'
        ),
        simulation,
        navigation
    ])
