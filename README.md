# PCB/SCH解析验证示例项目

## 项目简介

这是一个用于PCB（印刷电路板）和SCH（原理图）解析验证的示例项目，包含Altium Designer格式的源文件及其在KiCad中的转换文件。

## 项目结构

```
pcb-mcp/
├── .claude/         # 配置文件目录
├── .mcp.json        # MCP服务器配置文件
├── README.md        # 项目说明文档
├── cli/             # KiCad CLI 自动化处理目录
│   ├── A1-MAIN.kicad_sch                          # 原理图文件（KiCad格式）
│   ├── AI_Pyramid_PCB_HDMI_V0.3_20251031.kicad_pcb # PCB文件（KiCad格式）
│   ├── export.bat                                 # KiCad CLI 自动化导出脚本
│   ├── output/                                    # 脚本运行结果输出目录
│   │   ├── bom.csv                                # BOM 物料清单（脚本导出）
│   │   ├── netlist.d356                           # IPC-D-356 格式网表（脚本导出）
│   │   ├── netlist.net                            # 原理图网表（脚本导出）
│   │   └── gerber/                                # Gerber 光绘文件（脚本导出）
│   └── README.md                                  # CLI 目录说明文档
└── ori/             # Altium Designer工程文件
    ├── A1-MAIN.SchDoc                     # 原理图源文件
    ├── AI_Pyramid_PCB_HDMI_V0.3_20251031.PcbDoc  # PCB源文件
    ├── A1-MAIN-altium-import.kicad_sym    # KiCad符号库
    ├── A1-MAIN.net                        # 原理图网表文件
    ├── AI_Pyramid_PCB_HDMI_V0.3_20251031.csv  # BOM物料清单
    ├── AI_Pyramid_PCB_HDMI_V0.3_20251031.d356  # D356格式网表
    ├── gerber/                            # Gerber光绘文件
    └── sym-lib-table                      # KiCad库配置文件
```

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

## KiCad CLI 功能说明

### 简短回答

**不能完成所有操作**，CLI 功能是 GUI 的子集，有明显局限性。

---

## CLI 能做的事（`kicad-cli`）

```bash
# 基本命令结构
kicad-cli <subcommand> [options]
```

### ✅ 支持的操作

| 操作 | 命令示例 |
|------|----------|
| 导出 Gerber | `kicad-cli pcb export gerbers` |
| 导出 BOM | `kicad-cli sch export bom` |
| 导出 Netlist | `kicad-cli sch export netlist` |
| 导出 PDF/SVG | `kicad-cli sch export pdf` |
| 导出 STEP/3D | `kicad-cli pcb export step` |
| DRC 检查 | `kicad-cli pcb drc` |
| ERC 检查 | `kicad-cli sch erc` |
| 格式升级 | `kicad-cli upgrade` |

---

## ❌ 关于导入 Altium 文件

这是**关键限制**：

```
kicad-cli 目前不支持导入 Altium Designer 文件
```

### Altium 导入的实际情况

```
Altium .SchDoc / .PcbDoc 导入
    ↓
只能通过 KiCad GUI 手动操作
File → Import → Non-KiCad Schematic/PCB
    ↓
底层由 pcbnew/eeschema 的插件处理
CLI 未暴露此接口
```

### 变通方案

```python
# 方案1: 使用 KiCad Python 脚本 API（在 KiCad 内部运行）
import pcbnew
board = pcbnew.LoadBoard("file.kicad_pcb")

# 方案2: 用 scripting 调用导入（需要启动 GUI 环境）
# 方案3: 先用 GUI 转换，再用 CLI 处理后续
```

---

## CLI vs GUI 功能对比

```
┌─────────────────────────┬──────┬──────┐
│ 功能                     │ CLI  │ GUI  │
├─────────────────────────┼──────┼──────┤
│ 导入 Altium 文件          │  ❌  │  ✅  │
│ 导入 Eagle 文件           │  ❌  │  ✅  │
│ 原理图编辑                │  ❌  │  ✅  │
│ PCB 布局布线              │  ❌  │  ✅  │
│ 导出 Gerber/Drill        │  ✅  │  ✅  │
│ 导出 BOM                 │  ✅  │  ✅  │
│ 导出 Netlist             │  ✅  │  ✅  │
│ 导出 PDF/SVG             │  ✅  │  ✅  │
│ DRC/ERC                 │  ✅  │  ✅  │
│ 3D 导出 (STEP)           │  ✅  │  ✅  │
│ 库管理                   │  ❌  │  ✅  │
└─────────────────────────┴──────┴──────┘
```

---

## 推荐工作流

```
Altium 文件
    │
    ▼
[KiCad GUI] 导入并保存为 .kicad_sch / .kicad_pcb
    │
    ▼
[kicad-cli] 批量导出 Gerber / BOM / Netlist 等
    │
    ▼
自动化 CI/CD 流程
```

---

## 总结

- `kicad-cli` 主要定位是**自动化导出/检查**，不是完整的功能替代
- **Altium 导入必须走 GUI**（或通过 Python 脚本在 KiCad 环境内调用）
- 如果需要完全无头(headless)处理，可以考虑 `xvfb` 虚拟显示 + Python 脚本方案

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
