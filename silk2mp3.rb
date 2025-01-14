class Silk2mp3 < Formula
  desc "A tool to convert silk files to mp3 files"
  homepage "https://github.com/hiwanz/homebrew-silk2mp3"
  url "https://github.com/user-attachments/files/18406505/silk2mp3-v1.0.0.zip"
  version "1.0.0"
  sha256 "a80aa15b3dba0f03a6f1c348c05e4cfc56a4982e4da2555a4527d02ed9a1b4d9"

  depends_on "ffmpeg"

  def install
    # 安装主脚本到 Homebrew 的 bin 目录
    bin.install "converter.sh" => "silk2mp3"
    # 安装 silk 子目录到主脚本目录
    (bin/"silk").install Dir["silk/*"]
  end

  def caveats
    <<~EOS
      Sample: silk2mp3 input.silk mp3
      Sample: silk2mp3 input.silk wav
    EOS
  end
end