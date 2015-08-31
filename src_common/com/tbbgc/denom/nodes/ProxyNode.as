package com.tbbgc.denom.nodes {
	import com.tbbgc.denom.input.NodeInput;
	import com.tbbgc.denom.node.BaseNode;
	import com.tbbgc.denom.interfaces.INode;

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
