#!/bin/sh
set -e

mkdir -p "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"

RESOURCES_TO_COPY=${PODS_ROOT}/resources-to-copy-${TARGETNAME}.txt
> "$RESOURCES_TO_COPY"

XCASSET_FILES=()

realpath() {
  DIRECTORY="$(cd "${1%/*}" && pwd)"
  FILENAME="${1##*/}"
  echo "$DIRECTORY/$FILENAME"
}

install_resource()
{
  case $1 in
    *.storyboard)
      echo "ibtool --reference-external-strings-file --errors --warnings --notices --output-format human-readable-text --compile ${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$1\" .storyboard`.storyboardc ${PODS_ROOT}/$1 --sdk ${SDKROOT}"
      ibtool --reference-external-strings-file --errors --warnings --notices --output-format human-readable-text --compile "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$1\" .storyboard`.storyboardc" "${PODS_ROOT}/$1" --sdk "${SDKROOT}"
      ;;
    *.xib)
      echo "ibtool --reference-external-strings-file --errors --warnings --notices --output-format human-readable-text --compile ${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$1\" .xib`.nib ${PODS_ROOT}/$1 --sdk ${SDKROOT}"
      ibtool --reference-external-strings-file --errors --warnings --notices --output-format human-readable-text --compile "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$1\" .xib`.nib" "${PODS_ROOT}/$1" --sdk "${SDKROOT}"
      ;;
    *.framework)
      echo "mkdir -p ${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      mkdir -p "${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      echo "rsync -av ${PODS_ROOT}/$1 ${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      rsync -av "${PODS_ROOT}/$1" "${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      ;;
    *.xcdatamodel)
      echo "xcrun momc \"${PODS_ROOT}/$1\" \"${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$1"`.mom\""
      xcrun momc "${PODS_ROOT}/$1" "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$1" .xcdatamodel`.mom"
      ;;
    *.xcdatamodeld)
      echo "xcrun momc \"${PODS_ROOT}/$1\" \"${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$1" .xcdatamodeld`.momd\""
      xcrun momc "${PODS_ROOT}/$1" "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$1" .xcdatamodeld`.momd"
      ;;
    *.xcmappingmodel)
      echo "xcrun mapc \"${PODS_ROOT}/$1\" \"${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$1" .xcmappingmodel`.cdm\""
      xcrun mapc "${PODS_ROOT}/$1" "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$1" .xcmappingmodel`.cdm"
      ;;
    *.xcassets)
      ABSOLUTE_XCASSET_FILE=$(realpath "${PODS_ROOT}/$1")
      XCASSET_FILES+=("$ABSOLUTE_XCASSET_FILE")
      ;;
    /*)
      echo "$1"
      echo "$1" >> "$RESOURCES_TO_COPY"
      ;;
    *)
      echo "${PODS_ROOT}/$1"
      echo "${PODS_ROOT}/$1" >> "$RESOURCES_TO_COPY"
      ;;
  esac
}
if [[ "$CONFIGURATION" == "Debug" ]]; then
  install_resource "ABCalendarPicker/ABCalendarPicker/GradientBar.png"
  install_resource "ABCalendarPicker/ABCalendarPicker/TileDisabledSelected.png"
  install_resource "ABCalendarPicker/ABCalendarPicker/TileNormal.png"
  install_resource "ABCalendarPicker/ABCalendarPicker/TilePattern.png"
  install_resource "ABCalendarPicker/ABCalendarPicker/TileSelected.png"
  install_resource "ABCalendarPicker/ABCalendarPicker/TileToday.png"
  install_resource "ABCalendarPicker/ABCalendarPicker/TileTodaySelected.png"
  install_resource "AwesomeMenu/AwesomeMenu/Images/bg-addbutton-highlighted.png"
  install_resource "AwesomeMenu/AwesomeMenu/Images/bg-addbutton-highlighted@2x.png"
  install_resource "AwesomeMenu/AwesomeMenu/Images/bg-addbutton.png"
  install_resource "AwesomeMenu/AwesomeMenu/Images/bg-addbutton@2x.png"
  install_resource "AwesomeMenu/AwesomeMenu/Images/bg-menuitem-highlighted.png"
  install_resource "AwesomeMenu/AwesomeMenu/Images/bg-menuitem-highlighted@2x.png"
  install_resource "AwesomeMenu/AwesomeMenu/Images/bg-menuitem.png"
  install_resource "AwesomeMenu/AwesomeMenu/Images/bg-menuitem@2x.png"
  install_resource "AwesomeMenu/AwesomeMenu/Images/icon-plus-highlighted.png"
  install_resource "AwesomeMenu/AwesomeMenu/Images/icon-plus-highlighted@2x.png"
  install_resource "AwesomeMenu/AwesomeMenu/Images/icon-plus.png"
  install_resource "AwesomeMenu/AwesomeMenu/Images/icon-plus@2x.png"
  install_resource "AwesomeMenu/AwesomeMenu/Images/icon-star.png"
  install_resource "AwesomeMenu/AwesomeMenu/Images/icon-star@2x.png"
  install_resource "BButton/BButton/resources/FontAwesome.ttf"
  install_resource "DKNightVersion/DKNightVersion/ColorTable/DKColorTable.txt"
  install_resource "DateTools/DateTools/DateTools.bundle"
  install_resource "IQKeyboardManager/IQKeyBoardManager/Resources/IQKeyboardManager.bundle"
  install_resource "KVNProgress/KVNProgress/Resources/KVNProgressView.xib"
  install_resource "MJRefresh/MJRefresh/MJRefresh.bundle"
  install_resource "RongCloudIMKit/Rong_Cloud_iOS_IMKit_SDK_v2_4_11_stable/RongCloud.bundle"
  install_resource "RongCloudIMKit/Rong_Cloud_iOS_IMKit_SDK_v2_4_11_stable/en.lproj"
  install_resource "RongCloudIMKit/Rong_Cloud_iOS_IMKit_SDK_v2_4_11_stable/zh-Hans.lproj"
  install_resource "RongCloudIMKit/Rong_Cloud_iOS_IMKit_SDK_v2_4_11_stable/Emoji.plist"
  install_resource "SVProgressHUD/SVProgressHUD/SVProgressHUD.bundle"
  install_resource "StyledPageControl/StyledPageControlDemo/PageControlDemo/Resources/pagecontrol-thumb-normal.png"
  install_resource "StyledPageControl/StyledPageControlDemo/PageControlDemo/Resources/pagecontrol-thumb-normal@2x.png"
  install_resource "StyledPageControl/StyledPageControlDemo/PageControlDemo/Resources/pagecontrol-thumb-selected.png"
  install_resource "StyledPageControl/StyledPageControlDemo/PageControlDemo/Resources/pagecontrol-thumb-selected@2x.png"
  install_resource "TSMessages/Pod/Assets/NotificationBackgroundError.png"
  install_resource "TSMessages/Pod/Assets/NotificationBackgroundError@2x.png"
  install_resource "TSMessages/Pod/Assets/NotificationBackgroundErrorIcon.png"
  install_resource "TSMessages/Pod/Assets/NotificationBackgroundErrorIcon@2x.png"
  install_resource "TSMessages/Pod/Assets/NotificationBackgroundMessage.png"
  install_resource "TSMessages/Pod/Assets/NotificationBackgroundMessage@2x.png"
  install_resource "TSMessages/Pod/Assets/NotificationBackgroundSuccess.png"
  install_resource "TSMessages/Pod/Assets/NotificationBackgroundSuccess@2x.png"
  install_resource "TSMessages/Pod/Assets/NotificationBackgroundSuccessIcon.png"
  install_resource "TSMessages/Pod/Assets/NotificationBackgroundSuccessIcon@2x.png"
  install_resource "TSMessages/Pod/Assets/NotificationBackgroundWarning.png"
  install_resource "TSMessages/Pod/Assets/NotificationBackgroundWarning@2x.png"
  install_resource "TSMessages/Pod/Assets/NotificationBackgroundWarningIcon.png"
  install_resource "TSMessages/Pod/Assets/NotificationBackgroundWarningIcon@2x.png"
  install_resource "TSMessages/Pod/Assets/NotificationButtonBackground.png"
  install_resource "TSMessages/Pod/Assets/NotificationButtonBackground@2x.png"
  install_resource "TSMessages/Pod/Assets/TSMessagesDefaultDesign.json"
  install_resource "UzysAssetsPickerController/UzysAssetsPickerController/Library/UzysAssetsPickerController.xib"
  install_resource "UzysAssetsPickerController/UzysAssetsPickerController/Library/UzysAssetPickerController.bundle"
  install_resource "${BUILT_PRODUCTS_DIR}/DeviceUtil.bundle"
  install_resource "${BUILT_PRODUCTS_DIR}/MWPhotoBrowser.bundle"
  install_resource "${BUILT_PRODUCTS_DIR}/RETableViewManager.bundle"
fi
if [[ "$CONFIGURATION" == "Release" ]]; then
  install_resource "ABCalendarPicker/ABCalendarPicker/GradientBar.png"
  install_resource "ABCalendarPicker/ABCalendarPicker/TileDisabledSelected.png"
  install_resource "ABCalendarPicker/ABCalendarPicker/TileNormal.png"
  install_resource "ABCalendarPicker/ABCalendarPicker/TilePattern.png"
  install_resource "ABCalendarPicker/ABCalendarPicker/TileSelected.png"
  install_resource "ABCalendarPicker/ABCalendarPicker/TileToday.png"
  install_resource "ABCalendarPicker/ABCalendarPicker/TileTodaySelected.png"
  install_resource "AwesomeMenu/AwesomeMenu/Images/bg-addbutton-highlighted.png"
  install_resource "AwesomeMenu/AwesomeMenu/Images/bg-addbutton-highlighted@2x.png"
  install_resource "AwesomeMenu/AwesomeMenu/Images/bg-addbutton.png"
  install_resource "AwesomeMenu/AwesomeMenu/Images/bg-addbutton@2x.png"
  install_resource "AwesomeMenu/AwesomeMenu/Images/bg-menuitem-highlighted.png"
  install_resource "AwesomeMenu/AwesomeMenu/Images/bg-menuitem-highlighted@2x.png"
  install_resource "AwesomeMenu/AwesomeMenu/Images/bg-menuitem.png"
  install_resource "AwesomeMenu/AwesomeMenu/Images/bg-menuitem@2x.png"
  install_resource "AwesomeMenu/AwesomeMenu/Images/icon-plus-highlighted.png"
  install_resource "AwesomeMenu/AwesomeMenu/Images/icon-plus-highlighted@2x.png"
  install_resource "AwesomeMenu/AwesomeMenu/Images/icon-plus.png"
  install_resource "AwesomeMenu/AwesomeMenu/Images/icon-plus@2x.png"
  install_resource "AwesomeMenu/AwesomeMenu/Images/icon-star.png"
  install_resource "AwesomeMenu/AwesomeMenu/Images/icon-star@2x.png"
  install_resource "BButton/BButton/resources/FontAwesome.ttf"
  install_resource "DKNightVersion/DKNightVersion/ColorTable/DKColorTable.txt"
  install_resource "DateTools/DateTools/DateTools.bundle"
  install_resource "IQKeyboardManager/IQKeyBoardManager/Resources/IQKeyboardManager.bundle"
  install_resource "KVNProgress/KVNProgress/Resources/KVNProgressView.xib"
  install_resource "MJRefresh/MJRefresh/MJRefresh.bundle"
  install_resource "RongCloudIMKit/Rong_Cloud_iOS_IMKit_SDK_v2_4_11_stable/RongCloud.bundle"
  install_resource "RongCloudIMKit/Rong_Cloud_iOS_IMKit_SDK_v2_4_11_stable/en.lproj"
  install_resource "RongCloudIMKit/Rong_Cloud_iOS_IMKit_SDK_v2_4_11_stable/zh-Hans.lproj"
  install_resource "RongCloudIMKit/Rong_Cloud_iOS_IMKit_SDK_v2_4_11_stable/Emoji.plist"
  install_resource "SVProgressHUD/SVProgressHUD/SVProgressHUD.bundle"
  install_resource "StyledPageControl/StyledPageControlDemo/PageControlDemo/Resources/pagecontrol-thumb-normal.png"
  install_resource "StyledPageControl/StyledPageControlDemo/PageControlDemo/Resources/pagecontrol-thumb-normal@2x.png"
  install_resource "StyledPageControl/StyledPageControlDemo/PageControlDemo/Resources/pagecontrol-thumb-selected.png"
  install_resource "StyledPageControl/StyledPageControlDemo/PageControlDemo/Resources/pagecontrol-thumb-selected@2x.png"
  install_resource "TSMessages/Pod/Assets/NotificationBackgroundError.png"
  install_resource "TSMessages/Pod/Assets/NotificationBackgroundError@2x.png"
  install_resource "TSMessages/Pod/Assets/NotificationBackgroundErrorIcon.png"
  install_resource "TSMessages/Pod/Assets/NotificationBackgroundErrorIcon@2x.png"
  install_resource "TSMessages/Pod/Assets/NotificationBackgroundMessage.png"
  install_resource "TSMessages/Pod/Assets/NotificationBackgroundMessage@2x.png"
  install_resource "TSMessages/Pod/Assets/NotificationBackgroundSuccess.png"
  install_resource "TSMessages/Pod/Assets/NotificationBackgroundSuccess@2x.png"
  install_resource "TSMessages/Pod/Assets/NotificationBackgroundSuccessIcon.png"
  install_resource "TSMessages/Pod/Assets/NotificationBackgroundSuccessIcon@2x.png"
  install_resource "TSMessages/Pod/Assets/NotificationBackgroundWarning.png"
  install_resource "TSMessages/Pod/Assets/NotificationBackgroundWarning@2x.png"
  install_resource "TSMessages/Pod/Assets/NotificationBackgroundWarningIcon.png"
  install_resource "TSMessages/Pod/Assets/NotificationBackgroundWarningIcon@2x.png"
  install_resource "TSMessages/Pod/Assets/NotificationButtonBackground.png"
  install_resource "TSMessages/Pod/Assets/NotificationButtonBackground@2x.png"
  install_resource "TSMessages/Pod/Assets/TSMessagesDefaultDesign.json"
  install_resource "UzysAssetsPickerController/UzysAssetsPickerController/Library/UzysAssetsPickerController.xib"
  install_resource "UzysAssetsPickerController/UzysAssetsPickerController/Library/UzysAssetPickerController.bundle"
  install_resource "${BUILT_PRODUCTS_DIR}/DeviceUtil.bundle"
  install_resource "${BUILT_PRODUCTS_DIR}/MWPhotoBrowser.bundle"
  install_resource "${BUILT_PRODUCTS_DIR}/RETableViewManager.bundle"
fi

mkdir -p "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
rsync -avr --copy-links --no-relative --exclude '*/.svn/*' --files-from="$RESOURCES_TO_COPY" / "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
if [[ "${ACTION}" == "install" ]] && [[ "${SKIP_INSTALL}" == "NO" ]]; then
  mkdir -p "${INSTALL_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
  rsync -avr --copy-links --no-relative --exclude '*/.svn/*' --files-from="$RESOURCES_TO_COPY" / "${INSTALL_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
fi
rm -f "$RESOURCES_TO_COPY"

if [[ -n "${WRAPPER_EXTENSION}" ]] && [ "`xcrun --find actool`" ] && [ -n "$XCASSET_FILES" ]
then
  case "${TARGETED_DEVICE_FAMILY}" in
    1,2)
      TARGET_DEVICE_ARGS="--target-device ipad --target-device iphone"
      ;;
    1)
      TARGET_DEVICE_ARGS="--target-device iphone"
      ;;
    2)
      TARGET_DEVICE_ARGS="--target-device ipad"
      ;;
    *)
      TARGET_DEVICE_ARGS="--target-device mac"
      ;;
  esac

  # Find all other xcassets (this unfortunately includes those of path pods and other targets).
  OTHER_XCASSETS=$(find "$PWD" -iname "*.xcassets" -type d)
  while read line; do
    if [[ $line != "`realpath $PODS_ROOT`*" ]]; then
      XCASSET_FILES+=("$line")
    fi
  done <<<"$OTHER_XCASSETS"

  printf "%s\0" "${XCASSET_FILES[@]}" | xargs -0 xcrun actool --output-format human-readable-text --notices --warnings --platform "${PLATFORM_NAME}" --minimum-deployment-target "${IPHONEOS_DEPLOYMENT_TARGET}" ${TARGET_DEVICE_ARGS} --compress-pngs --compile "${BUILT_PRODUCTS_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
fi
