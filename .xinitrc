# remap caps to esc
# https://superuser.com/questions/566871/how-to-map-the-caps-lock-key-to-escape-key-in-arch-linux
setxkbmap -option caps:escape #-option altwin:swap_alt_win

#xinput --set-prop 20 "libinput Accel Speed" 1
unclutter --timeout 1 &

xrandr --output DP-1-1.1.5 --auto
#xrandr --output DP-1-3 --left-of DP-1-1.1.5 --rotate left
xrandr --output eDP-1 --off

# resolve error on `secret-tool store`
#   secret-tool: Object does not exist at path “/org/freedesktop/secrets/collection/login”
source /etc/X11/xinit/xinitrc.d/50-systemd-user.sh

exec i3
