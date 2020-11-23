#! /bin/sh
# set -x
make all
./writetests
cd tests
rm *.um
rm *.0
rm *.1
cd ../
mv *.um tests
mv *.0 tests
mv *.1 tests
cd tests
testFiles=$(ls *.um)
for testFile in $testFiles ; do
    testName=$(echo $testFile | sed -E 's/(.*).um/\1/')
    if [ -e "$testName.0" ] ; then
        um "$testName.um" < "$testName.0" > "$testName.rf"
        ../um "$testName.um" < "$testName.0" > "$testName.mine"
    else
        um "$testName.um" > "$testName.rf"
        ../um "$testName.um" > "$testName.mine"
    fi
    diff "$testName.rf" "$testName.mine"
    if [ -e "$testName.1" ] ; then
        diff "$testName.rf" "$testName.1"
        diff "$testName.mine" "$testName.1"
    fi
done
echo "If no diff results showed, all tests succeeded!"