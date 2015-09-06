package com.tbbgc.denom.common.nodes {
	import com.tbbgc.denom.Denom;
	import com.tbbgc.denom.common.input.NodeInput;
	import com.tbbgc.denom.common.input.NodeInputPlugin;
	import com.tbbgc.denom.common.interfaces.INode;
	import com.tbbgc.denom.common.interfaces.INodePlugin;
	import com.tbbgc.denom.common.parameters.NodeParameter;
	import com.tbbgc.denom.node.BaseNode;
	/**
	 * @author Simon
	 */
	public class PluginNode extends BaseNode implements INode, INodePlugin {
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

				this.parameters.apply(null, o);
			}

			a = data["left"];
			if (a != null) {
				o = [];

				len = a.length;

				for (i = 0; i < len; i++) {
					o.push( new NodeInputPlugin(this, a[i]["name"], onLeft, a[i]["id"], a[i]["def"]) );
				}

				this.left.apply(null, o);
			}

			a = data["right"];
			if (a != null) {
				o = [];

				len = a.length;

				for (i = 0; i < len; i++) {
					o.push( new NodeInput(this, a[i]["name"], null, (a[i]["single"] != null) ? a[i]["single"] as Boolean : false) );
				}

				this.right.apply(null, o);
			}

			super();
		}

		public function get nodeName() : String {
			return "PLUGIN: " + pluginName;
		}

		public function get pluginName() : String {
			return _name;
		}

		public function runRight(name:String):* {
			var n:NodeInput = this.getRightByName(name);
			if (n != null && n.haveConnections) {
				if (n.single) {
					return n.runFirst();
				} else {
					n.runConnections();
				}
			}
			return null;
		}

		public function haveRight(name:String):Boolean {
			var n:NodeInput = this.getRightByName(name);
			return (n != null && n.haveConnections);
		}

		private function onLeft(id:String):* {
			if (!Denom.IS_EDITOR) {
				return this.shared.runPlugin(id, this);
			}
			return getLeftPluginById(id).def;
		}

		private function getLeftPluginById(id:String):NodeInputPlugin {
			var p:Vector.<NodeInput> = this.getLeft();

			const len:int = p.length;
			for (var i:int = 0; i < len; i++) {
				if (p[i] is NodeInputPlugin && (p[i] as NodeInputPlugin).id == id) {
					return p[i] as NodeInputPlugin;
				}
			}

			return null;
		}
	}
}
