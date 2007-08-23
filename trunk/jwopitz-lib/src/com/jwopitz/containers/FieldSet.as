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
package com.jwopitz.containers
{ 	
    import com.jwopitz.core.jwo_internal;
    import com.jwopitz.skins.FieldSetBorder;
    
    import flash.events.Event;
    import flash.geom.Point;
    
    import mx.containers.Box;
    import mx.core.UITextField;
    import mx.styles.CSSStyleDeclaration;
    import mx.styles.StyleManager;
       
	use namespace jwo_internal;
    
    /**
     * Sets the horizontal alignment of the textField.  Values are "left, "center" and "right".  The default value is "left".
     */
    [Style(name="titleAlign", type="String", enumeration="left,center,right", inherit="no")]
    
    /**
     * Sets the gap between the textField and the drawn border endpoints on each side.  The default value is 2.
     */
    [Style(name="titleGap", type="Number", inherit="no")]
    
    /**
     * Sets the vertical placement of the textField.  Current values are "top".  The default value is "top".
     * 
     * 2007.04.12 - this feature has not yet been implemented - jwopitz
     */
    [Style(name="titlePlacement", type="String", enumeration="top", inherit="no")]
    
    /**
     * Sets the style for the textField.
     */
    [Style(name="titleStyleName", type="String", inherit="no")]
	
    public class FieldSet extends Box
    {
    	
	    ////////////////////////////////////////////////////////////////
		//	DEFAULT STYLES INIT
		////////////////////////////////////////////////////////////////
	
    	private static var defaultStylesInitialized:Boolean = setDefaultStyles();
		
		private static function setDefaultStyles ():Boolean
		{
        	if (!StyleManager.getStyleDeclaration('FieldSet'))
        	{
        		var tsn:CSSStyleDeclaration = new CSSStyleDeclaration();
        		tsn.setStyle('fontWeight', 'bold');
        		
        		var s:CSSStyleDeclaration = new CSSStyleDeclaration();
        		s.setStyle('borderStyle', 'solid');
				s.setStyle('borderSkin', FieldSetBorder);
				
				s.setStyle('paddingLeft', 2);
				s.setStyle('paddingRight', 2);
				s.setStyle('paddingTop', 2);
				s.setStyle('paddingBottom', 2);
				
				s.setStyle('titleAlign', 'left');
        		s.setStyle('titleGap', 2);
        		s.setStyle('titlePlacement', 'top');
        		s.setStyle('titleStyleName', tsn);
        						
				StyleManager.setStyleDeclaration('FieldSet', s, true);
        	}
        	
        	return true;
        }
		
		protected var titleStyleNameChanged:Boolean = false;
		
		override public function styleChanged (styleProp:String):void
		{
        	super.styleChanged(styleProp);
        	
        	var allStyles:Boolean = !styleProp || styleProp == "styleName";
        	if (allStyles || styleProp == "titleAlign" || styleProp == "titleGap")
        		titlePtChanged = true;
        		
        	if (allStyles || styleProp == "titleStyleName")
        		titleStyleNameChanged = true;
    
        	invalidateDisplayList();
        }
		
		/**
		 * 
		 */
        override protected function createChildren ():void
        {
            super.createChildren();
            
            if (!textField)
            {
                textField = new UITextField();
                textField.mouseEnabled = false;
                textField.text = title;
                textField.styleName = getStyle("titleStyleName");
                
                rawChildren.addChild(textField);
            }
        }
        
		/**
		 * 
		 */
		override protected function commitProperties ():void
		{
			super.commitProperties();
			
			if (titleTextChanged && textField)
			{
				textField.text = title;
				titleTextChanged = false;
			}
		}
        
        /**
         * 
         */
		override protected function updateDisplayList (unscaledWidth:Number, unscaledHeight:Number):void
		{
			if (titleStyleNameChanged)
			{
				textField.styleName = getStyle('titleStyleName');
				titleStyleNameChanged = false;
				titlePtChanged = true; //style may affect the position of the textField
			}
			
			if (titlePtChanged)
			{
				var pt:Point = getTitlePoint();
				var minX:Number = getStyle("cornerRadius") + getStyle("titleGap") + 5;
				var maxW:Number = getExplicitOrMeasuredWidth() - 2 * minX + 5;
				if (pt.x <= minX || textField.getExplicitOrMeasuredWidth() >= maxW)
				{
					pt.x = minX;
					
					textField.setActualSize(maxW, textField.getExplicitOrMeasuredHeight());
					textField.truncateToFit();
				}
				else
					textField.setActualSize(textField.getExplicitOrMeasuredWidth(), textField.getExplicitOrMeasuredHeight());
					
				textField.move(pt.x, pt.y);
				
				titlePtChanged = false;
			}
			
			super.updateDisplayList(unscaledWidth, unscaledHeight);
		}
			
		////////////////////////////////////////////////////////////////
		//	TITLE PT
		////////////////////////////////////////////////////////////////
	
		/**
		 * @private
		 */ 
		protected var titlePtChanged:Boolean = false;
        
		/**
		 * Returns the targeted origin pt of the titleTextField based on titleAlignment.
		 */
		protected function getTitlePoint ():Point
		{
			var pt:Point = new Point();
			
			if (!textField)
				return pt;
			
			var nx:Number = 0;
        	var ny:Number = 0;
			
			var ta:String = getStyle("titleAlign");
			var tg:Number = getStyle("titleGap");
			var cr:Number = getStyle("cornerRadius");
			        		
        	switch (ta)
        	{
        		case "right":
        		{
        			nx = width - cr - borderMetrics.right - tg - textField.getExplicitOrMeasuredWidth() - 5;
        			break;
        		}
        		
        		case "center":
        		{
        			nx = (width - textField.getExplicitOrMeasuredWidth()) / 2;
        			break;
        		}
        		
        		case "left":
        		default:
        		{
        			nx = cr + borderMetrics.left + tg + 5;
        			break;
        		}
        	}	
			
			if (pt.x != nx)
				pt.x = nx;
			
			return pt;
		}
		
		////////////////////////////////////////////////////////////////
		//	TITLE
		////////////////////////////////////////////////////////////////	
        
        /**
         * @private
         */ 
        protected var titleText:String = "";
        
		/**
		 * @private
		 */
        protected var titleTextChanged:Boolean = false;
        
        /**
		 * The string value of the FieldSet's title.
		 */
		[Bindable("titleChanged")]
        public function get title ():String
        {
            return titleText;
        }
		/**
		 * @private
		 */
        public function set title (value:String):void
        {
            if (titleText != value)
            {
            	titleText = value;
            	titleTextChanged = true;
            	titlePtChanged = true;
				
				invalidateProperties();
            	invalidateDisplayList();
            	
            	dispatchEvent(new Event("titleChanged"));
            }
        }
	
		////////////////////////////////////////////////////////////////
		//	TITLE TEXT FIELD
		////////////////////////////////////////////////////////////////       
		
		/**
		 * @private
		 */
		protected var textField:UITextField;
		
		/**
		 * Allows outside access to the fieldSet's textField.
		 */
        jwo_internal function get titleTextField ():UITextField
		{
        	return textField;
		}
    }
}