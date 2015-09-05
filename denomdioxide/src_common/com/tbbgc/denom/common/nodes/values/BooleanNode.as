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
		private var _set:NodeInput;

		private var _bool:NodeParameter;

		public function BooleanNode() {
			_get = new NodeInput(this, "GET", onGet);
			_set = new NodeInput(this, "SET", onSet);

			_bool = new NodeParameter("VALUE", true);

			left( _get, _set );

			parameters( _bool );

			super();
		}

		public function get nodeName() : String {
			return "BOOLEAN";
		}

		private function onGet(...args):* {
			return _bool.value as Boolean;
		}

		private function onSet(...args):* {
			if( args.length != 1 ) return null;

			const value:Boolean = args[0] as Boolean;

			this.setParameter(null, value);
		}
	}
}
