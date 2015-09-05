package com.tbbgc.denom.menu {
	import com.tbbgc.denom.dialogues.BaseDialogue;
	import com.tbbgc.denom.dialogues.ParametersDialogue;
	import com.tbbgc.denom.dialogues.SoundsDialogue;
	import com.tbbgc.denom.managers.PluginManager;
	import com.tbbgc.denom.managers.SoundsManager;

	import org.osflash.signals.Signal;

	import flash.desktop.NativeApplication;
	import flash.display.DisplayObjectContainer;
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.display.NativeWindow;
	import flash.display.Stage;
	import flash.events.Event;
	/**
	 * @author simonrodriguez
	 */
	public class Menu {
		private var _stage:Stage;

		private var _onSave:Signal;
		private var _onLoad:Signal;
		private var _onDebugAll:Signal;

		public function Menu( stage:Stage ) {
			_stage = stage;

			_onSave = new Signal();
			_onLoad = new Signal();
			_onDebugAll = new Signal();

			setupMenu([
				{
					name: "File",

					children: [
						{
							name: "Open",
							callback: onOpenEvent
						},
						{
							name: "Save",
							shortcut: "s",
							callback: onSaveEvent
						},
						{
							name: "Import",
							children: [
								{
									name: "Plugins",
									callback: onImportPlugins
								},
								{
									name: "Sounds",
									callback: onImportSounds
								}
							]
						},
						{
							name: "Close",
							callback: onExitEvent,
							shortcut: "w"
						},
						{
							name: "Exit",
							callback: onExitEvent,
							shortcut: "q"
						},
					]
				},

				{
					name: "Windows",
					children: [
						{
							name: "[RESET WINDOWS]",
							callback: onResetWindowsEvent
						},
						{
							name: "Parameters",
							callback: onParametersEvent
						},
						{
							name: "Sounds",
							callback: onSoundsEvent
						},
					]
				},

				{
					name: "Options",
					children: [
						{
							name: "Debug All",
							callback: onDebugAllEvent
						},
					]
				},

				{
					name: "Window",
					children: [
						{
							name: "Minimize",
							callback: onMinimize
						},
						{
							name: "Zoom",
							callback: onZoom
						}
					]
				}
			]);
		}

		private function setupMenu( struct:Object ):void {
			var menu:NativeMenu = new NativeMenu();

			for each( var obj:Object in struct ) {
				setupMenuRect( obj, menu );
			}

			if( NativeApplication.supportsMenu ) {
				NativeApplication.nativeApplication.menu = menu;
			}

			if( NativeWindow.supportsMenu ) {
				_stage.nativeWindow.menu = menu;
			}
		}

		private function setupMenuRect( struct:Object, parent:NativeMenu ):void {
			var itm:NativeMenuItem = new NativeMenuItem( struct["name"] );

			var children:Object = struct["children"];
			if( children != null ) {
				var sub:NativeMenu = new NativeMenu();

				for each( var obj:Object in children ) {
					setupMenuRect( obj, sub );
				}

				itm.submenu = sub;
			}

			if( struct["callback"] != null ) {
				itm.addEventListener(Event.SELECT, struct["callback"]);
			}

			if( struct["enabled"] != null ) {
				itm.checked = struct["enabled"] as Boolean;
			}

			if( struct["shortcut"] != null ) {
				itm.keyEquivalent = struct["shortcut"];
			}
			if( struct["shortcutMod"] != null ) {
				itm.keyEquivalentModifiers = struct["shortcutMod"];
			}

			parent.addItem(itm);
		}

		////////////////////

		public function get onSave():Signal { return _onSave; }
		public function get onLoad():Signal { return _onLoad; }
		public function get onDebugAll():Signal { return _onDebugAll; }

		////////////////////

		private function onExitEvent( e:Event ):void {
		    var exitingEvent:Event = new Event(Event.EXITING, false, true);
		    NativeApplication.nativeApplication.dispatchEvent(exitingEvent);
		    if (!exitingEvent.isDefaultPrevented()) {
		        NativeApplication.nativeApplication.exit();
		    }
		}

		private function onMinimize( e:Event ):void {
			_stage.nativeWindow.minimize();
		}

		private function onZoom( e:Event ):void {
			_stage.nativeWindow.maximize();
		}

		private function onResetWindowsEvent( e:Event ):void {
			var d:DisplayObjectContainer;

			const len:int = BaseDialogue.DIALOGUES.numChildren;
			for( var i:int = 0; i < len; i++ ) {
				d = BaseDialogue.DIALOGUES.getChildAt(i) as DisplayObjectContainer;
				if( d != null && d.numChildren > 0 ) {
					d.x = 0;
					d.y = 0;
				}
			}
		}

		private function onParametersEvent( e:Event ):void {
			new ParametersDialogue();
		}

		private function onSoundsEvent( e:Event ):void {
			new SoundsDialogue();
		}

		private function onOpenEvent( e:Event ):void {
			_onLoad.dispatch();
		}

		private function onSaveEvent( e:Event ):void {
			_onSave.dispatch();
		}

		private function onDebugAllEvent( e:Event ):void {
			_onDebugAll.dispatch();
		}
		
		private function onImportSounds( e:Event ):void {
			SoundsManager.askFolder();
		}
		
		private function onImportPlugins( e:Event ):void {
			PluginManager.askFolder();
		}
	}
}
