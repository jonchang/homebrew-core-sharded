class Repo < Formula
  desc "Repository tool for Android development"
  homepage "https://source.android.com/source/developing.html"
  url "https://github.com/GerritCodeReview/git-repo.git",
      :tag      => "v2.4.1",
      :revision => "d957ec6a834e333a3812546911f786b0c20b808f"
  version_scheme 1

  bottle :unneeded

  def install
    bin.install "repo"
    doc.install (buildpath/"docs").children
  end

  test do
    assert_match "usage:", shell_output("#{bin}/repo help 2>&1")
  end
end
