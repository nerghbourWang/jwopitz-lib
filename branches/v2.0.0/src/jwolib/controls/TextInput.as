/*

Copyright (c) 2007 J.W.Opitz, All Rights Reserved.

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
package jwolib.controls
{
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	
	import mx.controls.Button;
	import mx.controls.TextInput;
	import mx.core.EdgeMetrics;
	import mx.core.EventPriority;
	import mx.core.IFlexDisplayObject;
	import mx.core.mx_internal;
	import mx.managers.IFocusManagerComponent;
	import mx.skins.RectangularBorder;
	import mx.styles.CSSStyleDeclaration;
	import mx.styles.StyleManager;
	
	//use namespace mx_internal;

	//////////////////////////////////////////////////////////////
	//	STYLES
	//////////////////////////////////////////////////////////////

	/**
	 * The horizontal gap between the end of the UITextField and the clear button.
	 *
	 * @default 5
	 */
	[Style(name="horizontalGap", type="Number", format="Length", inherit="no")]

	/**
	 *  Name of the class to use as the skin for the background and border
	 *  when the clear button is not selected and the mouse is not over the control.
	 *
	 *  @default "/assets/swf/closeButtonSkins.swf#CloseButton_upSkin"
	 */
	[Style(name="upSkin", type="Class", inherit="no")]

	/**
	 *  Name of the class to use as the skin for the background and border
	 *  when the clear button is not selected and the mouse is over the control.
	 *
	 *  @default "/assets/swf/closeButtonSkins.swf#CloseButton_overSkin"
	 */
	[Style(name="overSkin", type="Class", inherit="no")]

	/**
	 *  Name of the class to use as the skin for the background and border
	 *  when the clear button is not selected and the mouse button is down.
	 *
	 *  @default "/assets/swf/closeButtonSkins.swf#CloseButton_downSkin"
	 */
	[Style(name="downSkin", type="Class", inherit="no")]

	/**
	 *  Name of the class to use as the skin for the background and border
	 *  when the clear button is not selected and is disabled.
	 *
	 *  @default "/assets/swf/closeButtonSkins.swf#CloseButton_disabledSkin"
	 */
	[Style(name="disabledSkin", type="Class", inherit="no")]

	//////////////////////////////////////////////////////////////
	//	EVENTS
	//////////////////////////////////////////////////////////////

	/**
	 * Triggered when the user clicks the clear button.
	 */
	[Event(name="clear", type="flash.events.Event")]

	/**
	 *  The TextInput control is a single-line text field
	 *  that is optionally editable.
	 *  All text in this control must use the same styling
	 *  unless it is HTML text.
	 *  The TextInput control supports the HTML rendering
	 *  capabilities of the Adobe Flash Player.
	 *
	 *  <p>The <code>&lt;jwo_lib:TextInput&gt;</code> tag inherits the attributes
	 *  of its superclass and adds the following attributes:</p>
	 *
	 *  <pre>
	 *  &lt;jwo_lib:TextInput
	 *    <b>Properties</b>
	 *    showClearButton="false|true"
	 *    &nbsp;
	 *    <b>Styles</b>
	 *    horizontalGap="5"
	 *    &nbsp;
	 *    <b>Events</b>
	 *    clear="<i>No default</i>"
	 *  /&gt;
	 *  </pre>
	 *
	 *  @see mx.controls.TextInput
	 */
	public class TextInput extends mx.controls.TextInput
	{
		//////////////////////////////////////////////////////////////
		//	DEFAULT STYLES
		//////////////////////////////////////////////////////////////

		/**
		 * @private
		 */
		private static var defaultStylesInitialized:Boolean = setDefaultStyles();

		/**
		 * @private
		 */
		private static function setDefaultStyles ():Boolean
		{
			//copy over old styles if applicable
			var oldS:CSSStyleDeclaration = StyleManager.getStyleDeclaration("TextInput");
			var s:CSSStyleDeclaration = new CSSStyleDeclaration();

			if (oldS)
			{
				//copy over old styles
				s = oldS;

				//clear old style
				StyleManager.clearStyleDeclaration("TextInput", true);
			}

			//create embedded skin vars
			[Embed(source="/assets/swf/closeButtonSkins.swf", symbol="CloseButton_disabledSkin")]
			var disabledSkin:Class;

			[Embed(source="/assets/swf/closeButtonSkins.swf", symbol="CloseButton_downSkin")]
			var downSkin:Class;

			[Embed(source="/assets/swf/closeButtonSkins.swf", symbol="CloseButton_overSkin")]
			var overSkin:Class;

			[Embed(source="/assets/swf/closeButtonSkins.swf", symbol="CloseButton_upSkin")]
			var upSkin:Class;

			//add new default styles
			s.setStyle("horizontalGap", 5);
			s.setStyle("disabledSkin", disabledSkin);
			s.setStyle("downSkin", downSkin);
			s.setStyle("overSkin", overSkin);
			s.setStyle("upSkin", upSkin);

			StyleManager.setStyleDeclaration("TextInput", s, true);

			return true;
		}
		
		//////////////////////////////////////////////////////////////
		//	CONSTRUCTOR
		//////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		public function TextInput ()
		{
			super();
			
			buttonMode = true;
			useHandCursor = true;
			
			//tapping into private workings of mx:TextInput 
			//which dispatches this event when the user types in the text field.
			addEventListener("textChanged",
				onTextChangedHandler,
				false,
				EventPriority.DEFAULT_HANDLER,
				false);
		}
		
		//////////////////////////////////////////////////////////////
		//	APPEAR AS LABEL
		//////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		protected var appearAsLabelAfterEdit:Boolean = true;
		
		/**
		 * @private
		 */
		protected var appearAsLabelChanged:Boolean = true;
		
		/**
		 * Flag indicating if once the component has lost focus, it should appear as a label, removing the border and clear button.
		 * The default value is true.
		 */
		[Bindable("appearAsLabelChanged")]
		public function get appearAsLabel ():Boolean
		{
			return appearAsLabelAfterEdit
		}
		
		/**
		 * @private
		 */
		public function set appearAsLabel (value:Boolean):void
		{
			if (appearAsLabelAfterEdit != value)
			{
				appearAsLabelAfterEdit = value;
				appearAsLabelChanged = true;
				
				invalidateProperties();
				invalidateDisplayList();
				
				dispatchEvent(new Event("appearAsLabelChanged"));
			}
		}
		
		//////////////////////////////////////////////////////////////
		//	PROMPT
		//////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		protected var promptChanged:Boolean = false;
		
		/**
		 * @private
		 */
		protected var editPrompt:String = " (edit)";
		
		/**
		 * Indicator string located at the end of the text when <code>labelMode</code> = true.
		 * Default value is " (edit)".
		 */
		[Bindable("promptChanged")]
		public function get prompt ():String
		{
			return editPrompt
		}
		
		/**
		 * @private
		 */
		public function set prompt (value:String):void
		{
			if (editPrompt != value)
			{
				editPrompt = value;
				promptChanged = true;
				
				invalidateProperties();
				invalidateDisplayList();
				
				dispatchEvent(new Event("promptChanged"));
			}
		}
		
		//////////////////////////////////////////////////////////////
		//	LABEL MODE
		//////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		protected var labelModeChanged:Boolean = true;
		
		/**
		 * @private
		 */
		protected var lblMode:Boolean = true;
		
		/**
		 * Flag that tells internal methods if component is in label mode or edit mode.
		 * This gets set in the focus event handlers.
		 */
		protected function get labelMode ():Boolean
		{
			return lblMode;
		}
		
		/**
		 * @private
		 */
		protected function set labelMode (value:Boolean):void
		{
			if (lblMode != value)
			{
				lblMode = value;
				labelModeChanged = true;
				
				invalidateProperties();
				invalidateDisplayList();
			}
		}
		
		//////////////////////////////////////////////////////////////
		//	CLEAR BUTTON
		//////////////////////////////////////////////////////////////

		/**
		 * @private
		 */
		protected var clearBtn:Button;

		//////////////////////////////////////////////////////////////
		//	SHOW CLEAR BUTTON
		//////////////////////////////////////////////////////////////

		/**
		 * @private
		 */
		protected var showClearBtn:Boolean = true;

		/**
		 * @private
		 */
		protected var showClearBtnChanged:Boolean = false;

		/**
		 * Flag indicating whether or not to show the clear button for the text field.
		 */
		[Bindable("showClearButtonChanged")]
		public function get showClearButton ():Boolean
		{
			return showClearBtn;
		}

		/**
		 * @private
		 */
		public function set showClearButton (value:Boolean):void
		{
			if (showClearBtn != value)
			{
				showClearBtn = value;

				showClearBtnChanged = true;

				invalidateProperties();
				invalidateSize();
				invalidateDisplayList();

				dispatchEvent(new Event("showClearButtonChanged"));
			}
		}

		//////////////////////////////////////////////////////////////
		//	HILITE TEXT ON FOCUS IN
		//////////////////////////////////////////////////////////////

		/**
		 * @private
		 */
		public var hiliteTextOnFocusIn:Boolean = true;
		
		//////////////////////////////////////////////////////////////
		//	FOCUS ON CLEAR
		//////////////////////////////////////////////////////////////

		/**
		 * @private
		 */
		protected var focusOnClearChanged:Boolean = false;

		/**
		 * @private
		 */
		protected var willFocusOnClear:Boolean = true;

		/**
		 * Flag indicating if the text field should gain focus after a clear event.  The default is true.
		 */
		public function get focusOnClear ():Boolean
		{
			return willFocusOnClear;
		}

		/**
		 * @private
		 */
		public function set focusOnClear (value:Boolean):void
		{
			if (willFocusOnClear != value)
			{
				willFocusOnClear = value;
				/*focusOnClearChanged = true;

				invalidateProperties();*/
			}
		}
		
		//////////////////////////////////////////////////////////////
		//	TEXT
		//////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		protected var textChanged:Boolean = false;
		
		/**
		 * @private
		 * 
		 * A storage property seperating the text from the added prompt.
		 */
		protected var originalText:String = "";
		
		/**
		 * @private
		 */
		override public function get text ():String
		{
			return originalText;
		}
		
		/**
		 * @private
		 */
		override public function set text (value:String):void
		{
			if (originalText != value)
			{
				originalText = value;
				textChanged = true;
				
				invalidateProperties();
			}
		}

		//////////////////////////////////////////////////////////////
		//	OVERRIDES
		//////////////////////////////////////////////////////////////

		/**
		 * @private
		 */
		protected var enabledChanged:Boolean = false;

		/**
		 * @private
		 */
		override public function get enabled ():Boolean
		{
			return super.enabled;
		}
		/**
		 * @private
		 */
		override public function set enabled (value:Boolean):void
		{
			if (super.enabled != value)
			{
				super.enabled = value;
				enabledChanged = true;

				invalidateProperties();
			}
		}

		/**
		 * @private
		 */
		override protected function createChildren ():void
		{
			super.createChildren();
			
			//add new listeners so text can affect clearBtn
			if (!clearBtn)
			{
				clearBtn = new Button();
				//clearBtn.focusEnabled = false;
				clearBtn.mouseFocusEnabled = false;

				clearBtn.setActualSize(18, 18);
				clearBtn.styleName = this;

				clearBtn.addEventListener(MouseEvent.CLICK, onClick_clearBtnHandler);

				addChild(clearBtn);
			}
			
			if (appearAsLabel)
			{
				textField.text = text + prompt;
				
				mx_internal::border.visible = false;
				clearBtn.visible = false;
			}
		}

		/**
		 * @private
		 */
		override protected function commitProperties ():void
		{
			super.commitProperties();
			
			if (appearAsLabelChanged)
			{
				if (appearAsLabel)
				{					
					labelMode = true;
					
					if (!hasFocusEventHandlers)
						addFocusEventHandlers();
				}
				else
				{
					labelMode = false;
					
					if (hasFocusEventHandlers)
						removeFocusEventHandlers();
				}
				
				appearAsLabelChanged = false;
			}
			
			if (labelModeChanged)
			{
				textField.text = labelMode?
					originalText + " " + prompt:
					originalText;
					
				labelModeChanged = false;
			}
			
			if (textChanged)
			{
				textChanged = false;
			}

			if (showClearBtnChanged)
			{
				clearBtn.mouseEnabled = showClearBtn;
				clearBtn.visible = showClearBtn;

				showClearBtnChanged = false;
			}

			if (enabledChanged)
			{
				clearBtn.enabled = enabled;

				enabledChanged = false;
			}
		}

		/**
		 * @private
		 */
		override protected function measure ():void
		{
			super.measure();

			measuredWidth = measuredWidth + getStyle("horizontalGap") + clearBtn.getExplicitOrMeasuredWidth();
		}

		/**
		 * @private
		 */
		override protected function updateDisplayList (unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			//gather info about the border
			var bm:EdgeMetrics;
			var b:IFlexDisplayObject = mx_internal::border;

			if (b)
			{
				b.setActualSize(unscaledWidth, unscaledHeight);
				bm = b is RectangularBorder ?
					RectangularBorder(b).borderMetrics : EdgeMetrics.EMPTY;
			}
			else
			{
				bm = EdgeMetrics.EMPTY;
			}
			
			//resize the textField and reposition the clear button to fit within the border if applicable
			var tw:Number;
			var hGap:Number = getStyle("horizontalGap");

			textField.x = bm.left;
			textField.y = bm.top;

			if (showClearBtn)
			{
				tw = Math.max(0, unscaledWidth - (bm.left + bm.right) - hGap - clearBtn.width);

				var tx:Number = bm.left + tw + hGap;
				var ty:Number = (unscaledHeight - clearBtn.height) / 2;

				clearBtn.move(tx, ty);
			}
			
			else
			{
				tw = Math.max(0, unscaledWidth - (bm.left + bm.right));
			}
			
			textField.width = tw; 
			textField.height = Math.max(0, unscaledHeight - (bm.top + bm.bottom + 1));
			
			//depending on certain display modes we need to shut the border and clear on or off
			if (appearAsLabel)
			{
				if (labelMode)
				{
					mx_internal::border.visible = false;
					clearBtn.visible = false;
				}
			}
			
			else
			{
				mx_internal::border.visible = true;
				
				if (showClearButton)
					clearBtn.visible = true;
			}
		}
		
		/**
		 * @private
		 */
		override public function styleChanged (styleProp:String):void
		{
			super.styleChanged(styleProp);
			
			var allStyles:Boolean = !styleProp || styleProp == "styleName";
			if (clearBtn && allStyles)
			{
				var upSkin:Class = getStyle("upSkin");
				var overSkin:Class = getStyle("overSkin");
				var downSkin:Class = getStyle("downSkin");
				var disabledSkin:Class = getStyle("disabledSkin");
				
				clearBtn.setStyle("upSkin", upSkin);
				clearBtn.setStyle("overSkin", overSkin);
				clearBtn.setStyle("downSkin", downSkin);
				clearBtn.setStyle("disabledSkin", disabledSkin);
			}
			
			if (clearBtn && styleProp == "upSkin" ||
				styleProp == "overSkin" ||
				styleProp == "downSkin" ||
				styleProp == "disabledSkin")
			{
				var btnSkin:Class = getStyle(styleProp);
				clearBtn.setStyle(styleProp, btnSkin);
			}
			
			invalidateDisplayList();
		}
		
		//////////////////////////////////////////////////////////////
		//	ADD/REMOVE EVENT HANDLERS
		//////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		protected var hasFocusEventHandlers:Boolean = false; 
		
		/**
		 * @private
		 */
		protected function addFocusEventHandlers ():void
		{
			addEventListener(FocusEvent.FOCUS_IN,
				onFocusIn,
				false,
				EventPriority.DEFAULT_HANDLER,
				false);
			
			addEventListener(FocusEvent.FOCUS_OUT,
				onFocusOut,
				false,
				EventPriority.DEFAULT_HANDLER,
				false);
				
			hasFocusEventHandlers = true;
		}
		
		/**
		 * @private
		 */
		protected function removeFocusEventHandlers ():void
		{
			removeEventListener(FocusEvent.FOCUS_IN,
				onFocusIn,
				false);
			
			removeEventListener(FocusEvent.FOCUS_OUT,
				onFocusOut,
				false);
				
			hasFocusEventHandlers = false;
		}
		
		//////////////////////////////////////////////////////////////
		//	EVENT HANDLERS
		//////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 * 
		 * This should only get fired from the user typing text into the textField.
		 */
		protected function onTextChangedHandler (evt:Event):void
		{
			if (textField)
			{
				var typedText:String = textField.text;
				originalText = typedText;
			}
		}
		
		/**
		 * @private
		 */
		protected function onFocusIn (evt:FocusEvent):void
		{
			if (hiliteTextOnFocusIn)
				textField.setSelection(0, text.length - 1);
			
			if (appearAsLabel)
				labelMode = false;
			
			if (!mx_internal::border.visible)
			{
				mx_internal::border.visible	= true;
				
				if (showClearBtn)
					clearBtn.visible = true;
			}
		}	
		
		/**
		 * @private
		 */
		protected function onFocusOut (evt:FocusEvent):void
		{
			var	nextFocus:IFocusManagerComponent = focusManager.getFocus();
			if (clearBtn != nextFocus && appearAsLabel)
				labelMode = true;
			
			if (mx_internal::border.visible)
			{
				mx_internal::border.visible	= false;
				
				if	(clearBtn != nextFocus)
					clearBtn.visible = false;
			}
		}
		
		/**
		 * @private
		 */
		protected function onClick_clearBtnHandler (evt:MouseEvent):void
		{
			text = "";
			htmlText = "";
			
			if (focusOnClear)
			{
				/*var nextFocus:IFocusManagerComponent = focusManager.getNextFocusManagerComponent(true);
				focusManager.setFocus(nextFocus);*/
				
				var nextFocus:IFocusManagerComponent = IFocusManagerComponent(this);
				focusManager.setFocus(nextFocus);
			}
			
			dispatchEvent(new Event('clear'));
		}
	}
}