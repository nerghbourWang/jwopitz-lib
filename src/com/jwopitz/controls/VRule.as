/*

Copyright (c) 2006 J.W.Opitz, All Rights Reserved.

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

*/
package com.jwopitz.controls
{
	import flash.display.Graphics;
	import flash.display.Sprite;

	import mx.controls.VRule;
	import mx.styles.CSSStyleDeclaration;
	import mx.styles.StyleManager;

	/**
	 * The amount of padding from the top of the component to the top of the line.
	 *
	 * @default 0
	 */
	[Style(name="paddingTop", type="Number", format="Length", inherit="no")]

	/**
	 * The amount of padding from the bottom of the component to the bottom of the line.
	 *
	 * @default 0
	 */
	[Style(name="paddingBottom", type="Number", format="Length", inherit="no")]

	/**
	 * The length of the gap between the dashes.
	 *
	 * @default 0
	 */
	[Style(name="dashLength", type="Number", format="Length", inherit="no")]

	/**
	 *  The VRule control creates a single vertical line.
	 *  You typically use this control to create a dividing line
	 *  within a container.
	 *
	 *  <p>The <code>&lt;jwo_lib:VRule&gt;</code> tag inherits all of the tag attributes
	 *  of its superclass, and adds the following tag attributes:</p>
	 *
	 *  <pre>
	 *  &lt;jwo_lib:VRule
	 *    <strong>Styles</strong>
	 *    paddingTop="0"
	 *    paddingBottom="0"
	 *    dashLength="0"
	 *  /&gt;
	 *  </pre>
	 *
	 *  @see mx.controls.HRule
	 */
	public class VRule extends mx.controls.VRule
	{
		/**
		 * @private
		 */
		private static var defaultStylesInitialized:Boolean = setDefaultStyles();

		/**
		 * @private
		 */
		 private static function setDefaultStyles ():Boolean
		{
			var s:CSSStyleDeclaration = StyleManager.getStyleDeclaration("HRule");
			if (!s)
				s = new CSSStyleDeclaration();
				
			if (!s.getStyle("strokeColor"))
				s.setStyle("strokeColor", 0xC4CCCC);
			
			if (!s.getStyle("strokeWidth"))
				s.setStyle("strokeWidth", 1);

        	if (!s.getStyle("paddingTop"))
        		s.setStyle("paddingTop", 0);

        	if (!s.getStyle("paddingBottom"))
        		s.setStyle("paddingBottom", 0);

        	if (!s.getStyle("dashLength"))
        		s.setStyle("dashLength", 0);

        	StyleManager.setStyleDeclaration("HRule", s, true);

        	return true;
        }

		/**
		 * @private
		 */
		protected var lineSprite:Sprite;

		/**
		 * @private
		 */
		protected var dashMask:Sprite;

		/**
		 * @private
		 */
		override protected function createChildren():void
		{
			super.createChildren();

			if (!lineSprite)
			{
				lineSprite = new Sprite();
				addChild(lineSprite);
			}

			if (!dashMask)
			{
				dashMask = new Sprite();
				addChild(dashMask);
			}
		}

		/**
		 * @private
		 */
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);

			// Look up the style properties
			var strokeColor:Number = getStyle("strokeColor");
			var shadowColor:Number = getStyle("shadowColor");
			var strokeWidth:Number = getStyle("strokeWidth");

			var dashLength:Number = getStyle("dashLength");
			var paddingTop:Number = getStyle("paddingTop");
			var paddingBottom:Number = getStyle("paddingBottom");

			// copied fom mx.controls.HRule

			// The thickness of the stroke shouldn't be greater than
			// the unscaledHeight of the bounding rectangle.
			if (strokeWidth > unscaledWidth)
				strokeWidth = unscaledWidth;

			//clear our graphics
			var g:Graphics = graphics;
			g.clear();

			//draw the lines as usual except now in lineSprite
			g = lineSprite.graphics;
			g.clear();

			// The vertical rule extends from the top edge
			// to the bottom edge of the bounding rectangle and
			// is horizontally centered within the bounding rectangle.
			var left:Number = (unscaledWidth - strokeWidth) / 2;
			var top:Number = Math.min(unscaledHeight, paddingTop);
			var right:Number = left + strokeWidth;
			var bottom:Number = Math.max(unscaledHeight - paddingBottom, 0);


			if (strokeWidth <= 1)
			{
				g.beginFill(strokeColor);
				g.drawRect(left,
						   top,
						   right - left,
						   bottom - top);
				g.endFill();
			}
			else if (strokeWidth == 2)
			{
				g.beginFill(strokeColor);
				g.drawRect(left,
						   top,
						   1,
						   bottom - top);
				g.endFill();

				g.beginFill(shadowColor);
				g.drawRect(right - 1,
						   top,
						   1,
						   bottom - top);
				g.endFill();
			}
			else if (strokeWidth > 2)
			{
				g.beginFill(strokeColor);
				g.drawRect(left,
						   top,
						   right - left - 1,
						   1);
				g.endFill();

				g.beginFill(shadowColor);
				g.drawRect(right - 1,
						   top,
						   1,
						   bottom - top - 1);
				g.drawRect(left,
						   bottom - 1,
						   right - left,
						   1);
				g.endFill();

				g.beginFill(strokeColor);
				g.drawRect(left,
						   top + 1,
						   1,
						   bottom - top - 2);
				g.endFill();
			}

			//now lets draw our mask
			g = dashMask.graphics;
			g.clear();

			if (dashLength <= 0)
			{
				lineSprite.mask = null;
				return
			}

			var dl:Number = dashLength * 2;

			var tx:Number = 0;
			var ty:Number = 0;
			var tw:Number = unscaledWidth;
			var th:Number = dl / 2;

			var i:int = 0;
			var l:int = Math.ceil(bottom - top / dl);
			for (i; i < l; i++)
			{
				ty = dl * i + top;
				if (ty + th > bottom)
					th = unscaledHeight - ty;

				g.beginFill(0x000000, 1.0);
				g.drawRect(tx, ty, tw, th);
				g.endFill();
			}

			//apply mask
			if (!lineSprite.mask)
				lineSprite.mask = dashMask;
		}
	}
}