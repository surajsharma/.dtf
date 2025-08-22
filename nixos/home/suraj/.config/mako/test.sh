
echo "Testing Mako notifications..."

# Kill any existing mako instance
pkill mako
sleep 1

# Start mako
mako &
sleep 2

# Test notifications
notify-send "Hello" "Mako is working!"
sleep 2

notify-send -u low "Low Priority" "This message has low priority"
sleep 2

notify-send -u critical "Critical Alert" "This is a critical message!"
sleep 2

notify-send -a "Volume" -h int:value:50 "Volume" "50%"
sleep 2

notify-send -i dialog-information "Info" "This has an icon"

echo "Tests complete! Check your notifications."
