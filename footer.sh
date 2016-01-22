function footer {

	thisfile_old="$thisfile"
	thisfile="footer"
	
	[[ $count ]] && if [ $count -gt 0 ] ; then echo >&2 ; fi
	
	thisfile="$thisfile_old"

}
