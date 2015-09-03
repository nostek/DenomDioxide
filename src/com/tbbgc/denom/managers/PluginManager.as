package com.tbbgc.denom.managers {
	/**
	 * @author Simon
	 */
	public class PluginManager {
		public static function get plugins():Vector.<Object> {
			return Vector.<Object>([
				{
					name: "Test Plugin",
					params: [
						{
							name: "Text",
							value: "Massa text"
						}
					],
					left: [
						{
							name: "GET",
							id: "TestPlugin_GET",
							def: "BANANA"
						}
					],
					right: [
						{
							name: "TEXT",
							single: true
						}
					]
				}
			]);
		}
		
		public static function getPluginName(data:Object):String {
			return data["name"];
		}
		
		public static function getPluginByName(name:String):Object {
			var p:Vector.<Object> = PluginManager.plugins;
			
			const len:int = p.length;
			for (var i:int = 0; i < len; i++) {
				if (PluginManager.getPluginName(p[i]) == name) {
					return p[i];
				}
			}
			
			return null;
		}
	}
}
