package com.tbbgc.denom.common.nodes.events {
	import com.tbbgc.denom.common.input.NodeInput;
	import com.tbbgc.denom.common.interfaces.INode;
	import com.tbbgc.denom.common.parameters.NodeParameter;
	import com.tbbgc.denom.node.BaseNode;

	/**
	 * @author simonrodriguez
	 */
	public class PostEventNode extends BaseNode implements INode {
		private var _run:NodeInput;

		private var _values:NodeInput;

		private var _id:NodeParameter;

		public function PostEventNode() {
			_run = new NodeInput(this, "RUN", onRun);

			_values = new NodeInput(this, "VALUES", null);

			_id = new NodeParameter("ID", "undefined");

			left( _run );

			right( _values );

			parameters( _id );

			super();
		}

		public function get nodeName() : String {
			return "POST EVENT";
		}

		/////////////////////

		private function onRun(...args):* {
			var data:Array = [];

			const connections:Vector.<NodeInput> = _values.connections;

			const len:int = connections.length;
			for (var i:int = 0; i < len; i++) {
				data.push( connections[i].run() );
			}

			this.shared.onPostEvent.dispatch( _id.value as String, data );
		}
	}
}
