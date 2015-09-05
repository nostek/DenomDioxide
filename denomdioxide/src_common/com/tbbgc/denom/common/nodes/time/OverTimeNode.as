package com.tbbgc.denom.common.nodes.time {
	import com.tbbgc.denom.common.input.NodeInput;
	import com.tbbgc.denom.common.interfaces.INode;
	import com.tbbgc.denom.node.BaseNode;

	import flash.utils.getTimer;

	/**
	 * @author simonrodriguez
	 */
	public class OverTimeNode extends BaseNode implements INode {
		private var _start:NodeInput;
		private var _stop:NodeInput;
		private var _get:NodeInput;

		private var _time:NodeInput;
		private var _a:NodeInput;
		private var _b:NodeInput;
		private var _onTick:NodeInput;
		private var _onDone:NodeInput;

		private var _timer:uint;

		public function OverTimeNode() {
			_start 	= new NodeInput(this, "START", onStart);
			_stop	= new NodeInput(this, "STOP", onStop);
			_get  	= new NodeInput(this, "GET", onGet);

			_time 	= new NodeInput(this, "TIME", null, true);
			_a 		= new NodeInput(this, "A", null, true);
			_b 		= new NodeInput(this, "B", null, true);
			_onTick 	= new NodeInput(this, "ON_TICK", null);
			_onDone	= new NodeInput(this, "ON_DONE", null);

			left( _start, _stop, _get );

			right( _time, _a, _b, _onTick, _onDone );

			_timer = 0;

			super();
		}

		override public function test() : void {
			if( _timer == 0 ) {
				onStart();
			} else {
				onStop();
			}
		}

		override public function reset():void {
			onStop();
		}

		public function get nodeName() : String {
			return "OVER TIME";
		}

		private function onStart(...args):* {
			if( _timer == 0 ) {
				this.shared.onEnterFrame.add(onUpdate);
			}

			_timer = getTimer();
		}

		private function onStop(...args):* {
			if( _timer != 0 ) {
				_timer = 0;

				this.shared.onEnterFrame.remove(onUpdate);
			}
		}

		private function onGet(...args):* {
			const t:Number = _time.haveConnections ? _time.runFirst() as Number : 0;
			const a:Number = _a.haveConnections ? _a.runFirst() as Number : 0;
			const b:Number = _b.haveConnections ? _b.runFirst() as Number : 0;

			if( _timer == 0 ) {
				return a;
			}

			const time:uint = Math.min( t, getTimer() - _timer);

			var ret:Number = a + (b - a) * (time/t);

			return ret;
		}

		private function onUpdate():void {
			_onTick.runConnections();

			const t:Number = _time.haveConnections ? _time.runFirst() as Number : 0;
			const time:uint = getTimer() - _timer;

			if( time >= t ) {
				onStop();

				_onDone.runConnections();
			}
		}
	}
}
