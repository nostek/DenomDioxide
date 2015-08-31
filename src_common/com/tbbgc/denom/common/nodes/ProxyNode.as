package com.tbbgc.denom.common.nodes {
	import com.tbbgc.denom.common.input.NodeInput;
	import com.tbbgc.denom.common.interfaces.INode;
	import com.tbbgc.denom.node.BaseNode;

	/**
	 * @author simonrodriguez
	 */
	public class ProxyNode extends BaseNode implements INode {
		private var _in:NodeInput;
		private var _out:NodeInput;

		public function ProxyNode() {
			_in = new NodeInput(this, "IN", onIn);

			_out = new NodeInput(this, "OUT", null);

			left( _in );

			right( _out );

			super();
		}

		public function get nodeName() : String {
			return "PROXY";
		}

		private function onIn(...args):* {
			_out.runConnections.apply(null, args);
		}
	}
}
