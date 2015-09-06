package com.tbbgc.denom.common.nodes.values {
	import com.tbbgc.denom.common.input.NodeInput;
	import com.tbbgc.denom.common.interfaces.INode;
	import com.tbbgc.denom.common.parameters.NodeParameter;
	import com.tbbgc.denom.node.BaseNode;

	/**
	 * @author simonrodriguez
	 */
	public class NumberNode extends BaseNode implements INode {
		private var _get:NodeInput;

		private var _number:NodeParameter;

		public function NumberNode() {
			_get = new NodeInput(this, "GET", onGet);

			_number = new NodeParameter("VALUE", 2000);

			left( _get );

			parameters( _number );

			super();
		}

		public function get nodeName() : String {
			return "NUMBER";
		}

		private function onGet():* {
			return _number.value as Number;
		}
	}
}
