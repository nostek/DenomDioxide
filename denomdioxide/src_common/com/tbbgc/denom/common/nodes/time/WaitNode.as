package com.tbbgc.denom.common.nodes.time {
	import com.tbbgc.denom.common.input.NodeInput;
	import com.tbbgc.denom.common.interfaces.INode;
	import com.tbbgc.denom.node.BaseNode;

	import flash.utils.getTimer;

	/**
	 * @author simonrodriguez
	 */
	public class WaitNode extends BaseNode implements INode {
		private var _start:NodeInput;
		private var _stop:NodeInput;

		private var _time:NodeInput;
		private var _onTick:NodeInput;
		private var _onDone:NodeInput;

		private var _timer:uint;

		public function WaitNode() {
			_start = new NodeInput(this, "START", onStart);
			_stop = new NodeInput(this, "STOP", onStop);

			_time = new NodeInput(this, "TIME", null, true);
			_onTick = new NodeInput(this, "ON_TICK", null);
			_onDone = new NodeInput(this, "ON_DONE", null);

			_timer = 0;

			left( _start, _stop );

			right ( _time, _onTick, _onDone );

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
			return "WAIT";
		}

		private function onStart(...args):* {
			_timer = getTimer() + _time.runFirst() as Number;

			this.shared.onEnterFrame.add( onUpdate );
		}

		private function onStop(...args):* {
			if( _timer != 0 ) {
				_timer = 0;

				this.shared.onEnterFrame.remove( onUpdate );
			}
		}

		private function onUpdate():void {
			if( getTimer() >= _timer ) {
				_timer = 0;

				this.shared.onEnterFrame.remove( onUpdate );

				_onDone.runConnections();
			} else {
				_onTick.runConnections();
			}
		}
	}
}
