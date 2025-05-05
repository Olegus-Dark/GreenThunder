@echo off
chcp 65001 > nul
setlocal enabledelayedexpansion
title Обновление GreenThunder Курлык-Курлык!

:: Настройки (владелец репы, репа, ветка)
set "repo_owner=Olegus-Dark"
set "repo_name=GreenThunder"
set "branch=main"

:: Упрощаем пути
set "script_dir=%~dp0"
set "temp_zip=%script_dir%_%repo_name%_temp.zip"
set "extract_folder=%script_dir%%repo_name%-%branch%"
set "zip_url=https://github.com/%repo_owner%/%repo_name%/archive/%branch%.zip"

echo ========================================
echo  Обновление %repo_name% 
echo ========================================

:: 1. Выпиливаем времянки
echo [1/4] Подготовка...
if exist "%temp_zip%" del "%temp_zip%"
if exist "%extract_folder%" rmdir /s /q "%extract_folder%"

:: 2. КАЧАТЕЛЬ 3000
echo [2/4] Грузим репу через зипку...
powershell -Command "[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12; $ProgressPreference = 'SilentlyContinue'; Invoke-WebRequest '%zip_url%' -OutFile '%temp_zip%'"
if not exist "%temp_zip%" (
    echo ОШИБКА: Не удалось скачать архив
    echo Проверьте:
    echo 1. Интернет-соединение
    echo 2. Название репозитория
    echo 3. Что ветка "%branch%" существует
    echo 777. Что у вас есть разрешение на 777!
    pause
    exit /b
)

:: 3. Распаковка
echo [3/4] Дербаним зипку...
powershell -Command "Add-Type -AssemblyName System.IO.Compression.FileSystem; [IO.Compression.ZipFile]::ExtractToDirectory('%temp_zip%', '%script_dir%')"
if not exist "%extract_folder%" (
    echo ОШИБКА: Не найдена папка после распаковки
    echo Попробуйте изменить ветку в настройках скрипта
    del "%temp_zip%"
    pause
    exit /b
)

:: 4. двигаем файлы
echo [4/4] Переносим файлы...
xcopy "%extract_folder%\*" "%script_dir%" /E /H /C /I /Q /Y >nul

:: Готово! Очистка
rmdir /s /q "%extract_folder%"
del "%temp_zip%"

echo.
echo ========================================
echo  УСПЕШНО! Все файлы обновлены КУРЛЫК!
echo  Расположение: %script_dir%
echo  СКРИПТ ЗАКРОЕТСЯ ЧЕРЕЗ ПЯТЬ СЕК, АГЛЫ!
echo ========================================
echo.
timeout /t 5