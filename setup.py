import setuptools

setuptools.setup(
  name="jupyter-pluto-proxy",
  # py_modules rather than packages, since we only have 1 file
  py_modules=['plutoserver'],
  entry_points={
      'jupyter_serverproxy_servers': [
          # name = packagename:function_name
          'pluto = plutoserver:setup_plutoserver',
      ]
  },
  install_requires=['jupyter-server-proxy==1.5.1002'],
  dependency_links=['http://github.com/fonsp/jupyter-server-proxy/tarball/3a58aa5005f942d0c208eab9a480f6ab171142ef#egg=jupyter-server-proxy-1.5.1002']
)

import os

# add Pluto. We don't use Manifest.toml because of some package server issues
os.system('julia -e "import Pkg; Pkg.Registry.update(); Pkg.activate(); Pkg.add(Pkg.PackageSpec(name=\\"Pluto\\", rev=\\"82f23e9\\"));"')

# we add some common packages to trigger download and precompile
os.system('julia -e "import Pkg; Pkg.activate(); Pkg.add(Pkg.PackageSpec(name=\\"Pluto\\", rev=\\"82f23e9\\")); Pkg.activate(mktempdir()); Pkg.add([\\"Images\\", \\"ImageMagick\\", \\"Plots\\"]); Pkg.precompile()"')