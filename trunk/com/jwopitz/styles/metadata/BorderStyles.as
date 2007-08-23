////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (C) 2003-2006 Adobe Macromedia Software LLC and its licensors.
//  All Rights Reserved. The following is Source Code and is subject to all
//  restrictions on such code as contained in the End User License Agreement
//  accompanying this product.
//
////////////////////////////////////////////////////////////////////////////////

/**
 *  Color of the border.
 *  The default value depends on the component class;
 *  if not overridden for the class, the default value is <code>0xB7BABC</code>.
 */
[Style(name="borderColor", type="uint", format="Color", inherit="no")]

/**
 *  Bounding box sides.
 *  A space-delimited String that specifies the sides of the border to show.
 *  The String can contain <code>"left"</code>, <code>"top"</code>,
 *  <code>"right"</code>, and <code>"bottom"</code> in any order.
 *  The default value is <code>"left top right bottom"</code>,
 *  which shows all four sides.
 *
 *  This style is only used when borderStyle is <code>"solid"</code>.
 */
[Style(name="borderSides", type="String", inherit="no")]

/**
 *  The border skin of the component.
 *
 *  @default mx.skins.halo.HaloBorder
 */
[Style(name="borderSkin", type="Class", inherit="no")]

/**
 *  Bounding box style.
 *  The possible values are <code>"none"</code>, <code>"solid"</code>,
 *  <code>"inset"</code>, and <code>"outset"</code>.
 *  The default value depends on the component class;
 *  if not overridden for the class, the default value is <code>"inset"</code>.
 *  The default value for most Containers is <code>"none"</code>.
 */
[Style(name="borderStyle", type="String", enumeration="inset,outset,solid,none", inherit="no")]

/**
 *  Bounding box thickness.
 *  Only used when <code>borderStyle</code> is set to <code>"solid"</code>.
 *
 *  @default 1
 */
[Style(name="borderThickness", type="Number", format="Length", inherit="no")]

/**
 *  Radius of component corners.
 *  The default value depends on the component class;
 *  if not overriden for the class, the default value is 0.
 *  The default value for ApplicationControlBar is 5.
 */
[Style(name="cornerRadius", type="Number", format="Length", inherit="no")]