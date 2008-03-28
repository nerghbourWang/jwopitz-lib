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
package com.jwopitz.controls.pagination
{
	/**
	 * Interface for controlling paginated data.
	 * 
	 * @see com.jwopitz.controls.pagination.PaginatedItemsControlBase
	 */
	public interface IPaginatedItemsControl
	{
		/**
		 * The number of items per page of data.
		 */
		function get itemsPerPage ():int;
		
		/**
		 * @private
		 */
		function set itemsPerPage (value:int):void;
		
		/**
		 * The set of data to be paginated based on items per page.  This value must be of type Array or mx.collections.IList or a runtime error will occur.
		 */
		function get dataProvider ():Object;
		
		/**
		 * @private
		 */
		function set dataProvider (value:Object):void;
		
		/**
		 * The current set of data represented by the selected index.
		 */
		function get selectedItems ():Array;
		
		/**
		 * The index value of the current set of data represented by the selected items.
		 */
		function get selectedIndex ():int;
		
		/**
		 * @private
		 */
		function set selectedIndex (value:int):void;
	}
}