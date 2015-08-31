package com.tbbgc.denom.nodes.math {
	import com.tbbgc.denom.input.NodeInput;
	import com.tbbgc.denom.node.BaseNode;
	import com.tbbgc.denom.interfaces.INode;

	/**
	 * @author simonrodriguez
	 */
	public class RoundNode extends BaseNode implements INode {
		private var _get:NodeInput;

		private var _value:NodeInput;

		public function RoundNode() {
			_get = new NodeInput(this, "GET", onGet);

			_value = new NodeInput(this, "VALUE", null, true);

			left( _get );

			right( _value );

			super();
		}

		public function get nodeName() : String {
			return "ROUND";
		}

		private function onGet(...args):* {
			if( !_value.haveConnections ) {
				return null;
			}

			const value:Number = _value.runFirst() as Number;

			if( !isNaN(value) ) {
				return Math.round(value);
			}

			return null;
		}
	}
}
