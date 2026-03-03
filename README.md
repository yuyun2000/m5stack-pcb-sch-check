# PCB/SCH解析验证示例项目

## 项目简介

这是一个用于PCB（印刷电路板）和SCH（原理图）解析验证的示例项目，包含Altium Designer格式的源文件及其在KiCad中的转换文件。

## 项目结构

```
pcb-mcp/
├── .claude/         # 配置文件目录
├── .mcp.json        # MCP服务器配置文件
├── README.md        # 项目说明文档
└── ori/             # 从Altium Designer导入到KiCad后手动导出的文件
    ├── A1-MAIN.SchDoc                     # Altium Designer原理图源文件
    ├── AI_Pyramid_PCB_HDMI_V0.3_20251031.PcbDoc  # Altium Designer PCB源文件
    ├── A1-MAIN-altium-import.kicad_sym    # KiCad符号库（Altium导入后）
    ├── A1-MAIN.net                        # 原理图网表（KiCad手动导出）
    ├── AI_Pyramid_PCB_HDMI_V0.3_20251031.csv  # BOM物料清单（KiCad手动导出）
    ├── AI_Pyramid_PCB_HDMI_V0.3_20251031.d356  # D356格式网表（KiCad手动导出）
    ├── gerber/                            # Gerber光绘文件（KiCad手动导出）
    └── sym-lib-table                      # KiCad库配置文件
```

## 文件导出说明

**重要说明**：ori目录下的所有非Altium源文件（.kicad_sym、.net、.csv、.d356、gerber/）都是从Altium Designer导入到KiCad软件后，通过**手动操作**导出的。

### 导出过程

目前的导出流程：
1. 使用KiCad的Altium导入功能打开SchDoc文件
2. 手动转换并导出符号库（.kicad_sym）
3. 手动导出网表文件（.net）
4. 导入PcbDoc文件到KiCad
5. 手动导出BOM（.csv）
6. 手动导出D356格式网表（.d356）
7. 手动导出Gerber光绘文件（gerber/目录）

## 下一步计划

**研究目标**：探索KiCad CLI（命令行界面）工具，实现自动化导出流程。

需要研究的KiCad CLI功能：
- 自动化导入Altium Designer文件
- 命令行导出符号库
- 命令行导出网表文件
- 命令行导出BOM
- 命令行导出Gerber文件
- 命令行导出D356格式网表

## 文件类型说明

### Altium Designer 源文件
- **.SchDoc**: 原理图源文件（Altium Designer格式）
- **.PcbDoc**: PCB源文件（Altium Designer格式）

### KiCad 导出文件
- **.kicad_sym**: KiCad符号库
- **.net**: 原理图网表文件
- **.csv**: BOM物料清单
- **.d356**: D356格式网表文件（用于PCB制造验证）
- **gerber/**: Gerber光绘文件（用于PCB制造）

## 功能用途

1. **格式转换验证**: 验证Altium Designer格式到KiCad格式的转换过程
2. **解析测试**: 用于测试PCB/SCH解析工具的功能
3. **验证工具**: 作为各种PCB/SCH验证工具的测试案例
4. **学习参考**: 了解PCB/SCH文件结构的学习资料

## 使用说明

### 查看项目
- 使用Altium Designer打开 `.SchDoc` 和 `.PcbDoc` 文件
- 使用KiCad打开转换后的文件进行查看和验证

### 解析测试
- 可作为测试PCB/SCH解析工具的样本文件
- 包含多种文件格式，适合全面测试

## 技术信息

- **源软件**: Altium Designer
- **目标软件**: KiCad
- **PCB设计**: 包含HDMI接口电路
- **项目版本**: V0.3
- **设计日期**: 2025-10-31

## 注意事项

- 本项目仅用于解析验证和测试目的
- 不包含完整的产品级电路设计文档
- 文件内容仅供技术验证使用
