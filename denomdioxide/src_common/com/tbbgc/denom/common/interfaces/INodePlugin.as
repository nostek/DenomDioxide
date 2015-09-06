package com.tbbgc.denom.common.interfaces {
	/**
	 * @author simon
	 */
	public interface INodePlugin {
		function runRight(name:String):*;
		function haveRight(name:String):Boolean;
	}
}
