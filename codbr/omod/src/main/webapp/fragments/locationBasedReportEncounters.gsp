<%
    def id = config.id ?: ui.randomId("locationBasedReportEncounters")
    def props = config.properties ?: ["patient", "form", "encounterType", "encounterDatetime", "location", "provider"]
    def showSelectButton = config.showSelectButton ?: false
%>

<script type="text/javascript" src="/${contextPath}/scripts/jquery/jquery.min.js" ></script>
<script type="text/javascript" src="/${contextPath}/scripts/jquery/jsTree/jquery.tree.min.js" ></script>
<script type="text/javascript" src="/${contextPath}/scripts/jquery/jsTree/themes/classic/style.css" ></script>

<script type="text/javascript">
jQuery(document).ready(function() {
	var loctree = jQuery('#hierarchyTree').tree({
			data: {
				type: "json",
				opts: {
					url: "/${contextPath}/q/locationHierarchy.json?selectLeafOnly=false"
				}
			},
			types: {
				"default" : {
					clickable : false,
					renameable : false,
					deletable : false,
					creatable : false,
					draggable : false,
					max_children : -1,
					max_depth : -1,
					valid_children : "all"
				},
				"nulloption" : {
					clickable : true,
					icon : { position : '-16px -16px' }
				},
				"selectable" : {
					clickable : true
				}
			},
			ui: {
				theme_name: "classic"
			},
			callback: {
				onselect: function(NODE, TREE_OBJ){
				var locname = document.getElementById('selectedTreeLoc').value=jQuery(NODE).attr('name');
					refreshTreeReportData(locname);
				}
			}
		});
});
	function refreshTreeReportData(selectedNode) {
		var encounterType = jQuery('#encounterType').val();
		var formType = jQuery('#formType').val();
		var tableId = "tblEncounter";

		var locname = selectedNode;

		jQuery.ajax({
			dataType : "json",
			url : '${ ui.actionLink("getEncounters") }',
			data : {
				'locationName' : locname,
				'properties' : [<%=props.collect { "'${it}'" }.join(",")%>	],
				'formType' : formType,
				'encounterType' : encounterType
			},
			success : function(data) {
				jQuery('#' + tableId + ' > tbody > tr').remove();

				var tbody = jQuery('#' + tableId + ' > tbody');
				for (index in data) {
					var item = data[index];
					var row = '<tr>';
					<%props.each {%>
					row += '<td>' + item.${it} +'</td>';
					<%}%>
					row += '</tr>';
					tbody.append(row);
				}

			}
		});
	}
</script>
<table class="layouttable"><tr><td style="vertical-align: top;"><div id="hierarchyTree"></div></td>
<td>
<div>
Event Type : <select id="encounterType" onchange="refreshTreeReportData(document.getElementById('selectedTreeLoc').value);">
<option></option>
<% if (encounterTypes) { %>
	<% encounterTypes.each { %>
		<option>${ ui.format(it.name) }</option>
	<% } %>
<% } %>
</select>
<input type="hidden" id="selectedTreeLoc">
Form Type : <select id="formType" onchange="refreshTreeReportData(document.getElementById('selectedTreeLoc').value);">
<option></option>
<% if (formTypes) { %>
	<% formTypes.each { %>
		<option>${ ui.format(it.name) }</option>
	<% } %>
<% } %>
</select>
</div>
<table id="tblEncounter" class="layouttable">
<thead>
    <tr>
        <th>${ ui.message("Person") }</th>
        <th>${ ui.message("Form") }</th>
        <th>${ ui.message("Event Type") }</th>
        <th>${ ui.message("Event Datetime") }</th>
        <th>${ ui.message("Event Location") }</th>
        <th>${ ui.message("Event Provider") }</th>
    </tr>
 </thead>
 <tbody>
    <% if (encounters) { %>
        <% encounters.each { %>
            <tr>
                <td>${ ui.format(it.patient) }</td>
                <td>${ ui.format(it.form) }</td>
                <td>${ ui.format(it.encounterType) }</td>
                <td>${ ui.format(it.encounterDatetime) }</td>
                <td>${ ui.format(it.location) }</td>
                <td>${ ui.format(it.provider) }</td>
            </tr>
        <% } %>
    <% } else { %>
        <tr>
            <td colspan="4">No data for selected location. Select another location to view data.</td>
        </tr>
    <% } %>
 </tbody>
</table></td></tr></table>
	
	
	