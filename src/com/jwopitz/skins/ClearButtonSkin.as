/*

Copyright (c) 2007 J.W.Opitz, All Rights Reserved.

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
package com.jwopitz.skins {

	import flash.display.Graphics;
	import flash.geom.Point;

	import mx.core.EdgeMetrics;
	import mx.skins.RectangularBorder;

	/**
	 * @private
	 */
	public class ClearButtonSkin extends RectangularBorder {

	    /**
	     * @private
	     */
	    protected var bm:EdgeMetrics;

	    /**
	     * @private
	     */
	    override public function get borderMetrics ():EdgeMetrics {
	        if (!bm){

	        	var borderThickness:Number = getStyle("borderThickness");
	        	bm = new EdgeMetrics(borderThickness, borderThickness, borderThickness, borderThickness);
	        }

	        return bm;
	    }

	    /**
	     * @private
	     */
	    override protected function updateDisplayList (unscaledWidth:Number, unscaledHeight:Number):void {
	        super.updateDisplayList(unscaledWidth, unscaledHeight);

			//since its a clear box, we don't really need any styling input aside from dimensions

			var g:Graphics = graphics;
			g.clear();
			g.lineStyle(0, 0x000000, 0.0);
			g.beginFill(0x000000, 0.0);

			g.drawRect(parent.x, parent.y, parent.width, parent.height);

			g.endFill();
	    }
	}
}