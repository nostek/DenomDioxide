package com.tbbgc.denom.common.nodes.conditional {
	import com.tbbgc.denom.common.input.NodeInput;
	import com.tbbgc.denom.common.interfaces.INode;
	import com.tbbgc.denom.node.BaseNode;

	/**
	 * @author simonrodriguez
	 */
	public class IsBetweenNode extends BaseNode implements INode {
		private var _run:NodeInput;

		private var _a:NodeInput;
		private var _b:NodeInput;
		private var _value:NodeInput;
		private var _onIs:NodeInput;

		public function IsBetweenNode() {
			_run = new NodeInput(this, "RUN", onRun);

			_a 		= new NodeInput(this, "A", null, true);
			_b		= new NodeInput(this, "B", null, true);
			_value 	= new NodeInput(this, "VALUE", null, true);
			_onIs	= new NodeInput(this, "ON_IS", null);

			left( _run );
			right( _a, _b, _value, _onIs );

			super();
		}

		public function get nodeName() : String {
			return "IS BETWEEN";
		}

		override public function test() : void {
			onRun();
		}

		private function onRun():* {
			if( _a.haveConnections && _b.haveConnections && _value.haveConnections && _onIs.haveConnections ) {
				const a:Number = _a.runFirst() as Number;
				const b:Number = _b.runFirst() as Number;
				const value:Number = _value.runFirst() as Number;

				if( value >= a && value <= b ) {
					_onIs.runConnections();
				}
			}
		}
	}
}
