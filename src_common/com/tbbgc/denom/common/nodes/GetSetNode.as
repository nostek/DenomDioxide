package com.tbbgc.denom.common.nodes {
	import com.tbbgc.denom.common.input.NodeInput;
	import com.tbbgc.denom.common.interfaces.INode;
	import com.tbbgc.denom.node.BaseNode;

	/**
	 * @author simonrodriguez
	 */
	public class GetSetNode extends BaseNode implements INode {
		private var _run:NodeInput;

		private var _get:NodeInput;
		private var _set:NodeInput;

		public function GetSetNode() {
			_run = new NodeInput(this, "RUN", onRun);

			_get = new NodeInput(this, "GET", null, true);
			_set = new NodeInput(this, "SET", null);

			left( _run );

			right( _get, _set );

			super();
		}

		public function get nodeName() : String {
			return "GETSET";
		}

		private function onRun(...args):* {
			if( _get.haveConnections && _set.haveConnections ) {
				_set.runConnections( _get.runFirst() );
			}
		}
	}
}
