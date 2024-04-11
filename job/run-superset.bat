@echo off
REM Get the current date and time
echo %date% %time% > E:\warehouse\job\log.txt

REM 1. Activate the virtual environment
call E:\warehouse\venv\Scripts\activate >> E:\warehouse\job\log.txt 2>&1

REM Check if the virtual environment is activated
IF NOT DEFINED VIRTUAL_ENV (
    echo Failed to activate virtual environment
    exit /b
)
echo Activated virtual environment successfully  >> E:\warehouse\job\log.txt 2>&1

REM 2. Check if port 4000 is in use and kill the process if it is
FOR /F "tokens=5" %%P IN ('netstat -ano ^| findstr :4000') DO (
    IF NOT "%%P"=="0" (
        echo Killing process on port 4000 with PID: %%P >> E:\warehouse\job\log.txt 2>&1
        taskkill /F /PID %%P
    )
)

REM Create a port tunnel 
start /B ssh -i ~/.ssh/hh-for-jump.pem -L 4000:hhdatabasev2.c1mrowwap63w.eu-west-1.rds.amazonaws.com:5432 jumpbox -N
echo Attempted to create first port (4000) tunnel  >> E:\warehouse\job\log.txt 2>&1

REM 3. Check if port 4001 is in use and kill the process if it is
FOR /F "tokens=5" %%P IN ('netstat -ano ^| findstr :4001') DO (
    IF NOT "%%P"=="0" (
        echo Killing process on port 4001 with PID: %%P  >> E:\warehouse\job\log.txt 2>&1
        taskkill /F /PID %%P
    )
)

start /B ssh -i ~/.ssh/hh-for-jump.pem -L 4001:hhdatabasev2.c1mrowwap63w.eu-west-1.rds.amazonaws.com:5432 jumpbox -N
echo Attempted to create 2nd port (4001) tunnel  >> E:\warehouse\job\log.txt 2>&1


REM Run Superset in the background
superset run -h 0.0.0.0 -p 8088 --with-threads --reload --debugger
echo Attempted to run Superset in the background