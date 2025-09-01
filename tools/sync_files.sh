#! /bin/sh

BASE_LOGSEQ_FOLDER=/Users/user/Documents/logseq/pages

# loop through files in Logseq folder
for file in ${BASE_LOGSEQ_FOLDER}/*; do
    # get the base filename
    base_filename=$(basename "${file}")

    # Skip over the template and contents.md
    if [ "${base_filename}" = "Recipe Template.md" ] or [ "${base_filename}" = "contents.md"]; then
        continue
    fi

    # get the cksum of the Logseq file
    logseq_cksum=$(cksum "${file}" | cut -d ' ' -f 1)

    # if the file exists in this repo, get it's cksum
    new_file=0
    repo_filename="./recipes/${base_filename}"
    if test -f "${repo_filename}"; then
        repo_cksum=$(cksum "${repo_filename}" | cut -d ' ' -f 1)
        echo "repo_cksum: $repo_cksum"
    else
        new_file=1
        echo "file not found in repo"
    fi

    # if the file doesn't exist, or it's cksum has changed copy it
    if [ ${new_file} -eq 1 ] || [ $logseq_cksum -ne $repo_cksum ]; then
        cp "${file}" "${repo_filename}"
        echo "copying file to repo"
    fi

    # if the file is new, add it to the index
    if [ ${new_file} -eq 1 ]; then
        name_sans_md=$(echo ${base_filename} | cut -d '.' -f 1)
        echo "debug - name_sans_md: ${name_sans_md}"
        exit 1 % need to test the following code
        sed -i 's/nav/a\"${name_sans_md}"' index.md

        name_sub_spaces=$(echo ${base_filename} | tr ' ' '%20')
        echo "[${name_sans_md}](recipes/${name_sub_spaces})" >> index.md
    fi

    # debug
    echo "basefilename: ${base_filename}, cksum: ${logseq_cksum}"
done
