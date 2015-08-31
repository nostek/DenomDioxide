package com.tbbgc.denom.nodes.values {
	import com.tbbgc.denom.input.NodeInput;
	import com.tbbgc.denom.interfaces.INode;
	import com.tbbgc.denom.node.BaseNode;
	import com.tbbgc.denom.parameters.NodeParameter;

	/**
	 * @author simonrodriguez
	 */
	public class NumberNode extends BaseNode implements INode {
		private var _get:NodeInput;
		private var _set:NodeInput;

		private var _number:NodeParameter;

		public function NumberNode() {
			_get = new NodeInput(this, "GET", onGet);
			_set = new NodeInput(this, "SET", onSet);

			_number = new NodeParameter("VALUE", 2000);

			left( _get, _set );

			parameters( _number );

			super();
		}

		public function get nodeName() : String {
			return "NUMBER";
		}

		private function onGet(...args):* {
			return _number.value as Number;
		}

		private function onSet(...args):* {
			if( args.length != 1 ) return null;

			const value:Number = args[0] as Number;

			this.setParameter(null, value);
		}
	}
}
