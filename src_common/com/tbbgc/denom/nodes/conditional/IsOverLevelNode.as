package com.tbbgc.denom.nodes.conditional {
	import com.tbbgc.denom.input.NodeInput;
	import com.tbbgc.denom.interfaces.INode;
	import com.tbbgc.denom.node.BaseNode;

	/**
	 * @author simonrodriguez
	 */
	public class IsOverLevelNode extends BaseNode implements INode {
		private var _setup:NodeInput;
		private var _run:NodeInput;

		private var _value:NodeInput;
		private var _nodes:NodeInput;

		private var _last:Number;

		public function IsOverLevelNode() {
			_setup 	= new NodeInput(this, "INIT", onSetup);
			_run 	= new NodeInput(this, "RUN", onRun);

			_value = new NodeInput(this, "VALUE", null, true);
			_nodes = new NodeInput(this, "NODES", null);

			left( _setup, _run );
			right( _value, _nodes );

			_last = 0;

			super();
		}

		public function get nodeName() : String {
			return "IS OVER LEVEL";
		}

		override public function test() : void {
			onRun();
		}

		private function onSetup(...args):* {
			if( _value.haveConnections ) {
				_last = _value.runFirst() as Number;
			}
		}

		private function onRun(...args):* {
			if( _value.haveConnections && _nodes.haveConnections ) {
				const value:Number = _value.runFirst() as Number;
				if( !isNaN(value) ) {
					const last:Number = _last;

					_nodes.runConnections( value, last );

					_last = value;
				}
			}
		}
	}
}
