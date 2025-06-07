# remap caps to esc
# https://superuser.com/questions/566871/how-to-map-the-caps-lock-key-to-escape-key-in-arch-linux
setxkbmap -option caps:escape

unclutter --timeout 1 &
exec i3
