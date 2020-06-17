class Xcodegen < Formula
  desc "Generate your Xcode project from a spec file and your folder structure"
  homepage "https://github.com/yonaskolb/XcodeGen"
  url "https://github.com/yonaskolb/XcodeGen/archive/2.16.0.tar.gz"
  sha256 "ae813fdbc3cc26a5af7de50fa1378292e23a0a719c20cb9b461d4bbd7099078a"
  head "https://github.com/yonaskolb/XcodeGen.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9dc6875065ddf5816c00312328f0f4f1c801ad11c8c40af7192d3068ec1edf27" => :catalina
    sha256 "d6359a7e712f7a749184ad7f9285abaafdf1cc0187d01278645e46688f86bb8a" => :mojave
  end

  depends_on :xcode => ["10.2", :build]

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"xcodegen.yml").write <<~EOS
      name: GeneratedProject
      options:
        bundleIdPrefix: com.project
      targets:
        TestProject:
          type: application
          platform: iOS
          sources: TestProject
    EOS
    (testpath/"TestProject").mkpath
    system bin/"XcodeGen", "--spec", testpath/"xcodegen.yml"
    assert_predicate testpath/"GeneratedProject.xcodeproj", :exist?
    assert_predicate testpath/"GeneratedProject.xcodeproj/project.pbxproj", :exist?
    output = (testpath/"GeneratedProject.xcodeproj/project.pbxproj").read
    assert_match "name = TestProject", output
    assert_match "isa = PBXNativeTarget", output
  end
end
