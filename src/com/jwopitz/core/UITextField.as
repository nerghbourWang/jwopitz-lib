package com.jwopitz.core
{
	import mx.core.IRepeaterClient;
	import mx.core.UITextField;
	
	[ExcludeClass]
	public class UITextField extends mx.core.UITextField implements IRepeaterClient
	{
		public function UITextField ()
		{
			super();
		}
		
		//////////////////////////////////////////////////////////////
		//	INSTANCE INDICES
		//////////////////////////////////////////////////////////////
		
		private var _instanceIndices:Array;
		
		public function get instanceIndices ():Array
		{
			return _instanceIndices ? _instanceIndices.slice(0) : null;
		}
		
		public function set instanceIndices (value:Array):void
		{
			_instanceIndices = value;
		}
		
		//////////////////////////////////////////////////////////////
		//	IS DOCUMENT
		//////////////////////////////////////////////////////////////
		
		public function get isDocument ():Boolean
		{
			return false;
		}
		
		//////////////////////////////////////////////////////////////
		//	REPEATER INDICES
		//////////////////////////////////////////////////////////////
		
		private var _repeaterIndices:Array;
		
		public function get repeaterIndices ():Array
		{
			return _repeaterIndices ? _repeaterIndices.slice() : [];
		}
		
		public function set repeaterIndices (value:Array):void
		{
			_repeaterIndices = value;
		}
		
		//////////////////////////////////////////////////////////////
		//	REPEATERS
		//////////////////////////////////////////////////////////////
		
		private var _repeaters:Array;
		
		public function get repeaters ():Array
		{
			return _repeaters ? _repeaters.slice(0) : [];
		}
		
		public function set repeaters (value:Array):void
		{
			_repeaters = value;
		}
		
		//////////////////////////////////////////////////////////////
		//	MISC.
		//////////////////////////////////////////////////////////////
		
		public function initializeRepeaterArrays (parent:IRepeaterClient):void
		{
			if (parent &&
				instanceIndices &&
				!_instanceIndices &&
				!parent.isDocument)
			{
				_instanceIndices = parent.instanceIndices;
				_repeaters = parent.repeaters;
				_repeaterIndices = parent.repeaterIndices;
			}
		}
	}
}