package com.jwopitz.controls
{
	import flash.events.Event;
	import flash.events.FocusEvent;
	
	import mx.controls.ComboBox;
	import mx.core.mx_internal;
	import mx.styles.CSSStyleDeclaration;
	import mx.styles.StyleManager;
	
	public class ComboBox extends mx.controls.ComboBox
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
			var oldS:CSSStyleDeclaration = StyleManager.getStyleDeclaration("ComboBox");
			var s:CSSStyleDeclaration = new CSSStyleDeclaration();

			if (oldS)
			{
				//copy over old styles
				s = oldS;

				//clear old style
				StyleManager.clearStyleDeclaration("ComboBox", true); //will this clear the mx.controls.ComboBox style too?
			}
			
			//s.setStyle();
			
			StyleManager.setStyleDeclaration("ComboBox", s, true);

			return true;
		}
		
		//////////////////////////////////////////////////////////////
		//	CONSTRUCTOR
		//////////////////////////////////////////////////////////////
		
		public function ComboBox ()
		{
			super();
			
			//editable = true;
		}
		
		//////////////////////////////////////////////////////////////
		//	EDITABLE
		//////////////////////////////////////////////////////////////
		
		/*override public function set editable (value:Boolean):void
		{
			super.editable = true;
		}*/
		
		//////////////////////////////////////////////////////////////
		//	EDIT PROMPT
		//////////////////////////////////////////////////////////////
		
		protected var editPromptChanged:Boolean = false;
		
		protected var ePrompt:String = " (edit)";
		
		[Bindable("editPromptChanged")]
		public function get editPrompt ():String
		{
			return ePrompt;
		}
		
		public function set editPrompt (value:String):void
		{
			if (ePrompt != value)
			{
				ePrompt = value;
				editPromptChanged = true;
				
				invalidateProperties();
				invalidateDisplayList();
				
				dispatchEvent(new Event("editPromptChanged"));
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
		//	OVERRIDES
		//////////////////////////////////////////////////////////////
		
		override protected function createChildren ():void
		{
			super.createChildren();
			
			
		}
		
		override protected function commitProperties ():void
		{
			super.commitProperties();
			
			if (labelModeChanged)
			{
				textInput.text = labelMode?
					selectedLabel + editPrompt:
					selectedLabel;
				
				//labelModeChanged = false; //we also have things to attend to in updateDisplayList
			}
		}
		
		override protected function updateDisplayList (unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			if (labelModeChanged)
			{
				if (labelMode)
				{
					textInput.mx_internal::border.visible = false;
					mx_internal::border.visible = false;
					mx_internal::downArrowButton.visible = false;
				}
				else
				{
					textInput.mx_internal::border.visible = true;
					mx_internal::border.visible = true;
					mx_internal::downArrowButton.visible = true;
				}
				
				labelModeChanged = false;
			}
		}
		
		//////////////////////////////////////////////////////////////
		//	EVT HANDLERS
		//////////////////////////////////////////////////////////////
		
		override protected function focusInHandler (event:FocusEvent):void
		{
			super.focusInHandler(event);
			
			labelMode = false;
		}
		
		override protected function focusOutHandler (event:FocusEvent):void
		{
			super.focusOutHandler(event);
			
			if (appearAsLabel)
				labelMode = true;
		}
		
	}
}