from launch import LaunchDescription
from launch.actions import ExecuteProcess, RegisterEventHandler
from launch.event_handlers import OnProcessExit
from launch.substitutions import Command
from launch_ros.actions import Node
from ament_index_python.packages import get_package_share_directory
from launch_ros.parameter_descriptions import ParameterValue
import os


def generate_launch_description():

    desc_pkg = get_package_share_directory('tractor_description')
    bringup_pkg = get_package_share_directory('tractor_bringup')

    xacro_file = os.path.join(
        desc_pkg,
        'urdf',
        'tractor.urdf.xacro'
    )

    controllers_file = os.path.join(
        desc_pkg,
        'config',
        'ros2_controllers.yaml'
    )

    world_file = os.path.join(
        bringup_pkg,
        'worlds',
        'huerto_papayos.world'
    )

    robot_description = {
        'robot_description': ParameterValue(
            Command([
                'xacro ',
                xacro_file,
                ' controllers_file:=',
                controllers_file
            ]),
            value_type=str
        )
    }

    gazebo = ExecuteProcess(
        cmd=[
            'gazebo',
            '--verbose',
            world_file,
            '-s', 'libgazebo_ros_init.so',
            '-s', 'libgazebo_ros_factory.so'
        ],
        output='screen'
    )

    robot_state_publisher = Node(
        package='robot_state_publisher',
        executable='robot_state_publisher',
        parameters=[robot_description],
        output='screen'
    )

    spawn_robot = Node(
        package='gazebo_ros',
        executable='spawn_entity.py',
        arguments=[
            '-entity', 'mini_tractor',
            '-topic', 'robot_description',
            '-x', '0',
            '-y', '0',
            '-z', '0.30'
        ],
        output='screen'
    )

    safety_node = Node(
        package='tractor_safety',
        executable='safety_stop_node',
        output='screen',
        parameters=[{
            'stop_distance': 0.8,
            'forward_angle_deg': 25.0
        }]
    )

    joint_state_broadcaster_spawner = Node(
        package='controller_manager',
        executable='spawner',
        arguments=[
            'joint_state_broadcaster',
            '--controller-manager',
            '/controller_manager'
        ],
        output='screen'
    )

    diff_drive_controller_spawner = Node(
        package='controller_manager',
        executable='spawner',
        arguments=[
            'diff_drive_controller',
            '--controller-manager',
            '/controller_manager'
        ],
        output='screen'
    )

    controller_spawners = RegisterEventHandler(
        OnProcessExit(
            target_action=spawn_robot,
            on_exit=[
                joint_state_broadcaster_spawner,
                diff_drive_controller_spawner
            ]
        )
    )

    return LaunchDescription([
        gazebo,
        robot_state_publisher,
        spawn_robot,
        controller_spawners,
        safety_node
    ])
