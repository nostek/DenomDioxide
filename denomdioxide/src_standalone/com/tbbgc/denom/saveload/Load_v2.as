package com.tbbgc.denom.saveload {
	import com.tbbgc.denom.common.input.NodeInput;
	import com.tbbgc.denom.common.models.AvailableNodes;
	import com.tbbgc.denom.common.models.DenomShared;
	import com.tbbgc.denom.common.nodes.PluginNode;
	import com.tbbgc.denom.common.parameters.NodeParameter;
	import com.tbbgc.denom.node.BaseNode;

	import flash.utils.getQualifiedClassName;
	/**
	 * @author simon
	 */
	public class Load_v2 {
		public static function run(shared:DenomShared, strings:Array, view:Object):Vector.<BaseNode> {
			var nodes:Vector.<BaseNode> = new Vector.<BaseNode>();

			var obj:Object;
			var c:Class;
			var node:BaseNode;
			var i:int;
			var p:Object;

			const len:int = view.length;

			for (i = 0; i < len; i++) {
				obj = view[i];

				c = getClass( unpackString(strings, obj[SLKeys.NODE_ID]) );

				if (c == PluginNode) {
					p = JSON.parse(unpackString(strings, obj[SLKeys.NODE_PLUGIN_DATA]));

					if (p == null) {
						continue;
					}

					node = new c(p);
				} else {
					node = new c();
				}

				node.shared = shared;

				nodes.push(node);

				if (obj[SLKeys.NODE_PARAMS] != null) {
					loadParameters(strings, node, obj[SLKeys.NODE_PARAMS]);
				}
			}

			for (i = 0; i < len; i++) {
				obj = view[i];

				node = nodes[i];

				if (obj[SLKeys.NODE_INPUTS] != null) {
					loadInputs(strings, node, obj[SLKeys.NODE_INPUTS], nodes);
				}
			}

			return nodes;
		}

		private static function loadInputs( strings:Array, node:BaseNode, data:Object, nodes:Vector.<BaseNode> ):void {
			var r:NodeInput, l:NodeInput;

			for each (var obj:Object in data) {
				r = node.getRightByName(unpackString(strings, obj[SLKeys.INPUT_NAME]));

				if (r != null) {
					for each( var cobj:Object in obj[SLKeys.INPUT_CONNECTIONS] ) {
						l = nodes[ cobj[SLKeys.CONNECTION_INDEX] ].getLeftByName(unpackString(strings, cobj[SLKeys.CONNECTION_NAME]));

						if (l != null) {
							r.connect(l);
							l.connect(r);
						}
					}
				}
			}
		}

		private static function loadParameters( strings:Array, node:BaseNode, data:Object ):void {
			var p:NodeParameter;

			for (var key:int in data) {
				p = node.getParameterByName(unpackString(strings, key));
				if (p != null) {
					p.value = unpackString(strings, data[key]);
				}
			}
		}

		private static function getClass( name:String ):Class {
			for each( var c:Class in AvailableNodes.AVAILABLE_NODES ) {
				if( nodeName(c) == name ) {
					return c;
				}
			}

			return null;
		}

		private static function nodeName( c:Class ):String {
			var className : String = getQualifiedClassName(c);
			return className.slice(className.lastIndexOf("::") + 2);
		}

		private static function unpackString( strings:Array, i:int ):* {
			return strings[i];
		}
	}
}
