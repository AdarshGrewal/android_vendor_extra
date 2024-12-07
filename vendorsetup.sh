enable_ccache() {
    if [[ -f ~/CCACHE/.ccache/ccache.conf ]]; then
        export USE_CCACHE=1
        export CCACHE_EXEC=$(command -v ccache)
        export CCACHE_DIR=~/CCACHE/.ccache
        export CCACHE_NOCOMPRESS=true
        echo -e "\e[32m[INFO]\e[0m ccache enabled with configuration from ~/CCACHE/.ccache/ccache.conf"
    else
        echo -e "\e[33m[WARN]\e[0m ccache.conf not found in ~/CCACHE/.ccache. Skipping ccache setup."
    fi
}

enable_gms() {
    local enable_gms_flag=${1:-true}
    if [[ "${enable_gms_flag}" == "true" && -f vendor/partner_gms/Android.mk ]]; then
        export WITH_GMS=true
        export GMS_MAKEFILE=gms.mk
        export BUILD_VANILLA=false
        export TARGET_UNOFFICIAL_BUILD_ID="gms"
        echo -e "\e[32m[INFO]\e[0m partner_gms found. Enabling GMS build."
    else
        export WITH_GMS=false
        export GMS_MAKEFILE=
        export BUILD_VANILLA=true
        unset TARGET_UNOFFICIAL_BUILD_ID
        echo -e "\e[33m[WARN]\e[0m partner_gms not found or disabling GMS. Proceeding with vanilla build."
    fi
}

enable_thin_lto() {
    local enable_thin_lto=${1:-true}
    if [[ "${enable_thin_lto}" == "true" ]]; then
        export KERNEL_LTO=thin
        echo -e "\e[32m[INFO]\e[0m Forcing thin lto."
    fi
}

