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
	
    import com.jwopitz.skins.FieldSetBorder;
    
    import flash.geom.Point;
    
    import mx.containers.Box;
    import mx.controls.Text;
    
    /**
     * Sets the horizontal alignment of the titleTextField.  Values are "left, "center" and "right".  The default value is "left".
     */
    [Style(name="titleAlign", type="String", enumeration="left,center,right", inherit="no")]
    
    /**
     * Sets the gap between the titleTextField and the drawn border endpoints on each side.  The default value is 2.
     */
    [Style(name="titleGap", type="Number", inherit="no")]
    
    /**
     * Sets the vertical placement of the titleTextField.  Current values are "top".  The default value is "top".
     * 
     * 2007.04.12 - this feature has not yet been implemented - jwopitz
     */
    [Style(name="titlePlacement", type="String", enumeration="top", inherit="no")]
    
    /**
     * Sets the style for the titleTextField.
     */
    [Style(name="titleStyleName", type="String", inherit="no")]
	
    [Bindable]
	public class FieldSet extends Box {
		
		public static const TITLE_ALIGN_LEFT:String = "left";
    	public static const TITLE_ALIGN_CENTER:String = "center";
    	public static const TITLE_ALIGN_RIGHT:String = "right";
                
        protected var _title:String = "";
        protected var _titleTextField:Text;
        
        protected var _titleAlign:String = "left";
		protected var _titleGap:Number = 2;
		protected var _titleStyleName:Object;
		protected var _borderSkin:Class;
		
        protected var _titlePt:Point;
        
        /**
		 * Constructor
		 */
        public function FieldSet (){
        	super();
        	
        	setDefaultStyles();
        	
        	//setStyle("borderStyle", "solid");
        	//setStyle("borderSkin", FieldSetBorder);
        }
		
		/**
		 * Sets the default values for custom styles.  This method is called during the constructor.
		 * Since subclasses will most likely have additional custom style properties,
		 * it is recommended that they override this method.
		 */
		protected function setDefaultStyles ():void {
			
		}
		
		override public function styleChanged (styleProp:String):void {
        	super.styleChanged(styleProp);
        	
        	var allStyles:Boolean = !styleProp || styleProp == "styleName";
        	if (allStyles || styleProp == "titleAlign"){
        		var ta:String = String(getStyle("titleAlign"));
        		if (ta && ta != "undefined")
        			_titleAlign = ta;
        	}
        		
        	
        	if (allStyles || styleProp == "titleGap"){
        		var tg:Number = Number(getStyle("titleGap"));
        		if (!isNaN(tg))
        			_titleGap = tg;
        	}
        		
        	
        	if (allStyles || styleProp == "titleStyleName"){
        		_titleStyleName = getStyle("titleStyleName")      	
        		
        		if (_titleTextField)
					_titleTextField.styleName = _titleStyleName;
        	}
        	
        	if (allStyles || styleProp == "borderStyle")
        		super.setStyle("borderStyle", "solid");
        		
        	if (allStyles || styleProp == "borderSkin")
				super.setStyle("borderSkin", FieldSetBorder);
				
			invalidateDisplayList();
        }
		
		/**
		 * 
		 */
        override protected function createChildren ():void {
            super.createChildren();
            
            if (!_titleTextField){
                _titleTextField = new Text();
                _titleTextField.mouseEnabled = false;
                _titleTextField.text = title;
                
                _titleTextField.styleName = _titleStyleName;
                
				rawChildren.addChild(_titleTextField);
            }
        }
		
		/**
		 * 
		 */
        override protected function layoutChrome (unscaledWidth:Number, unscaledHeight:Number):void {
            super.layoutChrome(unscaledWidth, unscaledHeight);
            
            adjustTitlePt();
            
            if (titleTextField && _titlePt){
            	titleTextField.setActualSize(titleTextField.getExplicitOrMeasuredWidth(), titleTextField.getExplicitOrMeasuredHeight());
            	titleTextField.move(_titlePt.x, _titlePt.y);
            }
        }
		
		/**
		 * Determines the point of placement for the titleTextField based on the value of titleAlign.
		 */
		protected function adjustTitlePt ():void {
			if (!titleTextField)
				return;
				
        	var nx:Number = 0;
        	var ny:Number = 0;
			var gap:Number = _titleGap;
			var cr:Number = getStyle("cornerRadius");
				        		
        	_titleAlign = getStyle("titleAlign"); 
        		
        	switch (_titleAlign){
        		case FieldSet.TITLE_ALIGN_RIGHT:
        		nx = width - cr - borderMetrics.right - _titleGap - titleTextField.getExplicitOrMeasuredWidth() - 5;
        		break;
        		
        		case FieldSet.TITLE_ALIGN_CENTER:
        		nx = (width - titleTextField.getExplicitOrMeasuredWidth()) / 2;
        		break;
        		
        		case FieldSet.TITLE_ALIGN_RIGHT:
        		default:
        		nx = cr + borderMetrics.left + _titleGap + 5;
        	}
        	
        	_titlePt = new Point(nx, ny);
        }
		
		/**
		 * The string value of the FieldSet's title.
		 */
        public function get title ():String {
            return _title;
        }
		/**
		 * @private
		 */
        public function set title (value:String):void {
            _title = value;
            
            if (_titleTextField)
                _titleTextField.text = value;
                
        	layoutChrome(unscaledWidth, unscaledHeight);
        }
		
		/**
		 * Allows outside access to the fieldSet's titleTextField.
		 */
        public function get titleTextField ():Text {
            return _titleTextField;
        }
    }
}