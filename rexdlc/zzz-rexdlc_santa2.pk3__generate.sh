#!/bin/bash -e

# dumb script to generate zzz-rexdlc_santa2.pk3 from func_xmasjam2017_v2.zip
# -> this is the media content required for the "Santa" model in Rexuiz as a christmas gimmick

echo 'entire dumb script - generates "zzz-rexdlc_santa2.pk3" from func_xmasjam2017_v2.zip'

if [ -f zzz-rexdlc_santa2.pk3 ]; then
  echo
  echo "zzz-rexdlc_santa2.pk3 already exists -> exit"
  echo
  exit 1
fi

if [ ! -f func_xmasjam2017_v2.zip ]; then
  echo
  echo "download func_xmasjam2017_v2.zip manually from: https://www.moddb.com/addons/xmas-jam-2017-v2"
  echo
  exit 1
fi

echo "requires: unzip, zip, sha256sum"
echo "exiting -> remove me if you know what you are doing"
exit 1


tempdir=$(mktemp -d)
unzip func_xmasjam2017_v2.zip -d ${tempdir}/_xmasjam > /dev/null

mkdir -p ${tempdir}/_work/sound/ctest1/santa
mkdir -p ${tempdir}/_work/models/ctest1

echo "1" > ${tempdir}/_work/rexdlc_santa2.serverpackage

cat << EOF > ${tempdir}/_work/rexdlc_santa2_server.cfg
modelprecache "models/ctest1/santa2.mdl"
modelprecache "models/ctest1/proj_snowball.mdl"
EOF

cat << EOF > ${tempdir}/_work/readme.txt
The Santa model + sounds are taken from the Arcane Dimensions Xmas Jam 2017

Source:
https://www.moddb.com/mods/arcane-dimensions/addons/xmas-jam-2017-v2

Main purpose: temporary replace the "Butcher" in rexuiz for a "christmas special" :)

EOF

cat << EOF > ${tempdir}/sha2
96972ba473b6a7d28645cdc621eb3011729a53eb4acb40d1f097768291a70850  ./sound/ctest1/santa/sack_swing.wav
79eed9346e0954fd53a6fdb9aa9708b8c29e8c5c256e9fd7c06f449e9cb6c00d  ./sound/ctest1/santa/pain1.wav
091a28236362cab1ce3b7bd55de25010d105db3bf644825c47b91725d8a613a0  ./sound/ctest1/santa/hohoho.wav
c23a04ed5134f76d1f44d2e61eeb446a569c2bcbccf79f16f472807aae3df53a  ./sound/ctest1/santa/sack_hit.wav
9cedf379a4504253bded76a67ba6d507706eec8e8c60321b0fe0bdd4f5597665  ./rexdlc_santa2_server.cfg
d3961719b7e6ee86acb9a6b0e9a8e93bec625efe80980070f52995fd086e6d72  ./models/ctest1/proj_snowball.mdl
47521468e8a2c1e8dd6a67dec7c0dd0af5d1cd1d38a6294f7294a3b664c966c9  ./models/ctest1/santa2.mdl
4355a46b19d348dc2f57c046f8ef63d4538ebb936000f3c9ee954a27460dd865  ./rexdlc_santa2.serverpackage
9faec2171d7ea27130f33d32e402e669937d4e1cce24eba67e0d702019aefb0a  ./readme.txt
EOF

sounds="
sack_swing.wav
pain1.wav
sack_hit.wav
hohoho.wav
"

for sound in $sounds; do
  cp ${tempdir}/_xmasjam/sound/xmas/santa/${sound} ${tempdir}/_work/sound/ctest1/santa/.
done

cp ${tempdir}/_xmasjam/progs/xmas/mon_santa.mdl ${tempdir}/_work/models/ctest1/santa2.mdl
cp ${tempdir}/_xmasjam/progs/xmas/proj_snowball.mdl ${tempdir}/_work/models/ctest1/.


# compress it
pushd . > /dev/null
cd ${tempdir}/_work
sha256sum --quiet -c ../sha2
if [ $? -ne 0 ]; then
  echo "checksum does not match -> exit"
else
  zip --quiet -r ${tempdir}/zzz-rexdlc_santa2.pk3 *
  popd > /dev/null
  mv ${tempdir}/zzz-rexdlc_santa2.pk3 .
  echo
  echo "should have worked:"
  ls -la zzz-rexdlc_santa2.pk3
fi

rm -rf ${tempdir}
