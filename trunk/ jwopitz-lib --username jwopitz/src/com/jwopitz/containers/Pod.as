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
	
	import flash.events.MouseEvent;
	
	import mx.containers.Panel;
	import mx.controls.Button;
	import mx.core.EventPriority;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	
	/**
     * Sets the vertical alignment of the header children added with addTitleBarComponent and the titleTextField.
     * Values are "top, "middle" and "bottom".  The default value is "middle".
     */
    [Style (name="headerVerticalAlign", type="String", enumeration="top,middle,bottom", inherit="no")]
    
    /**
     * Sets the horizontal gap of the header children added with addTitleBarComponent.  
     * If no value is set, then the value of horizontalGap will be used for the gap.  The default value is 6.
     */
    [Style (name="headerHorizontalGap", type="Number", inherit="no")]
	
	[Event (name="gripClick", type="flash.events.MouseEvent")]
	[Event (name="gripMouseDown", type="flash.events.MouseEvent")]
	[Event (name="gripMouseMove", type="flash.events.MouseEvent")]
	[Event (name="gripMouseOver", type="flash.events.MouseEvent")]
	[Event (name="gripMouseOut", type="flash.events.MouseEvent")]
	[Event (name="gripMouseUp", type="flash.events.MouseEvent")]
	[Event (name="gripRollOut", type="flash.events.MouseEvent")]
	[Event (name="gripRollOver", type="flash.events.MouseEvent")]
	
	[Bindable]
	public class Pod extends Panel {
		
		public static const GRIP_CLICK:String = "gripClick";
		public static const GRIP_MOUSE_DOWN:String = "gripMouseDown";
		public static const GRIP_MOUSE_MOVE:String = "gripMouseMove";
		public static const GRIP_MOUSE_OVER:String = "gripMouseOver";
		public static const GRIP_MOUSE_OUT:String = "gripMouseOut";
		public static const GRIP_MOUSE_UP:String = "gripMouseUp";
		public static const GRIP_ROLL_OUT:String = "gripRollOut";
		public static const GRIP_ROLL_OVER:String = "gripRollOver";
				
		protected var _creationQueue:Array = [];
		protected var _titleBarAssets:Array = [];
		
		protected var _headerVerticalAlign:String = "middle";
		protected var _headerChildGap:Number;
		
		public var defaultTitleBarComponentClass:Class = Button;
		
		/**
		 * Constructor
		 */
		public function Pod (){
			super();
			
			setDefaultStyles();
		}
		
		/**
		 * Sets the default values for custom styles.  This method is called during the constructor.
		 * Since subclasses will most likely have additional custom style properties,
		 * it is recommended that they override this method.
		 */
		protected function setDefaultStyles ():void {
			if (getStyle("headerVerticalAlign"))
				_headerVerticalAlign = String(getStyle("headerVerticalAlign"));
				
			if (getStyle("headerHorizontalGap"))
				_headerChildGap = Number(getStyle("headerHorizontalGap"));
			else
				_headerChildGap = Number(getStyle("horizontalGap"));
		}
		
		override public function styleChanged (styleProp:String):void {
			super.styleChanged(styleProp);
			
			var allStyles:Boolean = !styleProp || styleProp == "styleName";
			if (allStyles || styleProp == "headerVerticalAlign"){
				var hva:String = String(getStyle("headerVerticalAlign"));
				if (!hva)
					hva = "middle";
				
				_headerVerticalAlign = hva;
			}
			
			if (allStyles || styleProp == "headerHorizontalGap"){
				var hhg:Number = Number(getStyle("headerHorizontalGap"));
				if (isNaN(hhg))
					hhg = getStyle("horizontalGap");
					
				_headerChildGap = hhg;
			}
							
		}
		
		override protected function createChildren ():void {
			super.createChildren();
			
			titleBar.mouseChildren = false;
			assignTitleBarListeners();
		}
				
		override protected function layoutChrome (unscaledWidth:Number, unscaledHeight:Number):void {
			super.layoutChrome(unscaledWidth, unscaledHeight);
			
			repositionHeaderElements();
		}
		
		protected function assignTitleBarListeners ():void {
			titleBar.addEventListener(FlexEvent.CREATION_COMPLETE, titleBar_onCreationComplete, false, EventPriority.DEFAULT_HANDLER);
			
			titleBar.addEventListener(MouseEvent.CLICK, titleBar_onClick, false, EventPriority.DEFAULT_HANDLER);
			titleBar.addEventListener(MouseEvent.MOUSE_DOWN, titleBar_onMouseDown, false, EventPriority.DEFAULT_HANDLER);
			titleBar.addEventListener(MouseEvent.MOUSE_MOVE, titleBar_onMouseMove, false, EventPriority.DEFAULT_HANDLER);
			titleBar.addEventListener(MouseEvent.MOUSE_OUT, titleBar_onMouseOut, false, EventPriority.DEFAULT_HANDLER);
			titleBar.addEventListener(MouseEvent.MOUSE_OVER, titleBar_onMouseOver, false, EventPriority.DEFAULT_HANDLER);
			titleBar.addEventListener(MouseEvent.MOUSE_UP, titleBar_onMouseUp, false, EventPriority.DEFAULT_HANDLER);
			titleBar.addEventListener(MouseEvent.ROLL_OUT, titleBar_onRollOut, false, EventPriority.DEFAULT_HANDLER);
			titleBar.addEventListener(MouseEvent.ROLL_OVER, titleBar_onRollOver, false, EventPriority.DEFAULT_HANDLER);
		}
		
		protected function repositionHeaderElements ():void {
			
			var uic:UIComponent;
			var tx:Number = 0; //target x value
			var px:Number = 0; //previous x value
			var ty:Number = 0; //target y value
			
			var i:int = 0;
			var l:int = _titleBarAssets.length;
			if (l == 0)
				return;
			
			for (i; i < l; i++){
				uic = _titleBarAssets[i] as UIComponent;
				uic.setActualSize(uic.getExplicitOrMeasuredWidth(), uic.getExplicitOrMeasuredHeight());
				
				if (i == 0){
					tx = unscaledWidth - borderMetrics.right - uic.getExplicitOrMeasuredWidth() - 10;
				} else {
					tx = px - uic.getExplicitOrMeasuredWidth() - _headerChildGap;
				}
				
				switch(_headerVerticalAlign){
					case "top":
					ty = 5;
					break;
					
					case "bottom":
					ty = getHeaderHeight() - uic.getExplicitOrMeasuredHeight();
					break;
					
					case "middle":
					default:
					ty = (getHeaderHeight() - uic.getExplicitOrMeasuredHeight()) / 2;
					break;
				}
				
				
				if (uic.x != tx || uic.y != ty)
					uic.move(tx, ty);
				
				px = tx;
			}
			
			if (titleTextField){
				switch(_headerVerticalAlign){
					case "top":
					ty = 5;
					break;
					
					case "bottom":
					ty = getHeaderHeight() - titleTextField.getExplicitOrMeasuredHeight();
					break;
					
					case "middle":
					default:
					ty = (getHeaderHeight() - titleTextField.getExplicitOrMeasuredHeight()) / 2;
					break;
				}
				
				titleTextField.move(titleTextField.x, ty);
			}
			
		}
		
		public function addTitleBarComponent (value:UIComponent = null):UIComponent {
			if (!value)
				value = new defaultTitleBarComponentClass();
			
			value.addEventListener(MouseEvent.CLICK, titleBarComponent_defaultMouseEventHandler, false, EventPriority.DEFAULT_HANDLER);
			value.addEventListener(MouseEvent.MOUSE_DOWN, titleBarComponent_defaultMouseEventHandler, false, EventPriority.DEFAULT_HANDLER);
			value.addEventListener(MouseEvent.MOUSE_OUT, titleBarComponent_defaultMouseEventHandler, false, EventPriority.DEFAULT_HANDLER);
			value.addEventListener(MouseEvent.MOUSE_OVER, titleBarComponent_defaultMouseEventHandler, false, EventPriority.DEFAULT_HANDLER);
			value.addEventListener(MouseEvent.MOUSE_UP, titleBarComponent_defaultMouseEventHandler, false, EventPriority.DEFAULT_HANDLER);
			
			value.buttonMode = true;
			value.owner = this;
			//value.styleName = this;
			
			_titleBarAssets.push(value);
			
			if (!titleBar){
				_creationQueue.push(value);
			} else {
				titleBar.addChild(value);
			}
			
			return value;
		}
		
		/**
		 * Clones a target mouse event but allows for the type to be set prior to cloning.  
		 * This method should be used only for capturing events fired from the titleBar area which
		 * do not originate from any of its children.
		 */
		protected function createTitleBarMouseEvent (type:String, targetEvt:MouseEvent):MouseEvent {
			var evt:MouseEvent = new MouseEvent(type, 
												targetEvt.bubbles,
												targetEvt.cancelable,
												targetEvt.localX,
												targetEvt.localY,
												targetEvt.relatedObject,
												targetEvt.ctrlKey,
												targetEvt.altKey,
												targetEvt.shiftKey,
												targetEvt.buttonDown,
												targetEvt.delta);
			
			return evt;
		}
		
		//
		//	title bar button evt handlers 
		//-----------------------------------------------------------//
					
		/**
		 * TitleBar by default is setup to handle events as possible drag initiators while in popup modes.  
		 * In order to override that default behavior, the evt must stop propogation and be handled in a different manner so as not to
		 * trigger a possible drag action.
		 */ 
		protected function titleBarComponent_defaultMouseEventHandler (evt:MouseEvent):void {
			evt.stopPropagation();
		}
		
		//
		//	title bar evt handlers 
		//-----------------------------------------------------------//
		
		/**
		 * Depending on the instantiation of this component, the titleBar may not be created yet when calling addTitleBarComponent().
		 * In order to avoid null pointer references, if a titleBarComponent is being added and the titleBar = null, the added child
		 * is placed in the creation queue.  TitleBar then references this queue and adds the components listed.
		 */ 
		protected function titleBar_onCreationComplete (evt:FlexEvent):void {
			var titleBarChild:UIComponent;
			var i:int = 0;
			var l:int = _creationQueue.length;
			for (i; i < l; i++){
				titleBarChild = _creationQueue[i] as UIComponent;
				titleBar.addChild(titleBarChild);
			}
			
			_creationQueue = [];
		}
		
		protected function titleBar_onClick (evt:MouseEvent):void {
			dispatchEvent(createTitleBarMouseEvent(Pod.GRIP_CLICK, evt));
		}
		
		/**
		 * TitleBar has a predefined handler that acts on click events when a Pod is in popup mode.  
		 * titleBar_onMouseDown is used in order to receive and broadcast click events when in non-popup mode. 
		 */
		protected function titleBar_onMouseDown (evt:MouseEvent):void {
			if (!isPopUp){
				dispatchEvent(createTitleBarMouseEvent(Pod.GRIP_MOUSE_DOWN, evt));
			}
		}
		
		protected function titleBar_onMouseMove (evt:MouseEvent):void {
			dispatchEvent(createTitleBarMouseEvent(Pod.GRIP_MOUSE_MOVE, evt));
		}
		
		protected function titleBar_onMouseOut (evt:MouseEvent):void {
			dispatchEvent(createTitleBarMouseEvent(Pod.GRIP_MOUSE_OUT, evt));
		}
		
		protected function titleBar_onMouseOver (evt:MouseEvent):void {
			dispatchEvent(createTitleBarMouseEvent(Pod.GRIP_MOUSE_OVER, evt));
		}
		
		protected function titleBar_onMouseUp (evt:MouseEvent):void {
			dispatchEvent(createTitleBarMouseEvent(Pod.GRIP_MOUSE_UP, evt));
		}
		
		protected function titleBar_onRollOut (evt:MouseEvent):void {
			dispatchEvent(createTitleBarMouseEvent(Pod.GRIP_ROLL_OUT, evt));
		}
		
		protected function titleBar_onRollOver (evt:MouseEvent):void {
			dispatchEvent(createTitleBarMouseEvent(Pod.GRIP_ROLL_OVER, evt));
		}
				
		public function get headerHeight ():Number {
			return getHeaderHeight();
		}
		public function set headerHeight (value:Number):void {
			setStyle("headerHeight", value);
		}
		
	}
}