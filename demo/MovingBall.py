import pygame
import sys

# 初始化 Pygame
pygame.init()

# 设置窗口大小
width, height = 400, 400
screen = pygame.display.set_mode((width, height))
pygame.display.set_caption("Moving Ball")

# 设置球的初始位置和速度
x, y = 20, 20
x_speed, y_speed = 5, 5

# 游戏主循环
while True:
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            pygame.quit()
            sys.exit()

    # 移动球的位置
    x += x_speed
    y += y_speed

    # 边界检测，如果碰到窗口边缘，反转速度
    if x > width - 30 or x < 0:
        x_speed = -x_speed

    if y > height - 30 or y < 0:
        y_speed = -y_speed

    # 填充屏幕背景
    screen.fill((255, 255, 255))

    # 画一个蓝色的球
    pygame.draw.ellipse(screen, (0, 0, 255), (x, y, 30, 30))

    # 刷新屏幕
    pygame.display.flip()

    # 控制帧率
    pygame.time.Clock().tick(30)
