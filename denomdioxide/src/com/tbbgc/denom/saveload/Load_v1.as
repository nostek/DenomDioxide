package com.tbbgc.denom.saveload {
	import com.tbbgc.denom.common.input.NodeInput;
	import com.tbbgc.denom.common.models.AvailableNodes;
	import com.tbbgc.denom.common.parameters.NodeParameter;
	import com.tbbgc.denom.models.FlowModel;
	import com.tbbgc.denom.node.BaseNode;

	import flash.utils.getQualifiedClassName;
	/**
	 * @author Simon
	 */
	public class Load_v1 {
		public static function run(data:Object):Vector.<FlowModel> {
			var flows:Vector.<FlowModel> = new Vector.<FlowModel>();

			var views:Array = data["views"];

			var flow:FlowModel;
			var obj:Object;
			var c:Class;
			var node:BaseNode;

			for each( var view:Object in views ) {
				flow = new FlowModel();
				flow.name = view["name"];

				flow.nodes = new Vector.<BaseNode>();

				for each( obj in view["nodes"] ) {
					c = getClass( obj["id"] );
					node = new c();

					flow.nodes[ obj["index"] ] = node;

					node.x = obj["x"];
					node.y = obj["y"];

					loadParameters(node, obj["params"]);
				}

				for each( obj in view["nodes"] ) {
					node = flow.nodes[ obj["index"] ];

					loadInputs(node, obj["inputs"], flow.nodes);
				}

				flows.push( flow );
			}
			
			return flows;
		}
		
		private static function loadInputs( node:BaseNode, data:Object, nodes:Vector.<BaseNode> ):void {
			var name:String, cname:String;
			var input:NodeInput, cinput:NodeInput;;
			var child:BaseNode;
			var conn:Object;

			for each( var obj:Object in data ) {
				name = obj["name"];

				for each( input in node.getRight() ) {
					if( input.name == name ) {
						for each( conn in obj["connections"] ) {
							child = nodes[ conn["index"] ];
							cname = conn["name"];

							for each( cinput in child.getLeft() ) {
								if( cinput.name == cname ) {
									input.connect( cinput );
									cinput.connect( input );
								}
							}
						}
					}
				}
			}
		}

		private static function loadParameters( node:BaseNode, data:Object ):void {
			for( var key:String in data ) {
				for each( var param:NodeParameter in node.getParameters() ) {
					if( param.name == key ) {
						param.value = data[key];
					}
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
	}
}
