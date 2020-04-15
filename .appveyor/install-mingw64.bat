%SHELL% "echo 'cd %APPVEYOR_BUILD_FOLDER%' | sed -e 's/^\\(\\w\\):/\\/\\l\\1/' -e 's/\\\\/\\//g' | tee -a ~/.profile"
%SHELL% "echo 'PATH=~/.local/bin:$PATH' | tee -a ~/.profile"

%SHELL% "pacman -Sy --disable-download-timeout --noconfirm --needed %PY% %PY%-pip"
IF [%PY%]==[python2] (
  %SHELL% "pacman -Rcs --noconfirm python3 mingw-w64-x86_64-python3"
  %SHELL% "%PY% -m pip install --upgrade pip"
  %SHELL% "%PY% -m pip install -r requirements2-dev.txt"
) ELSE (
  %SHELL% "pacman -Rcs --noconfirm python2 mingw-w64-x86_64-python3"
  %SHELL% "%PY% -m pip install --upgrade pip"
  %SHELL% "%PY% -m pip install -r requirements3-dev.txt"
)
%SHELL% "%PY% -m pip install -r requirements.txt"
%SHELL% "%PY% bin/downloads.py"
