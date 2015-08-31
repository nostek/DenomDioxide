package com.tbbgc.denom.interfaces {
	/**
	 * @author simonrodriguez
	 */
	public interface INode {
		function get nodeName():String;

		function reset():void;

		function setParameter(name : String, value : *) : void;
		function getParameter(name : String) : *;
	}
}
