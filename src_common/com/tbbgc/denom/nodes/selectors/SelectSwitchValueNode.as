package com.tbbgc.denom.nodes.selectors {
	import com.tbbgc.denom.input.NodeInput;
	import com.tbbgc.denom.parameters.NodeParameter;
	import com.tbbgc.denom.node.BaseNode;
	import com.tbbgc.denom.interfaces.INode;

	/**
	 * @author simonrodriguez
	 */
	public class SelectSwitchValueNode extends BaseNode implements INode {
		private var _get:NodeInput;

		private var _value:NodeInput;

		private var _param:NodeParameter;

		public function SelectSwitchValueNode() {
			_get = new NodeInput(this, "GET", onGet);

			_value = new NodeInput(this, "VALUE", null, true);

			_param = new NodeParameter("VALUE", "text");

			left( _get );

			right( _value );

			parameters( _param );

			super();
		}

		public function get nodeName() : String {
			return "SWITCH VALUE";
		}

		private function onGet(...args):* {
			return _value.runFirst();
		}
	}
}
