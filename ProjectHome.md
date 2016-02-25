The jwo\_lib project consists of open source user interface components for Adobe Flex.

# News & Updates #

## **2009.07.30** ##
Just figured I would say that yes the project is still current.  These old bugs will be addressed once I get a working version of Flex/Flash Builder 4.

## **2008.04.02** ##
  * added titleBarChildren to Pod for title bar component declaration in mxml.
  * updated Pod example and source file to reflect change.
  * uploaded new content which includes src, docs, swc

## **2008.03.28** ##
  * fixed Pod titleBar assets not rendering on creation complete event
  * fixed FieldSet default backgroundColor and backgroundAlpha props to 0x000000 & 0.0 respectively
  * fixed PaginatedItemsControlBase::itemsPerPage not reflecting change
  * added example application for [PaginatedItemsControlBase](http://jwopitz-lib.googlecode.com/svn/examples/examples/PaginatedItemsControlApplication.html)
  * added srcview for all applications (see [componentManifest](http://code.google.com/p/jwopitz-lib/wiki/componentManifest))

## **2008.03.26** ##
I finally started building the project using FB3.  Since I haven't tackled any issues specifically for FB3 there should be no issues using the components in a FB2 project that I know of.  Please email me if you encounter such issues.

  * now compiled using FB3's compc/asdoc
  * added additional documentation to all components
  * added IPaginatedItemsControl
  * added PaginatedItemsControlBase