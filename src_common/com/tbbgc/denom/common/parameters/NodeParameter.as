package com.tbbgc.denom.common.parameters {
	/**
	 * @author simonrodriguez
	 */
	public class NodeParameter {
		private var _name:String;
		private var _value:*;

		private var _onChange:Function;

		public function NodeParameter( name:String, value:*, onChange:Function=null ) {
			_name = name;
			_value = value;
			_onChange = onChange;
		}

		public function get name():String { return _name; }

		public function get value():* { return _value; }

		public function set value(value:*):void {
			_value = value;

			if( _onChange != null ) {
				_onChange();
			}
		}
	}
}
