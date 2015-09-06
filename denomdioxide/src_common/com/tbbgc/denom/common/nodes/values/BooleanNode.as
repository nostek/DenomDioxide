package com.tbbgc.denom.common.nodes.values {
	import com.tbbgc.denom.common.input.NodeInput;
	import com.tbbgc.denom.common.interfaces.INode;
	import com.tbbgc.denom.common.parameters.NodeParameter;
	import com.tbbgc.denom.node.BaseNode;

	/**
	 * @author simonrodriguez
	 */
	public class BooleanNode extends BaseNode implements INode {
		private var _get:NodeInput;

		private var _bool:NodeParameter;

		public function BooleanNode() {
			_get = new NodeInput(this, "GET", onGet);

			_bool = new NodeParameter("VALUE", true);

			left( _get );

			parameters( _bool );

			super();
		}

		public function get nodeName() : String {
			return "BOOLEAN";
		}

		private function onGet():* {
			return _bool.value as Boolean;
		}
	}
}
