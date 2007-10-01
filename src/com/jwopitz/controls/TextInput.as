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
package com.jwopitz.controls
{
	import flash.events.Event;
	import flash.events.MouseEvent;

	import mx.controls.Button;
	import mx.controls.TextInput;
	import mx.core.EdgeMetrics;
	import mx.core.IFlexDisplayObject;
	import mx.core.mx_internal;
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
			[Embed (source="/assets/swf/closeButtonSkins.swf", symbol="CloseButton_disabledSkin")]
			var disabledSkin:Class;

			[Embed (source="/assets/swf/closeButtonSkins.swf", symbol="CloseButton_downSkin")]
			var downSkin:Class;

			[Embed (source="/assets/swf/closeButtonSkins.swf", symbol="CloseButton_overSkin")]
			var overSkin:Class;

			[Embed (source="/assets/swf/closeButtonSkins.swf", symbol="CloseButton_upSkin")]
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
		[Bindable ("showClearButtonChanged")]
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
		//	OVERRIDES
		//////////////////////////////////////////////////////////////

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
		}

		/**
		 * @private
		 */
		override protected function commitProperties ():void
		{
			super.commitProperties();

			if (showClearBtnChanged)
			{
				clearBtn.mouseEnabled = showClearBtn;
				clearBtn.visible = showClearBtn;

				showClearBtnChanged = false;
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
	        textField.height = Math.max(0, unscaledHeight - (bm.top + bm.bottom + 1));;
		}

		//////////////////////////////////////////////////////////////
		//	EVENT HANDLERS
		//////////////////////////////////////////////////////////////

		/**
		 * @private
		 */
		protected function onClick_clearBtnHandler (evt:MouseEvent):void
		{
			text = "";
			htmlText = "";

			dispatchEvent(new Event('clear'));
		}
	}
}