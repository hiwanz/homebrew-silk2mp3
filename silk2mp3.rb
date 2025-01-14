class Silk2mp3 < Formula
  desc "A tool to convert silk files to mp3 files"
  homepage "https://github.com/hiwanz/homebrew-silk2mp3"
  url "https://github.com/user-attachments/files/18406942/silk2mp3-v1.0.0.zip"
  version "1.0.0"
  sha256 "82e67a700c69d26b2832befd4fa11129acb9575818554570abdd3709ea3ebf40"

  depends_on "ffmpeg"

  def install
    # 安装主脚本到 Homebrew 的 bin 目录
    bin.install "converter.sh" => "silk2mp3"
    # 安装 silk 子目录到主脚本目录
    (bin/"silk").install Dir["silk/*"]
  end

  def caveats
    <<~EOS
      Sample1: silk2mp3 input.silk mp3
      Sample2: silk2mp3 input.silk wav
      Sample3: silk2mp3 input_folder output_folder mp3
    EOS
  end
end