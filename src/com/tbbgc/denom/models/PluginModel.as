package com.tbbgc.denom.models {
	/**
	 * @author Simon
	 */
	public class PluginModel {
		private var _data:Object;
		
		private var _name:String;
		
		public function PluginModel(data:Object) {
			_data = data;
			
			_name = data["name"];
		}
		
		public function get name():String {
			return _name;
		}
		
		public function get data():Object {
			return _data;
		}
	}
}
