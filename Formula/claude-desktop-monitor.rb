class ClaudeDesktopMonitor < Formula
  include Language::Python::Virtualenv

  desc "Watch Claude Desktop's resource usage over time in a terminal UI"
  homepage "https://github.com/thamwangjun/claude-desktop-monitor"
  url "https://github.com/thamwangjun/claude-desktop-monitor/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "f580bd37a4e2cb55baf8080b09a2587b7ed7f32b09f92428197b3da1114e9e1a"
  license "GPL-3.0-only"

  bottle do
    root_url "https://github.com/thamwangjun/homebrew-tap/releases/download/claude-desktop-monitor-0.3.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "c6952a97063b708f0dd3a51e1c9d0a4442f311d8722f2e9e180592ce7b824785"
  end

  depends_on "rust" => :build
  depends_on :macos
  depends_on "python@3.14"
  depends_on "terminal-notifier"

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/aa/c6/d1ddf4abb55e93cebc4f2ed8b5d6dbad109ecb8d63748dd2b20ab5e57ebe/psutil-7.2.2.tar.gz"
    sha256 "0746f5f8d406af344fd547f1c8daa5f5c33dbc293bb8d6a16d80b4bb88f59372"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "pync" do
    url "https://files.pythonhosted.org/packages/71/ce/06fca51df0cceb13dbcd8168e2657ffd942184005b3bb958dd17c14e0148/pync-2.0.3.tar.gz"
    sha256 "38b9e61735a3161f9211a5773c5f5ea698f36af4ff7f77fa03e8d1ff0caa117f"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "watchdog" do
    url "https://files.pythonhosted.org/packages/db/7d/7f3d619e951c88ed75c6037b246ddcf2d322812ee8ea189be89511721d54/watchdog-6.0.0.tar.gz"
    sha256 "9ddf7c82fda3ae8e24decda1338ede66e1c99883db93711d8fb941eaa2d8c282"
  end

  def install
    virtualenv_install_with_resources
    (bin/"claude-desktop-monitor").unlink
    (bin/"claude-desktop-monitor").write_env_script libexec/"bin/claude-desktop-monitor",
      PATH: "#{formula_opt_bin("terminal-notifier")}:$PATH"

    # pync vendors its own Intel-only terminal-notifier.app as a fallback for when
    # `which terminal-notifier` fails. The PATH override above means that never
    # happens here, so this x86_64 binary is unused, but it still trips Homebrew's
    # non-native-architecture audit if left in libexec.
    Dir.glob(libexec/"lib/python3.*/site-packages/pync/vendor/terminal-notifier-2.0.0").each do |dir|
      rm_r dir
    end
  end

  test do
    assert_match "usage:", shell_output("#{bin}/claude-desktop-monitor --help")
    system libexec/"bin/python", "-c", "import claude_desktop_monitor.monitor"
  end
end
