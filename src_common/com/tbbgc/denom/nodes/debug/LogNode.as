package com.tbbgc.denom.nodes.debug {
	import com.tbbgc.denom.input.NodeInput;
	import com.tbbgc.denom.interfaces.INode;
	import com.tbbgc.denom.node.BaseNode;

	/**
	 * @author simonrodriguez
	 */
	public class LogNode extends BaseNode implements INode {
		private var _run:NodeInput;

		private var _value:NodeInput;

		public function LogNode() {
			_run = new NodeInput(this, "RUN", onRun);

			_value = new NodeInput(this, "VALUE", null, true);

			left( _run );

			right( _value );

			super();
		}

		override public function test() : void {
			onRun();
		}

		public function get nodeName() : String {
			return "LOG";
		}

		private function onRun(...args):* {
			this.logText( _value.runFirst() );
		}
	}
}
