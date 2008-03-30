package jwolib.events
{
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.core.IUIComponent;
	
	public class TitleBarMouseEvent extends MouseEvent
	{
		/////////////////////////////////////////////////////////////////////////////////
		// CONST
		/////////////////////////////////////////////////////////////////////////////////
		
		public static const TITLE_BAR_CLICK:String = "titleBarClick";
		public static const TITLE_BAR_MOUSE_DOWN:String = "titleBarMouseDown";
		public static const TITLE_BAR_MOUSE_MOVE:String = "titleBarMouseMove";
		public static const TITLE_BAR_MOUSE_OVER:String = "titleBarMouseOver";
		public static const TITLE_BAR_MOUSE_OUT:String = "titleBarMouseOut";
		public static const TITLE_BAR_MOUSE_UP:String = "titleBarMouseUp";
		public static const TITLE_BAR_ROLL_OUT:String = "titleBarRollOut";
		public static const TITLE_BAR_ROLL_OVER:String = "titleBarRollOver";
		
		/////////////////////////////////////////////////////////////////////////////////
		// CONSTRUCTOR
		/////////////////////////////////////////////////////////////////////////////////
		
		public function TitleBarMouseEvent(type:String,
			bubbles:Boolean = true,
			cancelable:Boolean = false,
			localX:Number = NaN,
			localY:Number = NaN,
			relatedObject:InteractiveObject = null,
			ctrlKey:Boolean = false,
			altKey:Boolean = false,
			shiftKey:Boolean = false,
			buttonDown:Boolean = false,
			delta:int = 0)
		{
			super(type, bubbles, cancelable, localX, localY, relatedObject, ctrlKey, altKey, shiftKey, buttonDown, delta);
		}
		
		override public function clone ():Event
		{
			var evt:TitleBarMouseEvent = new TitleBarMouseEvent(type, bubbles, cancelable, localX, localY, relatedObject, ctrlKey, altKey, shiftKey, buttonDown, delta);
			
			return evt;
		}
	}
}