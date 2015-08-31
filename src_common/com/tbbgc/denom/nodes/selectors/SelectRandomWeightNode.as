package com.tbbgc.denom.nodes.selectors {
	import com.tbbgc.denom.parameters.NodeParameter;
	import com.tbbgc.denom.input.NodeInput;
	import com.tbbgc.denom.node.BaseNode;
	import com.tbbgc.denom.interfaces.INode;

	/**
	 * @author simonrodriguez
	 */
	public class SelectRandomWeightNode extends BaseNode implements INode {
		private var _get:NodeInput;

		private var _value:NodeInput;

		private var _weight:NodeParameter;

		public function SelectRandomWeightNode() {
			_get = new NodeInput(this, "GET", onGet);

			_value = new NodeInput(this, "VALUE", null, true);

			_weight = new NodeParameter("WEIGHT", 50);

			left( _get );

			right( _value );

			parameters( _weight );

			super();
		}

		public function get nodeName() : String {
			return "RANDOM WEIGHT";
		}

		private function onGet(...args):* {
			return _value.runFirst();
		}
	}
}
