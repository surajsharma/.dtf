#!/run/current-system/sw/bin/zsh
WALLPAPER=$(swww query | grep -o "image: .*" | cut -d' ' -f2- | tr -d '"')

# Generate CSS with the current wallpaper
cat > ~/.config/gtklock/style.css << EOF
window {
   background-size: cover;
   background-repeat: no-repeat;
   background-position: center;
   background-color: black;
   background-image: 
      linear-gradient(rgba(0, 0, 0, 0.88), rgba(0, 0, 0, 0.88)), /* translucent overlay */
      url("$WALLPAPER");
}


entry {
  background: rgba(0, 0, 0, 0.35);
  border: 1px solid rgba(255, 255, 255, 0.25);
  border-radius: 2px;
  padding: 10px 14px;
  color: white;
  caret-color: white;
}

button {
  background: rgba(255,255,255,0.12);
  border: 1px solid rgba(255,255,255,0.28);
  border-radius: 2px;
  padding: 8px 14px;
}

button:hover { background: rgba(255,255,255,0.18); }

#info-box{
  padding: 0;
  margin: 0;
  font-family: monospace;
}

#input-label{
  opacity: 0;
  margin-left:-100px;
}

EOF
gtklock  -s ~/.config/gtklock/style.css -d
