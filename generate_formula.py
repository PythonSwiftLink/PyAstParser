#from cookiecutter.main import cookiecutter
from os.path import join, abspath
from os import pardir, getcwd
import sys

if not len(sys.argv) >= 3: 
    exit(-1)

version = sys.argv[1]
sha = sys.argv[2]



template0 = """
class PyAstParser < Formula
  desc ""
  homepage ""

  url "https://github.com/PythonSwiftLink/PyAstParser/releases/download/{version}/PyAstParser.tar.gz"
  version "{version}"
  sha256 "{sha}"
  license ""

  def install
    bin.install "PyAstParser"
    end

  test do
    system "false"
  end
end
"""

template0 = """
class PyAstParser{version_name} < Formula
  desc ""
  homepage ""

  url "https://github.com/PythonSwiftLink/PyAstParser/releases/download/{version}/PyAstParser.tar.gz"
  version "{version}"
  sha256 "{sha}"
  license ""

  def install
    bin.install "PyAstParser"
    end

  test do
    system "false"
  end
end
"""

# template_dir = "https://github.com/PythonSwiftLink/BrewFormulaCookie.git"

# context = {
#     "version": version,
#     "name_version": version.replace(".",""),
#     "sha": sha
# }

formula_lastest = template0.format(version=version, version_name="", sha=sha)

formula_version = template0.format(version=version, version_name=f'AT{version.replace(".","")}', sha=sha)

with open("homebrew_formula/pyastparser.rb", "w") as f:
    f.write(formula_lastest)

with open(f"homebrew_formula/pyastparser@{version}.rb", "w") as f:
    f.write(formula_version)
