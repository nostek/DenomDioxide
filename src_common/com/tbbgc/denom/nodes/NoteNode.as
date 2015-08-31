package com.tbbgc.denom.nodes {
	import com.tbbgc.denom.parameters.NodeParameter;
	import com.tbbgc.denom.node.BaseNode;
	import com.tbbgc.denom.interfaces.INode;

	/**
	 * @author simonrodriguez
	 */
	public class NoteNode extends BaseNode implements INode {
		private var _note:NodeParameter;

		public function NoteNode() {
			_note = new NodeParameter("NOTE", "");

			parameters( _note );

			super();
		}

		public function get nodeName() : String {
			return "NOTE";
		}
	}
}
