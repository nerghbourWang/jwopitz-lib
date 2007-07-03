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
	
	[Style(name="dashLength", type="Number", format="Length", inherit="no")]
	
	public class VRule extends mx.controls.VRule
	{
		protected var lineSprite:Sprite;
		protected var dashMask:Sprite;
		
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
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			// Look up the style properties
			var strokeColor:Number = getStyle("strokeColor");
			var shadowColor:Number = getStyle("shadowColor");
			var strokeWidth:Number = getStyle("strokeWidth");
			var dashLength:Number = getStyle("dashLength");
			if (dashLength <= 0 || isNaN(dashLength))
			{
				lineSprite.mask = null;
				return;
			}
			
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
			var top:Number = 0;
			var right:Number = left + strokeWidth;
			var bottom:Number = unscaledHeight;
	
			if (strokeWidth == 1)
			{
				g.beginFill(strokeColor);
				g.drawRect(left, top, right-left, unscaledHeight);
				g.endFill();
			}
			else if (strokeWidth == 2)
			{
				g.beginFill(strokeColor);
				g.drawRect(left, top, 1, unscaledHeight);
				g.endFill();
	
				g.beginFill(shadowColor);
				g.drawRect(right - 1, top, 1, unscaledHeight);
				g.endFill();
			}
			else if (strokeWidth > 2)
			{
				g.beginFill(strokeColor);
				g.drawRect(left, top, right - left - 1, 1);
				g.endFill();
	
				g.beginFill(shadowColor);
				g.drawRect(right - 1, top, 1, unscaledHeight - 1);
				g.drawRect(left, bottom - 1, right - left, 1);
				g.endFill();
	
				g.beginFill(strokeColor);
				g.drawRect(left, top + 1, 1, unscaledHeight - 2);
				g.endFill();
			}
			
			//now lets draw our mask
			g = dashMask.graphics;
			g.clear();
			
			var dl:Number = dashLength * 2;
			
			var tx:Number = 0;
			var ty:Number = 0;
			var tw:Number = unscaledWidth;
			var th:Number = dl / 2;
			
			var i:int = 0;
			var l:int = Math.ceil(unscaledHeight / dl);
			for (i; i < l; i++)
			{	
				ty = dl * i;
				if (ty + th > unscaledHeight)
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