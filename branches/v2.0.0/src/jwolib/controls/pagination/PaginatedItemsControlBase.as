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
package jwolib.controls.pagination
{
	import flash.events.Event;
	
	import mx.collections.IList;
	import mx.containers.Box;
	
	[Event(name="dataProviderChanged", type="flash.events.Event")]
	[Event(name="itemsPerPageChanged", type="flash.events.Event")]
	[Event(name="selectedIndexChanged", type="flash.events.Event")]
	[Event(name="selectedItemsChanged", type="flash.events.Event")]
	
	/**
	 * PaginatedItemsControlBase is the base class for creating controls for paginated data.
	 * 
	 * <p>In order to facilitate a variety of design implementations,
	 * the developer should extend PaginatedItemsControlBase and add the actual controls for changing the selectedIndex.</p>
	 */
	public class PaginatedItemsControlBase extends Box implements IPaginatedItemsControl
	{
		/**
		 * @private
		 */ 
		public function PaginatedItemsControlBase ()
		{
			super();
			
			horizontalScrollPolicy = "off";
			verticalScrollPolicy = "off";
		}
		
		//////////////////////////////////////////////////////////////
		//	ITEMS PER PAGE
		//////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		private var _itemsPerPage:int;
		
		/**
		 * @private
		 */
		protected var itemsPerPageChanged:Boolean = false;
		
		/**
		 * The number of items per page of data.
		 */
		[Bindable("itemsPerPageChanged")]
		public function get itemsPerPage ():int
		{
			return _itemsPerPage;
		}
		
		/**
		 * @private
		 */
		public function set itemsPerPage (value:int):void
		{
			if (_itemsPerPage != value)
			{
				_itemsPerPage = value;
				itemsPerPageChanged = true;
				
				invalidateProperties();
				invalidateSize();
				invalidateDisplayList();
				
				dispatchEvent(new Event("itemsPerPageChanged"));
			}
		}
		
		//////////////////////////////////////////////////////////////
		//	DATA PROVIDER
		//////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		private var _dataProvider:Object;
		
		/**
		 * @private
		 */
		protected var dataProviderChanged:Boolean = false;
		
		/**
		 * The set of data to be paginated based on items per page.  This value must be of type Array or mx.collections.IList or a runtime error will occur.
		 */
		[Bindable("dataProviderChanged")]
		public function get dataProvider ():Object
		{
			return _dataProvider;
		}
		
		/**
		 * @private
		 */
		public function set dataProvider (value:Object):void
		{
			if (_dataProvider != value)
			{
				_dataProvider = value;
				dataProviderChanged = true;
				
				invalidateProperties();
				invalidateSize();
				invalidateDisplayList();
				
				dispatchEvent(new Event("dataProviderChanged"));
			}
		}
		
		/**
		 * The internal data set used by the component in order to represent the paginated data.
		 */
		protected var formattedDataProvider:Array = [];
		
		/**
		 * Takes a data source and formats it into a new array based on the itemsPerPage.
		 * 
		 * @param source The data source to be formatted.
		 * @returns Array A new formatted array that represents paginated data.
		 */
		protected function generateFormattedDataProvider (source:Object):Array
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
			pgSets = (tempSource.length <= itemsPerPage)?
				1:
				Math.ceil(tempSource.length / itemsPerPage);
			
			var i:int;
			var j:int;
			var k:int;
			var obj:Object;
			for (i; i < pgSets; i++)
			{
				pgSet = [];
				
				for (j; j < itemsPerPage; j++)
				{
					k = i * itemsPerPage + j;
					if (k < tempSource.length)
						pgSet.push(tempSource[k]);
						
					else
						break;
				}
				
				j = 0;
				
				obj = {data:pgSet};
				a.push(obj);
			}
			
			return a;
		}
		
		/**
		 * A convenience accessor for subclasses to use in order to calculate the selectedIndex based on various control implementations.
		 */
		[Bindable]
		protected var pgSets:int;
		
		//////////////////////////////////////////////////////////////
		//	SELECTED INDEX
		//////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		private var _selectedItems:Array = [];
		
		/**
		 * The current set of data represented by the selected index.
		 * Other UI componenets will use this to render the data.
		 */
		[Bindable("selectedItemsChanged")]
		public function get selectedItems ():Array
		{
			return _selectedItems;
		}
		
		/**
		 * @private
		 */
		protected function setSelectedItems (value:Array):void
		{
			_selectedItems = value;
			
			dispatchEvent(new Event("selectedItemsChanged"));
		}
		
		//////////////////////////////////////////////////////////////
		//	SELECTED INDEX
		//////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		private var _selectedIndex:int;
		
		/**
		 * @private
		 */
		protected var selectedIndexChanged:Boolean = false;
		
		/**
		 * The index value of the current set of data represented by the selected items.
		 */
		[Bindable("selectedIndexChanged")]
		public function get selectedIndex ():int
		{
			return _selectedIndex;
		}
		
		/**
		 * @private
		 */
		public function set selectedIndex (value:int):void
		{
			if (_selectedIndex != value)
			{
				_selectedIndex = value;
				selectedIndexChanged = true;
				
				invalidateProperties();
				invalidateSize();
				invalidateDisplayList();
				
				dispatchEvent(new Event("selectedIndexChanged"));
			}
		}
		
		//////////////////////////////////////////////////////////////
		//	OVERRIDES
		//////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		override protected function commitProperties ():void
		{
			super.commitProperties();
			
			if (itemsPerPageChanged)
			{
				//trickle down to next if {} block
				dataProviderChanged = true;
				
				itemsPerPageChanged = false;
			}
			
			if (dataProviderChanged)
			{
				formattedDataProvider = generateFormattedDataProvider(dataProvider);
				
				selectedIndex = 0;
				if (formattedDataProvider && formattedDataProvider.length > 0)
				{
					if (formattedDataProvider[0].hasOwnProperty("data"))
					{
						var a:Array = formattedDataProvider[selectedIndex].data as Array;
						setSelectedItems(a);
					}
				}
				
				dataProviderChanged = false;
			}
			
			if (selectedIndexChanged)
			{
				a = formattedDataProvider[selectedIndex].data as Array;
				setSelectedItems(a);
				
				selectedIndexChanged = false;
			}
		}
	}
}