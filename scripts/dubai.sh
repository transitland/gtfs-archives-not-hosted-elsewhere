# Dubai RTA provides GTFS in a 7z archive
# at https://www.dubaipulse.gov.ae/data/rta_gtfs-open/datafiles/605e9d34-cfea-4bed-9b31-3b2ce86c7a25/rta-public-transports#preview
# This script downloads that archive, removes any nested subdirectories, and zips
# the contents back into a zip archive (as required by the GTFS spec)

# brew install httpie p7zip

http --download https://www.dubaipulse.gov.ae/dataset/619d7723-33df-42d6-a87b-744c77dc45a1/resource/605e9d34-cfea-4bed-9b31-3b2ce86c7a25/download/gtfs.7z

7z x *.7z

zip -j dubai-rta.zip */**/*.txt 

rm -r *.7z
rm -r */**/*.txt