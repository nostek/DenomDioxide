package com.tbbgc.denom.common.nodes.values {
	import com.tbbgc.denom.common.input.NodeInput;
	import com.tbbgc.denom.common.interfaces.INode;
	import com.tbbgc.denom.common.parameters.NodeParameter;
	import com.tbbgc.denom.node.BaseNode;

	/**
	 * @author simonrodriguez
	 */
	public class TextNode extends BaseNode implements INode {
		private var _get:NodeInput;

		private var _text:NodeParameter;

		public function TextNode() {
			_get = new NodeInput(this, "GET", onGet);

			_text = new NodeParameter("TEXT", "Test Text");

			left( _get );

			parameters( _text );

			super();
		}

		public function get nodeName() : String {
			return "TEXT";
		}

		private function onGet():* {
			return _text.value as String;
		}
	}
}
