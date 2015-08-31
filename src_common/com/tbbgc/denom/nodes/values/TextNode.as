package com.tbbgc.denom.nodes.values {
	import com.tbbgc.denom.input.NodeInput;
	import com.tbbgc.denom.interfaces.INode;
	import com.tbbgc.denom.node.BaseNode;
	import com.tbbgc.denom.parameters.NodeParameter;

	/**
	 * @author simonrodriguez
	 */
	public class TextNode extends BaseNode implements INode {
		private var _get:NodeInput;
		private var _set:NodeInput;

		private var _text:NodeParameter;

		public function TextNode() {
			_get = new NodeInput(this, "GET", onGet);
			_set = new NodeInput(this, "SET", onSet);

			_text = new NodeParameter("TEXT", "Test Text");

			left( _get, _set );

			parameters( _text );

			super();
		}

		public function get nodeName() : String {
			return "TEXT";
		}

		private function onGet(...args):* {
			return _text.value as String;
		}

		private function onSet(...args):* {
			if( args.length != 1 ) return null;

			const value:String = args[0] as String;

			this.setParameter(null, value);
		}
	}
}
