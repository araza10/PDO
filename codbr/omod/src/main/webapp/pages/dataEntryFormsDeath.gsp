<% ui.decorateWith("codbr","standardPage")


 %>



<div id="featured-wrapper">
	<div id="featured" class="container">
		<table class="layouttable">
			<tr>
				
	<td class="sidebar">
	<div>
	<ul><li><strong><a href ="${ui.pageLink("codbr", "dataEntryForms")}">Birth Informant Form</a></strong></li>
	<li class="selectedli"><strong><a href ="${ui.pageLink("codbr", "dataEntryFormsDeath")}">Death Informant Form</a></strong></li>
	<li><strong><a href ="${ui.pageLink("codbr", "dataEntryFormsVerbal")}">Verbal Autopsy Questionnaire</a></strong> <br></br></li>
	<li><strong><a href ="${ui.pageLink("codbr", "dataEntryFormsFoetal")}">Foetal Death Informant Form</a></strong> <br></br></li>
	</ul>
	</div>
	</td>


				
				
				<td class="content-container">
						${ ui.includeFragment("codbr", "content/enterHtmlFormDeath") }
					
			</td></tr>
		</table>
			
	</div>
</div>