import configparser


class ConfigManager:
    def __init__(self, config_file):
        # config_file 文件放在调用方法同级
        self.config_file = config_file
        self.config = configparser.ConfigParser()

        self.config.read(self.config_file, encoding='utf-8')
        # # 如果配置文件不存在，则创建默认配置
        # if not os.path.exists(self.config_file):
        #     self.create_default_config()
        # else:
        #     self.config.read(self.config_file)

    def create_default_config(self):
        """创建默认配置文件"""
        self.config["DATABASE"] = {
            "host": "localhost",
            "port": "5432",
            "username": "admin",
            "password": "secret",
            "database": "mydb"
        }

        self.config["APP"] = {
            "debug": "True",
            "log_level": "INFO",
            "max_connections": "100",
            "timeout": "30"
        }

        self.config["PATHS"] = {
            "data_dir": "/var/data",
            "log_dir": "/var/logs",
            "temp_dir": "/tmp"
        }

        self.save_config()
        print(f"已创建默认配置文件: {self.config_file}")

    def save_config(self):
        """保存配置到文件"""
        with open(self.config_file, 'w') as configfile:
            self.config.write(configfile)
        print(f"配置已保存到: {self.config_file}")

    def get_value(self, section, key, default=None):
        """获取配置值"""
        try:
            return self.config.get(section, key)
        except (configparser.NoSectionError, configparser.NoOptionError):
            return default

    def set_value(self, section, key, value):
        """设置配置值"""
        if section not in self.config:
            self.config[section] = {}
        self.config[section][key] = str(value)

    def print_config(self):
        """打印所有配置"""
        for section in self.config.sections():
            print(f"[{section}]")
            for key, value in self.config.items(section):
                print(f"{key} = {value}")
            print()  # 空行分隔不同section

    def remove_key(self, section, key):
        """删除配置项"""
        if section in self.config and key in self.config[section]:
            del self.config[section][key]
            return True
        return False

    def remove_section(self, section):
        """删除整个配置节"""
        if section in self.config:
            self.config.remove_section(section)
            return True
        return False


# 示例用法
if __name__ == "__main__":
    # 创建配置管理器实例
    config_manager = ConfigManager("my_app_config.ini")

    print("当前配置:")
    config_manager.print_config()

    # 修改一些配置值
    config_manager.set_value("DATABASE", "host", "192.168.1.100")
    config_manager.set_value("APP", "timeout", "60")

    # 添加新配置节和配置项
    config_manager.set_value("NEW_SECTION", "new_key", "new_value")

    # 保存更改
    config_manager.save_config()

    print("修改后的配置:")
    config_manager.print_config()

    # 获取特定配置值
    db_host = config_manager.get_value("DATABASE", "host")
    print(f"数据库主机: {db_host}")

    # 删除配置项示例
    config_manager.remove_key("NEW_SECTION", "new_key")
    config_manager.remove_section("NEW_SECTION")
    config_manager.save_config()

    print("最终配置:")
    config_manager.print_config()