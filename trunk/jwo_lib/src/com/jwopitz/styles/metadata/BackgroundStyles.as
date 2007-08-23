////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (C) 2003-2006 Adobe Macromedia Software LLC and its licensors.
//  All Rights Reserved. The following is Source Code and is subject to all
//  restrictions on such code as contained in the End User License Agreement
//  accompanying this product.
//
////////////////////////////////////////////////////////////////////////////////

/**
 *  Alpha level of the color defined by the <code>backgroundColor</code>
 *  property, of the image or SWF file defined by the <code>backgroundImage</code>
 *  style.
 *  Valid values range from 0.0 to 1.0.
 *  
 *  @default 1.0
 */
[Style(name="backgroundAlpha", type="Number", inherit="no")]

/**
 *  Background color of a component.
 *  You can have both a <code>backgroundColor</code> and a
 *  <code>backgroundImage</code> set.
 *  Some components do not have a background.
 *  The DataGrid control ignores this style.
 *  The default value is <code>undefined</code>, which means it is not set.
 *  If both this style and the <code>backgroundImage</code> style
 *  are <code>undefined</code>, the component has a transparent background.
 *
 *  <p>For the Application container, this style specifies the background color
 *  while the application loads, and a background gradient while it is running. 
 *  Flex calculates the gradient pattern between a color slightly darker than 
 *  the specified color, and a color slightly lighter than the specified color.</p>
 * 
 *  <p>The default skins of most Flex controls are partially transparent. As a result, the background color of 
 *  a container partially "bleeds through" to controls that are in that container. You can avoid this by setting the 
 *  alpha values of the control's <code>fillAlphas</code> property to 1, as the following example shows:
 *  <pre>
 *  &lt;mx:<i>Container</i> backgroundColor="0x66CC66"/&gt;
 *      &lt;mx:<i>ControlName</i> ... fillAlphas="[1,1]"/&gt;
 *  &lt;/mx:<i>Container</i>&gt;</pre>
 *  </p>
 */
[Style(name="backgroundColor", type="uint", format="Color", inherit="no")]

/**
 *  Background color of the component when it is disabled.
 *  The global default value is <code>undefined</code>.
 *  The default value for List controls is <code>0xDDDDDD</code> (light gray).
 *  If a container is disabled, the background is dimmed, and the degree of
 *  dimming is controlled by the <code>disabledOverlayAlpha</code> style.
 */
[Style(name="backgroundDisabledColor", type="uint", format="Color", inherit="yes")]

/**
 *  Background image of a component.  This can be an absolute or relative
 *  URL or class.  You can either have both a <code>backgroundColor</code> and a
 *  <code>backgroundImage</code> set at the same time. The background image is displayed
 *  on top of the background color.
 *  The default value is <code>undefined</code>, meaning "not set".
 *  If this style and the <code>backgroundColor</code> style are undefined,
 *  the component has a transparent background.
 * 
 *  <p>The default skins of most Flex controls are partially transparent. As a result, the background image of 
 *  a container partially "bleeds through" to controls that are in that container. You can avoid this by setting the 
 *  alpha values of the control's <code>fillAlphas</code> property to 1, as the following example shows:
 *  <pre>
 *  &lt;mx:<i>Container</i> backgroundColor="0x66CC66"/&gt;
 *      &lt;mx:<i>ControlName</i> ... fillAlphas="[1,1]"/&gt;
 *  &lt;/mx:<i>Container</i>&gt;</pre>
 *  </p>
 */
[Style(name="backgroundImage", type="Object", format="File", inherit="no")]

/**
 *  Scales the image specified by <code>backgroundImage</code>
 *  to different percentage sizes.
 *  A value of <code>"100%"</code> stretches the image
 *  to fit the entire component.
 *  To specify a percentage value, you must include the percent sign (%).
 *  The default value is <code>"auto"</code>, which maintains
 *  the original size of the image.
 */
[Style(name="backgroundSize", type="String", inherit="no")]