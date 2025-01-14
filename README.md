homebrew-silk2mp3
============

在找silk转mp3格式工具的时候，发现了一个[kn007/silk-v3-decoder](https://github.com/kn007/silk-v3-decoder)项目，但是里面的decoder需要手工编译，在Mac下编译的时候报错，需要修改Makefile去掉-enable-threads才行，并不能直接开箱即用，由于我自己用Mac，所以我自己写了一个Homebrew脚本来实现这个功能，其他平台的可以参考kn007的项目自己编译。

安装
----

```sh
brew tap hiwanz/silk2mp3
brew install silk2mp3
```
如何使用？
----

一、导出微信的音频消息：

1. 打开微信聊天本地目录，一般在`~/Library/Containers/com.tencent.xinWeChat/Data/Library/Application Support/com.tencent.xinWeChat/`，具体路径可能有所不同，如果找不到可以在微信聊天窗口中找到任意图片或者文件，在右键菜单中选择在访达中显示，就能找到微信聊天的本地目录了。
2. 搜索.silk后缀的文件，这些就是微信的音频消息文件。
3. 根据语音聊天的时间可以通过文件创建时间排序找到对应音频文件，如果文件太多，可以先把需要的语音右键收藏到微信，删掉所有silk文件，然后再微信收藏中点击对应的语音消息，微信会下载生成一个新的音频文件，这样就能找到对应的音频文件了。

二、转换silk3编码音频为mp3:

1. 将前面找到的音频文件拷贝到一个目录下，比如`~/Downloads/silk`。
2. 打开终端，在silk目录下执行`silk2mp3 input.silk mp3`即可完成转换。
3. 如果需要批量转换，可以执行`silk2mp3 input_folder output_folder mp3`即可完成转换。

**注：如果你想转的不是mp3格式，可以将mp3参数替换为其他格式，比如aac，wav，flac和ogg等，只要ffmpeg支持的都可以。**
