### finalduty@github.com [rev: 8fe916e]
## Clone and Deploy VMWare Machine
srcvm='nfs-a01.finalduty.me'
dstvm='_template-centos'

srcpath='/vmfs/volumes/datastore0'
dstpath='/vmfs/volumes/datastore0'
src="$srcpath/$srcvm/"
dst="$dstpath/$dstvm"

startTime=`date +%s`
 cp -a $src $dst
 vmkfstools -E $dst/$srcvm.vmdk $dst/$dstvm.vmdk
 for i in `ls $dst | grep $srcvm`; do mv $dst/$i $dst/`echo $i | sed "s|$srcvm|$dstvm|"`; done
 sed -i "s|$srcvm|$dstvm|"g $dst/$dstvm.vmx
 vmid=$(vim-cmd solo/registervm $dst/$dstvm.vmx)
 vim-cmd vmsvc/power.on $vmid &
 sleep 1; vim-cmd vmsvc/message $vmid _vmx1 2
 vim-cmd vmsvc/getallvms | grep $vmid
 vim-cmd vmsvc/power.getstate $vmid | grep Powered
endTime=`date +%s`

echo "Start    : `date +%c -d @\$startTime`"; echo "Finish   : `date +%c -d @$endTime`"; echo "Duration : $(date +%T -d `echo @$(( $endTime - $startTime -43200 ))`)"
