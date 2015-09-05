package com.tbbgc.denom.common.nodes {
	import com.tbbgc.denom.common.interfaces.INode;
	import com.tbbgc.denom.common.parameters.NodeParameter;
	import com.tbbgc.denom.node.BaseNode;

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
