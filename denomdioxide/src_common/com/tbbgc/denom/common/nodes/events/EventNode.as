package com.tbbgc.denom.common.nodes.events {
	import com.tbbgc.denom.common.input.NodeInput;
	import com.tbbgc.denom.common.interfaces.INode;
	import com.tbbgc.denom.common.interfaces.INodeEvent;
	import com.tbbgc.denom.common.parameters.NodeParameter;
	import com.tbbgc.denom.node.BaseNode;

	/**
	 * @author simonrodriguez
	 */
	public class EventNode extends BaseNode implements INode, INodeEvent {
		private var _start:NodeInput;
		private var _stop:NodeInput;

		private var _name:NodeParameter;

		private var _started:Boolean;

		public function EventNode() {
			_start = new NodeInput(this, "ON_START", onStart);
			_stop = new NodeInput(this, "ON_STOP", onStop);

			_name = new NodeParameter("NAME", "undefined");

			right( _start, _stop );

			parameters( _name );

			_started = false;

			super();
		}

		public function get nodeName() : String {
			return "EVENT";
		}

		override public function test() : void {
			onStart();
		}

		private function onStart():* {
			_started = true;

			_start.runConnections();
		}
		private function onStop():* {
			_started = false;

			_stop.runConnections();
		}

		public function get eventName() : String {
			return _name.value as String;
		}

		public function start():void {
			onStart();
		}

		public function stop():void {
			onStop();
		}

		public function set isStarted(value:Boolean):void {
			_started = value;
		}

		public function get isStarted() : Boolean {
			return _started;
		}
	}
}
