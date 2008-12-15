/*

Copyright (c) 2008 J.W.Opitz, All Rights Reserved.

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
package com.jwopitz.controls.autoCompleteClasses
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import mx.controls.ComboBox;
	import mx.controls.listClasses.ListBase;
	import mx.core.ClassFactory;
	import mx.events.ListEvent;
	
	[Event(name="itemClick", type="mx.events.ListEvent")]
	[Event(name="typedTextChanged", type="flash.events.Event")]
	
	public class AutoCompleteBase extends ComboBox
	{
		///////////////////////////////////////////////////
		//	IS OPEN
		///////////////////////////////////////////////////
		
		private var _isOpen:Boolean = false;
		
		[Bindable("dropDownStatusChanged")]
		public function get isOpen ():Boolean
		{
			return _isOpen;
		}
		
		public function set isOpen (value:Boolean):void
		{
			if (_isOpen != value)
			{
				_isOpen = value;
				
				invalidateProperties();
				invalidateDisplayList();
				
				dispatchEvent(new Event("dropDownStatusChanged"));
			}
		}
		
		///////////////////////////////////////////////////
		//	TYPED TEXT
		///////////////////////////////////////////////////
		
		private var _typedText:String;
		protected var typedTextChanged:Boolean = false;
		
		[Bindable('typedTextChanged')]
		public function get typedText ():String
		{
			return _typedText;
		}
		
		public function set typedText (value:String):void
		{
			if (_typedText != value)
			{
				_typedText = value;
				typedTextChanged = true;
				
				//how we are passing a reference to what we are searching for
				if (dropdown && ClassFactory(itemRenderer).generator == AutoCompleteListItemRenderer)
					ClassFactory(itemRenderer).properties = {matchString:_typedText};
				
				invalidateProperties();
				invalidateDisplayList();
				
				if (!interceptTypedTextChangedEvent)
					dispatchEvent(new Event('typedTextChanged'));
				
				interceptTypedTextChangedEvent = false;
			}
		}
		
		private var interceptTypedTextChangedEvent:Boolean = false;
		
		public function setTypedText (value:String):void
		{
			interceptTypedTextChangedEvent = true;
			typedText = value;
		}
		
		///////////////////////////////////////////////////
		//	DROPDOWN
		///////////////////////////////////////////////////
		
		private var _dropdown:ListBase;
		
		override public function get dropdown ():ListBase
		{
			var d:ListBase = super.dropdown;
			if (_dropdown != d)
			{
				if (_dropdown)
				{
					_dropdown.removeEventListener(ListEvent.ITEM_CLICK, dropdown_itemClickHandler);
					_dropdown.removeEventListener(KeyboardEvent.KEY_DOWN, dropdown_keyDownHandler);
				}
				
				if (d)
				{
					d.addEventListener(ListEvent.ITEM_CLICK, dropdown_itemClickHandler);
					d.addEventListener(KeyboardEvent.KEY_DOWN, dropdown_keyDownHandler);
				}
				
				_dropdown = d;
			}
			
			return _dropdown;
		}
		
		///////////////////////////////////////////////////
		//	VALIDATION OVERRIDES
		///////////////////////////////////////////////////
		
		override protected function updateDisplayList (unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			if (typedTextChanged)
			{
				textInput.text = typedText
				
				var length:int = textInput.text.length;
				textInput.setSelection(length, length);
				
				typedTextChanged = false;
			}
		}
		
		///////////////////////////////////////////////////
		//	MISC. OVERRIDES
		///////////////////////////////////////////////////
		
		private var _dummyVar:Object;
		public var allowMultipleSelections:Boolean = false;
		
		override public function open ():void
		{
			isOpen = true;
			_dummyVar = dropdown; //triggers the getter
			
			super.open();
		}
		
		override public function close (trigger:Event = null):void
		{
			isOpen = false;
			
			super.close(trigger);
			super.close();
		}
		
		override public function set selectedIndex (value:int):void
		{
			prevIndex = super.selectedIndex;
			super.selectedIndex = value;
		}
		
		override public function set editable (value:Boolean):void
		{
			super.editable = true;
		}
		
		///////////////////////////////////////////////////
		//	EVT HANDLERS
		///////////////////////////////////////////////////
		
		protected function dropdown_itemClickHandler (evt:ListEvent):void
		{
			dispatchEvent(evt);
		}
		
		protected function dropdown_keyDownHandler (evt:KeyboardEvent):void
		{
			if (evt.keyCode == Keyboard.ENTER)
			{
				var evt2:ListEvent = new ListEvent(ListEvent.ITEM_CLICK)
				evt2.rowIndex = selectedIndex;
				
				dispatchEvent(evt2);
			}
		}
		
		override protected function textInput_changeHandler (event:Event):void
		{
			super.textInput_changeHandler(event);
			
			var length:int = textInput.text.length;
			typedText = text;
		}
		
		protected var prevIndex:int;
		
		override protected function keyDownHandler (event:KeyboardEvent):void
		{
			if (event.target == textInput)
				return;
			
			if (!event.ctrlKey)
			{
				if (event.keyCode == Keyboard.UP && prevIndex == 0)
				{
					textInput.text = typedText;
					
					if (dropdown)
						selectedIndex = dropdown.selectedIndex = -1;
				}
				
				if (dropdown && isOpen && event.keyCode == Keyboard.ENTER)
				{
					if (selectedIndex != -1)
					{
						dropdown.dispatchEvent(event.clone());
						
						if (allowMultipleSelections)
						{
							event.stopImmediatePropagation();
							return;
						}
					}
				}
			}
			
			super.keyDownHandler(event);
		}
		
		///////////////////////////////////////////////////
		//	DEFAULT STYLING
		///////////////////////////////////////////////////
		
		static private var isStylingInitialized:Boolean = initializeStyles();
		
		static private function initializeStyles ():Boolean
		{
			return true;
		}
		
		///////////////////////////////////////////////////
		//	CONSTRUCTOR
		///////////////////////////////////////////////////
		
		public function AutoCompleteBase()
		{
			super();
			
			itemRenderer = new ClassFactory(AutoCompleteListItemRenderer);
		}
	}
}