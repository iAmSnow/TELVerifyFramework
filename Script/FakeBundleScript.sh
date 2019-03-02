
APP_PATH="${TARGET_BUILD_DIR}/${WRAPPER_NAME}"
find "$APP_PATH" -name '*.framework' -type d | while read -r FRAMEWORK
do
FRAMEWORK_EXECUTABLE_NAME=$(defaults read "$FRAMEWORK/Info.plist" CFBundleExecutable)
FRAMEWORK_EXECUTABLE_PATH="$FRAMEWORK/$FRAMEWORK_EXECUTABLE_NAME"
BUNDLE_IN_ROOT="$APP_PATH/${FRAMEWORK_EXECUTABLE_NAME}.bundle"
if [[ -e "$FRAMEWORK_EXECUTABLE_PATH" ]]; then
FRAMEWORK_MACH_O="$(otool -a "$FRAMEWORK_EXECUTABLE_PATH" | head -n 1)"
FRAMEWORK_FAT_ARCH="$(lipo -info "$FRAMEWORK_EXECUTABLE_PATH")"
else
FRAMEWORK_MACH_O="NO EXIST"
FRAMEWORK_FAT_ARCH="NO EXIST"
fi
echo "FRAMEWORK_EXECUTABLE_NAME is $FRAMEWORK_EXECUTABLE_NAME"
echo "FRAMEWORK_EXECUTABLE_PATH is $FRAMEWORK_EXECUTABLE_PATH"
echo "FRAMEWORK_MACH_O is $FRAMEWORK_MACH_O"
echo "FRAMEWORK_FAT_ARCH is $FRAMEWORK_FAT_ARCH"
echo "BUNDLE_IN_ROOT is $BUNDLE_IN_ROOT"
if [[ "$FRAMEWORK_MACH_O" =~ "Archive :" ]]; then
echo "Rmove Static-Mach-O is $FRAMEWORK_EXECUTABLE_PATH"
rm "$FRAMEWORK_EXECUTABLE_PATH"
defaults write "$FRAMEWORK/Info.plist" CFBundlePackageType "BNDL"
defaults delete "$FRAMEWORK/Info.plist" CFBundleExecutable
if [[ -d "$BUNDLE_IN_ROOT" ]]; then
rm -rf "$BUNDLE_IN_ROOT"
fi
mv -f "$FRAMEWORK" "$BUNDLE_IN_ROOT"
elif [[ "$FRAMEWORK_FAT_ARCH" =~ "Architectures in the fat file" ]]; then
#statements
EXTRACTED_ARCHS=()
for ARCH in $ARCHS
do
echo "Extracting $ARCH from $FRAMEWORK_EXECUTABLE_NAME"
lipo -extract "$ARCH" "$FRAMEWORK_EXECUTABLE_PATH" -o "$FRAMEWORK_EXECUTABLE_PATH-$ARCH"
EXTRACTED_ARCHS+=("$FRAMEWORK_EXECUTABLE_PATH-$ARCH")
done
echo "Merging extracted architectures: ${ARCHS}"
lipo -o "$FRAMEWORK_EXECUTABLE_PATH-merged" -create "${EXTRACTED_ARCHS[@]}"
rm "${EXTRACTED_ARCHS[@]}"
echo "Replacing original executable with thinned version"
rm "$FRAMEWORK_EXECUTABLE_PATH"
mv "$FRAMEWORK_EXECUTABLE_PATH-merged" "$FRAMEWORK_EXECUTABLE_PATH"
fi
done