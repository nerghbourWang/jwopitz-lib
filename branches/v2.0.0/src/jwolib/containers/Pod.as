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
package jwolib.containers
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.containers.Panel;
	import mx.controls.Button;
	import mx.core.EventPriority;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.styles.CSSStyleDeclaration;
	import mx.styles.StyleManager;

	//////////////////////////////////////////////////////////////
	//	STYLES
	//////////////////////////////////////////////////////////////

	/**
     * Sets the vertical alignment of the header children added with addTitleBarComponent and the titleTextField.
     * Values are "top, "middle" and "bottom".
     *
     * @default middle
     */
    [Style(name="headerVerticalAlign", type="String", enumeration="top,middle,bottom", inherit="no")]

    /**
     * Sets the horizontal gap of the header children added with addTitleBarComponent.
     * If no value is set, then the value of horizontalGap will be used for the gap.
     *
     * @default 6
     */
    [Style(name="headerHorizontalGap", type="Number", inherit="no")]

	//////////////////////////////////////////////////////////////
	//	EVENTS
	//////////////////////////////////////////////////////////////

	/**
	 * Dispatched when the user clicks on the header area.
	 */
	[Event(name="gripClick", type="flash.events.MouseEvent")]

	/**
	 * Dispatched when the user presses the mouse button on the header area.
	 */
	[Event(name="gripMouseDown", type="flash.events.MouseEvent")]

	/**
	 * Dispatched when the user moves the mouse over the header area.
	 */
	[Event(name="gripMouseMove", type="flash.events.MouseEvent")]

	/**
	 * Dispatched when the user clicks on the header area.
	 */
	[Event(name="gripMouseOver", type="flash.events.MouseEvent")]

	/**
	 * Dispatched when the user moves the mouse out of the header area.
	 */
	[Event(name="gripMouseOut", type="flash.events.MouseEvent")]

	/**
	 * Dispatched when the user releases the mouse button above the header area.
	 */
	[Event(name="gripMouseUp", type="flash.events.MouseEvent")]

	/**
	 * Dispatched when the user rolls out of the header area.
	 */
	[Event(name="gripRollOut", type="flash.events.MouseEvent")]

	/**
	 * Dispatched when the user rolls over the header area.
	 */
	[Event(name="gripRollOver", type="flash.events.MouseEvent")]

	/**
	 * Pod is an extension of the &lt;mx:Panel&gt; allowing children to be added to the header area
	 * as well as triggering unique mouse events for the purposes of window's based interactions.
	 *
	 * <p>
	 *  <pre>
	 *  &lt;jwo_lib:Pod
	 *    <strong>Styles</strong>
	 *    headerVerticalAlign="top|middle|bottom"
	 *    headerHorizontalGap="2"
	 *    &gt;
	 *    ...
	 *      <i>child tags</i>
	 *    ...
	 *  &lt;/jwo_lib:Pod&gt;
	 *  </pre>
	 * </p>
	 *
	 *  @see mx.containers.Panel
	 */
	public class Pod extends Panel
	{

		/////////////////////////////////////////////////////////////////////////////////
		// CONSTANTS
		/////////////////////////////////////////////////////////////////////////////////

		/*

		2007.10.01 - jwopitz
		The following constants are located here rather than in a seperate MouseEvent subclass for ease of use.
		At some future point these MAY be moved over to a specialized MouseEvent subclass if the need arises.

		*/

		/**
		 * @private
		 */
    	public static const GRIP_CLICK:String = "gripClick";

		/**
		 * @private
		 */
    	public static const GRIP_MOUSE_DOWN:String = "gripMouseDown";

		/**
		 * @private
		 */
    	public static const GRIP_MOUSE_MOVE:String = "gripMouseMove";

		/**
		 * @private
		 */
    	public static const GRIP_MOUSE_OVER:String = "gripMouseOver";

		/**
		 * @private
		 */
    	public static const GRIP_MOUSE_OUT:String = "gripMouseOut";

		/**
		 * @private
		 */
    	public static const GRIP_MOUSE_UP:String = "gripMouseUp";

		/**
		 * @private
		 */
    	public static const GRIP_ROLL_OUT:String = "gripRollOut";

		/**
		 * @private
		 */
    	public static const GRIP_ROLL_OVER:String = "gripRollOver";

		/////////////////////////////////////////////////////////////////////////////////
		// DEFAULT STYLES INIT
		/////////////////////////////////////////////////////////////////////////////////

		/**
		 * @private
		 */
    	private static var defaultStylesInitialized:Boolean = setDefaultStyles();

		/**
		 * @private
		 */
		private static function setDefaultStyles ():Boolean
		{
        	if (!StyleManager.getStyleDeclaration('Pod'))
        	{
        		var s:CSSStyleDeclaration = new CSSStyleDeclaration();
        		s.setStyle('headerVerticalAlign', 'middle');
        		s.setStyle('headerHorizontalGap', 2);

				StyleManager.setStyleDeclaration('Pod', s, true);
        	}

        	return true;
        }

        /////////////////////////////////////////////////////////////////////////////////
		//
		/////////////////////////////////////////////////////////////////////////////////

		/**
		 * @private
		 *
		 * When childeren are added to the header via mxml they are stored here until their parent assets (the header) have been created.
		 */
		protected var creationQueue:Array = [];

		/**
		 * Exposed for declaritive instantiation of title bar assets.  For MXML use only.
		 */
		[ArrayElementType("mx.core.UIComponent")]
		public var titleBarChildren:Array = [];
		
		/**
		 * @private
		 */
		protected var titleBarAssets:Array = [];

		/**
		 * The default class to be used when calling <code>addTitleBarComponent()</code> with no parameter.
		 */
		public var defaultTitleBarComponentClass:Class = Button;

		/**
		 * @private
		 */
		override public function styleChanged (styleProp:String):void
		{
			super.styleChanged(styleProp);

			var allStyles:Boolean = !styleProp || styleProp == "styleName";
			if (allStyles || styleProp == "headerVerticalAlign" || styleProp == "headerHorizontalGap")
			{
				invalidateProperties();
			}
		}

		/**
		 * @private
		 */
		override protected function createChildren ():void
		{
			super.createChildren();

			titleBar.mouseChildren = false;
			assignTitleBarListeners();
			
			var child:UIComponent;
			for each (child in titleBarChildren)
				addTitleBarComponent(child);
				
			titleBarChildren = [];
		}

		/**
		 * @private
		 */
		override protected function layoutChrome (unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.layoutChrome(unscaledWidth, unscaledHeight);

			repositionHeaderElements();
		}

		/**
		 * Assigns default mouse event handlers to the tilte bar area.
		 */
		protected function assignTitleBarListeners ():void
		{
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

		/**
		 * Repositions the child elements of the header.
		 */
		protected function repositionHeaderElements ():void
		{
			var uic:UIComponent;
			var tx:Number = 0; //target x value
			var px:Number = 0; //previous x value
			var ty:Number = 0; //target y value

			var headerVerticalAlign:String = getStyle('headerVerticalAlign');
			var headerHorizontalGap:Number = getStyle('headerHorizontalGap');

			var i:int = 0;
			var l:int = titleBarAssets.length;
			if (l == 0)
				return;

			for (i; i < l; i++)
			{
				uic = titleBarAssets[i] as UIComponent;
				uic.setActualSize(uic.getExplicitOrMeasuredWidth(), uic.getExplicitOrMeasuredHeight());

				if (i == 0)
				{
					tx = unscaledWidth - borderMetrics.right - uic.getExplicitOrMeasuredWidth() - 10;
				}
				else
				{
					tx = px - uic.getExplicitOrMeasuredWidth() - headerHorizontalGap;
				}

				switch(headerVerticalAlign)
				{
					case "top":
					{
						ty = 5;
						break;
					}

					case "bottom":
					{
						ty = getHeaderHeight() - uic.getExplicitOrMeasuredHeight();
						break;
					}

					case "middle":
					default:
					{
						ty = (getHeaderHeight() - uic.getExplicitOrMeasuredHeight()) / 2;
						break;
					}
				}

				if (uic.x != tx || uic.y != ty)
					uic.move(tx, ty);

				px = tx;
			}

			if (titleTextField)
			{
				switch(headerVerticalAlign)
				{
					case "top":
					{
						ty = 5;
						break;
					}

					case "bottom":
					{
						ty = getHeaderHeight() - titleTextField.getExplicitOrMeasuredHeight();
						break;
					}

					case "middle":
					default:
					{
						ty = (getHeaderHeight() - titleTextField.getExplicitOrMeasuredHeight()) / 2;
						break;
					}
				}

				titleTextField.move(titleTextField.x, ty);
			}

		}

		/**
		 * Adds new children to the title bar area and registers default mouse event handlers.
		 * For most cases, title bar components should be added declaritively via MXML using titleBarChildren which calls this on the creation complete event.
		 * If however, assets are needing to be added dynamically at runtime, the developer can add them via this method.
		 *
		 * @see #titleBarChildren
		 * 
		 * @param value The UIComponent to be added.
		 *
		 * @return The UIComponent to be added.
		 */
		public function addTitleBarComponent (child:UIComponent = null):UIComponent
		{
			if (!child)
				child = new defaultTitleBarComponentClass();
			
			child.addEventListener(MouseEvent.CLICK,
				titleBarComponent_defaultMouseEventHandler,
				false,
				EventPriority.DEFAULT_HANDLER);

			child.addEventListener(MouseEvent.MOUSE_DOWN,
				titleBarComponent_defaultMouseEventHandler,
				false,
				EventPriority.DEFAULT_HANDLER);

			child.addEventListener(MouseEvent.MOUSE_OUT,
				titleBarComponent_defaultMouseEventHandler,
				false,
				EventPriority.DEFAULT_HANDLER);

			child.addEventListener(MouseEvent.MOUSE_OVER,
				titleBarComponent_defaultMouseEventHandler,
				false,
				EventPriority.DEFAULT_HANDLER);

			child.addEventListener(MouseEvent.MOUSE_UP,
				titleBarComponent_defaultMouseEventHandler,
				false,
				EventPriority.DEFAULT_HANDLER);
			
			child.buttonMode = true;
			child.owner = this;
			
			titleBarAssets.push(child);
			
			if (!titleBar)
				creationQueue.push(child);
			
			else
				titleBar.addChild(child);
				
			invalidateDisplayList();
			
			return child;
		}
		
		/**
		 * Clones a target mouse event but allows for the type to be set prior to cloning.
		 * This method should be used only for capturing events fired from the titleBar area which
		 * do not originate from any of its children.
		 *
		 * @param type The mouseEvent type of the target mouseEvent to be cloned.
		 * @param targetEvt The mouseEvent to be cloned.
		 *
		 * @return The cloned mouseEvent.
		 */
		protected function createTitleBarMouseEvent (type:String, targetEvt:MouseEvent):MouseEvent
		{
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

		////////////////////////////////////////////////////////////////////////
		//	TITLE BAR EVENT HANDLERS
		////////////////////////////////////////////////////////////////////////

		/**
		 * @private
		 *
		 * TitleBar by default is setup to handle events as possible drag initiators while in popup modes.
		 * In order to override that default behavior, the evt must stop propogation and be handled in a different manner so as not to
		 * trigger a possible drag action.
		 */
		protected function titleBarComponent_defaultMouseEventHandler (evt:MouseEvent):void
		{
			evt.stopPropagation();
		}

		/**
		 * @private
		 *
		 * Depending on the instantiation of this component, the titleBar may not be created yet when calling addTitleBarComponent().
		 * In order to avoid null pointer references, if a titleBarComponent is being added and the titleBar = null, the added child
		 * is placed in the creation queue.  TitleBar then references this queue and adds the components listed.
		 */
		protected function titleBar_onCreationComplete (evt:FlexEvent):void
		{
			var titleBarChild:UIComponent;
			var i:int = 0;
			var l:int = creationQueue.length;
			for (i; i < l; i++)
			{
				titleBarChild = creationQueue[i] as UIComponent;
				titleBar.addChild(titleBarChild);
			}

			creationQueue = [];
			
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
		}

		/**
		 * @private
		 */
		protected function titleBar_onClick (evt:MouseEvent):void
		{
			dispatchEvent(createTitleBarMouseEvent(Pod.GRIP_CLICK, evt));
		}

		/**
		 * @private
		 *
		 * TitleBar has a predefined handler that acts on click events when a Pod is in popup mode.
		 * titleBar_onMouseDown is used in order to receive and broadcast click events when in non-popup mode.
		 */
		protected function titleBar_onMouseDown (evt:MouseEvent):void
		{
			if (!isPopUp)
				dispatchEvent(createTitleBarMouseEvent(Pod.GRIP_MOUSE_DOWN, evt));
		}

		/**
		 * @private
		 */
		protected function titleBar_onMouseMove (evt:MouseEvent):void
		{
			dispatchEvent(createTitleBarMouseEvent(Pod.GRIP_MOUSE_MOVE, evt));
		}

		/**
		 * @private
		 */
		protected function titleBar_onMouseOut (evt:MouseEvent):void
		{
			dispatchEvent(createTitleBarMouseEvent(Pod.GRIP_MOUSE_OUT, evt));
		}

		/**
		 * @private
		 */
		protected function titleBar_onMouseOver (evt:MouseEvent):void
		{
			dispatchEvent(createTitleBarMouseEvent(Pod.GRIP_MOUSE_OVER, evt));
		}

		/**
		 * @private
		 */
		protected function titleBar_onMouseUp (evt:MouseEvent):void
		{
			dispatchEvent(createTitleBarMouseEvent(Pod.GRIP_MOUSE_UP, evt));
		}

		/**
		 * @private
		 */
		protected function titleBar_onRollOut (evt:MouseEvent):void
		{
			dispatchEvent(createTitleBarMouseEvent(Pod.GRIP_ROLL_OUT, evt));
		}

		/**
		 * @private
		 */
		protected function titleBar_onRollOver (evt:MouseEvent):void
		{
			dispatchEvent(createTitleBarMouseEvent(Pod.GRIP_ROLL_OVER, evt));
		}

		////////////////////////////////////////////////////////////////////////
		//	HEADER HEIGHT
		////////////////////////////////////////////////////////////////////////

		/**
		 * A convenience method for retrieving the header height.
		 *
		 * @return The height of the header.
		 */
		[Bindable("headerHeightChanged")]
		public function get headerHeight ():Number
		{
			return getHeaderHeight();
		}

		/**
		 * @private
		 */
		public function set headerHeight (value:Number):void
		{
			setStyle("headerHeight", value);

			dispatchEvent(new Event("headerHeightChanged"));
		}
	}
}