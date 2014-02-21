<%
	// Supports items, heading

	config.require("items")
%>


	<td class="sidebar">
	<% for (def itemConfig : config.items) { %>
	
		${ ui.includeFragment("codbr", "widget/panelMenuItem", itemConfig) }
	<% } %>
</td>