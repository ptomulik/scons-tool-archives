%SHELL% "echo 'cd %APPVEYOR_BUILD_FOLDER%' | sed -e 's/^\\(\\w\\):/\\/\\l\\1/' -e 's/\\\\/\\//g' | tee -a ~/.profile"
%SHELL% "echo 'PATH=~/.local/bin:$PATH' | tee -a ~/.profile"

%SHELL% "pacman -Sy --disable-download-timeout --noconfirm --needed %PY% %PY%-pip"
%SHELL% "%PY% -m pip install -r requirements.txt"
%SHELL% "%PY% bin/downloads.py"
