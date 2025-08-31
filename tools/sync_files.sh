#! /bin/sh

BASE_LOGSEQ_FOLDER=/Users/user/Documents/logseq/pages

# loop through files in Logseq folder
for file in ${BASE_LOGSEQ_FOLDER}/*; do
    # get the base filename
    base_filename=$(basename "${file}")

    # get the cksum of the Logseq file
    logseq_cksum=$(cksum "${file}" | cut -d ' ' -f 1)

    # if the file exists in this repo, get it's cksum
    copy_file=0
    repo_filename="./recipes/${base_filename}"
    if test -f "${repo_filename}"; then
        repo_cksum=$(cksum "${repo_filename}" | cut -d ' ' -f 1)
        echo "repo_cksum: $repo_cksum"
    else
        copy_file=1
        echo "file not found in repo"
    fi

    # if the file doesn't exist, or it's cksum has changed copy it
    if [ ${copy_file} -eq 1 ] || [ $logseq_cksum -ne $repo_cksum ]; then
        cp "${file}" "${repo_filename}"
        echo "copying file to repo"
    fi

    # debug
    echo "basefilename: ${base_filename}, cksum: ${logseq_cksum}"
done
