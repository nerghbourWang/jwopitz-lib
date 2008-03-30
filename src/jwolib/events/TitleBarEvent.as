package jwolib.events
{
	import flash.events.Event;
	
	import mx.core.IUIComponent;

	public class TitleBarEvent extends Event
	{
		/////////////////////////////////////////////////////////////////////////////////
		// CONST
		/////////////////////////////////////////////////////////////////////////////////
		
		public static const TITLE_BAR_CREATED:String = "titleBarCreated";
		public static const TITLE_BAR_CHILDREN_CREATED:String = "titleBarChildrenCreated";
		
		public var titleBarChild:IUIComponent;
		
		public function TitleBarEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
		
		override public function clone ():Event
		{
			var evt:TitleBarEvent = new TitleBarEvent(type, bubbles, cancelable);
			evt.titleBarChild = titleBarChild;
			
			return evt;
		}
	}
}