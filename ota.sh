DEVICE=$1
FLAVOUR=$2
DATE=$(date +%Y-%m-%d)

if [ $# -lt 2 ]; then
    echo "Missing mandatory parameters it must be like this :- bash ota.sh rmx3371 vanilla/gapps"
    exit 1
fi

cd OTA
mkdir -p $DEVICE/official/web
touch $DEVICE/official/$FLAVOUR.json

if [ $FLAVOUR == "vanilla" ]; then
DATETIME=$(grep "ro.build.date.utc=" out/target/product/$DEVICE/system/build.prop | cut -d "=" -f 2)
FILENAME=$(find out/target/product/$DEVICE/Legion-v*VANILLA.zip | cut -d "/" -f 6)
ID=$(sha256sum out/target/product/$DEVICE/Legion-v*VANILLA.zip | cut -d " " -f 1)
FILEHASH=$ID
SIZE=$(wc -c out/target/product/$DEVICE/Legion-v*VANILLA.zip | awk '{print $1}')
else
DATETIME=$(grep "ro.build.date.utc=" out/target/product/$DEVICE/system/build.prop | cut -d "=" -f 2)
FILENAME=$(find out/target/product/$DEVICE/Legion-v*GAPPS.zip | cut -d "/" -f 6)
ID=$(sha256sum out/target/product/$DEVICE/Legion-v*GAPPS.zip | cut -d " " -f 1)
FILEHASH=$ID
SIZE=$(wc -c out/target/product/$DEVICE/Legion-v*GAPPS.zip | awk '{print $1}')
fi

URL="https://sourceforge.net/projects/legionrom/files/$DEVICE/$FILENAME/download"
VERSION="13.0"
ROMTYPE="OFFICIAL"
JSON_FMT='{\n \t"response": [\n\t\t {\n\t\t\t\t\t\t\t\t"date":"%s ",\n\t\t\t\t\t\t\t\t"datetime":"%s",\n\t\t\t\t\t\t\t\t"filename":"%s",\n\t\t\t\t\t\t\t\t"url":"%s",\n\t\t\t\t\t\t\t\t"id":"%s",\n\t\t\t\t\t\t\t\t"size":"%s",\n\t\t\t\t\t\t\t\t"romtype":"%s",\n\t\t\t\t\t\t\t\t"version":"%s"\n\t\t}\n\t]\n}'
printf "$JSON_FMT" "$DATE" "$DATETIME" "$FILENAME" "$URL" "$ID" "$SIZE"  "$ROMTYPE" "$VERSION" > $DEVICE/official/$FLAVOUR.json
echo $FLAVOUR.json file created

cd OTA && git add . && git commit -m "$DEVICE: Latest $FLAVOUR update" && git push LegionOS-Devices HEAD:s
