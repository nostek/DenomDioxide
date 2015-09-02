package com.tbbgc.denom.managers {
	import com.tbbgc.denom.models.PluginModel;
	/**
	 * @author Simon
	 */
	public class PluginManager {
		public static function get plugins():Vector.<PluginModel> {
			return Vector.<PluginModel>([
				new PluginModel({
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
							id: "TestPlugin_GET"
						}
					]
				})
			]);
		}
	}
}
