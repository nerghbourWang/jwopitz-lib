2007.11.09 - jwopitz

In order to make use of the build.xml you will need to create a build.properties file.
Since your paths may be different than those on my machine, you most likely need to update the paths contained in the build.properties file.
Mac users will most definitely need to do so.

Copy and paste the below code into you build.properties file and update the paths (if applicable).

----------------------------------------------------------

# -----------------------------------------------------------------
# User-Defined Paths
#
# Modify these path values to reflect paths on your system
# -----------------------------------------------------------------

# The location of the Flex 2 SDK on your sytem.
flexSDK.bin.dir = D:/Program Files/Adobe/Flex Builder 2 Plug-in/Flex SDK 2/bin
flexSDK.lib.dir = D:/Program Files/Adobe/Flex Builder 2 Plug-in/Flex SDK 2/frameworks/libs

# Note that the locale dir uses the {locale} token at the end to specify the directory
# of language-specific files.  This is replaced by the compiler with the locale defined
# by the locale property below.
flexSDK.locale = en_US
flexSDK.locale.dir = D:/Program Files/Adobe/Flex Builder 2 Plug-in/Flex SDK 2/frameworks/locale/{locale}

asdoc.exe = ${flexSDK.bin.dir}/asdoc.exe
compc.exe = ${flexSDK.bin.dir}/compc.exe
mxmlc.exe = ${flexSDK.bin.dir}/mxmlc.exe

# The debug player is necessary here because it writes trace statements to a flashlog.txt
# file.  This allows us to examine the .txt file and determine the status of unit tests
# in an automated fashion.
flashDebugPlayer.exe = D:/Program Files/Adobe/Flex Builder 2 Plug-in/Player/debug/SAFlashPlayer.exe

# -----------------------------------------------------------------
# File Names - DO NOT MODIFY
# -----------------------------------------------------------------
# swc names
jwo_lib.name = jwo_lib

# manifest
manifest.uri = http://www.jwolib.com/2006/mxml
manifest.xml = ${basedir}/build/mxml-manifest.xml

# mxml app names
fieldSetApp.name = FieldSetApplication
ruleApp.name = HRuleVRuleApplication
hyperlinkTextApp.name = HyperlinkTextApplication
podApp.name = PodApplication
textInputApp.name = TextInputApplication
tileCanvasApp.name = TileCanvasApplication

# externs reporting
jwo_lib.report = report

# -----------------------------------------------------------------
# Project Paths - DO NOT MODIFY
# -----------------------------------------------------------------
asdoc.dir = ${basedir}/asdoc
bin.dir = ${basedir}/bin
build.dir = ${basedir}/build
examples.dir = ${basedir}/../jwo_lib_EXAMPLES
examples.bin = ${basedir}/../jwo_lib_EXAMPLES/example
examples.src = ${basedir}/../jwo_lib_EXAMPLES/src
src.dir = ${basedir}/src