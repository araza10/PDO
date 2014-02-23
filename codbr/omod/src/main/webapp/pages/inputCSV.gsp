<% ui.decorateWith("codbr","standardPage")
ui.includeJavascript("codbr", "jquery.js", 100)
	
%>

<div id="featured-wrapper">
	<div id="featured" class="container">
	${ ui.includeFragment("codbr", "inputCSVGenerate") }
	</div>
	
</div>