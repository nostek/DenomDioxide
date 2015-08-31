package com.tbbgc.denom.utils {
	import com.tbbgc.denom.managers.SettingsManager;
	import com.tbbgc.denom.input.NodeInput;
	import com.tbbgc.denom.models.AvailableNodes;
	import com.tbbgc.denom.models.FlowModel;
	import com.tbbgc.denom.node.BaseNode;
	import com.tbbgc.denom.parameters.NodeParameter;

	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.FileFilter;
	import flash.utils.getQualifiedClassName;
	/**
	 * @author simonrodriguez
	 */
	public class Load {
		private static var _lastUsedFile:File;

		private static var _onComplete:Function;
		private static var _onPreLoad:Function;

		public static function get lastUsedFile():File { return _lastUsedFile; }

		public static function runFirst( onPreLoad:Function, onComplete:Function ):void {
			if( SettingsManager.haveItem( SettingsManager.SETTINGS_JSON) ) {
				_onPreLoad = onPreLoad;
				_onComplete = onComplete;

				var path:String = SettingsManager.getItem( SettingsManager.SETTINGS_JSON ) as String;

				onFileSelect( null, path );
			}
		}

		public static function run( onPreLoad:Function, onComplete:Function ):void {
			_onPreLoad = onPreLoad;
			_onComplete = onComplete;

			var jsons:FileFilter = new FileFilter("Json", "*.json");
			var f:File = new File();
			f.addEventListener(Event.SELECT, onFileSelect);
			f.browseForOpen("Open denom flow", [jsons]);
		}

		private static function onFileSelect( e:Event, path:String=null ):void {
			_onPreLoad();

			var f:File;

			if( path != null ) {
				f = new File( path );
			} else {
				f = e.target as File;
			}

			var stream:FileStream = new FileStream();
			stream.open(f, FileMode.READ);
			var json:String = stream.readUTFBytes(stream.bytesAvailable);
			stream.close();

			load( JSON.parse(json) );

			SettingsManager.setItem( SettingsManager.SETTINGS_JSON, f.nativePath );

			_lastUsedFile = f;
		}

		private static function load( data:Object ):void {
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

			_onComplete( flows );
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
