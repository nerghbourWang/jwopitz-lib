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
    
    [Style(name="titleGap", type="String", inherit="no")]
    [Style(name="titleStyleName", type="String", inherit="no")]
	
    [Bindable]
	public class FieldSet extends Box {
    	
    	public static const TITLE_ALIGN_LEFT:String = "left";
    	public static const TITLE_ALIGN_CENTER:String = "center";
    	public static const TITLE_ALIGN_RIGHT:String = "right";
                
        protected var _title:String = "";
        protected var _titleTextField:Text;
        protected var _titlePlacement:String = "left";
        
        protected var _titlePt:Point;
        
		/**
		 * Constructor
		 */
        public function FieldSet (){
        	super();
        	
        	setStyle("borderSkin", FieldSetBorder);
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
                
                var titleStyle:Object = getStyle("titleStyleName");
                if (titleStyle)
                	_titleTextField.styleName = titleStyle;
                
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
        	/*if (borderMetrics.top > titleTextField.getExplicitOrMeasuredHeight())
        		ny = borderMetrics.top - (titleTextField.getExplicitOrMeasuredHeight() / 2);*/
        		
        	switch (_titlePlacement){
        		case FieldSet.TITLE_ALIGN_RIGHT:
        		nx = width - getStyle("cornerRadius") - borderMetrics.right - 10 - titleTextField.getExplicitOrMeasuredWidth();
        		break;
        		
        		case FieldSet.TITLE_ALIGN_CENTER:
        		nx = (width - titleTextField.getExplicitOrMeasuredWidth()) / 2;
        		break;
        		
        		case FieldSet.TITLE_ALIGN_RIGHT:
        		default:
        		nx = getStyle("cornerRadius") + borderMetrics.left + 10;
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
		 * The placement of the titleTextField.  The accepted values are "left", "center" and "right".  Any other value is replaced with "left".
		 * 
		 * @default "left"
		 */
        public function get titleAlign ():String {
        	return _titlePlacement;
        }
		/**
		 * @private
		 */
		public function set titleAlign (value:String):void {
        	_titlePlacement = value;
        	
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