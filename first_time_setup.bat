@echo off
python -m venv .env
.env\Scripts\python.exe -m pip install --upgrade pip
call clean_environment