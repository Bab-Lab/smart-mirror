for f in $(find lib -type f -name "*.dart")
do
  echo $f
  tr -cd ';' < $f | wc -c
done
