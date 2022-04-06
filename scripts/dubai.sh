# Dubai RTA provides GTFS in a 7z archive
# at https://www.dubaipulse.gov.ae/data/rta_gtfs-open/datafiles/605e9d34-cfea-4bed-9b31-3b2ce86c7a25/rta-public-transports#preview
# This script downloads that archive, removes any nested subdirectories, and zips
# the contents back into a zip archive (as required by the GTFS spec)

# brew install p7zip
# brew install libzip

wget -O dubai-rta.7z https://www.dubaipulse.gov.ae/dataset/619d7723-33df-42d6-a87b-744c77dc45a1/resource/605e9d34-cfea-4bed-9b31-3b2ce86c7a25/download/gtfs.7z

7z x -aoa dubai-rta.7z -odubai-rta

for zipfile in ./dubai-rta/*.zip; do
  zipcmp $zipfile ../dubai-rta.zip && {
    echo "zip contents changed"
    mv $zipfile ..
  } || {
    echo "contents are the same as before"
  }
done