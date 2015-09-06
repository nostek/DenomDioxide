package com.tbbgc.denom.utils {
	/**
	 * @author Simon
	 */
	public class ObjectEx {
		public static function numChildren( data:Object ):int {
			var c:int = 0;
			for each (var o:Object in data) {
				o;
				c++;
			}
			return c;
		}
		public static function select( data:Object, key:String, _def:*):* {
			if( data[key] != null ) {
				return data[key];
			}
			return _def;
		}
	}
}
