%SHELL% "echo 'cd %APPVEYOR_BUILD_FOLDER%' | sed -e 's/^\\(\\w\\):/\\/\\l\\1/' -e 's/\\\\/\\//g' | tee -a ~/.profile"
%SHELL% "echo 'PATH=~/.local/bin:$PATH' | tee -a ~/.profile"

REM Remove all unwanted packages
%SHELL% "pacman -Qqs '(^mingw-w64-|^scons$|^python$|^python2$|^python3$)' | sort | uniq | xargs pacman -Rcs --noconfirm"

REM Upgrade remaining packages
%SHELL% "pacman -Syu --disable-download-timeout --noconfirm"
%SHELL% "pacman -Syu --disable-download-timeout --noconfirm"

REM Install what's necessary
%SHELL% "pacman -Sy --disable-download-timeout --noconfirm --needed %PY% %PY%-pip"
IF [%PY%]==[python2] (
  %SHELL% "test -e /usr/bin/python || ln -s /usr/bin/python2 /usr/bin/python"
  %SHELL% "%PY% -m pip install -r requirements2-dev.txt"
) ELSE (
  %SHELL% "%PY% -m pip install -r requirements3-dev.txt"
)
%SHELL% "%PY% -m pip install -r requirements.txt"
%SHELL% "%PY% bin/downloads.py"
