package com.tbbgc.denom.common.nodes.selectors {
	import com.tbbgc.denom.common.input.NodeInput;
	import com.tbbgc.denom.common.interfaces.INode;
	import com.tbbgc.denom.common.parameters.NodeParameter;
	import com.tbbgc.denom.node.BaseNode;

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
