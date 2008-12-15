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
	import mx.controls.listClasses.ListBase;
	import mx.controls.listClasses.ListItemRenderer;

	public class AutoCompleteListItemRenderer extends ListItemRenderer
	{
		public var matchString:String = "";
		
		override protected function commitProperties ():void
		{
			super.commitProperties();
			
			//see mx.controls.listClasses.ListItemRenderer line# 314 (Flex 3 SDK)
			if (data)
			{
				var listOwner:ListBase = ListBase(listData.owner);
				
				label.text = "";
				label.htmlText = getEmphasizedText();
				label.multiline = listOwner.variableRowHeight;
				label.wordWrap = listOwner.wordWrap;
				
				if (listOwner.showDataTips)
				{
					if (listOwner.dataTipFunction || label.textWidth > label.width)
						toolTip = listOwner.itemToDataTip(data);
					
					else
						toolTip = null;
				}
				
				else
					toolTip = null
			}
		}
		
		protected function getEmphasizedText ():String
		{
			var s:String = listData.label ? listData.label : " ";
			var emphasis:String;
			if (listData.label)
			{
				emphasis = "<b>" + matchString + "</b>";
				
				if (listData.label.indexOf(matchString) != -1)
					s = listData.label.replace(matchString, emphasis);
			}
			
			return s;
		}
		
		public function AutoCompleteListItemRenderer()
		{
			super();
		}
		
	}
}