while [ -z "$(getprop sys.boot_completed)" ]; do
sleep 10
done
# Modify by yourself
sh /data/adb/modules/[ID Module]/Example/Example.sh
