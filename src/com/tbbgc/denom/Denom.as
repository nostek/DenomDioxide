package com.tbbgc.denom {
	import avmplus.getQualifiedClassName;

	import fl.controls.Button;
	import fl.controls.ComboBox;
	import fl.events.ComponentEvent;

	import com.tbbgc.denom.common.managers.DenomFileManager;
	import com.tbbgc.denom.common.models.AvailableNodes;
	import com.tbbgc.denom.common.models.DenomShared;
	import com.tbbgc.denom.common.nodes.GetSetNode;
	import com.tbbgc.denom.common.nodes.PluginNode;
	import com.tbbgc.denom.common.nodes.conditional.IfNode;
	import com.tbbgc.denom.common.nodes.conditional.IsBetweenNode;
	import com.tbbgc.denom.common.nodes.conditional.IsOverLevelNode;
	import com.tbbgc.denom.common.nodes.conditional.OverLevelValueNode;
	import com.tbbgc.denom.common.nodes.debug.LogNode;
	import com.tbbgc.denom.common.nodes.events.EventNode;
	import com.tbbgc.denom.common.nodes.events.PostEventNode;
	import com.tbbgc.denom.common.nodes.math.AddNode;
	import com.tbbgc.denom.common.nodes.math.Deg2RadNode;
	import com.tbbgc.denom.common.nodes.math.InvertNode;
	import com.tbbgc.denom.common.nodes.math.MultiplyNode;
	import com.tbbgc.denom.common.nodes.math.RoundNode;
	import com.tbbgc.denom.common.nodes.math.SubtractNode;
	import com.tbbgc.denom.common.nodes.parameters.AsPointNode;
	import com.tbbgc.denom.common.nodes.parameters.ParameterNode;
	import com.tbbgc.denom.common.nodes.selectors.SelectRandomNode;
	import com.tbbgc.denom.common.nodes.selectors.SelectRandomWeightNode;
	import com.tbbgc.denom.common.nodes.selectors.SelectSequenceNode;
	import com.tbbgc.denom.common.nodes.selectors.SelectSwitchNode;
	import com.tbbgc.denom.common.nodes.selectors.SelectSwitchValueNode;
	import com.tbbgc.denom.common.nodes.sound.AdvancedSoundNode;
	import com.tbbgc.denom.common.nodes.sound.MusicNode;
	import com.tbbgc.denom.common.nodes.sound.PlaySoundNode;
	import com.tbbgc.denom.common.nodes.sound.SoundNode;
	import com.tbbgc.denom.common.nodes.time.OverTimeNode;
	import com.tbbgc.denom.common.nodes.time.WaitNode;
	import com.tbbgc.denom.common.nodes.values.BetweenNode;
	import com.tbbgc.denom.common.nodes.values.BooleanNode;
	import com.tbbgc.denom.common.nodes.values.GraphNode;
	import com.tbbgc.denom.common.nodes.values.NumberNode;
	import com.tbbgc.denom.common.nodes.values.RandomNode;
	import com.tbbgc.denom.common.nodes.values.TextNode;
	import com.tbbgc.denom.dialogues.BaseDialogue;
	import com.tbbgc.denom.dialogues.InputDialogue;
	import com.tbbgc.denom.dialogues.ManageDialogue;
	import com.tbbgc.denom.dialogues.ParametersDialogue;
	import com.tbbgc.denom.dialogues.PopupDialogue;
	import com.tbbgc.denom.dialogues.SoundsDialogue;
	import com.tbbgc.denom.dialogues.YesNoDialogue;
	import com.tbbgc.denom.managers.PluginManager;
	import com.tbbgc.denom.managers.SettingsManager;
	import com.tbbgc.denom.menu.Menu;
	import com.tbbgc.denom.models.DataModel;
	import com.tbbgc.denom.models.FlowModel;
	import com.tbbgc.denom.models.PluginModel;
	import com.tbbgc.denom.models.UI;
	import com.tbbgc.denom.node.BaseNode;
	import com.tbbgc.denom.saveload.Load;
	import com.tbbgc.denom.saveload.Save;

	import flash.desktop.NativeApplication;
	import flash.display.DisplayObject;
	import flash.display.NativeMenu;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.ContextMenuEvent;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.NativeWindowBoundsEvent;
	import flash.events.UncaughtErrorEvent;
	import flash.geom.Point;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;



	public class Denom extends Sprite {
		public static const IS_EDITOR:Boolean = true;
		
		private var _menu:ContextMenu;
		private var _menuPosition:Point;

		private var _container:Sprite;

		private var _dragging:Boolean;
		private var _blockSave:Boolean;

		private var _addFlow:Button;
		private var _manage:Button;

		private var _flows:ComboBox;

		private var _lastNode:Class;

		public function Denom() {
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.quality = StageQuality.MEDIUM;
			stage.frameRate = 31;
			stage.color = UI.COLOR_BACKGROUND;

			stage.nativeWindow.title += " " + getAppDescVersion();

			_blockSave = true;

			new SettingsManager();

			DataModel.shared = new DenomShared(DataModel.ENTER_FRAME, new DenomFileManager(), new Dictionary());

			DataModel.DRAW_LINE.add( onDrawLine );

			_dragging = false;

			_container = new Sprite();
			addChild(_container);

			_addFlow = new Button();
			_addFlow.label = "Add";
			_addFlow.addEventListener(ComponentEvent.BUTTON_DOWN, onAddFlow);
			addChild(_addFlow);

			_manage = new Button();
			_manage.label = "Manage";
			_manage.addEventListener(ComponentEvent.BUTTON_DOWN, onManage);
			addChild(_manage);

			_flows = new ComboBox();
			_flows.width *= 2;
			_flows.addEventListener(Event.CHANGE, onSetFlow);
			addChild(_flows);

			BaseDialogue.DIALOGUES = addChild( new Sprite() ) as Sprite;

			var menu:Menu = new Menu( stage );
			menu.onSave.add( onSave );
			menu.onLoad.add( onLoad );
			menu.onDebugAll.add( onDebugAll );

			new ParametersDialogue();
			new SoundsDialogue();

			this.stage.doubleClickEnabled = true;

			this.stage.addEventListener(Event.RESIZE, onResize);
			this.stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			this.stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			this.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			this.stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			this.stage.addEventListener(MouseEvent.RIGHT_CLICK, onRightClick);
			this.stage.addEventListener(MouseEvent.DOUBLE_CLICK, onMouseDblClick);
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);

			this.stage.nativeWindow.addEventListener(NativeWindowBoundsEvent.MOVE, onSaveWindow);
			this.stage.nativeWindow.addEventListener(NativeWindowBoundsEvent.RESIZE, onSaveWindow);

			loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onUncaughtErrorHandler);

			buildMenu();

			onResize(null);

			addNode( getFlow("start"), new EventNode(), 100, 100 );
			onSetFlow(null, "start");

			setTimeout( onFirst, 50);
		}

		private function getAppDescVersion( label:Boolean=false ):String {
			var version:String;

			var xml:XML = NativeApplication.nativeApplication.applicationDescriptor;
			xml;
			/*FDT_IGNORE*/
			var ns:Namespace = xml.namespace();
			version = xml.ns::versionNumber;

			if( label ) {
				version += " " + xml.ns::versionLabel;
			}
			/*FDT_IGNORE*/

			return version;
		}

		private function onFirst():void {
			if( SettingsManager.haveItem(SettingsManager.SETTINGS_WINDOW) ) {
				var data:Object = SettingsManager.getItem(SettingsManager.SETTINGS_WINDOW);

				stage.nativeWindow.x = data["x"] as Number;
				stage.nativeWindow.y = data["y"] as Number;
				stage.nativeWindow.width = data["w"] as Number;
				stage.nativeWindow.height = data["h"] as Number;
			}

			_blockSave = false;

			var pop:YesNoDialogue = new YesNoDialogue("LOAD", "Do you want to load previous session?");
			pop.onYes.addOnce( onFirstYes );
		}

		private function onFirstYes():void {
			DataModel.ON_FIRST_RUN.dispatch();

			Load.runFirst( onPreLoad, onLoadComplete );
		}

		private function onUncaughtErrorHandler(event:UncaughtErrorEvent):void {
			var msg:String = "";

			if (event.error is Error)
			{
				var error:Error = event.error as Error;
				msg = JSON.stringify({error_name:error.name, error_id:error.errorID, error_message:error.message, error_stack:error.getStackTrace()});
			}
			else if (event.error is ErrorEvent)
			{
				var errorEvent:ErrorEvent = event.error as ErrorEvent;
				msg = JSON.stringify({error2:errorEvent.text});
			}

			new PopupDialogue("CRASH", msg);
		}

		private function onSaveWindow(e:NativeWindowBoundsEvent):void {
			if( _blockSave  ) {
				return;
			}

			SettingsManager.setItem(SettingsManager.SETTINGS_WINDOW, {
				x: stage.nativeWindow.x,
				y: stage.nativeWindow.y,
				w: stage.nativeWindow.width,
				h: stage.nativeWindow.height
			});
		}

		private function buildMenu():void {
			var nodename:Function = function(node:Class):String {
				var className : String = getQualifiedClassName(node);
				return className.slice(className.lastIndexOf("::") + 2);
			};

			var createsub:Function = function(name:String, items:Array):ContextMenuItem {
				var item:ContextMenuItem = new ContextMenuItem(name);
				item.submenu = new NativeMenu();
				item.submenu.items = items;
				return item;
			};

			var createplugin:Function = function(model:PluginModel):ContextMenuItem {
				var ctxitem:ContextMenuItem = new ContextMenuItem(model.name);
				ctxitem.data = model;
				ctxitem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onMenuSelectPlugin);
				return ctxitem;
			};

			var create:Function = function(node:Class):ContextMenuItem {
				var ctxitem:ContextMenuItem = new ContextMenuItem(nodename(node));
				ctxitem.data = node;
				ctxitem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onMenuSelect);
				return ctxitem;
			};

			var events:Array = [];
			var time:Array = [];
			var debug:Array = [];
			var values:Array = [];
			var parameters:Array = [];
			var selectrandom:Array = [];
			var selectswitch:Array = [];
			var selectlevel:Array = [];
			var sound:Array = [];
			var math:Array = [];
			var conditions:Array = [];
			var setter:Array = [];
			var plugins:Array = [];
			var other:Array = [];

			for each( var node:Class in AvailableNodes.AVAILABLE_NODES ) {
				switch( node ) {
					case SelectSequenceNode:
					case PluginNode:
					break;

					case EventNode:
					case PostEventNode:
						events.push(create(node));
					break;

					case LogNode:
						debug.push(create(node));
					break;

					case TextNode:
					case NumberNode:
					case BooleanNode:
					case RandomNode:
					case GraphNode:
					case BetweenNode:
						values.push(create(node));
					break;

					case WaitNode:
					case OverTimeNode:
						time.push(create(node));
					break;

					case ParameterNode:
					case AsPointNode:
						parameters.push(create(node));
					break;

					case IsOverLevelNode:
					case OverLevelValueNode:
						selectlevel.push(create(node));
					break;

					case SelectRandomNode:
					case SelectRandomWeightNode:
						selectrandom.push(create(node));
					break;

					case PlaySoundNode:
					case AdvancedSoundNode:
					case SoundNode:
					case MusicNode:
						sound.push(create(node));
					break;

					case AddNode:
					case SubtractNode:
					case MultiplyNode:
					case RoundNode:
					case InvertNode:
					case Deg2RadNode:
						math.push(create(node));
					break;

					case IfNode:
					case IsBetweenNode:
						conditions.push(create(node));
					break;

					case GetSetNode:
						setter.push(create(node));
					break;

					case SelectSwitchNode:
					case SelectSwitchValueNode:
						selectswitch.push(create(node));
					break;

					default:
						other.push(create(node));
					break;
				}
			}
			
			var plg:Vector.<PluginModel> = PluginManager.plugins;
			for each (var p:PluginModel in plg) {
				plugins.push(createplugin(p));
			}

			var selectors:Array = 	[
										createsub("Random", selectrandom),
										createsub("Switch", selectswitch),
										create(SelectSequenceNode)
									];

			conditions.unshift( createsub("Level", selectlevel) );

			_menu = new ContextMenu();
			_menu.items = 	[
								createsub("Events", events),
								createsub("Selectors", selectors),
								createsub("Conditional", conditions),
								createsub("Values", values),
								createsub("Setters", setter),
								createsub("Math", math),
								createsub("Time", time),
								createsub("Parameters", parameters),
								createsub("Sound", sound),
								createsub("Debug", debug),
								createsub("Plugins", plugins),
								createsub("Other", other),
							];
		}

		private function addNode( flow:Sprite, node:BaseNode, x:Number, y:Number ):void {
			node.x = x;
			node.y = y;
			flow.addChild(node);

			DataModel.SELECTED_NODE.value = node;
		}

		private function onEnterFrame(e:Event):void {
			DataModel.ENTER_FRAME.dispatch();
		}

		private function onRightClick(e:MouseEvent):void {
			if( e.target == _container || e.target == this.stage ) {
				_menuPosition = _container.globalToLocal( stage.localToGlobal( new Point( e.localX, e.localY ) ) );

				_menu.display(stage, e.stageX, e.stageY);
			}
		}

		private function onMouseDblClick(e:MouseEvent):void {
			if( (e.target == _container || e.target == this.stage) && _lastNode != null ) {
				var pos:Point = currentFlow.globalToLocal( new Point( e.stageX, e.stageY ) );
				addNode( currentFlow, new _lastNode(), pos.x, pos.y );
			}
		}

		private function onMenuSelect(e:ContextMenuEvent):void {
			var item:ContextMenuItem = e.currentTarget as ContextMenuItem;

			var curr:Sprite = currentFlow;

			if( curr != null ) {
				var c:Class = item.data as Class;
				addNode( currentFlow, new c(), _menuPosition.x, _menuPosition.y );

				_lastNode = c;
			}
		}

		private function onMenuSelectPlugin(e:ContextMenuEvent):void {
			var item:ContextMenuItem = e.currentTarget as ContextMenuItem;

			var curr:Sprite = currentFlow;

			if( curr != null ) {
				var m:PluginModel = item.data as PluginModel;
				addNode( currentFlow, new PluginNode(m.data), _menuPosition.x, _menuPosition.y );
			}
		}

		private function onMouseDown(e:MouseEvent):void {
			if( e.target == _container || e.target == this.stage ) {
				DataModel.SELECTED_NODE.value = null;

				_dragging = true;
				_container.startDrag();

				this.stage.focus = null;
			}
		}

		private function onMouseUp(e:MouseEvent):void {
			if( _dragging ) {
				_dragging = false;
				_container.stopDrag();
			}
		}

		private function onMouseWheel(e:MouseEvent):void {
			if( e.target == _container || e.target == this.stage ) {
				_container.scaleX = _container.scaleY += (0.01*e.delta);
				_container.scaleX = Math.max(0.1, _container.scaleX);
				_container.scaleY = Math.max(0.1, _container.scaleY);
			}
		}

		private function onKeyDown(e:KeyboardEvent):void {
			if( DataModel.SELECTED_NODE.value != null && e.keyCode == Keyboard.SPACE ) {
				(DataModel.SELECTED_NODE.value as BaseNode).test();
			}

			if( e.keyCode == Keyboard.F1 ) {
				centerFlow();
			}
		}

		private function onDrawLine( p1:Point, p2:Point ):void {
			_container.graphics.clear();
			if( p1 == null || p2 == null ) {
				return;
			}

			_container.graphics.lineStyle(UI.SIZE_NEWLINE, UI.COLOR_NEWLINE);
			_container.graphics.moveTo(p1.x, p1.y);
			_container.graphics.lineTo(p2.x, p2.y);
		}

		private function onSave():void {
			Save.run( Load.lastUsedFile );
		}

		private function onLoad():void {
			Load.run( onPreLoad, onLoadComplete );
		}
		private function onPreLoad():void {
			DataModel.DELETE_ALL.dispatch();
			_container.removeChildren();
		}
		private function onLoadComplete( flows:Vector.<FlowModel> ):void {
			for each( var flow:FlowModel in flows ) {
				for each( var node:BaseNode in flow.nodes ) {
					getFlow(flow.name).addChild(node);
				}
			}

			if( flow != null ) {
				onSetFlow(null, flow.name);
			} else {
				updateFlows();
			}

			DataModel.DRAW.dispatch();
		}

		private function onResize(e:Event):void {
			_flows.x = this.stage.stageWidth - (_flows.width + 15);
			_flows.y = this.stage.stageHeight - (_flows.height + 15);

			_addFlow.x = this.stage.stageWidth - (_addFlow.width + 15);
			_addFlow.y = _flows.y - (_addFlow.height + 5);

			_manage.x = _addFlow.x;
			_manage.y = _addFlow.y - 5 - _manage.height;
		}

		private function onDebugAll():void {
			DataModel.DELETE_ALL.dispatch();
			_container.removeChildren();

			var ypos:Number = 50;

			var node:BaseNode;

			for each( var c:Class in AvailableNodes.AVAILABLE_NODES ) {
				node = new c();
				node.x = 100;
				node.y = ypos;

				ypos += node.height + 50;

				getFlow("debug").addChild(node);
			}

			DataModel.DRAW.dispatch();
		}

		//////////////////////////////////////////////////
		////////// Flows

		private function updateFlows():void {
			_flows.removeAll();

			const len:int = _container.numChildren;
			for( var i:int = 0; i < len; i++ ) {
				_flows.addItem({label: _container.getChildAt(i).name});
			}
		}

		private function get currentFlow():Sprite {
			const len:int = _container.numChildren;
			for( var i:int = 0; i < len; i++ ) {
				if( (_container.getChildAt(i) as Sprite).visible ) {
					return _container.getChildAt(i) as Sprite;
				}
			}
			return null;
		}

		private function getFlow( name:String ):Sprite {
			const len:int = _container.numChildren;
			for( var i:int = 0; i < len; i++ ) {
				if( (_container.getChildAt(i) as Sprite).name == name ) {
					return _container.getChildAt(i) as Sprite;
				}
			}

			var s:Sprite = new Sprite();
			s.name = name;
			_container.addChild(s);

			updateFlows();

			return s;
		}

		private function onSetFlow( e:Event, label:String=null ):void {
			var name:String = label || _flows.selectedLabel;

			const len:int = _container.numChildren;
			for( var i:int = 0; i < len; i++ ) {
				_container.getChildAt(i).visible = (_container.getChildAt(i).name==name);

				if( _container.getChildAt(i).visible && label != null ) {
					_flows.selectedIndex = i;
				}
			}

			centerFlow();
		}

		private function centerFlow():void {
			if( currentFlow.numChildren > 0 ) {
				//ror at this code.

				const len:int = currentFlow.numChildren;

				var acc:DisplayObject;
				var t:DisplayObject;
				var num:Number = Number.MAX_VALUE;

				for( var i:int = 0; i < len; i++ ) {
					t = currentFlow.getChildAt(i);
					if( t.x < num || t.y < num ) {
						acc = t;
						if( t.x < t.y ) {
							num = t.x;
						} else {
							num = t.y;
						}
					}
				}

				var obj:DisplayObject = acc;
				_container.x = -obj.x;
				_container.y = -obj.y;
			} else {
				_container.x = _container.y = 0;
			}

			_container.x += stage.stageWidth/2;
			_container.y += stage.stageHeight/2;

			_container.scaleX = _container.scaleY = 1;
		}

		private function onAddFlow(e:ComponentEvent):void {
			var dlg:InputDialogue = new InputDialogue("New Flow", "Enter name:");
			dlg.onOK.addOnce( onAddedFlow );
		}

		private function onAddedFlow( text:String ):void {
			if( text == null || text == "" ) return;

			getFlow( text );
			onSetFlow(null, text);
			addNode( currentFlow, new EventNode(), 100, 100 );
		}

		private function onManage(e:ComponentEvent):void {
			var dlg:ManageDialogue = new ManageDialogue( _container );
			dlg.onClose.addOnce( onManageClose );
		}

		private function onManageClose():void {
			updateFlows();

			var curr:Sprite = currentFlow;
			if( curr != null ) {
				onSetFlow( null, curr.name );
			} else {
				if( _container.numChildren > 0 ) {
					onSetFlow( null, _container.getChildAt(0).name );
				}
			}
		}
	}
}
