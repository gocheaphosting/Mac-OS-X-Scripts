#! /bin/bash

tablength=60

echo

for suffix in all summary short tidy ; do
	echo "Deleting *_${suffix}.txt"
	rm *_${suffix}.txt
done

echo

for NAME in Account_Detail Airtime_Detail DEW_Report Group_Summary Individual_Detail Invoice_Summary ; do
		echo
		cat ${NAME}* | expand -t $tablength > ${NAME}_all.txt
		echo Created ${NAME}_all.txt
		cat ${NAME}_all.txt | \
			egrep "(^\"Total)|(^Invoice)" \
			> ${NAME}_summary.txt
		echo Created ${NAME}_summary.txt
		cat ${NAME}_summary.txt | grep -v '$0.00' > ${NAME}_short.txt
		echo Created ${NAME}_short.txt
		cat ${NAME}_short.txt | sed 's/\(^.*\).*Unique.*/          \1/' > ${NAME}_tidy.txt
		echo Created ${NAME}_tidy.txt
done
