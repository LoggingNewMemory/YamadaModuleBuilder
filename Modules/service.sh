while [ -z "$(getprop sys.boot_completed)" ]; do
	sleep 30
	# Modify by yourself
    /data/adb/modules/[ID Module]/Example/Example.sh
done

