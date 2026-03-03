# CLI 目录说明

## 目录内容

```
cli/
├── A1-MAIN.kicad_sch                          # 原理图文件（KiCad格式）
├── AI_Pyramid_PCB_HDMI_V0.3_20251031.kicad_pcb # PCB文件（KiCad格式）
├── export.bat                                 # KiCad CLI 自动化导出脚本
├── output/                                    # 脚本运行结果输出目录
│   ├── bom.csv                                # BOM 物料清单（脚本导出）
│   ├── netlist.d356                           # IPC-D-356 格式网表（脚本导出）
│   ├── netlist.net                            # 原理图网表（脚本导出）
│   └── gerber/                                # Gerber 光绘文件（脚本导出）
└── README.md                                  # 本说明文档
```

## 文件来源说明

### ✅ 手动导出的文件（KiCad格式）

- **A1-MAIN.kicad_sch**: 通过 KiCad 原理图编辑器（Eeschema）单机版手动导入 Altium Designer 的 `.SchDoc` 文件后导出的原理图文件
- **AI_Pyramid_PCB_HDMI_V0.3_20251031.kicad_pcb**: 通过 KiCad PCB编辑器（Pcbnew）单机版手动导入 Altium Designer 的 `.PcbDoc` 文件后导出的PCB文件

**导入过程**：
```
1. 打开 KiCad 原理图编辑器（Eeschema）
2. File → Import → Non-KiCad Schematic
3. 选择 Altium Designer 原理图文件（.SchDoc）
4. 完成导入后，保存为 KiCad 格式的原理图文件（.kicad_sch）

1. 打开 KiCad PCB编辑器（Pcbnew）
2. File → Import → Non-KiCad PCB
3. 选择 Altium Designer PCB文件（.PcbDoc）
4. 完成导入后，保存为 KiCad 格式的PCB文件（.kicad_pcb）
```

### ✅ 自动化导出的文件（output/）

output/ 目录下的文件是通过运行 `export.bat` 脚本，使用 KiCad CLI 工具自动化导出的：

- **bom.csv**: 物料清单
- **netlist.net**: 原理图网表（OrcadPCB2格式）
- **netlist.d356**: IPC-D-356 格式网表（用于PCB制造验证）
- **gerber/**: Gerber 光绘文件（包含钻孔文件）

## 使用方法

### 运行导出脚本

```bash
# 直接运行 bat 脚本
export.bat
```

### 脚本功能

export.bat 脚本支持以下自动化操作：

| 操作 | 输出文件 |
|------|----------|
| 导出网表 | output/netlist.net |
| 导出 BOM | output/bom.csv |
| 导出 D356 | output/netlist.d356 |
| 导出 Gerber | output/gerber/ |

## KiCad CLI 说明

### 脚本配置

脚本使用 KiCad 9.0 版本的 CLI 工具，可在脚本顶部修改配置：

```batch
:: ====== 配置区 ======
set KICAD_CLI=C:\Program Files\KiCad\9.0\bin\kicad-cli.exe
set SCH_FILE=A1-MAIN.kicad_sch
set PCB_FILE=AI_Pyramid_PCB_HDMI_V0.3_20251031.kicad_pcb
```

### 限制说明

**重要提示**：KiCad CLI 工具不支持直接导入 Altium Designer 文件（.SchDoc/.PcbDoc），必须先通过 GUI 手动导入并保存为 KiCad 格式。

## 文件对比验证

可以将 output/ 目录下的自动化导出文件与 ori/ 目录下的手动导出文件进行对比，验证 CLI 导出结果的正确性。
