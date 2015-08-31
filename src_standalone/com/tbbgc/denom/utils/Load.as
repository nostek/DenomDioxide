package com.tbbgc.denom.utils {
	import com.tbbgc.denom.interfaces.INodeParameter;
	import com.tbbgc.denom.flow.DenomFlow;
	import com.tbbgc.denom.input.NodeInput;
	import com.tbbgc.denom.interfaces.INode;
	import com.tbbgc.denom.models.AvailableNodes;
	import com.tbbgc.denom.node.BaseNode;
	import com.tbbgc.denom.nodes.events.PostEventNode;
	import com.tbbgc.denom.parameters.NodeParameter;

	import flash.utils.getQualifiedClassName;
	/**
	 * @author simonrodriguez
	 */
	public class Load {
		public static const FORCE_LOAD:Boolean = false;

		public function run( view:Array, flow:DenomFlow ):Vector.<INode> {
			var obj:Object;

			var len:int = 0;
			for( obj in view ) {
				len++;
			}

			var nodes:Vector.<INode> = new Vector.<INode>( len, true );

			var node:INode;
			var c:Class;

			for each( obj in view ) {
				c = getclass( obj["id"] );
				node = new c();

				(node as BaseNode).flow = flow;

				if( node is PostEventNode ) {
					(node as PostEventNode).signal = flow.onEvent;
				}

				nodes[ obj["index"] ] = node;

				loadparams(node, obj["params"]);
			}

			for( var i:int = 0; i < len; i++ ) {
				if( nodes[i] is INodeParameter ) {
					for( var x:int = i+1; x < len; x++ ) {
						if( nodes[x] is INodeParameter && (nodes[i] as INodeParameter).parameterName == (nodes[x] as INodeParameter).parameterName ) {
							nodes[x] = nodes[i];
						}
					}
				}
			}

			for each( obj in view ) {
				node = nodes[ obj["index"] ];

				loadinputs(node, obj["inputs"], nodes);
			}

			return nodes;
		}

		//////////////////////////////////////////

		private function loadinputs( node:INode, data:Object, nodes:Vector.<INode> ):void {
			var name:String, cname:String;
			var input:NodeInput, cinput:NodeInput;;
			var child:BaseNode;
			var conn:Object;

			for each( var obj:Object in data ) {
				name = obj["name"];

				for each( input in (node as BaseNode).getRight() ) {
					if( input.name == name ) {
						for each( conn in obj["connections"] ) {
							child = nodes[ conn["index"] ] as BaseNode;
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

		private function loadparams( node:INode, data:Object ):void {
			for( var key:String in data ) {
				for each( var param:NodeParameter in (node as BaseNode).getParameters() ) {
					if( param.name == key ) {
						param.value = data[key];
					}
				}
			}
		}

		private function getclass( name:String ):Class {
			for each( var c:Class in AvailableNodes.AVAILABLE_NODES ) {
				if( nodename(c) == name ) {
					return c;
				}
			}

			return null;
		}

		private function nodename( c:Class ):String {
			var className : String = getQualifiedClassName(c);
			return className.slice(className.lastIndexOf("::") + 2);
		}
	}
}
