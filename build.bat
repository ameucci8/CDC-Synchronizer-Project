@echo off
rem Create the working library
vlib work
if %errorlevel% neq 0 (
    echo Failed to create work library
    exit /b %errorlevel%
)

rem Compile only the necessary SystemVerilog files


vlog C:\Users\andre\OneDrive\Documents\VScode\ecse_398_cdc\ecse398cdc\testbenches\soc_tb.sv
if %errorlevel% neq 0 (
    echo Compilation of processor_tb failed
    exit /b %errorlevel%
)

vlog C:\Users\andre\OneDrive\Documents\VScode\ecse_398_cdc\ecse398cdc\testbenches\soc_prime_tb.sv
if %errorlevel% neq 0 (
    echo Compilation of processor_tb failed
    exit /b %errorlevel%
)

vlog C:\Users\andre\OneDrive\Documents\VScode\ecse_398_cdc\ecse398cdc\testbenches\soc_async_prime_tb.sv
if %errorlevel% neq 0 (
    echo Compilation of processor_tb failed
    exit /b %errorlevel%
)

vlog C:\Users\andre\OneDrive\Documents\VScode\ecse_398_cdc\ecse398cdc\testbenches\soc_load_prime_tb.sv
if %errorlevel% neq 0 (
    echo Compilation of processor_tb failed
    exit /b %errorlevel%
)

vlog C:\Users\andre\OneDrive\Documents\VScode\ecse_398_cdc\ecse398cdc\testbenches\soc_async_load_prime_tb.sv
if %errorlevel% neq 0 (
    echo Compilation of processor_tb failed
    exit /b %errorlevel%
)

rem Start the simulation
vsim -L work work.soc_async_prime_tb
if %errorlevel% neq 0 (
    echo Simulation failed
    exit /b %errorlevel%
)

pause  rem Keeps the window open to see the output
