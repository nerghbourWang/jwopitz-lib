# Introduction #

For some reason the source view for the TileCanvas was not uploaded and that code has since been lost within the project.  Luckily I found an old posting somewhere of this code.


# Details #

```
<?xml version="1.0" encoding="utf-8"?>

<mx:Application 

	layout="absolute"

	

	viewSourceURL="srcview/index.html"

	

	xmlns:mx="http://www.adobe.com/2006/mxml"

	xmlns:containers="com.jwopitz.containers.*">



	<mx:Script>

		<![CDATA[

			import mx.controls.Alert;

			import mx.core.Container;

			import mx.collections.SortField;

			import mx.events.CollectionEventKind;

			import mx.collections.Sort;

			import mx.events.EffectEvent;

			import mx.events.CollectionEvent;

			import mx.collections.ArrayCollection;

			import com.jwopitz.containers.QuoteDetailCard;

			import com.jwopitz.vo.QuoteVO

			import mx.effects.Move;

			import mx.containers.Box;

			

			[Bindable]private var columns:int = 3;

			[Bindable]private var columnWidth:Number = 150;

			[Bindable]private var columnGap:Number = 5;

			

			[Bindable]private var rows:int = 0;

			[Bindable]private var rowHeight:Number = 100;

			[Bindable]private var rowGap:Number = 5;

			

			private var thumbs:Array;

			

			[Bindable]private var isMoving:Boolean = false;

			

			[Bindable]

			private var order:Boolean = false;

			

			[Bindable]

			private var  d:ArrayCollection = new ArrayCollection(

									[new QuoteVO('GOOG', 'Google', 145.12, 0.35, 0.02),

									 new QuoteVO('IBM', 'IBM', 45.78, -0.15, -0.01),

									 new QuoteVO('AAPL', 'Apple', 103.01, -0.02, -0.01),

									 new QuoteVO('POPN', 'Pop N Fresh', 12.14, 0.12, 0.07),

									 ])/*new QuoteVO('IBM', 'IBM', 45, 0.35, 0.02),

									 new QuoteVO('AAPL', 'Apple', 103, 0.35, 0.02),

									 new QuoteVO('POPN', 'Pop N Fresh', 1214, 0.35, 0.02),

									 new QuoteVO('GOOG', 'Google', 145, 0.35, 0.02),

									 new QuoteVO('IBM', 'IBM', 45, 0.35, 0.02),

									 new QuoteVO('AAPL', 'Apple', 103, 0.35, 0.02),

									 new QuoteVO('POPN', 'Pop N Fresh', 1214, 0.35, 0.02),]

									);*/

									

			private function sort (property:String):void {

				

				var s:Sort = new Sort();

				s.fields = [new SortField(property, false, order)];

				d.sort = s;

				d.refresh();

			}

						

			private function setupRenderer (h:Boolean = false):ClassFactory {

				var cf:ClassFactory = new ClassFactory(QuoteDetailCard);

				if (h){

					cf.properties = {currentState:'horizontalLayout'};

				}

				return cf;

			}

			

			private function tcCreationComplete ():void {

				tc.direction = 'vertical';

				tc.itemSpawnPoint = new Point(tc.width - tc.columnWidth, tc.height - tc.rowHeight);

				tc.dataProvider = d;

			}

													

		]]>

	</mx:Script>

	

	<mx:Panel title="TileCanvas by jwopitz - updated {new Date()}" 

		width="98%" height="98%" 

		paddingLeft="5" paddingRight="5" paddingBottom="5" paddingTop="5">

		

		<mx:HBox>

			<mx:VBox>

				<mx:Label text="{'actual columns: ' + tc.columns}"/>

				<mx:HBox>

					<mx:Label text="columns"/>

					<mx:NumericStepper id="col_nm" minimum="1" maximum="10" value="3"/>

				</mx:HBox>

			</mx:VBox>

			

			<mx:VBox>

				<mx:Label text="{'actual rows: ' + tc.rows}"/>

				<mx:HBox>

					<mx:Label text="rows"/>

					<mx:NumericStepper id="row_nm" minimum="1" maximum="10" value="3"/>

				</mx:HBox>

			</mx:VBox>	

			

			<mx:VBox>

				<mx:Label text="current direction {tc.direction}"/>

				<mx:Button label="change direction"

				click="(tc.direction == 'horizontal')? tc.direction = 'vertical': tc.direction = 'horizontal';"/>

			</mx:VBox>

			

			<mx:Button label="add cell" 

				click="d.addItem(new QuoteVO('YHOO', 'Yahoo Inc.', 15.76, -.02, -.00));"/>

				

			<mx:Button label="delete cell" 

				click="d.removeItemAt(d.length - 1);"/>

			

			<mx:Spacer width="25"/>

			

			<mx:Button width="125" label="{(order) ? 'sort descending' : 'sort ascending'}" 

				click="order = !order; sort(sorts_rbg.selectedValue as String);"/>

			

			<mx:RadioButtonGroup id="sorts_rbg" change="sort(sorts_rbg.selectedValue as String);"/>

			<mx:RadioButton group="{sorts_rbg}" label="symbol" value="symbol" selected="true"/>	

			<mx:RadioButton group="{sorts_rbg}" label="value" value="value"/>	

			<mx:RadioButton group="{sorts_rbg}" label="change" value="change"/>

			<mx:RadioButton group="{sorts_rbg}" label="% change" value="percentChange"/>		

				

			

			

		</mx:HBox>

		

		<mx:HBox width="100%" height="100%">

			<containers:TileCanvas id="tc" width="100%" height="100%" 

				itemSpawnPoint="{new Point(tc.width - tc.columnWidth, tc.height - tc.rowHeight)}" 

				columns="{col_nm.value}" columnWidth="{columnWidth}" 

				rows="{row_nm.value}" rowHeight="{rowHeight}" dragEnabled="true" dropEnabled="true"

				itemRenderer="{setupRenderer()}" creationComplete="tcCreationComplete()" backgroundColor="white"/>

				

			<mx:List width="300" itemRenderer="{setupRenderer(true)}" rowHeight="55" height="100%"

				dataProvider="{d}"/>

		</mx:HBox>

			

		

		

	</mx:Panel>

	

</mx:Application>
```