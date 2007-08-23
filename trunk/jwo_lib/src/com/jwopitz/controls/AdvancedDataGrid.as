package com.jwopitz.controls
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import mx.controls.DataGrid;
	import mx.controls.dataGridClasses.DataGridBase;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.controls.listClasses.ListBase;
	import mx.controls.scrollClasses.ScrollBar;
	import mx.core.mx_internal;
	
	use namespace mx_internal;
	
	public class AdvancedDataGrid extends DataGrid
	{
		override protected function updateDisplayList (unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			//if there are no locked columns then opt out
			if (lockedColumnCount == 0 && lockedRowCount == 0)
				return;
				
			var bThickness:Number = Number(getStyle("borderThickness")); 
										
			//horizontalScrollBar's target x, y, width & height
			var htx:Number;
			var hty:Number;
			var htw:Number;
			var hth:Number;
						
			if (horizontalScrollBar && horizontalScrollBar.visible)
			{
				htx = bThickness;
				var i:int = 0;
				for (i; i < lockedColumnCount; i++)
				{
					htx += DataGridColumn(columns[i]).width;
				}
				hty = horizontalScrollBar.y// + bThickness;
				
				htw = getExplicitOrMeasuredWidth() - htx - bThickness;
				
				if (verticalScrollBar && verticalScrollBar.visible)
					htw -= verticalScrollBar.getExplicitOrMeasuredWidth();
				
				hth = horizontalScrollBar.getExplicitOrMeasuredHeight();
				
				horizontalScrollBar.move(htx, hty);
				horizontalScrollBar.setActualSize(htw, hth);				
			}
			
			//verticalScrollBar's target x, y, width & height
			var vtx:Number;
			var vty:Number;
			var vtw:Number;
			var vth:Number;
			
			if (verticalScrollBar && verticalScrollBar.visible)
			{
				vtx = verticalScrollBar.x// + bThickness;
				vty = bThickness + headerHeight + (rowHeight * (lockedRowCount - 1)); //headers count as a locked row
				vtw = verticalScrollBar.getExplicitOrMeasuredWidth() - bThickness;
				vth = this.getExplicitOrMeasuredHeight() - vty - bThickness;
				
				if (horizontalScrollBar && horizontalScrollBar.visible)
					vth -= horizontalScrollBar.getExplicitOrMeasuredHeight();
				
				verticalScrollBar.move(vtx, vty);
				verticalScrollBar.setActualSize(vtw, vth);
			}				 
		}
		
		override protected function layoutChrome (unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.layoutChrome(unscaledWidth, unscaledHeight);
			
			var bAlpha:Number = getStyle("borderAlpha");
			var bColor:uint = getStyle("borderColor");
			var bThickness:Number = getStyle("borderThickness");
			
			var g:Graphics = graphics;
			g.clear();
			g.lineStyle(bThickness, bColor, bAlpha);
			
			var pt0:Point;
			var pt1:Point;
			
			if (horizontalScrollBar && horizontalScrollBar.visible)
			{
				pt0 = new Point(-10, height)//(0, horizontalScrollBar.y);
				pt1 = new Point(-10, height * 2);//(horizontalScrollBar.x, horizontalScrollBar.y);
				
				g.moveTo(pt0.x, pt0.y);
				g.lineTo(pt1.x, pt1.y);
			}
			
			if (verticalScrollBar && verticalScrollBar.visible)
			{
			}
		}
		
		override protected function drawVerticalLine (s:Sprite, colIndex:int, color:uint, x:Number):void
		{
			
			var l:int = columnCount - 1;
			if (colIndex >= l)
				return;
			
			//draw our vertical lines 
	        var g:Graphics = s.graphics;
	        if (lockedColumnCount > 0 && colIndex == lockedColumnCount - 1)
	            g.lineStyle(1, 0, 100);
	        else
	            g.lineStyle(1, color, 100);
	        
	        g.moveTo(x, 1);
	        g.lineTo(x, listContent.height);
		}
	}
}