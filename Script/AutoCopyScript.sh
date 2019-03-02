
cd $BUILT_PRODUCTS_DIR

mkdir $PROJECT_NAME.framework/Frameworks &>/dev/null

for framework in *.framework; do
if [ $framework != $PROJECT_NAME.framework ]; then
cp -r $framework $PROJECT_NAME.framework/Frameworks/ &>/dev/null
fi
done
