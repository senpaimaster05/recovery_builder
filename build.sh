MANIFEST="https://github.com/minimal-manifest-twrp/platform_manifest_twrp_aosp"
DEVICE=X689B
DT_LINK="https://github.com/mastersenpai0405/twrp_Infinix_Hot_10s"
DT_PATH=device/infinix/$DEVICE

echo " ===+++ Setting up Build Environment +++==="
apt install openssh-server -y
apt update --fix-missing
apt install openssh-server -y
mkdir ~/twrp && cd ~/twrp

echo " ===+++ Syncing Recovery Sources +++==="
repo init --depth=1 -u $MANIFEST
repo sync
repo sync
git clone $DT_LINK $DT_PATH

echo " ===+++ Building Recovery +++==="
. build/envsetup.sh
export ALLOW_MISSING_DEPENDENCIES=true
lunch twrp_${DEVICE}-eng && mka bootimage

# Upload zips & recovery.img
echo " ===+++ Uploading Recovery +++==="
version=$(cat bootable/recovery/variables.h | grep "define TW_MAIN_VERSION_STR" | cut -d \" -f2)
OUTFILE=TWRP-${version}-${DEVICE}-$(date "+%Y%m%d-%I%M").zip

cd out/target/product/$DEVICE
mv boot.img ${OUTFILE%.zip}.img
zip -r9 $OUTFILE ${OUTFILE%.zip}.img

curl -sL $OUTFILE https://git.io/file-transfer | sh
./transfer wet *.zip
© 2021 GitHub, Inc.
