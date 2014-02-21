<%
	/* Creates a menu item for inclusion in panel widget */

	config.require("label");
	def onClick = config.href
%>

<div onclick="window.location='${onClick}'; return false;">
	

	 ${ config.label }
	
	
	
</div>
