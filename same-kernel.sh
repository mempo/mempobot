echo "THIS SCRIPT IS NOT YET READY TO BE USED HERE" ; exit 


echo "-------------------------------------------"
echo "The Mempo's version"
echo "-------------------------------------------"

#cd ~
rm -rf deterministic-kernel/
git clone https://github.com/mempo/deterministic-kernel.git
#cd deterministic-kernel/

# TODO verify signature
#LANG=C git tag -v `git describe --tags`
#echo "if signature is correct then press ENTER, else Ctrl-C to abort"
#read _

bash deterministic-kernel/run.sh 

#sha256sum deterministic-kernel/kernel-build/linux-mempo/*.sh
sums=$(sha256sum deterministic-kernel/kernel-build/linux-mempo/*.deb)

#./notify.sh  $sums 
