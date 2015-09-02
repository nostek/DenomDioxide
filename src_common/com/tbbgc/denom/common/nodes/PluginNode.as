package com.tbbgc.denom.common.nodes {
	import com.tbbgc.denom.common.input.NodeInputPlugin;
	import com.tbbgc.denom.common.interfaces.INode;
	import com.tbbgc.denom.common.parameters.NodeParameter;
	import com.tbbgc.denom.node.BaseNode;
	/**
	 * @author Simon
	 */
	public class PluginNode extends BaseNode implements INode {
		private var _name:String;
		
		public function PluginNode(data:Object) {
			_name = data["name"];
			
			var len:int;
			var i:int;
			
			var o:Array;
			var a:Array;
			
			a = data["params"];
			if (a != null) {
				o = [];
				
				len = a.length;
				
				for (i = 0; i < len; i++) {
					o.push( new NodeParameter(a[i]["name"], a[i]["value"]) );
				}
				
				parameters.apply(null, o);
			}
			
			a = data["left"];
			if (a != null) {
				o = [];
				
				len = a.length;
				
				for (i = 0; i < len; i++) {
					o.push( new NodeInputPlugin(this, a[i]["name"], onLeft, a[i]["id"], (a[i]["single"] != null) ? a[i]["single"] as Boolean : false) );
				}
				
				left.apply(null, o);
			}
							
			super();
		}

		public function get nodeName() : String {
			return "PLUGIN: " + _name;
		}
		
		private function onLeft(id:String, args:Array):* {
			trace(id, args);
			return this.getParameters()[0].value; //TODO
		}
	}
}
