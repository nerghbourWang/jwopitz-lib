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
package com.jwopitz.controls
{
	import flash.events.Event;
	
	import mx.collections.IList;
	import mx.controls.LinkBar;
	import mx.core.EventPriority;
	import mx.events.ItemClickEvent;

	public class PagedList extends LinkBar
	{		
		//////////////////////////////////////////////////////////////////////
		//	NEXT / PREV BUTTONS
		//////////////////////////////////////////////////////////////////////
		
		protected var showNextPrevBtns:Boolean = true;
		
		public function get showNavButtons ():Boolean
		{
			return showNextPrevBtns;
		}
		
		public function set showNavButtons (value:Boolean):void
		{
			if (showNextPrevBtns != value)
			{
				showNextPrevBtns = value;
				super.dataProvider = generateActualDataProvider(dataProvider);
				
				invalidateProperties();
				invalidateSize();
				invalidateDisplayList();
			}
		}
		
		protected var prevBtnLbl:String = "<<";
		
		public function get prevButtonLabel ():String
		{
			return prevBtnLbl;
		}
		
		public function set prevButtonLabel (value:String):void
		{
			if (prevBtnLbl != value)
			{
				prevBtnLbl = value;
				super.dataProvider = generateActualDataProvider(dataProvider);
				
				invalidateProperties();
				invalidateSize();
				invalidateDisplayList();
			}
		}
		
		protected var nextBtnLbl:String = ">>";
		
		public function get nextButtonLabel ():String
		{
			return nextBtnLbl;
		}
		
		public function set nextButtonLabel (value:String):void
		{
			if (nextBtnLbl != value)
			{
				nextBtnLbl = value;
				super.dataProvider = generateActualDataProvider(dataProvider);
				
				invalidateProperties();
				invalidateSize();
				invalidateDisplayList();
			}
		}
		
		//////////////////////////////////////////////////////////////////////
		//	SELECTED ITEMS
		//////////////////////////////////////////////////////////////////////
		
		protected var prevIndex:uint;
		
		protected var selectedDataProvider:Array = [];
		
		[Bindable("selectedItemsChanged")]
		public function get selectedItems ():Array
		{
			return selectedDataProvider;
		}
		
		protected function updateSelectedItems (index:uint):void
		{
			var selectedDP:Array;
			var data:Object = formattedDataProvider[index].data;
			if (data is int)
			{
				if (data == 1)
					index = Math.min(prevIndex + data, formattedDataProvider.length - 2);
					
				else if (data == -1)
					index = Math.max(prevIndex + data, 1);
					
				selectedDP = formattedDataProvider[index].data as Array;
			}
			
			else if (data is Array)
				selectedDP = data as Array;
			
			resetNavItems();
			selectedIndex = index;
			prevIndex = index;
			selectedDataProvider = selectedDP;
			
			invalidateProperties();
			invalidateDisplayList();
			
			dispatchEvent(new Event("selectedItemsChanged"));
		}
		
		//////////////////////////////////////////////////////////////////////
		//	RESULTS PER PAGE
		//////////////////////////////////////////////////////////////////////
		
		protected var resultsPerPg:uint = 10;
		
		[Bindable("resultsPerPageChanged")]
		public function get resultsPerPage ():uint
		{
			return resultsPerPg;
		}
		
		public function set resultsPerPage (value:uint):void
		{
			if (resultsPerPg != value)
			{
				resultsPerPg = value;
				super.dataProvider = generateActualDataProvider(dp);
				
				invalidateProperties();
				invalidateSize();
				invalidateDisplayList();
				
				dispatchEvent(new Event("resultsPerPageChanged"));
			}
		}
		
		//////////////////////////////////////////////////////////////////////
		//	DATA PROVIDER
		//////////////////////////////////////////////////////////////////////
		
		protected var dp:Object;
		
		override public function get dataProvider ():Object
		{
			return dp;
		}
		
		override public function set dataProvider (value:Object):void
		{
			if (dp != value)
			{
				dp = value;
				super.dataProvider = generateActualDataProvider(dp);
				
				invalidateProperties();
				invalidateSize();
				invalidateDisplayList();
			}
		}
		
		protected var formattedDataProvider:Array = [];
		
		protected function generateActualDataProvider (source:Object):Array
		{
			var tempSource:Array = [];
			var a:Array = []; //what we're returning
			
			//we are currently only allowing arrays and mx.collection classes
			if (source &&
				!(source is IList) &&
				!(source is Array))
			{
				throw new Error("source parameter must be one of the following types: Array, IList,");
			}
			
			if (source is IList)
				tempSource = IList(source).toArray();
			
			if (source is Array)
			{
				var item:Object
				for each (item in source as Array)
					tempSource.push(item);
			}
			
			//if it has no length then what's the point
			if (tempSource.length < 1)
				return a;
				
			var pgSet:Array = [];
			var pgSets:uint = (tempSource.length <= resultsPerPage)?
				1:
				Math.ceil(tempSource.length / resultsPerPage);
			
			//adding prev button
			if (pgSets > 1 && showNavButtons)
				a.push({label:prevButtonLabel, data:-1});
			
			var i:int;
			var j:int;
			var k:int;
			var obj:Object;
			for (i; i < pgSets; i++)
			{
				pgSet = [];
				
				for (j; j < resultsPerPage; j++)
				{
					k = i * resultsPerPage + j;
					if (k < tempSource.length)
						pgSet.push(tempSource[k]);
						
					else
						break;
				}
				
				j = 0;
				
				obj = {label:i + 1, data:pgSet};
				a.push(obj);
			}
			
			//adding next button
			if (pgSets > 1 && showNavButtons)
				a.push({label:nextButtonLabel, data:1});
			
			formattedDataProvider = a;
			
			if (pgSets > 1 && showNavButtons)
			{
				prevIndex = 1;
				updateSelectedItems(1);
			}
				
			else
			{
				prevIndex = 0;
				updateSelectedItems(0);
			}
			
			return a;
		}
		
		//////////////////////////////////////////////////////////////////////
		//	CONSTRUCTOR
		//////////////////////////////////////////////////////////////////////
		
		public function PagedList ()
		{
			super();
			
			addEventListener(ItemClickEvent.ITEM_CLICK, onItemClickEvent, false, EventPriority.DEFAULT_HANDLER, false);
		}
		
		protected function onItemClickEvent (evt:ItemClickEvent):void
		{
			updateSelectedItems(evt.index);
		}
	}
}