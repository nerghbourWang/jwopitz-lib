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
package com.jwopitz.skins
{
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.geom.Matrix;
	
	import mx.containers.Panel;
	import mx.core.EdgeMetrics;
	import mx.skins.RectangularBorder;
	import mx.styles.StyleManager;

	public class CalloutBorder extends RectangularBorder
	{
		////////////////////////////////////////////////////////////////
		//	BORDER METRICS
		////////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		protected var bm:EdgeMetrics;
		
		/**
		 * @private
		 */
		override public function get borderMetrics ():EdgeMetrics
		{
			if (!bm)
			{				
				if (parent && parent is Panel)
				{
					var btl:Number = getStyle("borderThicknessLeft");
					var btr:Number = getStyle("borderThicknessRight");
					var btt:Number = getStyle("borderThicknessTop");
					var btb:Number = getStyle("borderThicknessBottom");
					
					bm = new EdgeMetrics(btl, btt, btr, btb);
				}
				
				else
				{
					var bt:Number = getStyle("borderThickness");
					
					bm = new EdgeMetrics(bt, bt, bt, bt);
				}
			}
			
			return bm;
		}
		
		////////////////////////////////////////////////////////////////
		//	VALIDATION
		////////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		override protected function updateDisplayList (unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			var backgroundAlpha:Number = getStyle("backgroundAlpha") ? getStyle("backgroundAlpha") : 1;
			var backgroundColor:uint = getStyle("backgroundColor") ? getStyle("backgroundColor") : 0xffffff;
			
			var borderAlpha:Number = getStyle("borderAlpha") ? getStyle("borderAlpha") : 1;
			var borderColor:uint = getStyle("borderColor") ? getStyle("borderColor") : 0x666666;
			var borderThickness:Number = getStyle("borderThickness") ? getStyle("borderThickness") : 1;
			
			var cornerRadius:Number = getStyle("cornerRadius") ? getStyle("cornerRadius") : 10;
			
			var calloutPlacement:String = getStyle("calloutPlacement") ? getStyle("calloutPlacement") : "topRight";
			//var calloutPositioning:String = getStyle("calloutPositioning"); //absolute, relative
			var calloutOffset:Number = getStyle("calloutOffset") ? getStyle("calloutOffset") : 10;
			var calloutWidth:Number = getStyle("calloutWidth") ? getStyle("calloutWidth") : 15;
			var calloutHeight:Number = getStyle("calloutHeight") ? getStyle("calloutHeight") : 25;
			
			var g:Graphics = graphics;
			g.clear();
			
			if (borderAlpha > 0 && borderThickness > 0)
				g.lineStyle(borderThickness, borderColor, borderAlpha, true);
			
			var m:Matrix = new Matrix();
			m.createGradientBox(unscaledWidth, unscaledHeight, Math.PI / 2);
			
			g.beginGradientFill(GradientType.LINEAR,
								getStyle("backgroundGradientColors") ? getStyle("backgroundGradientColors") : [backgroundColor, backgroundColor], 
								getStyle("backgroundGradientAlphas") ? getStyle("backgroundGradientAlphas") : [backgroundAlpha, backgroundAlpha], 
								[0, 255], 
								m);
			
			g.moveTo(cornerRadius, 0);
			g.curveTo(0, 0, 0, cornerRadius);
			
			g.lineTo(0, unscaledHeight - cornerRadius);
			g.curveTo(0, unscaledHeight, cornerRadius, unscaledHeight);
			
			if (calloutPlacement.indexOf("top") != -1)
			{
				if (calloutPlacement == "topRight")
				{
					g.lineTo(cornerRadius + calloutOffset, unscaledHeight);
					g.lineTo(cornerRadius + calloutOffset, unscaledHeight + calloutHeight);
					g.lineTo(cornerRadius + calloutOffset + calloutWidth, unscaledHeight);
				}
				
				else if (calloutPlacement == "topLeft")
				{
					g.lineTo(unscaledWidth - cornerRadius - calloutOffset - calloutWidth, unscaledHeight);
					g.lineTo(unscaledWidth - cornerRadius - calloutOffset, unscaledHeight + calloutHeight);
					g.lineTo(unscaledWidth - cornerRadius - calloutOffset, unscaledHeight);
				}
			}
			
			g.lineTo(unscaledWidth - cornerRadius, unscaledHeight);
			g.curveTo(unscaledWidth, unscaledHeight, unscaledWidth, unscaledHeight - cornerRadius);
			
			g.lineTo(unscaledWidth, cornerRadius);
			g.curveTo(unscaledWidth, 0, unscaledWidth - cornerRadius, 0);
			
			if (calloutPlacement.indexOf("bottom") != -1)
			{
				if (calloutPlacement == "bottomRight")
				{
					g.lineTo(cornerRadius + calloutOffset + calloutWidth, 0);
					g.lineTo(cornerRadius + calloutOffset, -calloutHeight);
					g.lineTo(cornerRadius + calloutOffset, 0);
				}
				
				else if (calloutPlacement == "bottomLeft")
				{
					g.lineTo(unscaledWidth - cornerRadius - calloutOffset, 0);
					g.lineTo(unscaledWidth - cornerRadius - calloutOffset, -calloutHeight);
					g.lineTo(unscaledWidth - cornerRadius - calloutOffset - calloutWidth, 0);
				}
			}
			
			g.lineTo(cornerRadius, 0);
			g.endFill();
		}
		
		////////////////////////////////////////////////////////////////
		//	DEFAULT STYLES
		////////////////////////////////////////////////////////////////
		
		////////////////////////////////////////////////////////////////
		//	CONSTRUCTOR
		////////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		public function CalloutBorder ()
		{
			super();
		}
		
	}
}