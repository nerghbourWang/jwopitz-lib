package com.jwopitz.vo {

	[Bindable]
	public class QuoteVO {
		
		public var symbol:String = "";
		public var name:String = "";
		public var value:Number = 0.00;
		public var change:Number = 0.00;
		public var percentChange:Number = 0.00;
		
		public function QuoteVO (symbol:String = "", 
								 name:String = "", 
								 value:Number = 0.00,
								 change:Number = 0.00,
								 percentChange:Number = 0.00){
								 	
			this.symbol = symbol;
			this.name = name;
			this.value = value;
			this.change = change;
			this.percentChange = percentChange;
			
		}
		
	}
}