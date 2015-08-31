package com.tbbgc.denom.common.nodes.selectors {
	import com.tbbgc.denom.common.input.NodeInput;
	import com.tbbgc.denom.common.interfaces.INode;
	import com.tbbgc.denom.common.parameters.NodeParameter;
	import com.tbbgc.denom.node.BaseNode;

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
