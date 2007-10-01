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
package com.jwopitz.controls {

	import com.jwopitz.skins.ClearButtonSkin;

	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;

	import mx.containers.Canvas;
	import mx.controls.LinkButton;
	import mx.core.UITextField;
	import mx.styles.CSSStyleDeclaration;
	import mx.styles.StyleManager;

	//////////////////////////////////////////////////////////////
	//	STYLES
	//////////////////////////////////////////////////////////////

	/**
	 * Style declaration for when the rollOver event has been triggered over the <code>linkBtn</code>.
	 */
	[Style(name="rollOverStyle", type="String", inherit="no")]

	/**
	 * HyperlinkText is an accessible component that provides a simple single or multiline text field that functions like an HTML hyperlink.
	 *
	 * <p>The <code>&lt;jwo_lib:HyperlinkText&gt;</code> tag inherits the attributes
	 * of its superclass and adds the following attributes:</p>
	 *
	 *  <pre>
	 *  &lt;mx:TextInput
	 *    <b>Properties</b>
	 * 	  text=""
	 *    &nbsp;
	 *    <b>Styles</b>
	 *    rollOverStyle="underline"
	 *  /&gt;
	 *  </pre>
	 *
	 *  @see mx.containers.Canvas
	 *  @see mx.controls.LinkButton
	 *  @see mx.core.UITextField
	 */
	public class HyperlinkText extends Canvas {

		//////////////////////////////////////////////////////////////
		//	DEFAULT STYLES INIT
		//////////////////////////////////////////////////////////////

		/**
		 * @private
		 */
		private static var defaultStylesInitialized:Boolean = setDefaultStyles();

		/**
		 * @private
		 */
		private static function setDefaultStyles ():Boolean {

			if (!StyleManager.getStyleDeclaration('HyperlinkText')){

				var rollOverStyle:CSSStyleDeclaration = new CSSStyleDeclaration();
				rollOverStyle.setStyle('textDecoration', 'underline');

				var defaultStyle:CSSStyleDeclaration = new CSSStyleDeclaration();
				defaultStyle.setStyle('color', 0x0000FF);
				defaultStyle.setStyle('textDecoration', 'none');
				defaultStyle.setStyle('disabledSkin', ClearButtonSkin);
				defaultStyle.setStyle('downSkin', ClearButtonSkin);
				defaultStyle.setStyle('overSkin', ClearButtonSkin);
				defaultStyle.setStyle('upSkin', ClearButtonSkin);
				defaultStyle.setStyle('rollOverStyle', rollOverStyle);

				StyleManager.setStyleDeclaration('HyperlinkText', defaultStyle, true);
			}

			return true;
		}

		//////////////////////////////////////////////////////////////
		//	CONSTRUCTOR
		//////////////////////////////////////////////////////////////

		/**
		 * Constructor
		 */
		public function HyperlinkText (){
			super();

			horizontalScrollPolicy = "off";
			verticalScrollPolicy = "off";
		}

		//////////////////////////////////////////////////////////////
		//	OVERRIDES
		//////////////////////////////////////////////////////////////

		/**
		 * @private
		 */
		protected var txtField:UITextField;

		/**
		 * @private
		 */
		protected var linkBtn:LinkButton;

		/**
		 * @private
		 */
		override protected function createChildren ():void {
			super.createChildren();

			if (!linkBtn){
				linkBtn = new LinkButton();
				linkBtn.buttonMode = true;
				linkBtn.owner = this;
				linkBtn.styleName = this;
				linkBtn.tabEnabled = true;
				linkBtn.move(0, 0);

				linkBtn.addEventListener(MouseEvent.CLICK, linkBtn_onClick);
				linkBtn.addEventListener(MouseEvent.MOUSE_DOWN, linkBtn_onMouseDown);
				linkBtn.addEventListener(MouseEvent.MOUSE_UP, linkBtn_onMouseUp);
				linkBtn.addEventListener(MouseEvent.ROLL_OUT, linkBtn_onRollOut);
				linkBtn.addEventListener(MouseEvent.ROLL_OVER, linkBtn_onRollOver);

				linkBtn.addEventListener(FocusEvent.FOCUS_IN, linkBtn_onFocusIn);
				linkBtn.addEventListener(FocusEvent.FOCUS_OUT, linkBtn_onFocusOut);

				addChild(linkBtn);
			}

			if (!txtField){
				txtField = new UITextField();
				txtField.mouseEnabled = false;
				txtField.owner = this;
				txtField.selectable = false;
				txtField.styleName = this;
				txtField.text = txt;
				txtField.wordWrap = hasDefinedWidth;
				txtField.move(0, 0);

				addChild(txtField);
			}
		}

		/**
		 * @private
		 */
		override protected function updateDisplayList (unscaledWidth:Number, unscaledHeight:Number):void {
			super.updateDisplayList(unscaledWidth, unscaledHeight);

			var tw:Number;
			var th:Number;

			if (isNaN(percentWidth)){
				tw = getExplicitOrMeasuredWidth();
				th = getExplicitOrMeasuredHeight();
			} else {
				tw = unscaledWidth;
				th = unscaledHeight;
			}

			txtField.setActualSize(tw, th);
			linkBtn.setActualSize(tw, th);

			invalidateSize();
		}

		//////////////////////////////////////////////////////////////
		//	UPDATE TEXT FIELD
		//////////////////////////////////////////////////////////////

		/**
		 * If a defined width is set, then the textField's wordWrap is set to true.
		 */
		protected function updateTextFieldProperties ():void {
			if (!isNaN(width) || !isNaN(percentWidth))
				hasDefinedWidth = true;
			else
				hasDefinedWidth = false;

			if (txtField)
				txtField.wordWrap = hasDefinedWidth;

			invalidateDisplayList();

		}

		//////////////////////////////////////////////////////////////
		//	LINK BUTTON EVENT HANDLERS
		//////////////////////////////////////////////////////////////

		/**
		 * @private
		 */
		protected function linkBtn_onClick (evt:MouseEvent):void {
			evt.stopPropagation();
			dispatchEvent(evt);
		}

		/**
		 * @private
		 */
		protected function linkBtn_onMouseDown (evt:MouseEvent):void {
			txtField.styleName = getStyle("rollOverStyle");
		}

		/**
		 * @private
		 */
		protected function linkBtn_onMouseUp (evt:MouseEvent):void {
			txtField.styleName = getStyle("rollOverStyle");
		}

		/**
		 * @private
		 */
		protected function linkBtn_onRollOut (evt:MouseEvent):void {
			txtField.styleName = this;
		}

		/**
		 * @private
		 */
		protected function linkBtn_onRollOver (evt:MouseEvent):void {
			txtField.styleName = getStyle("rollOverStyle");
		}

		/**
		 * @private
		 */
		protected function linkBtn_onFocusIn (evt:FocusEvent):void {
			txtField.styleName = getStyle("rollOverStyle");
		}

		/**
		 * @private
		 */
		protected function linkBtn_onFocusOut (evt:FocusEvent):void {
			txtField.styleName = this;
		}

		//////////////////////////////////////////////////////////////
		//	TEXT
		//////////////////////////////////////////////////////////////

		/**
		 * @private
		 */
		protected var txt:String = "";

		/**
		 * Specifies the plain text displayed by this control.
		 */
		public function get text ():String {
			return txt;
		}

		/**
		 * @private
		 */
		public function set text (value:String):void {
			txt = value;

			if (txtField)
				txtField.text = txt;
		}

		//////////////////////////////////////////////////////////////
		//	WIDTH & PERCENT WIDTH OVERRIDES
		//////////////////////////////////////////////////////////////

		/**
		 * @private
		 */
		protected var hasDefinedWidth:Boolean = false;

		/**
		 * @private
		 */
		override public function set width (value:Number):void {
			super.width = value;

			updateTextFieldProperties();
		}

		/**
		 * @private
		 */
		override public function set percentWidth (value:Number):void {
			super.percentWidth = value;

			updateTextFieldProperties();
		}
	}
}