release() {
    device=${1}
    project="$(basename ${ANDROID_BUILD_TOP})"
    sf_project_name=""
    extraimages=""
    
    if [[ "${device}" == "zircon" ]]; then
        sf_project_name="zirconrandom"
        extraimages="initbootimage vendorbootimage" 
    fi

    if [ -z "${sf_project_name}" ]; then
        echo -e "\e[31m[ERROR]\e[0m Project name is not set. Skipping release."
        exit 1
    fi

    if [[ ${WITH_GMS} == "true" ]]; then
        type="GMS"
        device_variant="${device}_gms"
    else
        type="VANILLA"
        device_variant="${device}"
    fi

    echo -e "\e[32m[INFO]\e[0m Starting release for device: ${device} (${type} variant)"
    [[ -d "${ANDROID_BUILD_TOP}/ota" ]] && rm -rf "${ANDROID_BUILD_TOP}/ota"
    git clone git@github.com:loonage/ota.git "${ANDROID_BUILD_TOP}/ota"
    cd "${ANDROID_BUILD_TOP}/ota"
    git pull origin "${project}"

    if git fetch origin "${project}"; then
        git checkout origin/"${project}"
    else
        git checkout --orphan "${project}"
        git rm -rf .
    fi

    breakfast "${device}"
    m installclean

    if [[ -n "${extraimages}" ]]; then
        echo -e "\e[32m[INFO]\e[0m Running m bacon with extraimages for ${device}"
        m  "${extraimages}" bacon
    else
        echo -e "\e[32m[INFO]\e[0m Running m bacon for ${device}"
        m bacon
    fi

    build_props="${OUT}/system/build.prop"
    filename=$(grep -oP '(?<=ro.lineage.version=).*' "${build_props}")
    filename="lineage-${filename}.zip"
    tag_name=$(echo "$filename" | grep -oP '(?<=lineage-\d+\.\d+-)(\d{8})(?=-UNOFFICIAL)')

    if [ -z "$tag_name" ]; then
        tag_name=$(echo "$filename" | grep -oP '\d{8}(?=-UNOFFICIAL)')
    fi

    if [ -z "$tag_name" ]; then
        tag_name=$(echo "$filename" | grep -oP '(?<=lineage-\d+\.\d+-)(\d{8})')
    fi

    if [ -z "$tag_name" ]; then
        echo -e "\e[31m[ERROR]\e[0m Failed to extract tag_name (date) from filename: ${filename}"
        exit 1
    fi

    id=$(awk '{print $1}' "${OUT}/${filename}.sha256sum")
    romtype=$(grep -oP '(?<=ro.lineage.releasetype=).*' "${build_props}")
    size=$(stat -c%s "${OUT}/${filename}")
    version=$(grep -oP '(?<=ro.lineage.build.version=).*' "${build_props}")
    datetime=$(cat "${OUT}"/system/build.prop | grep ro.build.date.utc=)
    datetime="${datetime#*=}"

    release_url="https://sourceforge.net/projects/${sf_project_name}/files/los/${tag_name}/$(basename ${filename})/download"
    ota_entry=$(jq -n \
        --arg datetime "${datetime}" \
        --arg filename "${filename}" \
        --arg id "${id}" \
        --arg romtype "${romtype}" \
        --argjson size "${size}" \
        --arg version "${version}" \
        --arg release_url "$release_url" \
        '{
            response: [
                {
                    datetime: $datetime,
                    filename: $filename,
                    id: $id,
                    romtype: $romtype,
                    size: $size,
                    url: $release_url,
                    version: $version
                }
            ]
        }')

    echo -e "\e[32m[INFO]\e[0m Generated OTA JSON entry:"
    echo "${ota_entry}"

    rm -f "${device_variant}.json"
    echo "${ota_entry}" > "${device_variant}.json"

    git add "${device_variant}.json"
    git commit -m "${device_variant}: OTA update $(date +%F)"

    if [[ $(git rev-list --count HEAD) -gt 0 ]]; then
        pr_branch="ota-update-$(date +%Y%m%d%H%M%S)"
        git checkout -b "${pr_branch}"
        git push origin "${pr_branch}"
        gh pr create --base los-22 --head "${pr_branch}" --title "OTA update for ${device_variant}" --body "This PR contains the OTA update for ${device_variant}."
    else
        echo -e "\e[31m[ERROR]\e[0m No commits found in ${pr_branch}. Aborting PR creation."
        exit 1
    fi

    cd ..
    echo -e "\e[32m[INFO]\e[0m Deleting the OTA repo from ${ANDROID_BUILD_TOP}/ota."
    rm -rf "${ANDROID_BUILD_TOP}/ota"

    {
        echo "mkdir /home/frs/project/${sf_project_name}/los/"
        echo "mkdir /home/frs/project/${sf_project_name}/los/${tag_name}/"
    } | sftp adarshgrewal@frs.sourceforge.net

    rsync -Ph ${OUT}/${filename} adarshgrewal@frs.sourceforge.net:/home/frs/project/${sf_project_name}/los/"${tag_name}"/
    rsync -Ph ${OUT}/${filename}.sha256sum adarshgrewal@frs.sourceforge.net:/home/frs/project/${sf_project_name}/los/"${tag_name}"/

    declare -A image_map=(
        ["initbootimage"]="${OUT}/init_boot.img"
        ["vendorbootimage"]="${OUT}/vendor_boot.img"
        ["recoveryimage"]="${OUT}/recovery.img"
    )

    if [ -n "${extraimages}" ]; then
        extraimages=$(echo "${extraimages}" | xargs)
        echo "[INFO] Initial extraimages value: ${extraimages}"

        images=$(echo "${extraimages}" | grep -oP '\b\w*image\w*\b')

        echo "[INFO] Processing extra images:"
        echo "${images}"

        while IFS= read -r image; do
            if [[ -v "image_map[${image}]" ]]; then
                image_path="${image_map[${image}]}"
                if [ -f "${image_path}" ]; then
                    remote_file="$(basename "${image_path}")"
                    sftp adarshgrewal@frs.sourceforge.net <<< "ls /home/frs/project/${sf_project_name}/los/${tag_name}/${remote_file}" &>/dev/null
                    if [ $? -eq 0 ]; then
                        echo "[INFO] ${remote_file} already exists on the server. Skipping upload."
                    else
                        echo "[INFO] Uploading ${image_path}"
                        rsync -Ph "${image_path}" "adarshgrewal@frs.sourceforge.net:/home/frs/project/${sf_project_name}/los/${tag_name}/"
                    fi
                else
                    echo "[ERROR] ${image_path} not found in ${OUT}"
                fi
            else
                echo "[ERROR] Unknown extra image: $image"
            fi
        done <<< "${images}"
    else
        echo "[INFO] No extra images to process."
    fi

    echo -e "\e[32m[INFO]\e[0m Release created successfully!"
}

enable_ccache
enable_gms
enable_thin_lto
