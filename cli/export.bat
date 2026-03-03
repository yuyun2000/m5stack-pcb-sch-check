@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul

:: ====== 配置区 ======
set KICAD_CLI=C:\Program Files\KiCad\9.0\bin\kicad-cli.exe
set SCH_FILE=A1-MAIN.kicad_sch
set PCB_FILE=AI_Pyramid_PCB_HDMI_V0.3_20251031.kicad_pcb

:: 输出目录（脚本所在目录下的 output 文件夹）
set OUT_DIR=%~dp0output
set GERBER_DIR=%OUT_DIR%\gerber
:: ====================

:: 检查 kicad-cli 是否存在
if not exist "%KICAD_CLI%" (
    echo [ERROR] 未找到 kicad-cli: %KICAD_CLI%
    echo 请检查 KiCad 安装路径或修改脚本配置区
    pause
    exit /b 1
)

:: 检查源文件是否存在
if not exist "%SCH_FILE%" (
    echo [ERROR] 未找到原理图文件: %SCH_FILE%
    pause
    exit /b 1
)
if not exist "%PCB_FILE%" (
    echo [ERROR] 未找到 PCB 文件: %PCB_FILE%
    pause
    exit /b 1
)

:: 创建输出目录
if not exist "%OUT_DIR%"     mkdir "%OUT_DIR%"
if not exist "%GERBER_DIR%"  mkdir "%GERBER_DIR%"

echo.
echo ============================================
echo   KiCad 批量导出工具
echo ============================================
echo   SCH : %SCH_FILE%
echo   PCB : %PCB_FILE%
echo   OUT : %OUT_DIR%
echo ============================================
echo.

set TOTAL=4
set PASS=0
set FAIL=0

:: -----------------------------------------------
:: [1/4] 原理图 Netlist (OrcadPCB2)
:: -----------------------------------------------
echo [1/%TOTAL%] 导出原理图 Netlist (OrcadPCB2)...
"%KICAD_CLI%" sch export netlist ^
    --format orcadpcb2 ^
    --output "%OUT_DIR%\netlist.net" ^
    "%SCH_FILE%"

if %errorlevel% neq 0 (
    echo [FAIL] 原理图 Netlist 导出失败
    set /a FAIL+=1
) else (
    echo [OK]   netlist.net
    set /a PASS+=1
)

:: -----------------------------------------------
:: [2/4] BOM
:: -----------------------------------------------
echo.
echo [2/%TOTAL%] 导出 BOM...
"%KICAD_CLI%" sch export bom ^
    --output "%OUT_DIR%\bom.csv" ^
    --fields "Reference,Value,Footprint,Quantity,${KISYS3DMOD},MPN,Manufacturer" ^
    --labels "位号,值,封装,数量,3D模型,料号,制造商" ^
    --group-by "Value,Footprint" ^
    "%SCH_FILE%"

if %errorlevel% neq 0 (
    :: 部分版本不支持 --labels，降级重试
    echo [WARN] 尝试简化参数重新导出 BOM...
    "%KICAD_CLI%" sch export bom ^
        --output "%OUT_DIR%\bom.csv" ^
        --fields "Reference,Value,Footprint,Quantity" ^
        --group-by "Value,Footprint" ^
        "%SCH_FILE%"
)

if %errorlevel% neq 0 (
    echo [FAIL] BOM 导出失败
    set /a FAIL+=1
) else (
    echo [OK]   bom.csv
    set /a PASS+=1
)

:: -----------------------------------------------
:: [3/4] PCB IPC-D-356
:: -----------------------------------------------
echo.
echo [3/%TOTAL%] 导出 PCB IPC-D-356...
"%KICAD_CLI%" pcb export ipcd356 ^
    --output "%OUT_DIR%\netlist.d356" ^
    "%PCB_FILE%"

if %errorlevel% neq 0 (
    echo [FAIL] IPC-D-356 导出失败
    set /a FAIL+=1
) else (
    echo [OK]   netlist.d356
    set /a PASS+=1
)

:: -----------------------------------------------
:: [4/4] Gerber + Drill
:: -----------------------------------------------
echo.
echo [4/%TOTAL%] 导出 Gerber + 钻孔文件...

:: Gerber 各层
"%KICAD_CLI%" pcb export gerbers ^
    --output "%GERBER_DIR%" ^
    --layers "F.Cu,B.Cu,F.Mask,B.Mask,F.Silkscreen,B.Silkscreen,F.Paste,B.Paste,Edge.Cuts" ^
    --subtract-soldermask ^
    "%PCB_FILE%"

if %errorlevel% neq 0 (
    echo [FAIL] Gerber 导出失败
    set /a FAIL+=1
    goto SUMMARY
)

:: 钻孔文件
"%KICAD_CLI%" pcb export drill ^
    --output "%GERBER_DIR%\\" ^
    --format excellon ^
    --drill-origin absolute ^
    --excellon-separate-th ^
    "%PCB_FILE%"

if %errorlevel% neq 0 (
    echo [FAIL] 钻孔文件导出失败
    set /a FAIL+=1
) else (
    echo [OK]   gerber\  ^(含 Gerber + 钻孔^)
    set /a PASS+=1
)

:: -----------------------------------------------
:: 汇总
:: -----------------------------------------------
:SUMMARY
echo.
echo ============================================
echo   导出完成  成功: %PASS%/%TOTAL%  失败: %FAIL%/%TOTAL%
echo ============================================
echo.
echo 输出目录结构：
echo %OUT_DIR%
echo ├── netlist.net      （原理图网表）
echo ├── bom.csv          （物料清单）
echo ├── netlist.d356     （IPC-D-356 测试网表）
echo └── gerber\          （Gerber + 钻孔）

echo.
if %FAIL% gtr 0 (
    echo [WARNING] 有 %FAIL% 项导出失败，请检查以上错误信息！
) else (
    echo [SUCCESS] 所有文件导出成功！
)

echo.
pause