# "test" checks if the file/profile/bashrc exists usinf '-f'
# and if file exists then runs the next command
# Example:
# generated by Git for Windows
# test -f ~/.profile && . ~/.profile

bashrc_path=~/.bash-config/.bashrc
# bashrc_path="C:/Users/qtpie/.bashrc"
test -f $bashrc_path && . $bashrc_path
