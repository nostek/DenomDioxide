package com.tbbgc.denom.nodes.events {
	import com.tbbgc.denom.interfaces.INodeEvent;
	import com.tbbgc.denom.input.NodeInput;
	import com.tbbgc.denom.interfaces.INode;
	import com.tbbgc.denom.node.BaseNode;
	import com.tbbgc.denom.parameters.NodeParameter;

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

		private function onStart(... args):* {
			_started = true;

			_start.runConnections.apply(null, args);
		}
		private function onStop(... args):* {
			_started = false;

			_stop.runConnections.apply(null, args);
		}

		public function get eventName() : String {
			return _name.value as String;
		}

		public function start(...args):void {
			onStart.apply(null, args);
		}

		public function stop(...args):void {
			onStop.apply(null, args);
		}

		public function set isStarted(value:Boolean):void {
			_started = value;
		}

		public function get isStarted() : Boolean {
			return _started;
		}
	}
}
