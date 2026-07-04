import math

import rclpy
from rclpy.node import Node

from geometry_msgs.msg import Twist
from sensor_msgs.msg import LaserScan


class SafetyStopNode(Node):
    def __init__(self):
        super().__init__('safety_stop_node')

        self.declare_parameter('stop_distance', 0.8)
        self.declare_parameter('forward_angle_deg', 25.0)

        self.stop_distance = float(self.get_parameter('stop_distance').value)
        self.forward_angle_deg = float(self.get_parameter('forward_angle_deg').value)

        self.obstacle_detected = False
        self.last_cmd = Twist()

        self.scan_sub = self.create_subscription(
            LaserScan,
            '/scan',
            self.scan_callback,
            10
        )

        self.cmd_sub = self.create_subscription(
            Twist,
            '/cmd_vel_raw',
            self.cmd_callback,
            10
        )

        self.cmd_pub = self.create_publisher(
            Twist,
            '/cmd_vel',
            10
        )

        self.get_logger().info(
            f'SafetyStopNode iniciado. '
            f'stop_distance={self.stop_distance:.2f} m, '
            f'forward_angle_deg={self.forward_angle_deg:.1f} deg'
        )

    def cmd_callback(self, msg: Twist):
        self.last_cmd = msg

        safe_cmd = Twist()

        if self.obstacle_detected and msg.linear.x > 0.0:
            safe_cmd.linear.x = 0.0
            safe_cmd.angular.z = msg.angular.z
            self.cmd_pub.publish(safe_cmd)
            return

        self.cmd_pub.publish(msg)

    def scan_callback(self, msg: LaserScan):
        if not msg.ranges:
            return

        half_angle = math.radians(self.forward_angle_deg)
        min_distance = float('inf')
        obstacle = False

        for i, distance in enumerate(msg.ranges):
            angle = msg.angle_min + i * msg.angle_increment

            if angle < -half_angle or angle > half_angle:
                continue

            if math.isinf(distance) or math.isnan(distance):
                continue

            min_distance = min(min_distance, distance)

            if distance < self.stop_distance:
                obstacle = True

        if obstacle and not self.obstacle_detected:
            self.get_logger().warn(
                f'Obstáculo detectado a {min_distance:.2f} m. Bloqueando avance.'
            )

        if not obstacle and self.obstacle_detected:
            self.get_logger().info('Trayectoria libre nuevamente.')

        self.obstacle_detected = obstacle

        if self.obstacle_detected and self.last_cmd.linear.x > 0.0:
            stop_msg = Twist()
            stop_msg.angular.z = self.last_cmd.angular.z
            self.cmd_pub.publish(stop_msg)


def main(args=None):
    rclpy.init(args=args)
    node = SafetyStopNode()

    try:
        rclpy.spin(node)
    except KeyboardInterrupt:
        pass

    node.destroy_node()
    rclpy.shutdown()


if __name__ == '__main__':
    main()