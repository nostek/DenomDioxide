package com.tbbgc.denom.utils {
	import org.osflash.signals.Signal;
	/**
	 * @author simonrodriguez
	 */
	public class ValueSignal {
		private var _value:*;
		private var _onChanged:Signal = new Signal();

		public function ValueSignal(def:*) {
			_value = def;
		}

		public function set value(value:*):void { _value = value; _onChanged.dispatch(); }
		public function get value():* { return _value; }

		public function set valueAsInt(value:int):void { _value = value; _onChanged.dispatch(); }
		public function get valueAsInt():int { return _value as int; }

		public function set valueAsNumber(value:Number):void { _value = value; _onChanged.dispatch(); }
		public function get valueAsNumber():Number { return _value as Number; }

		public function get onChanged():Signal { return _onChanged; }
	}
}
