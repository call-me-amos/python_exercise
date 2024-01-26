import pygame
import sys

# 初始化 Pygame
pygame.init()

# 设置窗口大小
screen_width = 800
screen_height = 600
window = pygame.display.set_mode((screen_width, screen_height))

# 设置球的大小和颜色
ball_radius = 20
ball_color = (255, 0, 0)

# 设置球的速度和方向
ball_speed = [2, 2]
ball_direction = [0, 180]

# 游戏循环
while True:
    # 处理退出事件
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            pygame.quit()
            sys.exit()

            # 更新球的位置
    ball_x = screen_width // 2 - ball_radius + ball_speed[0] * ball_direction[0] // 2
    ball_y = screen_height // 2 - ball_radius + ball_speed[1] * ball_direction[1] // 2

    # 绘制球
    pygame.draw.circle(window, ball_color, (int(ball_x), int(ball_y)), ball_radius)

    # 更新球的方向和速度
    ball_direction = [ball_direction[0] + ball_speed[0], ball_direction[1] + ball_speed[1]]
    ball_speed = [ball_speed[0] + ball_direction[0] // 2, ball_speed[1] + ball_direction[1] // 2]

    # 检查球是否碰到边界，如果是则反弹
    if ball_x < ball_radius or ball_x > screen_width - ball_radius:
        ball_direction[0] = -ball_direction[0]
    if ball_y < ball_radius or ball_y > screen_height - ball_radius:
        ball_direction[1] = -ball_direction[1]

        # 更新屏幕显示
    pygame.display.flip()