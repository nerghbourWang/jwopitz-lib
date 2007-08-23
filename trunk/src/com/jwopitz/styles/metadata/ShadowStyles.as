////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (C) 2003-2006 Adobe Macromedia Software LLC and its licensors.
//  All Rights Reserved. The following is Source Code and is subject to all
//  restrictions on such code as contained in the End User License Agreement
//  accompanying this product.
//
////////////////////////////////////////////////////////////////////////////////

/**
 *  Boolean property that specifies whether the component has a visible
 *  drop shadow.
 *  This style is used with <code>borderStyle="solid"</code>.
 *  The default value is <code>false</code>.
 *
 *  <p><b>Note:</b> For drop shadows to appear on containers, set
 *  <code>backgroundColor</code> or <code>backgroundImage</code> properties.
 *  Otherwise, the shadow appears behind the container because
 *  the default background of a container is transparent.</p>
 */
[Style(name="dropShadowEnabled", type="Boolean", inherit="no")]

/**
 *  Color of the drop shadow.
 *
 *  @default 0x000000
 */
[Style(name="dropShadowColor", type="uint", format="Color", inherit="yes")]

/**
 *  Direction of the drop shadow.
 *  Possible values are <code>"left"</code>, <code>"center"</code>,
 *  and <code>"right"</code>.
 *
 *  @default "center"
 */
[Style(name="shadowDirection", type="String", enumeration="left,center,right", inherit="no")]

/**
 *  Distance of the drop shadow.
 *  If the property is set to a negative value, the shadow appears above the component.
 *
 *  @default 2
 */
[Style(name="shadowDistance", type="Number", format="Length", inherit="no")]



