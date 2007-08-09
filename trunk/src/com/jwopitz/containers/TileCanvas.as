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
package com.jwopitz.containers
{	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ICollectionView;
	import mx.collections.IList;
	import mx.collections.ListCollectionView;
	import mx.collections.XMLListCollection;
	import mx.containers.Canvas;
	import mx.controls.listClasses.IListItemRenderer;
	import mx.controls.listClasses.TileListItemRenderer;
	import mx.core.ClassFactory;
	import mx.core.Container;
	import mx.core.DragSource;
	import mx.core.IFactory;
	import mx.core.IFlexDisplayObject;
	import mx.effects.Move;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	import mx.events.DragEvent;
	import mx.events.PropertyChangeEvent;
	import mx.managers.DragManager;
	
	[Event (name='columnsChange', type='flash.events.Event')]
	[Event (name='rowsChange', type='flash.events.Event')]
	
	/**
	 * A TileCanvas container lays out its children in a grid of equal-sized cells based on the columnWidth and rowHeight values. 
	 * A TileCanvas container's direction property determines whether its cells are laid out horizontally or vertically, 
	 * beginning from the upper-left corner of the TileCanvas container.
	 */
	public class TileCanvas extends Canvas
	{
		//
		//properties
		//-----------------------------------------------------------//
		protected var _columns:int = 1;
		protected var _columnWidth:int = 50;
		protected var _columnGap:int = 5;
		
		protected var _rows:int = 1;
		protected var _rowHeight:int = 50;
		protected var _rowGap:int = 5;
		
		protected var _direction:String = 'horizontal';
		
		protected var _dataProvider:ListCollectionView;
		
		protected var _currentItemCount:int = 0;
		protected var _itemRenderer:IFactory;
		protected var _itemAddOn:Function = defaultItemAddOn;
		protected var _items:ArrayCollection;
		protected var _filteredItems:Array;
		
		protected var _mouseDownPt:Point;
		protected var _mouseOverItem:Container;
		protected var _draggedItem:Container;
		
		protected var _isPressed:Boolean = false;
		protected var _dragEnabled:Boolean = false;
		protected var _dragMoveEnabled:Boolean = false;
		protected var _dropEnabled:Boolean = false;
		protected var _isManualViewUpdate:Boolean = false; //used to supress normal adding and removing evt handlers
		
		/**
		 * Registers the x and y coordinates where new instances created by the itemRenderer will originate from.
		 */
		public var itemSpawnPoint:Point;
		
		public var enableAutoUpdate:Boolean = true;
		public var enableMoveOnRefresh:Boolean = true; //allows move animation on refresh of data
		public var enableRefreshOnMove:Boolean = true; //allows move to act as item sorting
		
		//
		//static methods
		//-----------------------------------------------------------//
				
		//
		//methods
		//-----------------------------------------------------------//
		/**
		 * Constructor
		 */
		public function TileCanvas ()
		{
			super();
			
			itemSpawnPoint = new Point(columnGap, rowGap);
			
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			
			itemRenderer = new ClassFactory(TileListItemRenderer);
			
		}	
		
		/**
		 * Updates the number of actual rows and columns based on the number of items in the dataProvider.
		 */
		protected function updateRowsAndColumns ():void
		{
			if (!_dataProvider)
				return;
				
			if (direction == 'horizontal')
			{
				_rows = Math.ceil(_dataProvider.length / columns);
				dispatchEvent(new Event('rowsChange'));
			} 
			else
			{
				_columns = Math.ceil(_dataProvider.length / rows);
				dispatchEvent(new Event('columnsChange'));
			}
		}
		
		/**
		 * Called for every item in the dataProvider to retrieve the appropriate x and y coordinates to move to.
		 * 
		 * @param columnIndex The column position of the item.
		 * @param rowIndex The row position of the item.
		 * 
		 * @return The actual x and y coordinates based on the columnIndex and rowIndex for the item.
		 */
		protected function calculateItemPosition (columnIndex:int, rowIndex:int):Point
		{
			/*var xTo:Number = columnGap;
			var yTo:Number = rowGap;
			
			if (direction == 'horizontal'){
				if (columnIndex != 0){
					xTo += columnIndex * columnWidth;
					xTo += columnIndex * columnGap;
				}
				if (rowIndex != 0){
					yTo += rowIndex * rowHeight;
					yTo += rowIndex * rowGap;
				}
			} else {
				if (rowIndex != 0){
					xTo += rowIndex * columnWidth;
					xTo += rowIndex * columnGap;
				}
				if (columnIndex != 0){
					yTo += columnIndex * rowHeight;
					yTo += columnIndex * rowGap;
				}
			}*/
			
			var xTo:Number = columnGap;
			if (columnIndex != 0)
			{
				xTo += columnIndex * columnWidth;
				xTo += columnIndex * columnGap;
			}
			
			var yTo:Number = rowGap;
			if (rowIndex != 0)
			{
				yTo += rowIndex * rowHeight;
				yTo += rowIndex * rowGap;
			}
			
			return new Point(xTo, yTo);
		}
		
		/**
		 * Iterates through each item in the dataProvider to determine its column and row index based on the its position within
		 * the context of the maximum allowed columns or maximum allowed rows.
		 * 
		 * @see calculateItemPosition
		 */
		protected function updateItemLocations ():void
		{
			trace('updateItemLocations');
			if (!_dataProvider)
				return;
			
			var count:int = 0
			var i:int = 0;
			for (i; i < rows; i++)
			{
				var j:int = 0;
				for (j; j < columns; j++)
				{	
					if (count == _dataProvider.length)
						return;
					
					var item:Container = _items[count] as Container;	
					var pt:Point = calculateItemPosition(j, i);
					
					if (item && item.x != pt.x || item.y != pt.y)
					{
						var m:Move = new Move(item);
						m.xTo = pt.x;
						m.yTo = pt.y;
						m.play();
					}
					
					count++
				}
			}
		}
		
		/**
		 * If <code>enableRefreshOnMove == true</code> then a drag and drop operation will trigger a 
		 * reordering of the data in the dataProvider to reflect the data order in the list. 
		 */
		protected function updateDataProviderItems ():void
		{
			var tempArray:Array = new Array();
			var i:int = 0;
			for (i; i < _items.length; i++)
			{
				var item:Container = _items.getItemAt(i) as Container;
				tempArray[i] = item.data;
			}
			
			for (i = 0; i < _dataProvider.length; i++)
			{
				_dataProvider[i] = tempArray[i];
			}
		}
		
		/**
		 * A convenience method for creating new instances from the itemRenderer and initializing certain properties.
		 * 
		 * @return A new instance from the itemRenderer.
		 */
		protected function getItemInstance ():Container
		{
			var item:Container = itemRenderer.newInstance() as Container;
			item.owner = this;
			item.x = itemSpawnPoint.x;
			item.y = itemSpawnPoint.y;
			item.width = columnWidth;
			item.height = rowHeight;
			
			itemAddOn(item);
			return item;
		}
		
		/**
		 * Retreives the item under the mouse.
		 * 
		 * @return The item under the mouse.
		 */
		protected function getItemUnderMouse ():Container
		{
			var pt:Point = localToGlobal(_mouseDownPt);
			var i:int = 0;
			for (i; i < _items.length; i++)
			{
				var item:Container = _items.getItemAt(i) as Container;
				if (item.hitTestPoint(pt.x, pt.y))
					return item;
			}
			return null;
		}
		
		/**
		 * An empty placeholder method called on each new instance generated from the itemRenderer.
		 * 
		 * @param value The instance genereated from the itemRendere in which to add functionality.
		 */
		protected function defaultItemAddOn (value:Container):void
		{
			//do nothing
		}
								
		//
		//collection evt handler methods
		//-----------------------------------------------------------//
		/**
		 * @private 
		 */
		protected function onCollectionChange_dataProviderHandler (evt:CollectionEvent):void
		{
			switch (evt.kind)
			{
				case CollectionEventKind.ADD:
				{
					collectionChange_addLogic(evt);
					break;
				}
				
				case CollectionEventKind.MOVE:
				{
					collectionChange_moveLogic(evt);
					break;
				}
				
				case CollectionEventKind.REFRESH:
				{
					collectionChange_refreshLogic(evt);
					break;
				}
				
				case CollectionEventKind.REMOVE:
				{
					collectionChange_removeLogic(evt);
					break;
				}
				
				case CollectionEventKind.REPLACE:
				{
					//collectionChange_replaceLogic();
					break;
				}
				
				case CollectionEventKind.RESET:
				{
					collectionChange_resetLogic(evt);
					break;
				}
				
				case CollectionEventKind.UPDATE:
				{
					collectionChange_updateLogic(evt);
					break;
				}
				
				default:
					//do nothing;
			}
		}
		
		/**
		 * @private 
		 */
		protected function collectionChange_addLogic (evt:CollectionEvent):void
		{
			trace('collectionChange_addLogic')
			if (_isManualViewUpdate)
				return;
			
			var changeItemsCount:int = evt.items.length;
			var startingIndex:int = evt.location;
			var item:Container;
			var i:int = 0;
			for (i; i < changeItemsCount; i++)
			{
				item = getItemInstance();
				item.data = _dataProvider.getItemAt(startingIndex + i);
				_items.addItemAt(item, startingIndex + i);
				addChild(item);
			}
			
			updateRowsAndColumns();
			updateItemLocations();
		}
		
		/**
		 * @private 
		 */
		protected function collectionChange_moveLogic (evt:CollectionEvent):void
		{
			trace('collectionChange_moveLogic');
			if (_isManualViewUpdate)
			{
				//need to update item indices in _items
				var item:Container = _items.removeItemAt(evt.oldLocation) as Container;
				_items.addItemAt(item, evt.location);
				
				_isManualViewUpdate = false;
			}
			
			updateRowsAndColumns();
			updateItemLocations();
			
			if (enableRefreshOnMove)
				updateDataProviderItems();
		}
		
		/**
		 * @private 
		 */
		protected function collectionChange_refreshLogic (evt:CollectionEvent):void
		{
			trace('collectionChange_refreshLogic');
			var item:Container;
			var tempArray:Array = new Array();
			var i:int = 0;
			if (!enableMoveOnRefresh && _dataProvider.filterFunction == null)
			{
				for (i; i < _items.length; i++)
				{
					item = _items.getItemAt(i) as Container;
					item.data = _dataProvider.getItemAt(i);
				}
			} 
			else if (_dataProvider.filterFunction == null)
			{
				for (i; i < _items.length; i++)
				{
					item = _items.getItemAt(i) as Container;
					var index:int = _dataProvider.getItemIndex(item.data);
					tempArray[index] = item;
				}
				_items = new ArrayCollection(tempArray);
			}
			else
			{
				//do nothing			
			}
			
			updateRowsAndColumns();
			updateItemLocations();
		}
		
		/**
		 * @private 
		 */
		protected function collectionChange_removeLogic (evt:CollectionEvent):void
		{
			trace('collectionChange_removeLogic');
			if (_isManualViewUpdate)
				return;
			
			var changeItemsCount:int = evt.items.length;
			var startingIndex:int = evt.location;
			var item:Container;
			var i:int = 0;
			for (i; i < changeItemsCount; i++)
			{
				item = _items.removeItemAt(startingIndex) as Container;
				removeChild(item);
			}
			
			updateRowsAndColumns();
			updateItemLocations();
		}
		
		/**
		 * @private 
		 */		
		protected function collectionChange_resetLogic (evt:CollectionEvent):void
		{
			trace('collectionChange_resetLogic');
			removeAllChildren();
			_items = new ArrayCollection();
			_currentItemCount = 0;
						
			var i:int = 0;
			for (i; i < _dataProvider.length; i++)
			{
				var item:Container = getItemInstance();
				item.data = _dataProvider.getItemAt(_currentItemCount);
				item.x = 0;
				item.y = 0;
				
				_items.addItem(item);
				addChild(item);			
				_currentItemCount++;
			}
			
			updateRowsAndColumns();
			updateItemLocations();		
		}
		
		/**
		 * @private 
		 */
		protected function collectionChange_updateLogic (evt:CollectionEvent):void
		{
			trace('collectionChange_updateLogic');
			var i:int = 0;
			for (i; i < evt.items.length; i++)
			{
				var updateEvt:PropertyChangeEvent = evt.items[i] as PropertyChangeEvent;
				var itemIndex:int = _dataProvider.getItemIndex(updateEvt.source);
				
				var item:Container = _items.getItemAt(itemIndex) as Container;
				item.data = _dataProvider.getItemAt(itemIndex);
			}
		}
		
		//
		//drag evt handler methods
		//-----------------------------------------------------------//
		/**
		 * @private 
		 */
		protected function onDragComplete (evt:DragEvent):void
		{
			//do nothing
		}
		
		/**
		 * @private 
		 */
		protected function onDragDrop (evt:DragEvent):void
		{
			if (!dataProvider)
				dataProvider = [];
			
			if (evt.dragSource.hasFormat('items'))
			{
				_mouseDownPt = new Point(evt.localX, evt.localY);
				
				var i:int = dataProvider.length;
				if (evt.dragInitiator == this && dataProvider.length > 0)
					i--;
								
				_mouseOverItem = getItemUnderMouse();
				if (_mouseOverItem)
					i = _items.getItemIndex(_mouseOverItem);
				
				if (evt.action == DragManager.MOVE && evt.dragInitiator == this)
				{
					_isManualViewUpdate = true;
					
					//update the dataProvider
					var oldIndex:int = _items.getItemIndex(_draggedItem);
					var data:Object = _dataProvider.removeItemAt(oldIndex);
					_dataProvider.addItemAt(data, i);
					
					//then update the view via a move-Change event
					var collectionEvt:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
					collectionEvt.kind = CollectionEventKind.MOVE;
					collectionEvt.location = i;
					collectionEvt.oldLocation = oldIndex;
					collectionEvt.items = new Array(_draggedItem);
					
					collectionChange_moveLogic(collectionEvt);
					dispatchEvent(collectionEvt);
					return;
				}
				
				if (evt.action == DragManager.COPY && evt.dragInitiator == this)
				{
					oldIndex = _items.getItemIndex(_draggedItem);
					var dataToCopy:Object = _dataProvider.getItemAt(oldIndex);
				}
			}
		}
		
		/**
		 * @private 
		 */
		protected function onDragEnter (evt:DragEvent):void
		{
			if (evt.dragSource.hasFormat('items'))
			{
				DragManager.acceptDragDrop(this);
				DragManager.showFeedback(evt.ctrlKey ? DragManager.COPY : DragManager.MOVE);
				return;
			}
			
			DragManager.showFeedback(DragManager.NONE);
		}
		
		/**
		 * @private 
		 */
		protected function onDragExit (evt:DragEvent):void
		{
			DragManager.showFeedback(DragManager.NONE);
		}
		
		/**
		 * @private 
		 */
		protected function onDragOver (evt:DragEvent):void
		{
			if (evt.dragSource.hasFormat('items'))
			{
				DragManager.showFeedback(evt.ctrlKey ? DragManager.COPY : DragManager.MOVE);
				return;
			}
			
			DragManager.showFeedback(DragManager.NONE);
		}
		
		/**
		 * @private 
		 */
		protected function onDragStart (evt:DragEvent):void
		{
			var data:Object = IListItemRenderer(evt.draggedItem).data;
			
			var dragSource:DragSource = new DragSource();
			dragSource.addData(data, 'items');
			
			var bitmap:Bitmap = SpriteUtil.render(IListItemRenderer(evt.draggedItem));
			
			var dragProxy:Container = new Container();
			dragProxy.width = evt.draggedItem.width;
			dragProxy.height = evt.draggedItem.height;
			dragProxy.rawChildren.addChild(bitmap);
						
			DragManager.doDrag(evt.dragInitiator, dragSource, evt, dragProxy);
		}
		
		//
		//mouse evt handler methods
		//-----------------------------------------------------------//
		/**
		 * @private 
		 */
		protected function onMouseDown (evt:MouseEvent):void
		{
			if (!enabled)
				return;
			
			_isPressed = true;
			
			var pt:Point = new Point(evt.localX, evt.localY);
			pt = DisplayObject(evt.target).localToGlobal(pt);
			_mouseDownPt = globalToLocal(pt);
			
			systemManager.addEventListener(MouseEvent.MOUSE_UP, onMouseUp, true);
		}
		
		/**
		 * @private 
		 */
		protected function onMouseMove (evt:MouseEvent):void
		{
			if (!enabled || !_dataProvider || _dataProvider.length < 1)
				return;
			
			if (_isPressed)
			{
				if (dragEnabled && !DragManager.isDragging && _mouseDownPt)
				{	
					_draggedItem = getItemUnderMouse();
					if (_draggedItem == this || _draggedItem == null)
						return;
					
					var pt:Point = new Point(evt.localX, evt.localY);
					pt = DisplayObject(evt.target).localToGlobal(pt);
					_mouseDownPt = globalToLocal(pt);
									
					var dragEvt:DragEvent = new DragEvent(DragEvent.DRAG_START);
					dragEvt.draggedItem = _draggedItem;
					dragEvt.dragInitiator = this;
					dragEvt.localX = _mouseDownPt.x - _draggedItem.x;
					dragEvt.localY = _mouseDownPt.y - _draggedItem.y;
					dragEvt.buttonDown = true;
					dispatchEvent(dragEvt);
				}
			}
		}
		
		/**
		 * @private 
		 */
		protected function onMouseUp (evt:MouseEvent):void
		{
			if (!enabled)
				return;
			
			systemManager.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp, true);
			
			_isPressed = false;
			_mouseDownPt = null;
		}
		
		//
		//getters & setters
		//-----------------------------------------------------------//
		
		/**
		 * The maximum number of columns allowed.  Once the number of items in the dataProvider exceeds the maxColumns per row,
		 * it positions the items in excess in the next row. This is dependant of the value of <code>direction</code>.
		 */
		[Bindable (event='columnsChange')]
		public function get columns ():int
		{
			return _columns;
		}
		/**
		 * @private
		 */
		public function set columns (value:int):void
		{
			//trace('set columns');
			_columns = value;
			updateRowsAndColumns();
			updateItemLocations();
			dispatchEvent(new Event('columnsChange'));
		}
		
		/**
		 * The width of the columns.  Each item in the dataProvider will be rendered to this width.
		 */
		public function get columnWidth ():int
		{
			return _columnWidth;
		}
		/**
		 * @private 
		 */
		public function set columnWidth (value:int):void
		{
			//trace('set columnWidth');
			_columnWidth = value;
			updateRowsAndColumns();
			updateItemLocations();
		}
		
		/**
		 * The amount of spacing between columns.
		 */
		public function get columnGap ():int
		{
			return _columnGap;
		}
		/**
		 * @private 
		 */
		public function set columnGap (value:int):void
		{
			//trace('set columnGap');
			_columnGap = value;
			updateRowsAndColumns();
			updateItemLocations();
		}
		
		/**
		 * The maximum number of rows allowed.  Once the number of items in the dataProvider exceeds the maxRows per column,
		 * it positions the items in excess in the next column.  This is dependant of the value of <code>direction</code>. 
		 */
		[Bindable (event='rowsChange')]
		public function get rows ():int
		{
			return _rows;
		}
		/**
		 * @private 
		 */
		public function set rows (value:int):void
		{
			//trace('set rows');
			_rows = value;
			updateRowsAndColumns();
			updateItemLocations();
			dispatchEvent(new Event('rowsChange'));
		}
		
		/**
		 * The height of the rows.  Each item in the dataProvider will be rendered to this height.
		 */
		public function get rowHeight ():int
		{
			return _rowHeight;
		}
		/**
		 * @private 
		 */
		public function set rowHeight (value:int):void
		{
			//trace('set rowHeight');
			_rowHeight = value;
			updateRowsAndColumns();
			updateItemLocations();
		}
		
		/**
		 * The amount of spacing between rows.
		 */
		public function get rowGap ():int
		{
			return _rowGap;
		}
		/**
		 * @private 
		 */
		public function set rowGap (value:int):void
		{
			//trace('set rowGap');
			_rowGap = value;
			updateRowsAndColumns();
			updateItemLocations();
		}
		
		/**
		 * Determines how children are placed in the container.
		 */
		[Bindable]
		public function get direction ():String
		{
			return _direction;
		}
		/**
		 * @private 
		 */
		public function set direction (value:String):void
		{
			//trace('set direction');
			_direction = value; //currently always set to horizontal;
			updateRowsAndColumns();
			updateItemLocations();
		}
		
		/**
		 * The set of data to be viewed.
		 */
		[Bindable('collectionChange')]
		[Inspectable(category="Data", defaultValue="undefined")]
		public function get dataProvider ():Object
		{
			return _dataProvider;
		}
		/**
		 * @private 
		 */
		public function set dataProvider (value:Object):void
		{
			if (_dataProvider)
				_dataProvider.removeEventListener(CollectionEvent.COLLECTION_CHANGE, onCollectionChange_dataProviderHandler);
			
			if (value is Array)
			{
				_dataProvider = new ArrayCollection (value as Array);
			} 
			else if (value is ICollectionView)
			{
				_dataProvider = ListCollectionView(value);
			}
			else if (value is IList)
			{
				_dataProvider = new ListCollectionView(value as IList);
			} 
			else if (value is XMLList)
			{
				_dataProvider = new XMLListCollection(value as XMLList);
			} 
			else if (value is XML)
			{
				var xmlList:XMLList = new XMLList();
				xmlList += value;
				_dataProvider = new XMLListCollection(xmlList);
			}
			else
			{
				_dataProvider = new ArrayCollection([value]); 
			}
			
			if (enableAutoUpdate)
				_dataProvider.enableAutoUpdate();
			else
				_dataProvider.disableAutoUpdate();
			
			_dataProvider.createCursor();
			_dataProvider.addEventListener(CollectionEvent.COLLECTION_CHANGE, onCollectionChange_dataProviderHandler);
			
			var evt:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
			evt.kind = CollectionEventKind.RESET;
			onCollectionChange_dataProviderHandler(evt);
			dispatchEvent(evt);
			
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
		}
		
		/**
		 * The custom item renderer for the control.
		 */
		public function get itemRenderer ():IFactory
		{
			return _itemRenderer;
		}
		/**
		 * @private 
		 */
		public function set itemRenderer (value:IFactory):void
		{
			_itemRenderer = value;
		}
		
		/**
		 * Serves as a place to add extra functionality to the items generated from the itemRenderer.  
		 * For instance, it may be desired to have each item have a context menu on mouseEvents.
		 * A custom addOn function would be used to achieve this.
		 * The addOn function's signature is expected as <code>function (value:Container):void</code> 
		 */
		public function get itemAddOn ():Function
		{
			return _itemAddOn;
		}
		/**
		 * @private
		 */
		public function set itemAddOn (value:Function):void
		{
			_itemAddOn = value;
		}
		
		/**
		 * A flag that indicates whether you can drag items out of this control and drop them on other controls.
		 */
		public function get dragEnabled ():Boolean
		{
			return _dragEnabled;
		}
		/**
		 * @private  
		 */
		public function set dragEnabled (value:Boolean):void
		{
			if (_dragEnabled && !value)
			{
				removeEventListener(DragEvent.DRAG_START, onDragStart);
				removeEventListener(DragEvent.DRAG_COMPLETE, onDragComplete);
			}
			
			_dragEnabled = value;
			
			if (value)
			{
				addEventListener(DragEvent.DRAG_START, onDragStart);
				addEventListener(DragEvent.DRAG_COMPLETE, onDragComplete);
			}
		}
		
		/**
		 * A flag that indicates whether items can be moved instead of just copied from the control as part of a drag-and-drop operation.
		 */
		public function get dragMoveEnabled ():Boolean
		{
			return _dragMoveEnabled;
		}
		/**
		 * @private 
		 */
		public function set dragMoveEnabled (value:Boolean):void
		{
			_dragMoveEnabled = value;
		}
		
		/**
		 * A flag that indicates whether dragged items can be dropped onto the control.
		 */
		public function get dropEnabled ():Boolean
		{
			return _dropEnabled;
		}
		/**
		 * @private 
		 */
		public function set dropEnabled (value:Boolean):void
		{
			if (_dropEnabled && !value)
			{
				removeEventListener(DragEvent.DRAG_DROP, onDragDrop);
				removeEventListener(DragEvent.DRAG_ENTER, onDragEnter);
				removeEventListener(DragEvent.DRAG_EXIT, onDragExit);
				removeEventListener(DragEvent.DRAG_OVER, onDragOver);
			}
			
			_dropEnabled = value;
			
			if (value)
			{
				addEventListener(DragEvent.DRAG_DROP, onDragDrop);
				addEventListener(DragEvent.DRAG_ENTER, onDragEnter);
				addEventListener(DragEvent.DRAG_EXIT, onDragExit);
				addEventListener(DragEvent.DRAG_OVER, onDragOver);
			}
		} 
		
	}
}

import flash.display.Bitmap;
import flash.display.BitmapData;

import mx.core.IFlexDisplayObject;

class SpriteUtil
{
	
	/**
	 * Renders a dragProxy image of the item being dragged.
	 * 
	 * @param target The item being dragged.
	 * 
	 * @return An image copy of the item being dragged.
	 */
	public static function render (target:IFlexDisplayObject):Bitmap
	{
		var data:BitmapData = new BitmapData(target.width, target.height);
        data.draw(target);
        var bitmap:Bitmap = new Bitmap(data);
        return bitmap;
    }
}