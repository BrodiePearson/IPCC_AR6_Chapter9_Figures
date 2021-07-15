for somefile in $(ls *.png)
do
    echo convert $somefile -trim $somefile
    convert $somefile -trim $somefile
done
