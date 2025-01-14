#!/bin/bash
# Author: kn007 <kn007@126.com>
# Modified by: hiwanz <princeb4d@gmail.com>
# Link: https://github.com/kn007/silk-v3-decoder
# Usage: sh converter.sh input_folder output_folder format
# Requirement: ffmpeg

# 预设颜色
RED="$(tput setaf 1 2>/dev/null || echo '\e[0;31m')"
GREEN="$(tput setaf 2 2>/dev/null || echo '\e[0;32m')"
YELLOW="$(tput setaf 3 2>/dev/null || echo '\e[0;33m')"
WHITE="$(tput setaf 7 2>/dev/null || echo '\e[0;37m')"
RESET="$(tput sgr 0 2>/dev/null || echo '\e[0m')"

# 获取脚本的真实路径（支持软链接）
SOURCE="$0"
while [ -L "$SOURCE" ]; do
  DIR=$(dirname "$SOURCE")
  SOURCE=$(readlink "$SOURCE")
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
done
cur_dir=$(cd "$(dirname "$SOURCE")" && pwd)
decoder_bin="$cur_dir/silk/decoder"

# 检查是否存在解码器
if [ ! -r "$decoder_bin" ]; then
	echo -e "${WHITE}[Notice]${RESET} Silk v3 Decoder is not found, compile it."
fi

# 批量转换
while [ $3 ]; do
	[[ ! -z "$(pgrep ffmpeg)" ]]&&echo -e "${RED}[Error]${RESET} ffmpeg is occupied by another application, please check it."&&exit
	[ ! -d "$1" ]&&echo -e "${RED}[Error]${RESET} Input folder not found, please check it."&&exit
	TOTAL=$(ls $1|wc -l)
	[ ! -d "$2" ]&&mkdir "$2"&&echo -e "${WHITE}[Notice]${RESET} Output folder not found, create it."
	[ ! -d "$2" ]&&echo -e "${RED}[Error]${RESET} Output folder could not be created, please check it."&&exit
	CURRENT=0
	echo -e "${WHITE}========= Batch Conversion Start ==========${RESET}"
	ls $1 | while read line; do
		let CURRENT+=1
		$decoder_bin "$1/$line" "$2/$line.pcm" > /dev/null 2>&1
		if [ ! -f "$2/$line.pcm" ]; then
			ffmpeg -y -i "$1/$line" "$2/${line%.*}.$3" > /dev/null 2>&1 &
			ffmpeg_pid=$!
			while kill -0 "$ffmpeg_pid"; do sleep 1; done > /dev/null 2>&1
			[ -f "$2/${line%.*}.$3" ]&&echo -e "[$CURRENT/$TOTAL]${GREEN}[OK]${RESET} Convert $line to ${line%.*}.$3 success, ${YELLOW}but not a silk v3 encoded file.${RESET}"&&continue
			echo -e "[$CURRENT/$TOTAL]${YELLOW}[Warning]${RESET} Convert $line false, maybe not a silk v3 encoded file."&&continue
		fi
		ffmpeg -y -f s16le -ar 24000 -ac 1 -i "$2/$line.pcm" "$2/${line%.*}.$3" > /dev/null 2>&1 &
		ffmpeg_pid=$!
		while kill -0 "$ffmpeg_pid"; do sleep 1; done > /dev/null 2>&1
		rm "$2/$line.pcm"
		[ ! -f "$2/${line%.*}.$3" ]&&echo -e "[$CURRENT/$TOTAL]${YELLOW}[Warning]${RESET} Convert $line false, maybe ffmpeg no format handler for $3."&&continue
		echo -e "[$CURRENT/$TOTAL]${GREEN}[OK]${RESET} Convert $line To ${line%.*}.$3 Finish."
	done
	echo -e "${WHITE}========= Batch Conversion Finish =========${RESET}"
	exit
done

# 单文件转换
$decoder_bin "$1" "$1.pcm" > /dev/null 2>&1
if [ ! -f "$1.pcm" ]; then
	ffmpeg -y -i "$1" "${1%.*}.$2" > /dev/null 2>&1 &
	ffmpeg_pid=$!
	while kill -0 "$ffmpeg_pid"; do sleep 1; done > /dev/null 2>&1
	[ -f "${1%.*}.$2" ]&&echo -e "${GREEN}[OK]${RESET} Convert $1 to ${1%.*}.$2 success, ${YELLOW}but not a silk v3 encoded file.${RESET}"&&exit
	echo -e "${YELLOW}[Warning]${RESET} Convert $1 false, maybe not a silk v3 encoded file."&&exit
fi
ffmpeg -y -f s16le -ar 24000 -ac 1 -i "$1.pcm" "${1%.*}.$2" > /dev/null 2>&1
ffmpeg_pid=$!
while kill -0 "$ffmpeg_pid"; do sleep 1; done > /dev/null 2>&1
rm "$1.pcm"
[ ! -f "${1%.*}.$2" ]&&echo -e "${YELLOW}[Warning]${RESET} Convert $1 false, maybe ffmpeg no format handler for $2."&&exit
echo -e "${GREEN}[OK]${RESET} Convert $1 To ${1%.*}.$2 Finish."
exit
