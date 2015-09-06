package com.tbbgc.denom.common.interfaces {
	import org.osflash.signals.Signal;
	/**
	 * @author simon
	 */
	public interface IFileManager {
		function get onLoad():Signal;
		function getFullURL( file:String ):String;
		function getFile( file:String ):void;
	}
}
