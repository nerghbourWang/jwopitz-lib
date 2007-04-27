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
package com.jwopitz.controls {
    
    import flash.events.Event;
    import flash.events.FocusEvent;
    import flash.events.MouseEvent;
    
    import mx.containers.Canvas;
    import mx.controls.LinkButton;
    import mx.core.UITextField;
    
    /**
     * Style declaration for when the mouseDown event has been triggered over the <code>_linkBtn</code>.
     */
    [Style(name="downText", type="String", inherit="no")]
    
    /**
     * Style declaration for when the rollOver event has been triggered over the <code>_linkBtn</code>.
     */
    [Style(name="overText", type="String", inherit="no")]
        
    public class HyperlinkText extends Canvas {
        
        protected var _text:String = "";
        
        protected var _txtField:UITextField;
        protected var _linkBtn:LinkButton;
        
        protected var _titleStyle:Object;
        
        protected var _hasDefinedWidth:Boolean = false;
        
        public function HyperlinkText (){
            super();
            
            horizontalScrollPolicy = "off";
            verticalScrollPolicy = "off";
        }
                
        override protected function createChildren ():void {
            super.createChildren();
            
            if (!_linkBtn){
                _linkBtn = new LinkButton();
                _linkBtn.buttonMode = true;
                _linkBtn.owner = this;
                _linkBtn.styleName = this;
                _linkBtn.tabEnabled = true;
                
                _linkBtn.addEventListener( MouseEvent.CLICK, linkBtn_onClick);
                _linkBtn.addEventListener(MouseEvent.MOUSE_DOWN, linkBtn_onMouseDown);
                _linkBtn.addEventListener(MouseEvent.MOUSE_UP, linkBtn_onMouseUp);
                _linkBtn.addEventListener( MouseEvent.ROLL_OUT, linkBtn_onRollOut);
                _linkBtn.addEventListener(MouseEvent.ROLL_OVER, linkBtn_onRollOver);
                
                _linkBtn.addEventListener(FocusEvent.FOCUS_IN, linkBtn_onFocusIn);
                _linkBtn.addEventListener(FocusEvent.FOCUS_OUT, linkBtn_onFocusOut);
                
                addChild(_linkBtn);
            }
            
            if (!_txtField){
                _txtField = new UITextField();
                _txtField.mouseEnabled = false;
                _txtField.owner = this;
                _txtField.selectable = false;
                _txtField.styleName = this;
                _txtField.text = _text;
                _txtField.wordWrap = _hasDefinedWidth;
                
                addChild(_txtField);
            }
        }
        
        override protected function updateDisplayList (unscaledWidth:Number, unscaledHeight:Number):void {
            super.updateDisplayList(unscaledWidth, unscaledHeight);
            
            var tw:Number;
            var th:Number;
            
            if (isNaN(percentWidth)){
                tw = getExplicitOrMeasuredWidth();
                th = getExplicitOrMeasuredHeight();
            } else {
                tw = unscaledWidth;
                th = unscaledHeight;
            }
            
            _txtField.move(0, 0);
            _txtField.setActualSize(tw, th);
            
            _linkBtn.move(0, 0);
            _linkBtn.setActualSize(tw, th);
            
            invalidateSize()
        }
                
        protected function updateTextFieldProperties ():void {
            if (!isNaN(width) || !isNaN(percentWidth))
                _hasDefinedWidth = true;
            else
                _hasDefinedWidth = false;
                
            if (_txtField)
                _txtField.wordWrap = _hasDefinedWidth;
                
            invalidateDisplayList();

        }
        
        protected function linkBtn_onClick (evt:MouseEvent):void {
            evt.stopPropagation();
            dispatchEvent(evt);
        }
        
        protected function linkBtn_onMouseDown (evt:MouseEvent):void {
            _titleStyle = getStyle("downText");
            if (_titleStyle)
                _txtField.styleName = _titleStyle;
        }
        
        protected function linkBtn_onMouseUp (evt:MouseEvent):void {
            _titleStyle = getStyle("overText");
            if (_titleStyle)
                _txtField.styleName = _titleStyle;
        }
        
        protected function linkBtn_onRollOut (evt:MouseEvent):void {
            _txtField.styleName = this;
        }
        
        protected function linkBtn_onRollOver (evt:MouseEvent):void {
            _titleStyle = getStyle("overText");
            if (_titleStyle)
                _txtField.styleName = _titleStyle;
        }
        
        protected function linkBtn_onFocusIn (evt:FocusEvent):void {
            _titleStyle = getStyle("overText");
            if (_titleStyle)
                _txtField.styleName = _titleStyle;
        }
        
        protected function linkBtn_onFocusOut (evt:FocusEvent):void {
            _txtField.styleName = this;
        }
                                
        public function get text ():String {
            return _text;
        }
        public function set text (value:String):void {
            _text = value;
            
            if (_txtField)
                _txtField.text = _text;
        }
                
        override public function set width (value:Number):void {
            super.width = value;
            
            updateTextFieldProperties();
        }
        
        override public function set percentWidth (value:Number):void {
            super.percentWidth = value;
            
            updateTextFieldProperties();
        }
    }
}