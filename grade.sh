CPATH='.:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar'

rm -rf student-submission
rm -rf grading-area

mkdir grading-area

git clone $1 student-submission
echo 'Finished cloning'

if [[ -f "student-submission/ListExamples.java" ]]; then
    echo "File found"
else
    echo "file ListExamples.java not found"
    exit 1
fi

cp student-submission/ListExamples.java grading-area/
cp TestListExamples.java grading-area/
cp -r lib grading-area

cd grading-area
javac -cp $CPATH *.java 2>/dev/null

if [[ $? -ne 0 ]]; then
    echo "Compilation error!"
    exit 1
fi

echo "Program compiled successfully"

java -cp $CPATH org.junit.runner.JUnitCore TestListExamples > junit-output.txt

numOK=$(grep -c "OK" junit-output.txt)

if [[ $numOK -eq 1 ]]; then
    echo "You have passed all the tests!"
else
    lastline=$(cat junit-output.txt | tail -n 2 | head -n 1)
    tests=$(echo $lastline | awk -F'[, ]' '{print $3}')
    failures=$(echo $lastline | awk -F'[, ]' '{print $6}')
    successes=$((tests - failures))
    echo "Your score is $successes / $tests"
fi



# Draw a picture/take notes on the directory structure that's set up after
# getting to this point

# Then, add here code to compile and run, and do any post-processing of the
# tests
