LATESTARTSERVICE=true

ui_print "🗡--------------------------------🗡"
ui_print "                        "
ui_print "🗡--------------------------------🗡"
ui_print "         By:         "
ui_print "------------------------------------"
ui_print "           "
ui_print "------------------------------------"
ui_print " "
sleep 1.5

ui_print "-----------------📱-----------------"
ui_print "            DEVICE INFO             "
ui_print "-----------------📱-----------------"
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

ui_print "-----------------🗡-----------------"
ui_print "            MODULE INFO             "
ui_print "-----------------🗡-----------------"
ui_print "Name : "
ui_print "Version : 3.0"
ui_print "Support Root : Magisk / KernelSU / APatch"
ui_print " "
sleep 1.5

ui_print "      INSTALLING        "
ui_print " "
sleep 1.5


# This actually the method I use for the scripting. Because my script is not
# On service.sh. Instead I make a new folder containing the script, and execute in service.sh

unzip -o "$ZIPFILE" '[Folder Name]/*' -d $MODPATH >&2
set_perm_recursive $MODPATH/[Folder Name] 0 0 0774 0774
