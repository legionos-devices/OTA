DEVICE=$1
FLAVOUR=$2
BRAND=$3
MODEL=$4
DEV=$5

if [ $# -lt 5 ]; then
    echo "Missing mandatory parameters it must be like this :- bash ota.sh jasmine_sprout vanilla Xioami A2 "Immanuel Raj""
    exit 1
fi

DATETIME=$(grep "ro.build.date.utc=" out/target/product/$DEVICE/system/build.prop | cut -d "=" -f 2)
FILENAME=$(find out/target/product/$DEVICE/LegionOS-v*.zip | cut -d "/" -f 5)
ID=$(sha256sum out/target/product/$DEVICE/LegionOS-v*.zip | cut -d " " -f 1)
FILEHASH=$ID
SIZE=$(wc -c out/target/product/$DEVICE/LegionOS-v*.zip | awk '{print $1}')
URL="https://sourceforge.net/projects/legionrom/files/$DEVICE/$FILENAME/download"
VERSION="v11.0"
ROMTYPE="OFFICIAL"
JSON_FMT='{ "response": [ { "datetime": "%s","filename":" %s","id":"%s","romtype": "%s", "size":"%s", "url":"%s", "version": "%s","device_brand": "%s","device_model": "%s","device_codename": "%s","developer": "%s"} ] }'
printf "$JSON_FMT" "$DATETIME" "$FILENAME" "$ID" "$ROMTYPE" "$SIZE" "$URL" "$VERSION" "$BRAND" "$MODEL" "$DEVICE" "$DEV"> OTA/$DEVICE/$FLAVOUR.json
echo $/OTA/$DEVICE/$FLAVOUR.json file created

cd OTA && git add . && git commit -m "$DEVICE: Latest $FLAVOUR update" && git push LegionOS-Devices HEAD:11
