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
package com.jwopitz.containers {
	
    import com.jwopitz.core.jwo_internal;
    import com.jwopitz.skins.FieldSetBorder;
    
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
	
    public class FieldSet extends Box {
    	
    ////////////////////////////////////////////////////////////////
	//	DEFAULT STYLES INIT
	////////////////////////////////////////////////////////////////
	
    	private static var defaultStylesInitialized:Boolean = setDefaultStyles();
		
		private static function setDefaultStyles ():Boolean {
        	
        	if (!StyleManager.getStyleDeclaration('FieldSet')){
        		
        		var tsn:CSSStyleDeclaration = new CSSStyleDeclaration();
        		tsn.setStyle('fontWeight', 'bold');
        		
        		var s:CSSStyleDeclaration = new CSSStyleDeclaration();
        		s.setStyle('titleAlign', 'left');
        		s.setStyle('titleGap', 2);
        		s.setStyle('titlePlacement', 'top');
        		s.setStyle('borderStyle', 'solid');
				s.setStyle('borderSkin', FieldSetBorder);
				s.setStyle('titleStyleName', tsn);
				
				StyleManager.setStyleDeclaration('FieldSet', s, true);
        	}
        	
        	return true;
        }
		
		protected var _titleAlign:String = "left";
		protected var _titleGap:Number = 2;
		protected var _titleStyleName:Object;
		        
        protected var titleStyleNameChanged:Boolean = false;
		
		override public function styleChanged (styleProp:String):void {
        	super.styleChanged(styleProp);
        	
        	var allStyles:Boolean = !styleProp || styleProp == "styleName";
        	if (allStyles || styleProp == "titleAlign")
        		_titleAlign = getStyle("titleAlign");
        		
        	if (allStyles || styleProp == "titleGap")
        		_titleGap = getStyle("titleGap");
        		
        	if (allStyles || styleProp == "titleStyleName")
        		titleStyleNameChanged = true;
    
        	invalidateDisplayList();
        }
		
		/**
		 * 
		 */
        override protected function createChildren ():void {
            super.createChildren();
            
            if (!textField){
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
		override protected function commitProperties ():void {
			super.commitProperties();
			
			if (titleTextChanged && textField){
				textField.text = title;
				titleTextChanged = false;
			}
		}
        
        /**
         * 
         */
		override protected function updateDisplayList (unscaledWidth:Number, unscaledHeight:Number):void {
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			if (titleStyleNameChanged){
				textField.styleName = getStyle('titleStyleName');
				titleStyleNameChanged = false;
				titlePtChanged = true; //style may affect the position of the textField
			}
			
			if (titlePtChanged){
				textField.setActualSize(textField.getExplicitOrMeasuredWidth(), 
										textField.getExplicitOrMeasuredHeight());
				
				textField.move(titlePoint.x, titlePoint.y);
				titlePtChanged = false;
			}
		}
			
	////////////////////////////////////////////////////////////////
	//	TITLE PT
	////////////////////////////////////////////////////////////////
	
		/**
		 * @private
		 */ 
		protected var titlePtChanged:Boolean = false;
        
		/**
		 * @private
		 */
		private var _tp:Point = new Point();
		
		/**
		 * Returns the targeted origin pt of the titleTextField based on titleAlignment.
		 */
		protected function get titlePoint ():Point {
			if (!textField)
				return _tp;
						
			var nx:Number = 0;
        	var ny:Number = 0;
			
			var ta:String = _titleAlign
			var tg:Number = _titleGap
			var cr:Number = getStyle("cornerRadius");
			        		
        	switch (ta){
        		case "right":
        		nx = width - cr - borderMetrics.right - tg - textField.getExplicitOrMeasuredWidth() - 5;
        		break;
        		
        		case "center":
        		nx = (width - textField.getExplicitOrMeasuredWidth()) / 2;
        		break;
        		
        		case "left":
        		default:
        		nx = cr + borderMetrics.left + tg + 5;
        	}	
			
			if (_tp.x != x)
				_tp.x = nx;
			
			return _tp;
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
        public function get title ():String {
            return titleText;
        }
		/**
		 * @private
		 */
        public function set title (value:String):void {
            if (titleText != value){
            	titleText = value;
            	titleTextChanged = true;
            	titlePtChanged = true;
				
            	invalidateProperties();
            	invalidateDisplayList();
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
        jwo_internal function get titleTextField ():UITextField {
        	return textField;
		}
    }
}