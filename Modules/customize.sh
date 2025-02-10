LATESTARTSERVICE=true

ui_print "------------------------------------"
ui_print "                        "
ui_print "------------------------------------"
ui_print "         By:         "
ui_print "------------------------------------"
ui_print "           "
ui_print "------------------------------------"
ui_print " "
sleep 1.5

ui_print "------------------------------------"
ui_print "            DEVICE INFO             "
ui_print "------------------------------------"
ui_print "DEVICE : $(getprop ro.build.product) "
ui_print "MODEL : $(getprop ro.product.model) "
ui_print "MANUFACTURE : $(getprop ro.product.system.manufacturer) "
ui_print "PROC : $(getprop ro.product.board) "
ui_print "CPU : $(getprop ro.hardware) "
ui_print "ANDROID VER : $(getprop ro.build.version.release) "
ui_print "KERNEL : $(uname -r) "
ui_print "RAM : $(free | grep Mem |  awk '{print $2}') "
ui_print " "
sleep 1.5

ui_print "------------------------------------"
ui_print "            MODULE INFO             "
ui_print "------------------------------------"
ui_print "Name : "
ui_print "Version : 1.0"
ui_print "Support Root : Magisk / KernelSU / APatch"
ui_print " "
sleep 1.5

ui_print "      INSTALLING [ENTER NAME]       "
ui_print " "
sleep 1.5

# Replace or remove Marine if needed

unzip -o "$ZIPFILE" 'Marine/*' -d $MODPATH >&2
set_perm_recursive $MODPATH/Marine 0 0 0774 0774

# You can addd something more here