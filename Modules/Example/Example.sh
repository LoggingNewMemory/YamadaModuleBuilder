# This is a function, so you don't need to chmod 644 everytime

tweak() {
	if [ -f $2 ]; then
		chmod 644 $2 >/dev/null 2>&1
		echo $1 >$2 2>/dev/null
		chmod 444 $2 >/dev/null 2>&1
	fi
}

# you can use this like this

tweak <your modification>
