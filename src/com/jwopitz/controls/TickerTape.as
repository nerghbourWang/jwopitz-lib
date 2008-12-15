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
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ICollectionView;
	import mx.collections.IList;
	import mx.collections.IViewCursor;
	import mx.collections.ListCollectionView;
	import mx.collections.XMLListCollection;
	import mx.containers.Box;
	import mx.containers.BoxDirection;
	import mx.controls.Label;
	import mx.core.ClassFactory;
	import mx.core.IDataRenderer;
	import mx.core.IFactory;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	
	[Event(name="dataProviderChanged", type="flash.events.Event")]
	
	public class TickerTape extends Box
	{
		//////////////////////////////////////////////////////////
		//	ITEM RENDERER
		//////////////////////////////////////////////////////////
		
		protected var unusedRenderers:ArrayCollection = new ArrayCollection();
		
		private var itemFactory:IFactory = new ClassFactory(Label);
		protected var itemRendererChanged:Boolean = false;
		
		public function get itemRenderer ():IFactory
		{
			return itemFactory;
		}
		
		public function set itemRenderer (value:IFactory):void
		{
			if (itemFactory != value)
			{
				itemFactory = value;
				itemRendererChanged = true;
				
				invalidateProperties();
				invalidateDisplayList();
			}
		}
		
		//////////////////////////////////////////////////////////
		//	SPEED
		//////////////////////////////////////////////////////////
		
		private var timer:Timer;
		private var timerInterval:int = 125;
		
		private var _speed:int = 5;
		
		public function get speed ():int
		{
			return _speed;
		}
		
		public function set speed (value:int):void
		{
			if (_speed != value)
			{
				_speed = value;
				
				timer.reset();
				timer.start();
			}
		}
		
		//////////////////////////////////////////////////////////
		//	DATA PROVIDER
		//////////////////////////////////////////////////////////
		
		protected var collection:ICollectionView;
		
		protected var dataProviderChanged:Boolean = false;
		
		[Bindable("dataProviderChanged")]
		public function get dataProvider ():Object
		{
			return collection;
		}
		
		public function set dataProvider (value:Object):void
		{
			if (value is Array)
				collection = new ArrayCollection(value as Array);
			
			else if (value is ICollectionView)
				collection = ICollectionView(value);
			
			else if (value is IList)
				collection = new ListCollectionView(IList(value));
			
			else if (value is XMLList)
				collection = new XMLListCollection(value as XMLList);
			
			else
				collection = new ArrayCollection([value]);
			
			collection.addEventListener(CollectionEvent.COLLECTION_CHANGE, collectionChangeHandler, false, 0, true);
			
			var evt:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
			evt.kind = CollectionEventKind.RESET;
			collectionChangeHandler(evt);
			dispatchEvent(evt);
			
			dataProviderChanged = true;
			
			invalidateProperties();
			invalidateDisplayList();
			
			dispatchEvent(new Event("dataProviderChanged"));
		}
		
		//////////////////////////////////////////////////////////
		//	CHILDREN
		//////////////////////////////////////////////////////////
		
		//////////////////////////////////////////////////////////
		//	VALIDATION
		//////////////////////////////////////////////////////////
		
		override protected function commitProperties ():void
		{
			super.commitProperties();
			
			if (itemRendererChanged)
			{
				removeAllChildren();
				unusedRenderers.removeAll();
				
				dataProviderChanged = true;
				itemRendererChanged = false;
			}
			
			if (dataProviderChanged)
			{
				//we need to update the children to reflect the number of the items in the dataProvider
				var diff:int = collection.length - numChildren;
				if (diff > 0)
				{
					var i:int = 0;
					while (i < diff)
					{
						//we need to see if we have any unused renderers to recycle
						if (unusedRenderers.length > 0)
							var renderer:DisplayObject = DisplayObject(unusedRenderers.getItemAt(0));
						
						//we create a new one
						else
							renderer = DisplayObject(itemRenderer.newInstance());
						
						addChild(renderer);
						i++;
					}
				}
				
				else if (diff < 0)
				{
					//we need pop the renderer out of the display list and add to the recycle list
					i = 0;
					while (i < Math.abs(diff))
					{
						if (getChildAt(0) is IDataRenderer)
						{
							renderer = removeChildAt(0);
							
							if (!unusedRenderers.contains(renderer))
								unusedRenderers.addItem(renderer);
						}
						
						i++;
					}
				}
				
				else
				{
					//do nothing since we have the same amount of renderers in the display list as we have items in the collection
				}
				
				//now let's update those visible renderers' data property
				var iterator:IViewCursor = collection.createCursor();
				
				i = 0;
				while (i < numChildren)
				{
					renderer = getChildAt(i);
					if (!iterator.afterLast)
					{
						IDataRenderer(renderer).data = iterator.current;
						iterator.moveNext();
					}
					
					i++;
				}
								
				//dataProviderChanged = false; //defer to UDL
			}
		}
		
		override protected function measure ():void
		{
			super.measure();
			
			if (direction == BoxDirection.HORIZONTAL)
			{
				setStyle("paddingLeft", getExplicitOrMeasuredWidth());
				setStyle("paddingRight", getExplicitOrMeasuredWidth());
				
				setStyle("paddingTop", 0);
				setStyle("paddingBottom", 0);
			}
			
			else
			{
				setStyle("paddingLeft", 0);
				setStyle("paddingRight", 0);
				
				setStyle("paddingTop", getExplicitOrMeasuredHeight());
				setStyle("paddingBottom", getExplicitOrMeasuredHeight());
			}
		}
		
		override protected function updateDisplayList (unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			if (dataProviderChanged)
			{
				callLater(calculateMaxTickerPosition);
				dataProviderChanged = false;
			}
		}
		
		//////////////////////////////////////////////////////////
		//	EVENT HANDLERS
		//////////////////////////////////////////////////////////
		
		protected function collectionChangeHandler (evt:CollectionEvent):void
		{
			dataProviderChanged = true;
			
			invalidateProperties();
			invalidateDisplayList();
		}
		
		protected function timerHandler (evt:TimerEvent):void
		{
			if (direction == BoxDirection.HORIZONTAL)
			{
				if (horizontalScrollPosition >= maxTickerScrollPosition)
					horizontalScrollPosition = 0;
				
				else
					horizontalScrollPosition += speed;
			}
			
			else
			{
				if (verticalScrollPosition >= maxTickerScrollPosition)
					verticalScrollPosition = 0;
				
				else
					verticalScrollPosition += speed;
			}
		}
		
		//////////////////////////////////////////////////////////
		//	SCROLL PROPS
		//////////////////////////////////////////////////////////
		
		public function start ():void
		{
			timer.start();
		}
		
		public function stop ():void
		{
			timer.reset();
		}
		
		public function reset ():void
		{
			timer.reset();
			horizontalScrollPosition = verticalScrollPosition = 0;
		}
		
		//////////////////////////////////////////////////////////
		//	MAX TICKER POSITION
		//////////////////////////////////////////////////////////
		
		private var maxTickerScrollPosition:Number = 0;
		protected var needsMaxTickerUpdate:Boolean = false;
		
		[Bindable("maxTickerPositionChanged")]
		public function get maxTickerPosition ():Number
		{
			return maxTickerScrollPosition;
		}
		
		private function calculateMaxTickerPosition ():void
		{
			var child:DisplayObject = getChildAt(numChildren - 1);
			if (direction == BoxDirection.HORIZONTAL)
				maxTickerScrollPosition = (child.x + child.width + getStyle("paddingRight")) - getExplicitOrMeasuredWidth();
			
			else
				maxTickerScrollPosition = (child.y + child.height + getStyle("paddingBottom")) - getExplicitOrMeasuredHeight();
			
			dispatchEvent(new Event("maxTickerPositionChanged"));
		}
		
		//////////////////////////////////////////////////////////
		//	CONSTRUCTOR
		//////////////////////////////////////////////////////////
		
		public function TickerTape()
		{
			super();
			
			timer = new Timer(timerInterval);
			timer.addEventListener(TimerEvent.TIMER, timerHandler);
			timer.start();
			
			direction = BoxDirection.HORIZONTAL;
			horizontalScrollPolicy = verticalScrollPolicy = "off";
		}
		
	}
}